#!/bin/env php
<?php

/**
 * db-copy
 *
 * Copies a database from one server to another server
 *
 * @example ./db-copy.php --source ssh:root@d.outsidehubmedia.com:31338/mysql --destination mysql:cmgoodbadmin:password@10.0.0.127/mysql
 * @author Rick Christy <rchristy@carbonmedia.com>
 * @uses PEAR ConsoleCommandLine (https://pear.php.net/package/Console_CommandLine)
 * @todo #1 alter to innodb: ALTER TABLE table_name ENGINE=InnoDB;
 * @todo #2 rebuild indexes: REPAIR TABLE table_name QUICK;
 * @todo #3 copy: scp (for RDS have to use mysql -> mysql)
 * @version 0.1
 */
if ((include_once 'Console/CommandLine.php') === false) {
	die("\n" . 'FAILED: Console/CommandLine.php not found! Please install PEAR ConsoleCommandLine: https://pear.php.net/package/Console_CommandLine' . "\n");
}
define('CLI_LINES_DEFAULT', 25);
define('CLI_COLUMNS_DEFAULT', 80);
$errors = $warnings = array();
$screen = get_viewport_dimensions();

define('APP_NAME', 'db-copy');
define('APP_VERSION', '0.1');
define('DEFAULT_PORT_SSH', 22);
define('DEFAULT_PORT_MYSQL', 3306);
define('METHOD_SSH', 'ssh');
define('METHOD_MYSQLDUMP', 'mysql');
define('ESC', "\033");
define('MPR_REGEX', '/(\\|\\d\\d|\\|@[CLR]|\\|~[CDLR]\\d{1,3}.|\\|%[CDLR]\\d{1,3}.|\\|\\[YX\\d{1,3};\\d{1,3}|\\|\\[X\\d{1,3}|%YX\\d{1,3};\\d{1,3}|\\|%X\\d{1,3}|\\|\\[[ABCD]\\d{1,3}|<.*?>|\\|CL|\\|DE|\\|TC)/s');
define('ANSI_REGEX', '/(\\033\\[[0124];?\\d\\d?m|\\033\\[2J|\\033\\[\\d;\\dH)/');
define('BADGE_OK', '|02[|10OK|02]');
define('BADGE_FAIL', '|04[|12FAIL|04]');
define('BADGE_WARN', '|06[|14WARN|06]');
define('BADGE_NOT_EXIST', '|06[|14|~C11 <NOT EXIST>|06]');
define('BADGE_AUTH', '|04[|12|~C11 <AUTH>|04]');
define('SQL_NO_ROWS', 'NO_ROWS_RETURNED_FROM_QUERY');
define('CLI_LINEWIDTH', (int) $screen['columns']);
define('WRAP_WIDTH', CLI_LINEWIDTH);

//these databases will be skipped in all copy operations that specify no database specifically
$ignored_dbs = array('mysql', 'information_schema', 'performance_schema');

//create the command line parser object and configure it to handle the cli args and parameters
$parser = new Console_CommandLine(array('name' => 'db-copy', 'description' => 'Copies database(s) from one server to another server using either ssh and rsync, or mysqldump.', 'version' => '0.1'));
$parser->renderer->line_width = CLI_LINEWIDTH;
$parser->addOption('source', array('help_name' => '{source_uri}', 'long_name' => '--source', 'action' => 'StoreString', 'description' => "Format: <method>:<user>[:pass]@<host>[:port][/database(s)]\nWhere method is one of mysql or ssh.\nExample: mysql:bilbo:s3cr3t@tolkien.org:8088/the_shire\nNote: method:user@host parts required, other parts optional.\nNote: If database not specified omit the slash.\nIf more than one database specified use CSV format (db1, db2, db3)\nWhen no database specified all databases will be copied except tables used for MySQL internals.\nNote when using SSH method, MySQL username and password will be inherited and localhost used to attempt connection (use .my.cnf on server)."));
$parser->addOption('source_mysql_auth', array('help_name' => '{username:password}', 'long_name' => '--source-mysql-auth', 'action' => 'StoreString', 'description' => "Format: <username>:<password>\nUse this username and password for the source MySQL authentication instead of username and password extracted from --source.\nUseful when .my.cnf is not configured for --source user in the source URI."));
$parser->addOption('destination', array('help_name' => '{destination_uri}', 'long_name' => '--destination', 'action' => 'StoreString', 'description' => "Format: <method>:<user>[:pass]@<host>[:port][/database(s)]\nWhere method is one of mysql or ssh.\nExample: mysql:bilbo:s3cr3t@tolkien.org:8088/the_shire\nNote: method:user@host parts required, other parts optional.\nNote: If database not specified omit the slash.\nIf more than one database specified use CSV format (db1, db2, db3)\nWhen no database specified all databases will be copied except tables used for MySQL internals.\nNote when using SSH method, MySQL username and password will be inherited and localhost used to attempt connection (use .my.cnf on server)."));
$parser->addOption('destination_mysql_auth', array('help_name' => '{username:password}', 'long_name' => '--destination-mysql-auth', 'action' => 'StoreString', 'description' => "Format: <username>:<password>\nUse this username and password for the destination MySQL authentication instead of username and password extracted from --destination.\nUseful when .my.cnf is not configured for --destination user in the destination URI."));
$parser->addOption('email', array('help_name' => '{email_address_list}', 'long_name' => '--email', 'action' => 'StoreString', 'description' => "Notify by email.\nFormat: comma delimited list of email addresses to notify.\nNote: Scope of notifications handled by --notify-database, and --notify-job flags"));
$parser->addOption('user_map_file', array('help_name' => '{path_to_ini_file}', 'long_name' => '--user-map-file', 'action' => 'StoreString', 'description' => "Use this user map file to verify users if --verify-users is also true.\n.ini block format: {\n    [database_name]\n    user={username}\n    pass={password}\n}"));
$parser->addOption('force', array('help_name' => ' ', 'long_name' => '--force', 'action' => 'StoreTrue', 'description' => "Force overwrite of all destination databases with source. WARNING this cannot be undone!"));
$parser->addOption('notify_db', array('help_name' => ' ', 'long_name' => '--notify-db', 'action' => 'StoreTrue', 'description' => "Notify when ANY database copy operation is completed."));
$parser->addOption('notify_job', array('help_name' => ' ', 'long_name' => '--notify-job', 'action' => 'StoreTrue', 'description' => "Notify when ALL databases copy operations are completed."));
$parser->addOption('abort_on_error', array('help_name' => ' ', 'long_name' => '--abort-on-error', 'action' => 'StoreTrue', 'description' => "Abort on any error encountered."));
$parser->addOption('clean_up', array('help_name' => ' ', 'long_name' => '--clean-up', 'action' => 'StoreTrue', 'description' => "Remove working temporary files (tar, sql, etc.) on job completion."));
$parser->addOption('alter_innodb', array('help_name' => ' ', 'long_name' => '--alter-innodb', 'action' => 'StoreTrue', 'description' => "Modify all tables to use the InnoDB storage engine. Will execute ALTER TABLE to convert MyISAM to InnoDB."));
$parser->addOption('rebuild_indexes', array('help_name' => ' ', 'long_name' => '--rebuild-indexes', 'action' => 'StoreTrue', 'description' => "Will rebuild any FULLTEXT indexes found if --alter-innodb is also true."));
$parser->addOption('verify_users', array('help_name' => ' ', 'long_name' => '--verify-users', 'action' => 'StoreTrue', 'description' => "Verify that users can access the databases on the destination.\nUses --user-map-file to determine database names, usernames, passwords, and accessibility verification tests."));
$parser->addOption('batch_mode', array('help_name' => ' ', 'long_name' => '--batch-mode', 'action' => 'StoreTrue', 'description' => "Run in batch mode - do not pause and wait for keyboard input when viewing summary and confirmation screens."));
$procflags = array('source_connected_ssh' => false, 'source_connected_db' => false, 'destination_connected_ssh' => false, 'destination_connected_db' => false, 'operations_performed' => array());

try {
	$opt = $parser->parse();
	if (!array_search(!null, $opt->options)) {
		//show help if options are not passed (all nulls)
		$parser->displayError($parser->displayUsage());
	}

	//output the app header
	output_header();

	if (is_null($opt->options['source']) || is_null($opt->options['destination'])) {
		echo "\n\n";
		$parser->displayError(mpr(BADGE_FAIL . " |15INVALID INVOCATION. |07To copy you must specify a source and a destination."));
	} else {
		//set default force to false
		if (is_null($opt->options['force'])) {
			$opt->options['force'] = false;
		}
		//set default batch_mode to false
		if (is_null($opt->options['batch_mode'])) {
			$opt->options['batch_mode'] = false;
		}
		define('BATCH_MODE', $opt->options['batch_mode']);

		//valid source and destination
		$src = parse_uri($opt->options['source']);
		$dst = parse_uri($opt->options['destination']);

		//trap database names only on destination
		if (count($src['name']) == 0 && count($dst['name']) > 0) {
			echo "\n\n";
			$parser->displayError(mpr(BADGE_FAIL . " |15INVALID INVOCATION. |07Destination database names provided without same number of source database names."));
		}

		//override with --source-mysql-auth and --destination-mysql-auth if applicable
		if (!is_null($opt->options['source_mysql_auth'])) {
			$src_auth = explode(':', $opt->options['source_mysql_auth']);
			$src['mysql_user'] = (!empty($src_auth[0])) ? $src_auth[0] : $src['mysql_user'];
			$src['mysql_pass'] = (!empty($src_auth[1])) ? $src_auth[1] : $src['mysql_pass'];
		}
		if (!is_null($opt->options['destination_mysql_auth'])) {
			$dst_auth = explode(':', $opt->options['destination_mysql_auth']);
			$dst['mysql_user'] = (!empty($dst_auth[0])) ? $dst_auth[0] : $dst['user'];
			$dst['mysql_pass'] = (!empty($dst_auth[1])) ? $dst_auth[1] : $dst['pass'];
		}

		//analyze source
		switch ($src['method']) {
			case METHOD_MYSQLDUMP:
				$src['port'] = (empty($src['port'])) ? DEFAULT_PORT_MYSQL : $src['port'];
				$src['con'] = connect_db($src['host'], $src['port'], $src['user'], $src['pass'], $src['name'][0]);
				$procflags['source_connected_db'] = ($src['con'] === false) ? false : true;
				$src['status'] = ($procflags['source_connected_db']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				$src['mysql_status'] = ($procflags['source_connected_db']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				break;
			case METHOD_SSH:
				$src['port'] = (empty($src['port'])) ? DEFAULT_PORT_SSH : $src['port'];
				if (empty($src['mysql_pass'])) {
					array_push($errors, '|20|12-|16 ' . BADGE_AUTH . ' |07Using SSH method with SSH key requires |15--source-mysql-auth |07to propagate username and password');
					$src['con'] = false;
				} else {
					$src['con'] = connect_ssh($src['host'], $src['port'], $src['user'], $src['pass'], $src['mysql_user'], $src['mysql_pass'], $src['name'][0]);
				}
				$procflags['source_connected_ssh'] = ($src['con'] === false) ? false : true;
				$src['status'] = ($procflags['source_connected_ssh']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				$src['mysql_status'] = (is_array($src['con']['databases']) && count($src['con']['databases'] > 0)) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				break;
		}

		//analyze destination
		switch ($dst['method']) {
			case METHOD_MYSQLDUMP:
				$dst['port'] = (empty($dst['port'])) ? DEFAULT_PORT_MYSQL : $dst['port'];
				$dst['con'] = connect_db($dst['host'], $dst['port'], $dst['user'], $dst['pass'], $dst['name'][0]);
				$procflags['destination_connected_db'] = ($dst['con'] === false) ? false : true;
				$dst['status'] = ($procflags['destination_connected_db']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				$dst['mysql_status'] = ($procflags['destination_connected_db']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				break;
			case METHOD_SSH:
				$dst['port'] = (empty($dst['port'])) ? DEFAULT_PORT_SSH : $dst['port'];
				if (empty($dst['mysql_pass'])) {
					array_push($errors, '|20|12-|16 ' . BADGE_AUTH . ' |07Using SSH method with SSH key requires |15--destination-mysql-auth |07to propagate username and password');
					$dst['con'] = false;
				} else {
					$dst['con'] = connect_ssh($dst['host'], $dst['port'], $dst['user'], $dst['pass'], $dst['mysql_user'], $dst['mysql_pass'], $dst['name'][0]);
				}
				$procflags['destination_connected_ssh'] = ($dst['con'] === false) ? false : true;
				$dst['status'] = ($procflags['destination_connected_ssh']) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				$dst['mysql_status'] = (is_array($dst['con']['databases']) && count($dst['con']['databases'] > 0)) ? mpr('|07CONNECTION ' . BADGE_OK) : mpr('CONNECTION ' . BADGE_FAIL);
				break;
		}

		//handle only databases we care about
		$src['con']['databases'] = (count(strip_ignored_dbs($src['name'])) > 0) ? $src['name'] : $src['con']['databases'];
		$dst['con']['databases'] = (count(strip_ignored_dbs($dst['name'])) > 0) ? $dst['name'] : $dst['con']['databases'];

		//show summary
		output_summary();

		//show connection details
		echo h2('CONNECTION DETAILS');
		output_connection_details($src, $dst);
		pause();

		//if has connection errors, exit
		if (count($errors) > 0) {
			output_errors();
            clean_up();
			die();
		} else {
			//no errors

			//verify users
			if (!is_null($opt->options['verify_users'])) {
				if (is_null($opt->options['user_map_file'])) {
					array_push($errors, '|12- ' . BADGE_FAIL . ' |15verify_users()|07: user-map-file not specified');
				} else if (!is_readable($opt->options['user_map_file'])) {
					array_push($errors, '|12- ' . BADGE_FAIL . ' |15verify_users()|07: user-map-file: |15' . $options['user_map_file'] . ' |07not readable');
				} else {
					$user_map = parse_ini_file('db-users.ini', true);
					$dbcount = count($user_map);
					echo h2('USER VERIFICATION', "|15DATABASES: |10{$dbcount}");
					$verify_users_results = verify_users($src, $dst, $opt->options, $user_map);
					echo "\n";
					$procflags['verify_users'] = $verify_users_results['success'];
					if ($verify_users_results['success'] === false) {
						$errors = array_merge(
							$errors, 
							$verify_users_results['results']['src']['errors'], 
							$verify_users_results['results']['dst']['errors']
						);
						$warnings = array_merge(
							$warnings, 
							$verify_users_results['results']['src']['warnings'], 
							$verify_users_results['results']['dst']['warnings']
						);
					}
					pause();
				}
			}

			//get MyISAM tables
			if (!is_null($opt->options['alter_innodb'])) {
				echo h2('ALTER MYISAM TO INNODB OPERATION QUEUE ON DESTINATION');
				$myisams = inventory_myisam_tables($src, $dst, $opt->options);
				$procflags['alter_innodb'] = $myisams['success'];
				$dst['myisams'] = $myisams['results']['myisams'];
				$dst['total_myisams'] = $myisams['results']['total_myisams'];
				if ($myisams['success'] === false) {
					$errors = array_merge($errors, $myisams['errors']);
				}
				pause();
			}

			//get FULLTEXT indexes
			if (!is_null($opt->options['rebuild_indexes'])) {
				echo h2('FULLTEXT INDEX REBUILD OPERATION QUEUE ON DESTINATION');
				$indexes = get_fulltext_indexes($src, $dst, $opt->options);
				$procflags['rebuild_indexes'] = $indexes['success'];
				$dst['indexes'] = $indexes['results']['indexes'];
				$dst['total_indexes'] = $indexes['results']['total_indexes'];
				if ($indexes['success'] === false) {
					$errors = array_merge($errors, $indexes['errors']);
				}
				pause();
			}

			//show operation queue
			output_operation_queue($src, $dst);
			pause();

			if (count($errors) > 0) {
				//if has any other errors, exit
				output_errors();
                clean_up();
				die();
			} else if (count($warnings) > 0) {
				//show the warnings, but continue
				output_errors();
			}
		}
	}
} catch (Exception $e) {
	$parser->displayError($e->getMessage());
	$parser->displayUsage();
}



/**
 * Clean up and close connections
 * @return void
 */
function clean_up() {
    global $src, $dst;
    $src['con'] = null;
    $dst['con'] = null;
}



/**
 * Obtain list of tables and columns with fulltext indexes from a connection
 * @param array $dst destination connection
 * @param string $database name to get tables for
 * @return mixed array of tables for a database | FALSE on failure
 */
function get_fulltext_indexes_from_connection($dst) {
	$sql = sprintf(
		'SELECT DISTINCT TABLE_SCHEMA, INDEX_NAME, TABLE_NAME FROM information_schema.statistics WHERE index_type LIKE "FULLTEXT%%"'
	);
	return query_db($dst, $sql);
}



/**
 * Obtains inventory of FULL_TEXT indexes from database tables
 * @param array $src source connection
 * @param array $dst destination connection
 * @param array $options used for copy from CLI
 * @return mixed array of results
 */
function get_fulltext_indexes($src, $dst, $options) {
	$success = false;
	$errors = array();
	$result = array('src' => array(), 'dst' => array());
	$indexes = array();
	$total_indexes = 0;

	echo mpr(" |08[|15DST|08] ");
	$status = ' FULLTEXT indexes will be rebuilt.';
	$tmp = get_fulltext_indexes_from_connection($dst);
	if (($tmp['success'] == true) && ($tmp['results']['rows'] != SQL_NO_ROWS) && (count($tmp['results']['rows']) > 0)) {
		//successfully ran query now get the indexes into an array
		foreach ($tmp['results']['rows'] as $idx => $row) {
			$indexes[$row['TABLE_SCHEMA']] = array();
			$indexes[$row['TABLE_SCHEMA']][$row['TABLE_NAME']] = array();
			$total_indexes++;
		}
		$total = 0;
		foreach ($tmp['results']['rows'] as $idx => $row) {
			array_push($indexes[$row['TABLE_SCHEMA']][$row['TABLE_NAME']], $row['INDEX_NAME']);
			$indexes[$row['TABLE_SCHEMA']]['db_index_count'] = count($indexes[$row['TABLE_SCHEMA']][$row['TABLE_NAME']]);
			$total += number_format($indexes[$row['TABLE_SCHEMA']]['db_index_count']);
			$stat_line = "|06(|14{$total}|06)|07{$status}";
			echo mpr("{$stat_line}|[D" . strlen_clean_ansi_mpr($stat_line));
		}
	} else if (!$tmp['success']) {
		//failed to do something with introspector
		array_push($errors, "|12- |07Error introspecting FULLTEXT indexes on |15{$dst['host']}");
		$success = false;
	}
	echo "\n";
	$result['total_indexes'] = $total_indexes;
	$result['indexes'] = $indexes;
	return array(
		'success' => $success,
		'errors' => $errors,
		'results' => $result,
	);
}



/**
 * Obtains inventory of MyISAM tables
 * @param array $src source connection
 * @param array $dst destination connection
 * @param array $options used for copy from CLI
 * @return mixed array of results
 */
function inventory_myisam_tables($src, $dst, $options) {
	$success = false;
	$errors = array();
	$result = array('src' => array(), 'dst' => array());
	$myisam = array();
	$total_myisams = 0;

	echo mpr(" |08[|15SRC|08] ");
	$status = ' MyISAM storage engine tables will be converted to InnoDB.';
	foreach ($src['con']['databases'] as $idx => $database) {
		$tmp = get_myisam_tables($src, $database);
        die(print_r($tmp, true));
		//has myisam tables that need to be converted
		if (($tmp['success'] == true) && ($tmp['results']['rows'] != SQL_NO_ROWS) && (count($tmp['results']['rows']) > 0)) {
			$myisam[$database] = $tmp['results']['rows'];
			$myisam[$database] = array();
			foreach ($tmp['results']['rows'] as $idx => $row) {
				array_push($myisam[$database], $row['Name']);
			}
			$total_myisams += count($myisam[$database]);
		} else if (!$tmp['success']) {
			//failed to do something with introspector
			array_push($errors, "|12- |07Error inventorying MyISAM storage engine on |15{$database}");
			$success = false;
		}
		$total = number_format($total_myisams);
		$stat_line = "|02(|10{$total}|02)|07{$status}";
		echo mpr("{$stat_line}|[D" . strlen_clean_ansi_mpr($stat_line));
	}
	echo "\n";

	if (count($myisam) > 0) {
		$result['total_myisams'] = $total_myisams;
		$result['myisams'] = $myisam;
	}
	return array(
		'success' => $success,
		'errors' => $errors,
		'results' => $result,
	);
}



/**
 * Gets all MyISAM storage engine tables in a database
 * @param array $src destination connection
 * @param string $dbname database name to scan
 * @return mixed array of MyISAM tables in the database | FALSE on failure
 */
function get_myisam_tables($src, $dbname) {
	$sql = sprintf(
		'SHOW TABLE STATUS FROM %s WHERE ENGINE LIKE "MyISAM"',
		$dbname
	);
	return query_db($src, $sql);
}



/**
 * Run query on database regardless of method
 * For MySQL uses PDO object, for SSH uses SSH command
 * NOTE: use "" quotes in SQL queries for SSH compat.
 * @param array $con connection to run query on
 * @param string $sql for query
 * @param mixed results of query | FALSE on failure
 */
function query_db($con, $sql) {
	$success = false;
	$errors = array();
	$result = array();
	//connection is not valid return false
	if (!is_array($con) || !array_key_exists('method', $con['con']) || !array_key_exists('handle', $con['con'])) {
		return false;
	}
	switch ($con['method']) {
		case METHOD_MYSQLDUMP:
			try {
				$dbh = $con['con']['handle'];
				$sth = $dbh->query($sql);
				$res = $sth->execute();
				$dat = $sth->fetchAll(PDO::FETCH_COLUMN);
				$result = array(
					'method' => METHOD_MYSQLDUMP,
					'handle' => $con['con']['handle'],
					'rows' => $dat,
				);
				$success = true;
			} catch (PDOException $e) {
				$result = false;
				$success = false;
				$res = $e->getCode();
				array_push($errors, wordwrap("|20|12-|07 MySQL ERROR [{$res}]: " . $e->getMessage(), WRAP_WIDTH));
			}
            break;
        case METHOD_SSH:
            $mysql_user = $con['mysql_user'];
            $mysql_pass = $con['mysql_pass'];
            $mysql_cmd = sprintf(
                'mysql -u%s -p%s --exec="%s"',
                $mysql_user,
                str_replace('&', '\\&', $mysql_pass),
                str_replace('"', '\\"', $sql)
            );
            $cmd = $con['con']['handle'];
            $mysql_command = "{$cmd} '{$mysql_cmd}' 2>&1";
            exec($mysql_command, $out, $res);
			if ($res !== 0) {
				array_push($errors, wordwrap("|20|12-|07 MySQL ERROR [{$res}]: ({$mysql_command}):\n|20|12-|07 " . implode("\n", $out), WRAP_WIDTH));
				return false;
			} else {
				array_pop($out);
				if (count($out) == 0) {
					$out[0] = SQL_NO_ROWS;
				}
				$result = array(
					'method' => METHOD_SSH,
					'handle' => $con['con']['handle'],
					'rows' => get_rows_from_mysql_cli_output($out),
				);
				$success = true;
			}
			break;
	}
	return array(
		'success' => $success,
		'errors' => $errors,
		'results' => $result,
	);
}



/**
 * Cleans column data from MySQL query via SSH mysql command
 * @param string $val value to clean
 * @return mixed cleaned up value (with specific type that varies)
 */
function clean_column_data($val) {
	$trimmed = trim($val);
	$empty = empty($trimmed);
	$new_val = ($empty) ? 'NULL' : $trimmed;
	if (is_numeric($new_val)) {
		if (is_float($new_val)) {
			return (float) $new_val;
		} else {
			return (int) $new_val;
		}
	} else {
		return $new_val;
	}
}



/**
 * Gets rows from a MySQL CLI output into array format
 * @param array $output from the CLI as executed through SSH
 * @return mixed array of rows (array(0 => 'colname' => 'value')) | FALSE on failure
 */
function get_rows_from_mysql_cli_output($out) {
	if ($out[0] == SQL_NO_ROWS) {
		return array();
	} else {
		$column_row = $out[1];
		$data_rows_start = 3;
		$data_rows_end = (count($out) - $data_rows_start) - 1;
		$data_rows = array_slice($out, $data_rows_start, $data_rows_end);
		$columns = explode('|', substr($column_row, 1, strlen($column_row) - 1));
		$columns = array_filter(array_map('trim', $columns));
		$data = array();
		foreach ($data_rows as $idx => $line) {
			$column_data = explode('|', substr($line, 1, strlen($line) - 1));
			$column_data = array_filter(array_map('clean_column_data', $column_data));
			array_pop($column_data);
			$row = array_combine($columns, $column_data);
			array_push($data, $row);
		}
		return $data;
	}
}



/**
 * Verifies the users have grants to the database
 * @param array $src source connection
 * @param array $dst destination connection
 * @param array $options used for copy from CLI
 * @param arary $user_map map of users from INI format
 * @return mixed array of results from grant checks
 */
function verify_users($src, $dst, $options, $user_map) {
	$success = false;
	$errors = array();
	$warnings = array();
	$result = array('src' => array(), 'dst' => array());
	$db_count = count($user_map);
    $dbcl = sprintf('%03d', strlen($db_count));
	echo mpr(" |08[|15SRC|08] ");
	$result['src'] = verify_db_users($src, $user_map);
	$r = $result['src'];
    echo "\n" . BADGE_OK . " |~L{$dbcl}{$r['ok']}\n";
    $ok = mpr(BADGE_OK . " |~L{$dbcl}{$r['ok']} ");
    $warn = mpr(BADGE_WARN . " |~L{$dbcl}{$r['warn']} ");
    $fail = mpr(BADGE_FAIL . " |~L{$dbcl}{$r['fail']}");
    die(print_r(array('ok' => $ok, 'warn' => $warn, 'fail' => $fail)));
	echo mpr("|@R<{$ok} {$warn} {$fail}>");
	if (count($result['src']['errors']) > 0) {
		$errors = array_merge($errors, $result['src']['errors']);
	} else {
	}
	echo mpr("\n |08[|15DST|08] ");
	$result['dst'] = verify_db_users($dst, $user_map);
	$r = $result['dst'];
	echo mpr("|@R<" . BADGE_OK . " |07{$r['ok']} " . BADGE_WARN . " |07{$r['warn']} " . BADGE_FAIL . " |07{$r['fail']}>");
	if (count($result['dst']['errors']) > 0) {
		$errors = array_merge($errors, $result['dst']['errors']);
	} else {
	}
	// echo "\n";
	return array(
		'success' => $success,
		'errors' => $errors,
		'warnings' => $warnings,
		'results' => $result,
	);
}



/**
 * Helper function to verify_users - verifies db users on SSH/mysql connection
 * @param array $con connection to verify users with
 * @param array $user_map of users to verify
 * @return array result of verification
 */
function verify_db_users($con, $user_map) {
	$success = false;
	$errors = array();
	$result = array();
	$warnings = array();
	$ok = $fail = $warn = 0;
	if (!is_array($con)) {
		array_push($errors, '|12- |07verify_db_users(): connection is not an array');
	} else if (!array_key_exists('handle', $con['con'])) {
		array_push($errors, '|12- |07verify_db_users(): connection is missing handle');
	} else {
		foreach ($user_map as $database => $account) {
			echo mpr('|DE');
			if (!in_array($database, $con['con']['databases'])) {
				//we know that database doesn't exist don't try to verify it
				echo mpr('|14.');
				$warnings[$database] = "|14- " . BADGE_NOT_EXIST . " |07{$database} does not exist on {$con['host']}";
				$warn++;
			} else {
				//database exists verify user can access
				switch ($con['method']) {
				case METHOD_MYSQLDUMP:
					$result['verify_users'][$database] = (connect_db($con['host'], $con['port'], $account['user'], $account['pass'], $database) === false) ? false : true;
					break;
				case METHOD_SSH:
					$result['verify_users'][$database] = (connect_ssh($con['host'], $con['port'], $con['user'], $con['pass'], $account['user'], $account['pass'], $database) === false) ? false : true;
					break;
				}
				if ($result['verify_users'][$database] === false) {
					//has error
					echo mpr('|12.');
					$errors[$database] = "|12- " . BADGE_AUTH . " |07Cannot authenticate to {$con['host']} db={$database} user={$account['user']} pass={$account['pass']}";
					$fail++;
				} else {
					//no error
					echo mpr('|10.');
					$ok++;
				}
			}
		}
	}
	return array(
		'success' => $success,
		'errors' => $errors,
		'warnings' => $warnings,
		'results' => $result,
		'ok' => $ok,
		'warn' => $warn,
		'fail' => $fail,
	);
}



/**
 * Draws the header for the program
 * @return void
 */
function output_header() {
	$screen = get_viewport_dimensions();
	echo mpr('|CL|19' . str_repeat(' ', $screen['columns'] - 1) . ' |[YX01;01|15 ' . app_name() . '|[YX01;02|16|07');
}



/**
 * Outputs the summary
 * @return void
 */
function output_summary() {
	global $procflags, $src, $dst, $opt;
	$verify_users = ($opt->options['verify_users']) ? 'Yes' : 'No';
	$alter_innodb = ($opt->options['alter_innodb']) ? 'Yes' : 'No';
	$rebuild_indexes = ($opt->options['rebuild_indexes']) ? 'Yes' : 'No';
	$abort_on_error = ($opt->options['abort_on_error']) ? 'Yes' : 'No';
	$clean_up = ($opt->options['clean_up']) ? 'Yes' : 'No';
	$notify_db = ($opt->options['notify_db']) ? 'x' : ' ';
	$notify_job = ($opt->options['notify_job']) ? 'x' : ' ';
	if (!is_null($opt->options['email'])) {
		$recipients = explode(',', $opt->options['email']);
		$comma = mpr('|07,|15');
		$recipients = implode($comma, $recipients);
	} else {
		$recipients = 'No recipients';
	}
	if (!is_null($opt->options['user_map_file'])) {
		$user_map_file = $opt->options['user_map_file'];
	} else {
		$user_map_file = 'Not specified';
	}
	echo h1('SUMMARY');
	$out = <<<EOF
 |07|~L40 <Source: {$src['status']}> |07Destination: {$dst['status']}

 |07|~L40 <Verify Users: |15{$verify_users}> |07User Map: |15{$user_map_file}
 |07|~L40 <MyISAM to InnoDB: |15{$alter_innodb}> |07Rebuild Indexes: |15{$rebuild_indexes}
 |07|~L40 <Abort on Error: |15{$abort_on_error}> |07Clean Up: |15{$clean_up}

 |07Notify these recipients via email:
 |15{$recipients}

 |07When:
 |07|~L40 <[|15{$notify_db}|07] Each database is completed> |07[|15{$notify_job}|07] Entire job completed

EOF;
	echo mpr($out);
}



/**
 * Output the connection details
 * @param array $src Source array of variable data
 * @param array $dst Destination array of variable data
 * @return void
 */
function output_connection_details($src, $dst) {
	$src['pass'] = (!empty($src['pass'])) ? $src['pass'] : '|14NONE (SSH Key)';
	$dst['pass'] = (!empty($dst['pass'])) ? $dst['pass'] : '|14NONE (SSH Key)';
	$out = <<<EOF
 |15|~L40 <SOURCE> |~L40 <DESTINATION>

 |07|~L40 <Method: |15{$src['method']}> |07Method: |15{$dst['method']}
 |07|~L40 <Host: |15{$src['host']}> |07Host: |15{$dst['host']}
 |07|~L40 <Port: |15{$src['port']}> |07Port: |15{$dst['port']}
 |07|~L40 <User: |15{$src['user']}> |07User: |15{$dst['user']}
 |07|~L40 <Pass: |15{$src['pass']}> |07Pass: |15{$dst['pass']}
 |07|~L40 <Status: |15{$src['status']}> |07Status: |15{$dst['status']}

 |07|~L40 <MySQL User: |15{$src['mysql_user']}> |07MySQL User: |15{$dst['mysql_user']}
 |07|~L40 <MySQL Pass: |15{$src['mysql_pass']}> |07MySQL Pass: |15{$dst['mysql_pass']}
 |07|~L40 <Status: |15{$src['mysql_status']}> |07Status: |15{$dst['mysql_status']}

EOF;
	//echo the output
	echo mpr($out);
}



/**
 * Outputs the operation queue table
 * @param array $src Source array of data
 * @param array $dst Destination array of data
 * @return void
 */
function output_operation_queue($src, $dst) {
	global $opt, $errors;
	$col_len = 39;
	$divider1 = str_repeat('-', $col_len);
	$divider2 = str_repeat('=', $col_len);

	//databases desired to be copied
	$src_list = $src['con']['databases'];
	//all databases which EXIST on destination
	$dst_list = $dst['con']['databases'];
	//source databases which EXIST on destination
	$existing = array_intersect($src_list, $dst_list);
	//source databases which do NOT EXIST on destination
	$dif_list = array_diff($src_list, $dst_list);

	//list of operations to be completed and status between src/dst
	$ops_list = array();
	foreach ($src_list as $idx => $database) {
		array_push(
			$ops_list,
			array(
				'name' => $database,
				'src_exists' => in_array($database, $src['con']['databases']),
				'dst_exists' => in_array($database, $dst_list),
				'dst_overwrite' => in_array($database, $existing),
				'dst_myisam' => count($dst['myisams'][$database]),
				'dst_index' => $dst['indexes'][$database]['db_index_count']
			)
		);
	}

	//--force used and overwriting, or no overwriting required
	//table header
	$name_len = get_longest_dbname($src, $dst);
	$cols = array(
		'src' => array(
			'name' => $name_len, 
			'exists' => 3
		), 
		'dst' => array(
			'name' => $name_len, 
			'exists' => 3, 
			'overwrite' => 3,
			'myisam' => 6,
			'index' => 6
		)
	);

	$op_summary = array();
	if (count($ops_list) > 0) {
		array_push($op_summary, '|15COPY: |10' . number_format(count($ops_list)));
	}
	if (count($existing) > 0) {
		array_push($op_summary, '|15OVERWRITE: |12' . number_format(count($existing)));
	}
	if ($dst['total_myisams'] > 0 && $opt->options['alter_innodb']) {
		array_push($op_summary, '|15ALTER: |14' . number_format($dst['total_myisams']));
	}
	if ($dst['total_indexes'] > 0 && $opt->options['rebuild_indexes']) {
		array_push($op_summary, '|15RE-INDEX: |06' . number_format($dst['total_indexes']));
	}
	echo h2('DATABASE OPERATION QUEUE', implode(' ', $op_summary));

	echo mpr(sprintf(' |07|~L%02d <|15SOURCE |07DB NAME> |~L%02d <EX?> |~L%02d <|15DESTINATION |07DB NAME> |~L%02d <EX?> |~L%02d <OW?> |~L%02d <MYISAM> |~L%02d <INDEX>',
		$cols['src']['name'],
		$cols['src']['exists'],
		$cols['dst']['name'],
		$cols['dst']['exists'],
		$cols['dst']['overwrite'],
		$cols['dst']['myisam'],
		$cols['dst']['index']
	));
	echo "\n";
	echo mpr(sprintf(' |08|~D%02d- |~D%02d- |~D%02d- |~D%02d- |~D%02d- |~D%02d- |~D%02d-',
		$cols['src']['name'],
		$cols['src']['exists'],
		$cols['dst']['name'],
		$cols['dst']['exists'],
		$cols['dst']['overwrite'],
		$cols['dst']['myisam'],
		$cols['dst']['index']
	));

	//table body
	foreach ($ops_list as $idx => $op) {
		$op['src_exists'] = ($op['src_exists']) ? mpr('|02Y') : mpr('|04N');
		$op['dst_exists'] = ($op['dst_exists']) ? mpr('|04Y') : mpr('|06N');
		$op['dst_overwrite'] = ($op['dst_overwrite']) ? mpr('|12Y') : mpr('|08-');
		$op['dst_myisam'] = ($op['dst_myisam']) ? mpr("|14{$op['dst_myisam']}") : ' ';
		$op['dst_index'] = ($op['dst_index']) ? mpr("|06{$op['dst_index']}") : ' ';

		echo mpr(sprintf("\n |07|~L%02d <{$op['name']}> |~C%02d <{$op['src_exists']}> |07|~L%02d <{$op['name']}> |~C%02d <{$op['dst_exists']}> |~C%02d <{$op['dst_overwrite']}> |~C%02d <{$op['dst_myisam']}> |~C%02d <{$op['dst_index']}>",
			$cols['src']['name'],
			$cols['src']['exists'],
			$cols['dst']['name'],
			$cols['dst']['exists'],
			$cols['dst']['overwrite'],
			$cols['dst']['myisam'],
			$cols['dst']['index']
		));
	}
	//check for overwrite and lack of --force option
	if (count($existing) > 0 && $opt->options['force'] == false) {
		array_push($errors, mpr('|12- |07Attempted to copy |08(|15' . count($existing) . '|08) |07database(s) that would be overwritten on destination!'));
		output_errors();
		echo mpr("|14- |07Use of |15--force |07is required to overwrite databases that already exist on destination.\n");
		die();
	}
	echo "\n";
}



/**
 * Outputs the errors encountered from processing
 * @return void
 */
function output_errors() {
	global $errors, $warnings;
	echo h3('MESSAGES', '|11LEGEND|03: ' . BADGE_OK . ' ' . BADGE_WARN . ' ' . BADGE_FAIL . ' |20|12 CONNECTION ERROR |16|07');
	echo mpr(implode("\n", str_replace("\n", "\n", $errors)));
	echo mpr(implode("\n", str_replace("\n", "\n", $warnings)) . "\n");
}



/**
 * Returns an array without the ignored dbs
 * @param array $dbs to process
 * @return array of databases omitting ignored dbs
 */
function strip_ignored_dbs($dbs) {
	global $ignored_dbs;
	$ignore = '|' . implode('|', $ignored_dbs) . '|';
	$ret = array();
	foreach ($dbs as $idx => $dbname) {
		if (strpos($ignore, "|{$dbname}|") !== false) {
			continue;
		}
		array_push($ret, $dbname);
	}
	return $ret;
}



/**
 * Connects to MySQL database, returns PDO object
 * @param string $host hostname of the MySQL database server
 * @param int $port port the MySQL database server listens on
 * @param string $user username to connect with
 * @param string $pass password to connect with
 * @param string $name database name to connect to
 * @return mixed array PDO database object, and list of databases on success | FALSE on failure
 */
function connect_db($host, $port, $user, $pass, $name) {
	global $parser, $errors;
	$dsn = "mysql:host={$host};port={$port};dbname={$name}";
	try {
		$dbh = new PDO($dsn, $user, $pass);
		$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sth = $dbh->query("show databases");
		$res = $sth->execute();
		$dat = $sth->fetchAll(PDO::FETCH_COLUMN);
		return array(
			'method' => METHOD_MYSQLDUMP,
			'handle' => $dbh,
			'databases' => strip_ignored_dbs($dat),
		);
	} catch (PDOException $e) {
		$res = $e->getCode();
		array_push($errors, wordwrap("|20|12-|07 MySQL ERROR [{$res}]: " . $e->getMessage(), WRAP_WIDTH));
		//$parser->displayError("MySQL ERROR [{$res}]: " . $e->getMessage());
		return false;
	}
}



/**
 * Connects to server via SSH
 * @param string $host hostname of the MySQL database server
 * @param int $port port the database server listens on for SSH
 * @param string $user username to connect to SSH with
 * @param string $pass password to connect to SSH with
 * @param string $mysql_user username to connect to MySQL with
 * @param string $mysql_pass password to connect to MySQL with
 * @param string $name database name to connect to
 * @return mixed array string to execute SSH command on successful ssh and MySQL use, and list of databases | FALSE on failure
 */
function connect_ssh($host, $port, $user, $pass, $mysql_user, $mysql_pass, $name) {
	global $parser, $errors;
	$cmd = sprintf(
		'ssh -o BatchMode=yes -t %s %s%s@%s',
		(!empty($port)) ? "-p{$port}" : ' ',
		$user,
		(!empty($pass)) ? ":{$pass}" : '',
		$host
	);
	$mysql_cmd = sprintf(
		'mysql -u%s -p%s --exec="show databases"',
		$mysql_user,
		str_replace('&', '\\&', $mysql_pass),
		str_replace('&', '\\&', $name)
	);
	$ssh_command = "{$cmd} pwd 2>&1";
	exec($ssh_command, $out, $res);
	if ($res !== 0) {
		array_push($errors, wordwrap("|20|12-|07 SSH ERROR [{$res}] ({$ssh_command}):\n|20|12-|07 " . implode("\n", $out), WRAP_WIDTH));
		array_pop($out);
		//$parser->displayError("SSH ERROR [{$res}] ({$ssh_command}):\n" . implode("\n", $out));
		return false;
	} else {
		$mysql_command = "{$cmd} '{$mysql_cmd}' 2>&1";
		exec($mysql_command, $out, $res);
		//remove heading output from ssh command execution
		array_shift($out);
		array_shift($out);
		//remove connection closed from ssh output
		array_pop($out);
		if ($res !== 0) {
			array_push($errors, wordwrap("|20|12-|07 MySQL ERROR [{$res}]: ({$mysql_command}):\n|20|12-|07 " . implode("\n", $out), WRAP_WIDTH));
			//$parser->displayError("MySQL ERROR [{$res}] ({$mysql_command}):\n" . implode("\n", $out));
			return false;
		} else {
			$out = implode("\n", $out);
			$tmp = preg_replace('/[^\\w]{3,}/s', "\n", $out);
			$dat = explode("\n", $tmp);
			//clean up the mysql table
			array_shift($dat);
			array_shift($dat);
			array_pop($dat);
			return array(
				'method' => METHOD_SSH,
				'handle' => $cmd,
				'databases' => strip_ignored_dbs($dat),
			);
		}
	}
}



/**
 * Parses a URI (uniform resource identifier) and returns array of it's parts
 * If any parts are missing will set them to empty strings ('').
 *
 * Example:
 *  ssh:username:password@10.0.0.127:3306/database
 *
 * @param string $uri to parse
 * @return mixed array of URI parts method, user, pass, host, port, and name on success | null on failure
 */
function parse_uri($uri) {
	if (preg_match('%(ssh|mysql)?:?([^:]*):?(.*)?@([^/:]*):?([^/]*)?/?(.*)?%', $uri, $matches)) {
		list($all, $method, $user, $pass, $host, $port, $name) = $matches;
		$ret = array(
			'method' => $method,
			'user' => $user,
			'mysql_user' => $user,
			'pass' => $pass,
			'mysql_pass' => $pass,
			'host' => $host,
			'port' => $port,
		);
		$ret['name'] = explode(',', $name);
		$ret['name'] = array_filter(array_map('trim', $ret['name']));
		return $ret;
	} else {
		return null;
	}
}



/**
 * Mystic PaRser
 * |00 - |23 = Color codes:
 *   FG (00 = Black, Dark blue, Dark green, Dark cyan, Dark red, Dark magenta, Dark yellow, Light gray, Dark gray,
 *       09 = Light blue, Light green, Light cyan, Light red, Light magenta, Light yellow, 15 = White)
 *   BG (16 = Black, Blue, Green, Cyan, Red, Magenta, Yellow, 23 = Grey)
 * NOTE: xx = 0 padded chars, e.g. for 5 of them, use 05, for 50% use 050.
 * |~Cxxxz<{str}> - Pads {string} to center (literally enclosed in <>'s) xxx times with z char by char unit
 * |~Lxxxz<{str}> - Pads {string} to left (literally enclosed in <>'s) xxx times with z char by char unit
 * |~Rxxxz<{str}> - Pads {string} to right (literally enclosed in <>'s) xxx times with z char by char unit
 * |~Dxxxz - Duplicates z char xxx times by char unit
 * |%Cxxxz<{str}> - Pads {string} to center (literally enclosed in <>'s) xxx times with z char by percent unit
 * |%Lxxxz<{str}> - Pads {string} to left (literally enclosed in <>'s) xxx times with z char by percent unit
 * |%Rxxxz<{str}> - Pads {string} to right (literally enclosed in <>'s) xxx times with z char by percent unit
 * |%YXccc;rrr - Mover cursor to row rrr column ccc
 * |%Xccc - Mover cursor to column ccc (on current row) by percent unit
 * |%Dxxxz - Duplicates z char xxx times by percent unit
 * |[Axxx - Moves cursor up xxx rows by char unit
 * |[Bxxx - Moves cursor down xxx rows by char unit
 * |[Cxxx - Moves cursor right xxx columns by char unit
 * |[Dxxx - Moves cursor left xxx columns by char unit
 * |[YXccc;rrr - Moves cursor to row rrr column ccc by char unit
 * |[Xccc - Move cursor to column ccc (on current row) by char unit
 * |@C<str> - Align {string} to center (literally enclosed in <>'s) - unique from pad since it moves cursor, not pads it
 * |@L<str> - Align {string} to left (literally enclosed in <>'s) - unique from pad since it moves cursor, not pads it
 * |@R<str> - Align {string} to right (literally enclosed in <>'s) - unique from pad since it moves cursor, not pads it
 * |CL - Clear screen
 * |DE - Delay 1/10th second
 * |TC - Twirling cursor
 * @example |08|~L20 <DB NAME> |~L10 <EXISTS?> |~L20 <DB NAME> |~L10 <EXISTS?> |~L10 <OVERWRITE?>
 * @example |08|~L20 <|15DB NAME> |~C10 <EXISTS?> |~L20 <|15DB NAME> |~C10 <EXISTS?> |~C10 <OVERWRITE?>
 * @param string $string to parse
 * @author Rick Christy (ported to PHP from Mystic BBS MCI Parser by James Coyle)
 * @return string parsed version of the string replaced with ANSI codes
 */
function mpr($str) {
	global $screen;
	$c = array(
		'00' => ESC . '[0;30m', //black foreground
		'01' => ESC . '[0;34m', //dark blue foreground
		'02' => ESC . '[0;32m', //dark green foreground
		'03' => ESC . '[0;36m', //dark cyan foreground
		'04' => ESC . '[0;31m', //dark red foreground
		'05' => ESC . '[0;35m', //dark magenta foreground
		'06' => ESC . '[0;33m', //dark yellow foreground
		'07' => ESC . '[0;37m', //light gray  foreground
		'08' => ESC . '[1;30m', //dark gray foreground
		'09' => ESC . '[1;34m', //bright blue foreground
		'10' => ESC . '[1;32m', //bright green foreground
		'11' => ESC . '[1;36m', //bright cyan foreground
		'12' => ESC . '[1;31m', //bright red foreground
		'13' => ESC . '[1;35m', //bright magenta foreground
		'14' => ESC . '[1;33m', //bright yellow foreground
		'15' => ESC . '[1;37m', //white foreground
		'16' => ESC . '[40m', //black background
		'17' => ESC . '[44m', //blue background
		'18' => ESC . '[42m', //green background
		'19' => ESC . '[46m', //cyan background
		'20' => ESC . '[41m', //red background
		'21' => ESC . '[45m', //magenta background
		'22' => ESC . '[43m', //yellow background
		'23' => ESC . '[47m', //gray background
	);
	preg_match_all(MPR_REGEX, $str, $mci);
	$parsed = $str;
	for ($i = 0; $i < count($mci[0]); $i++) {
		//main switch
		switch (substr($mci[0][$i], 0, 2)) {
			//colors
			case '|0':
			case '|1':
			case '|2':
				$code = $mci[0][$i];
				$color = substr($mci[0][$i], 1, 2);
				$parsed = preg_replace('/' . preg_quote($code) . '/', $c[$color], $parsed, 1);
				break;
			//clear screen
			case '|C':
				$code = $mci[0][$i];
				if ($code == '|CL') {
					$parsed = preg_replace('/' . preg_quote($code) . '/', ESC . '[2J' . ESC . '[0;0H', $parsed, 1);
				}
				break;
			//delay
			case '|D':
				$code = $mci[0][$i];
				if ($code == '|DE') {
					$parsed = preg_replace('/' . preg_quote($code) . '/', '', $parsed, 1);
					if (!BATCH_MODE) {
						usleep(100000); //1/10th of a second
						flush();
					}
				}
				break;
			//twirling cursor
			case '|T':
				$code = $mci[0][$i];
				if ($code == '|TC') {
					$parsed = preg_replace('/' . preg_quote($code) . '/', '', $parsed, 1);
					if (!BATCH_MODE) {
						twirl_cursor();
					}
				}
				break;
			//align by movement
			case '|@':
				switch (substr($mci[0][$i], 2, 1)) {
					case 'C':
						//center
						$dir = STR_PAD_BOTH;
						preg_match_all('/(\\|@C)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$str = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($str)) {
							$str = mpr($str);
						}
						$aligned = align_text($str, $dir);
						$parsed = preg_replace($find, $aligned, $parsed, 1);
						break;
					case 'L':
						//left
						$dir = STR_PAD_LEFT;
						preg_match_all('/(\\|@L)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$str = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($str)) {
							$str = mpr($str);
						}
						$aligned = align_text($str, $dir);
						$parsed = preg_replace($find, $aligned, $parsed, 1);
						break;
					case 'R':
						//right
						$dir = STR_PAD_RIGHT;
						preg_match_all('/(\\|@R)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$str = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($str)) {
							$str = mpr($str);
						}
						$aligned = align_text($str, $dir);
						$parsed = preg_replace($find, $aligned, $parsed, 1);
						break;
				} //align by movement
				break;
			//padding + repeat by char
			case '|~':
				switch (substr($mci[0][$i], 2, 1)) {
					case 'C':
						//center
						$pad = STR_PAD_BOTH;
						preg_match_all('/(\\|~C)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$padded = full_str_pad($padstr, $amount, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'L':
						//right
						$pad = STR_PAD_RIGHT;
						preg_match_all('/(\\|~L)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$padded = full_str_pad($padstr, $amount, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'R':
						//left
						$pad = STR_PAD_LEFT;
						preg_match_all('/(\\|~R)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$padded = full_str_pad($padstr, $amount, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'D':
						//duplicate
						preg_match_all('/(\\|~D)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$repstr = str_repeat($char, $amount);
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$parsed = preg_replace($find, $repstr, $parsed, 1);
						break;
				} //padding + repeat by char
				break;
			//padding, repeat, and move by percent
			case '|%':
				switch (substr($mci[0][$i], 2, 1)) {
					case 'C':
						//center
						preg_match_all('/(\\|%C)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$amount_from_percent = (int) floor((int) $screen['columns'] / 100 * $amount);
						$padded = full_str_pad($padstr, $amount_from_percent, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'L':
						//right
						preg_match_all('/(\\|%L)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$amount_from_percent = (int) floor((int) $screen['columns'] / 100 * $amount);
						$padded = full_str_pad($padstr, $amount_from_percent, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'R':
						//left
						preg_match_all('/(\\|%R)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$padstr = substr($mci[0][$i + 1], 1, (strlen($mci[0][$i + 1]) - 2));
						$find = "{$mci[0][$i]}{$mci[0][$i + 1]}";
						$find = '/' . preg_quote($find) . '/';
						if (is_mpr($padstr)) {
							$padstr = mpr($padstr);
						}
						$amount_from_percent = (int) floor((int) $screen['columns'] / 100 * $amount);
						$padded = full_str_pad($padstr, $amount_from_percent, $char, $pad);
						$parsed = preg_replace($find, $padded, $parsed, 1);
						break;
					case 'D':
						//duplicate
						preg_match_all('/(\\|%D)(\\d{1,3})(.)/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$char = $matches[3][0];
						$amount_from_percent = (int) floor((int) $screen['columns'] / 100 * $amount);
						$repstr = str_repeat($char, $amount_from_percent);
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$parsed = preg_replace($find, $repstr, $parsed, 1);
						break;
					case 'X':
						//gotox
						preg_match_all('/(\\|%X)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$col = $matches[2][0];
						$col_from_percent = (int) floor((int) $screen['columns'] / 100 * $col);
						$row = $matches[3][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $col_from_percent . 'G';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'Y':
						//cursor movement yx
						switch (substr($mci[0][$i], 2, 2)) {
							case 'YX':
								//gotoyx
								preg_match_all('/(\\|%YX)(\\d{1,3});(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
								$code = $matches[1][0];
								$col = $matches[3][0];
								$col_from_percent = (int) floor((int) $screen['columns'] / 100 * $col);
								$row = $matches[2][0];
								$find = $mci[0][$i];
								$find = '/' . preg_quote($find) . '/';
								$movestr = ESC . '[' . (int) $row . ';' . (int) $col_from_percent . 'H';
								$parsed = preg_replace($find, $movestr, $parsed, 1);
								break;
						} //cursor movement yx
						break;
				} //padding + repeat by percent
				break;
			//cursor movement
			case '|[':
				switch (substr($mci[0][$i], 2, 1)) {
					case 'A':
						//up
						preg_match_all('/(\\|\\[A)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $amount . 'A';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'B':
						//down
						preg_match_all('/(\\|\\[B)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $amount . 'B';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'C':
						//right
						preg_match_all('/(\\|\\[C)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $amount . 'C';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'D':
						//left
						preg_match_all('/(\\|\\[D)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$amount = $matches[2][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $amount . 'D';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'X':
						//gotox
						preg_match_all('/(\\|\\[X)(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
						$code = $matches[1][0];
						$col = $matches[2][0];
						$find = $mci[0][$i];
						$find = '/' . preg_quote($find) . '/';
						$movestr = ESC . '[' . (int) $col . 'G';
						$parsed = preg_replace($find, $movestr, $parsed, 1);
						break;
					case 'Y':
						//cursor movement yx
						switch (substr($mci[0][$i], 2, 2)) {
							case 'YX':
								//gotoyx
								preg_match_all('/(\\|\\[YX)(\\d{1,3});(\\d{1,3})/', $mci[0][$i], $matches, PREG_PATTERN_ORDER);
								$code = $matches[1][0];
		                        $row = $matches[2][0];
								$col = $matches[3][0];
								$find = $mci[0][$i];
								$find = '/' . preg_quote($find) . '/';
								$movestr = ESC . '[' . (int) $row . ';' . (int) $col . 'H';
								$parsed = preg_replace($find, $movestr, $parsed, 1);
								break;
						} //cursor movement yx
						break;					
				} //cursor movement directions
				break;
		} //main switch
	} //regex loop
	return $parsed;
}



/**
 * Aligns text to left, center, or right side of the screen
 * @param string $str to align
 * @param int $dir direction to align to
 * @return string with code used to align the text to screen
 */
function align_text($str, $dir) {
	$len = strlen_clean_ansi_mpr($str);
	switch ($dir) {
	case STR_PAD_LEFT:
		$col = 1;
		break;
	case STR_PAD_BOTH:
		$col = floor((CLI_LINEWIDTH - $len) / 2);
		break;
	case STR_PAD_RIGHT:
		$col = CLI_LINEWIDTH - $len;
		break;
	}
	return ESC . "[{$col}G{$str}";
}



/**
 * Strips Mystic PaRser codes from string
 * @param string $str to strip codes from
 * @return string free of Mystic PaRser codes
 */
function strip_mpr($str) {
	$parsed = preg_replace(MPR_REGEX, '', $str);
	return $parsed;
}



/**
 * Strips ANSI codes from string
 * @param string $str to strip codes from
 * @return string free of ANSI codes
 */
function strip_ansi($str) {
	$parsed = preg_replace(ANSI_REGEX, '', $str);
	return $parsed;
}



/**
 * Determines if string is using Mystic PaRser codes
 * @param string $str to check
 * @return boolean TRUE if string is using MPR | FALSE otherwise
 */
function is_mpr($str) {
	preg_match_all(MPR_REGEX, $str, $mci);
	return (count($mci[0]) > 0);
}



/**
 * Determines if string is using ANSI codes
 * @param string $str to check
 * @return boolean TRUE if string is using MPR | FALSE otherwise
 */
function is_ansi($str) {
	preg_match_all(ANSI_REGEX, $str, $ansi);
	return (count($ansi[0]) > 0);
}



/**
 * Returns length of string without ANSI or MPR codes
 * @param string $str to get length of
 * @return int length of string without ANSI or MPR codes
 */
function strlen_clean_ansi_mpr($str) {
	$len = 0;
	preg_match_all(ANSI_REGEX, $str, $ansi);
	$len += strlen(implode('', $ansi[0]));
	preg_match_all(MPR_REGEX, $str, $mpr);
	$len += strlen(implode('', $mpr[0]));
	$len = strlen($str) - $len;
	return $len;
}



/**
 * Returns length of string without ANSI codes
 * @param string $str to get length of
 * @return int length of string without ANSI codes
 */
function strlen_clean_ansi($str) {
	preg_match_all(ANSI_REGEX, $str, $ansi);
	$len = 0;
	for ($i = 0; $i < count($ansi[0]); $i++) {
		$match = $ansi[0][$i];
		$len += strlen($match);
	}
	$len = strlen($str) - $len;
	return $len;
}



/**
 * Replaces \033 ESC code with @ text to visually debug ANSI code
 * @param string $str to decode
 * @return string with \033 ESC replaced with @ text
 */
function decode_esc($str) {
	return str_replace(ESC, '@', $str);
}



/**
 * Custom str_pad function using str_repeat instead
 * @param string $input string to pad
 * @param int $pad_length length of padding
 * @param string $pad_string to use for padding
 * @param int $pad_type type of padding to use:
 *            (LEFT|RIGHT|BOTH) compatible with str_pad() constants
 * @author bob@bobarmadillo.com
 * @link http://php.net/manual/en/function.str-pad.php#27364
 */
function full_str_pad($input, $pad_length, $pad_string = '', $pad_type = 0) {
	$str = '';
	$length = $pad_length - strlen_clean_ansi($input);
	if ($length > 0) {
		// str_repeat doesn't like negatives
		if ($pad_type == STR_PAD_RIGHT) {
			// STR_PAD_RIGHT == 1
			$str = $input . str_repeat($pad_string, $length);
		} elseif ($pad_type == STR_PAD_BOTH) {
			// STR_PAD_BOTH == 2
			$str = str_repeat($pad_string, floor($length / 2));
			$str .= $input;
			$str .= str_repeat($pad_string, ceil($length / 2));
		} else {
			// defaults to STR_PAD_LEFT == 0
			$str = str_repeat($pad_string, $length) . $input;
		}
	} else {
		// if $length is negative or zero we don't need to do anything
		$str = $input;
	}
	return $str;
}



/**
 * Sends an email
 * @param boolean $html send email as HTML format?
 * @param mixed $to recipient of email (array('First Last' => 'email'), or string)
 * @param string $from sender of email
 * @param string $subject subject of email
 * @param string $body email body
 * @param mixed $cc recipient of email in carbon copy (array('First Last' => 'email'), or string)
 * @param mixed $bcc recipient of email in blind carbon copy (array('First Last' => 'email'), or string)
 * @return boolean TRUE if mail sent successfully | FALSE otherwise
 */
function send_email($html = false, $to, $from, $subject, $body, $cc = null, $bcc = null) {
	$recipients = array('to' => array(), 'cc' => array(), 'bcc' => array());
	if ($html) {
		$headers = array(
			'MIME-Version: 1.0',
			'Content-type: text/html; charset=iso-8859-1',
		);
	} else {
		$headers = array();
	}
	if (is_array($to)) {
		foreach ($to as $name => $email) {
			array_push($recipients['to'], "{$name} <{$email}>");
			$to = $email;
		}
	} else {
		array_push($recipients['to'], $to);
	}
	if (is_array($cc)) {
		foreach ($cc as $name => $email) {
			array_push($recipients['cc'], "{$name} <{$email}>");
		}
	} else {
		if (!is_null($cc)) {
			array_push($recipients['cc'], $cc);
		}
	}
	if (is_array($bcc)) {
		foreach ($bcc as $name => $email) {
			array_push($recipients['bcc'], "{$name} <{$email}>");
		}
	} else {
		if (!is_null($bcc)) {
			array_push($recipients['bcc'], $bcc);
		}
	}
	array_push($headers, 'From: ' . $from);
	if (count($recipients['to']) > 0) {
		array_push($headers, 'To: ' . implode(', ', $recipients['to']));
	}
	if (count($recipients['cc']) > 0) {
		array_push($headers, 'Cc: ' . implode(', ', $recipients['cc']));
	}
	if (count($recipients['bcc']) > 0) {
		array_push($headers, 'Bcc: ' . implode(', ', $recipients['bcc']));
	}
	$header = implode("\r\n", $headers);
	return mail($to, $subject, $body, $header);
}



/**
 * Sends an email using an array (using send_email function)
 * @param array $args in format:
 * email(array(
 *     'html' => true,
 *     'to' => 'String or array of CC recipients (name <email.com> or email.com format)',
 *     'from' => 'First Last <first_last@sending_domain.com>',
 *     'subject' => 'Email subject here',
 *     'body' => 'Email body here - can be HTML if pass html = true',
 *     'cc' => 'String or array of CC recipients (name <email.com> or email.com format)',
 *     'bcc' => 'String or array of BCC recipients (name <email.com> or email.com format)',
 * ));
 * @example
 * $to = array('Rick Christy' => 'rchristy@carbonmedia.com', 'Rick Christy' => 'rchristy@outdoorhub.com');
 * $bcc = array('Rick Christy' => 'rchristy@outsidehub.com', 'rick' => 'rick@soundgasmdesign.com');
 * $cc = array('grymmj4ck' => 'grymmj4ck@hotmail.com', 'Rick Christy' => 'grymmjack@gmail.com');
 * $from = 'Rick Christy <rchristy@carbonmedia.com>';
 * $subject = 'Test email sending from db-copy';
 * $body = 'Testing from db-copy.';
 * $message = '<table border="1" cellpadding="5"><tr><td>Test Cell</td><td>Test cell 2</td></tr></table>';
 * email(
 *     array(
 *         'html' => true,
 *         'to' => $to,
 *         'from' => $from,
 *         'subject' => $subject,
 *         'body' => $message,
 *         'cc' => $cc,
 *         'bcc' => $bcc,
 *     )
 * );
 * @return boolean TRUE if email sent successfully | FALSE otherwise
 */
function email($args) {
	return send_email(
		$args['html'],
		$args['to'],
		$args['from'],
		$args['subject'],
		$args['body'],
		$args['cc'],
		$args['bcc']
	);
}



/**
 * Shows the textmode cursor
 * @return void
 */
function show_cursor() {
	if (substr(PHP_OS, 0, 3) == 'WIN') {
		echo ESC . '[25h';
	} else {
		//linux
		passthru('tput cnorm');
	}
}



/**
 * Hides the textmode cursor
 * @return void
 */
function hide_cursor() {
	if (substr(PHP_OS, 0, 3) == 'WIN') {
		echo ESC . '[25l';
	} else {
		//linux
		passthru('tput civis');
	}
}



/**
 * Outputs a twirling cursor
 * @return void
 */
function twirl_cursor() {
	$delay = 10000;
	$cursor = '\\|//-';
	//hide_cursor();
	echo mpr('|07');
	for ($x = 0; $x < 1; $x++) {
		for ($i = 0; $i < strlen($cursor); $i++) {
			echo $cursor[$i] . mpr('|[D01');
			usleep($delay);
			flush();
		}
		$x++;
	}
	echo mpr(' |[D01');
	//show_cursor();
}



/**
 * Introspects on viewport and gets number of columns and rows
 * @return array of viewport columns and rows
 */
function get_viewport_dimensions() {
	$columns = CLI_COLUMNS_DEFAULT;
	$lines = CLI_LINES_DEFAULT;
	if (substr(PHP_OS, 0, 3) == 'WIN') {
		$out = trim(`cmd /c mode`);
		preg_match_all('/Lines:\\s*(?P<lines>\\d*)\\n\\s*Columns:\\s*(?P<columns>\\d*)\\n/s', $out, $matches, PREG_PATTERN_ORDER);
		$columns = $matches['columns'][0];
		$lines = $matches['lines'][0];
	} else {
		//LINUX
		$out = trim(`stty size`);
		if (preg_match('/(?P<lines>.*) (?P<columns>.*)/', $out, $matches)) {
			$columns = $matches['columns'];
			$lines = $matches['lines'];
		}
	}
	return array(
		'columns' => $columns,
		'lines' => $lines,
	);
}



/**
 * Main header string
 * @param string $str for header
 * @return string header formatted
 */
function h1($str) {
	return mpr("\n\n|15 " . kerning($str, 1) . "|07\n\n");
}



/**
 * Sub header string
 * @param string $str_left left side of the header
 * @param string $str_right right side of the header
 * @return string header formatted
 */
function h2($str_left, $str_right = null) {
	$div_width = WRAP_WIDTH - 1;
	if (!empty($str_left)) {
		$str_left = " {$str_left} ";
	} else {
		$str_left = ' ';
	}
	$cols_left = sprintf('%03d', WRAP_WIDTH - 1);
	$ret = "\n|~L{$div_width}=<|11{$str_left}|03>";
	if (!is_null($str_right)) {
		$str_right = "|03[ {$str_right} |03]";
		$cols_right = strlen_clean_ansi_mpr($str_right);
		$ret .= "|[D{$cols_right}|03{$str_right}";
	}
	$parsed = "\n\n" . mpr($ret) . "\n\n";
	return $parsed;
}



/**
 * Sub header string for errors
 * @param string $str_left left side of the header
 * @param string $str_right right side of the header
 * @return string header formatted
 */
function h3($str_left, $str_right = null) {
	$div_width = WRAP_WIDTH - 1;
	if (!empty($str_left)) {
		$str_left = " {$str_left} ";
	} else {
		$str_left = ' ';
	}
	$cols_left = sprintf('%03d', WRAP_WIDTH - 1);
	$ret = "\n|~L{$div_width}=<|12{$str_left}|04>";
	if (!is_null($str_right)) {
		$str_right = "|04[ {$str_right} |04]";
		$cols_right = strlen_clean_ansi_mpr($str_right);
		$ret .= "|[D{$cols_right}|04{$str_right}";
	}
	$parsed = "\n\n" . mpr($ret) . "\n\n";
	return $parsed;
}



/**
 * Kerns characters by spaces (FOO -> F O O for example)
 * @param string $str to kern
 * @param int $spaces to kern with
 * @return string kerned with spaces between characters
 */
function kerning($str, $spaces) {
	$ret = '';
	$len = strlen($str);
	$rep = str_repeat(' ', $spaces);
	for ($i = 0; $i < $len; $i++) {
		$ret .= "{$str[$i]}{$rep}";
	}
	return rtrim($ret);
}



/**
 * Gets the longest database name
 * @param $src connection
 * @param $dst connection
 * @return int strlen of longest database name
 */
function get_longest_dbname($src, $dst) {
	$dbs = array_merge($src['con']['databases'], $dst['con']['databases']);
	$len = 0;
	foreach ($dbs as $db) {
		$test = strlen($db);
		$len = ($test > $len) ? $test : $len;
	}
	return $len;
}



/**
 * Pause the console output
 * @param string $prompt to show to tell user console output is paused
 * @return void
 */
function pause($prompt = null) {
	if (BATCH_MODE) {
		return;
	}
	$str = (is_null($prompt)) ? "\n |02>> |10PRESS ANY KEY TO CONTINUE|08..." : $prompt;
	$len = strlen_clean_ansi_mpr($str) + 1;
	$pad = $len;
	echo mpr($str);
	if (substr(PHP_OS, 0, 3) == 'WIN') {
		passthru('pause >> nul');
	} else {
		//linux
		passthru('read -n1 -r -s -p ""');
	}
	echo mpr("|[D{$len}|~D{$pad} |[D{$len}|[A1");
}



/**
 * Returns the application name and version
 * @return string application name and version
 */
function app_name() {
	return APP_NAME . ' v' . APP_VERSION;
}


/**
 * Outputs with print_r with optional die and banner
 * @param mixed $var to print_r()
 * @param boolean $die?
 * @param string $banner to show
 * @return void
 */
function dumpr($var, $die = true, $banner = null) {
	echo mpr("\n\n|08|%D100=\n");
	if (!is_null($banner)) {
		echo mpr("\n|15{$banner}\n|08|%D100-\n");
	}
	print_r($var);
	echo mpr("|08|%D100=\n");
	if ($die) {
		die();
	}
}

/**
 * Outputs with var_export with optional die and banner
 * @param mixed $var to var_export()
 * @param boolean $die?
 * @param string $banner to show
 * @return voidd
 */
function dumpv($var, $die = true, $banner = null) {
	$banner = (!is_null($banner)) ? $banner : '';
	echo mpr("\n\n|08|%100=\n");
	if (!is_null($banner)) {
		echo mpr("\n|15{$banner}\n|08|%D100-\n");
	}
	var_export($var);
	echo mpr("|08|%D100=\n");
	if ($die) {
		die();
	}
}

?>