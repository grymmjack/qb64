/* mysqlClient.h - connect to and execute SQL from MySQL/mariaDB server */

#include <stdio.h>
#include <mysql.h>
#include <stdbool.h> 
#include <string.h>   /* for all the new-fangled string functions */


/* initialize pointers (static keeps values until process ends) 									*/
static char *opt_host_name = "";      	/* server host (default=localhost)  						*/
static char *opt_user_name = "";   		/* username (default=login name)    						*/
static char *opt_password = "";  	    /* password (default=none)          						*/
static unsigned int opt_port_num = 0;  	/* port number (use built-in value) 						*/
static char *opt_socket_name = NULL;   	/* socket name (use built-in value) 						*/
static char *opt_db_name = "";      	/* database name (default=none)     						*/
static char *opt_tbl_name = "";			/* table name (default=none)        						*/    
static char *opt_sql_stmt = "";			/* sql statement (default=none)     						*/ 
static char *opt_select_what = "";		/* sql query - SELECT options       						*/
static char *opt_select_from = "";		/* sql query - SELECT FROM options  						*/
static char *opt_select_filename = "";	/* sql query - INTO FILE filename  							*/  
static char *opt_language_id = "";		/* ID of calling language (i.e. QB64) for TRUE/FALSE flags 	*/
static char *opt_privileges = "";		/* list of privileges granted/denied by sql statement	 	*/
static char *opt_values = "";		    /* values used to insert into table						 	*/
static unsigned int opt_flags = 0;     	/* connection flags (none)          						*/
static MYSQL *conn;                    	/* pointer to connection handler    						*/
static MYSQL_RES *res_set;

static int useRows = 0;
static int rowCtr = 0;


/* Utility Routines for C Header Functions */

void print_error (MYSQL *conn, char *message)
{
	fprintf (stderr, "%s\n", message);
	if (conn != NULL) {
		fprintf (stderr, "Error %u (%s): %s\n",
		mysql_errno (conn), mysql_sqlstate (conn), mysql_error (conn)); }
}


/* mySQL Command Functions */

/* Connect to SQL Session */
int __sqlConnect (char *opt_host_name, char *opt_user_name, char *opt_password, char *opt_db_name)
{
	conn = mysql_init (NULL);
	if (conn == NULL) {
		print_error (NULL, "sqlConnect: mysql_init() failed (probably out of memory)");			
		fflush(stdout);
		return 1; }
	if (mysql_real_connect(conn, opt_host_name, opt_user_name, opt_password, opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL) {
		print_error(conn, "sqlConnect: mysql_real_connect() failed");			
		mysql_close(conn);
		fflush(stdout);
		return 99; }
	fflush(stdout);
	return (0);
}


/* Disconnect to SQL Session */
int __sqlDisconnect (void)
{                   
	mysql_close(conn);
	fflush(stdout);
	return 0;
}


/* Free res_set from __sqlFetchRow Session */
int __sqlFreeFetchRow (void)
{                   
	mysql_free_result(res_set);
	return 0;
}


/* Ping the current SQL Session to make sure it's up/running */
int __sqlPing (void)
{
	if (mysql_ping(conn)) {
		print_error (conn, "sqlPING: mysql_ping() failed");	
		mysql_close (conn);
		fflush(stdout);
		return 99; }
	fflush(stdout);
	return 0;
}


/* Fetch number of rows in table */
int __sqlNumRows (char *opt_tbl_name)
{
	char *sqlQuery = "SELECT * FROM ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	MYSQL_RES *res;
	if (buffer == NULL) {
		print_error (conn, "sqlNumRows: Buffer out of memory");			
		mysql_close (conn);
		fflush(stdout);
		return 0; } 
    else  {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlNumRows: Failed to execute query");
		fprintf(stderr, "sqlNumFields: sqlQuery = %s\n", sqlQuery);
		free (buffer);
		fflush(stdout);
		return 0; }
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlNumRows: Query returned NULL");
		mysql_close (conn);
		fflush(stdout);
		return 0; }
	int rows = mysql_num_rows(res);
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
	return rows;
}


/* Fetch number of columns in table */
int __sqlNumFields (char *opt_tbl_name)
{
	char *sqlQuery = "SELECT * FROM ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	MYSQL_RES *res;
	if (buffer == NULL) {
		print_error(conn, "mysql_num_fields: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 0; } 
    else  {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "mysql_num_fields: Failed to execute query");
		fprintf(stderr, "mysql_num_fields: sqlQuery = %s\n", sqlQuery);
		fflush(stdout);
		return 0; }
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error(conn, "mysql_num_fields: Query returned NULL");
		mysql_close (conn);
		return 0; }
	int cols = mysql_num_fields(res);
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
	return cols;	
}


/* Execute provided SQL statement */
int __sqlStoreResult (char *opt_sql_stmt)
{
	char *sqlQuery = "\0";
	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	char* buffer = (char*) malloc(strlen(opt_sql_stmt) + 1);
	MYSQL_RES *res;
	MYSQL_ROW row;
	if (buffer == NULL) {
		print_error(conn, "sqlStoreResult: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, opt_sql_stmt);
		sqlQuery = buffer; }	
	FILE *fp;	
	fp = fopen("sqlResults.txt", "w");
	if (fp == NULL) {
		perror ("sqlStoreResult: Unable to open the file");
		fprintf(stderr, "sqlStoreResult: filename = sqlResults.txt\n");
		fflush(stdout);
		mysql_close (conn);
		exit ( EXIT_FAILURE ); }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlStoreResult: Failed to execute query");
		fprintf(stderr, "sqlStoreResult: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	res = mysql_use_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlStoreResult: Query returned NULL");
		fprintf(stderr, "sqlStoreResult: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 4; }
	int columns = mysql_num_fields(res);
	int i = 0;
	int ctr = 0;
	while ((row = mysql_fetch_row(res))) {
//		unsigned long rowsize = *mysql_fetch_lengths(res);
		for (i = 0; i < columns; i++) {
			if (i == columns-1) {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Replaces a NULL value with a 0 */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; }
				else {
					strcat(fullrecord, row[i]);     	/* Adds the row to fullrecord */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; } }
			else {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Copy name into full name */
					strcat( fullrecord, "\t" ); }     	/* Separate the rows by a <TAB> */				
				else {
					strcat(fullrecord, row[i]);     	/* Replaces a NULL value with a 0 */
					strcat( fullrecord, "\t" ); } 		/* Separate the rows by a <TAB> */
			}
		}
		fprintf(fp, "%s", fullrecord);
		strcpy(fullrecord, "\0"); }
	fflush(fp);
	int fclose(FILE *fp);
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Change Database */
int __sqlUseDatabase (char *opt_db_name)
{
	char *sqlQuery = "USE ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_db_name) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlUseDatabase: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_db_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlUseDatabase: Failed to execute query");
		fprintf(stderr, "sqlUseDatabase: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3;
	}
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Fetch a listing of all databases */
int __sqlShowDatabases (void)
{
	char *sqlQuery = "SHOW DATABASES ";
	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	MYSQL_RES *res;
	MYSQL_ROW row;
	if (mysql_query(conn, sqlQuery)) {
		print_error (conn, "sqlShowDatabases: Failed to execute query. Error");			
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	FILE *fp;	
	fp = fopen("sqlResults.txt", "w");
	if (fp == NULL) {
		perror ("sqlShowDatabases: Unable to open the file");
		fprintf(stderr, "sqlShowDatabases: filename = sqlResults.txt\n");
		fflush(stdout);
		exit ( EXIT_FAILURE ); }	
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error (conn, "sqlShowDatabases: Query returned NULL. Error");			
		mysql_close (conn);
		fflush(stdout);
		return 4; }	
	int columns = mysql_num_fields(res);
	int i = 0, ctr = 0;
	while ((row = mysql_fetch_row(res))) {
		for (i = 0; i < columns; i++) {
			if (i == columns-1) {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Replaces a NULL value with a 0 */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; }
				else {
					strcat(fullrecord, row[i]);     	/* Adds the row to fullrecord */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; } }
			else  {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Copy name into full name */
					strcat( fullrecord, "\t" ); }     	/* Separate the rows by a <TAB> */				
				else {
					strcat(fullrecord, row[i]);     	/* Replaces a NULL value with a 0 */
					strcat( fullrecord, "\t" ); } } }   /* Separate the rows by a <TAB> */
		fprintf(fp, "%s", fullrecord);
		strcpy(fullrecord, "\0"); }	
	fflush(fp);
	int fclose(FILE *fp);
	mysql_free_result(res);
	fflush(stdout);
	return 0;	
}


/* Fetch a listing of all tables in current database */
int __sqlShowTables (void)
{
	char *sqlQuery = "SHOW TABLES ";
	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	MYSQL_RES *res;
	MYSQL_ROW row;
	if (mysql_query(conn, sqlQuery)) {
		print_error (conn, "sqlShowTables: Failed to execute query");			
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	FILE *fp;	
	fp = fopen("sqlResults.txt", "w");
	if (fp == NULL) {
		perror ("sqlShowTables: Unable to open the file");
		fprintf(stderr, "sqlShowTables: filename = sqlResults.txt\n");
		fflush(stdout);
		exit ( EXIT_FAILURE ); }	
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error (conn, "sqlShowTables: Query returned NULL");			
		mysql_close (conn);
		fflush(stdout);
		return 4; }	
	int columns = mysql_num_fields(res);
	int i = 0, ctr = 0;
	while ((row = mysql_fetch_row(res))) {
		for (i = 0; i < columns; i++) {
			if (i == columns-1) {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Replaces a NULL value with a 0 */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; }
				else {
					strcat(fullrecord, row[i]);     	/* Adds the row to fullrecord */
					strcat(fullrecord, "\n" );          /* Add newline to end of record */
					++ctr; } }
			else {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		/* Copy name into full name */
					strcat( fullrecord, "\t" ); }     	/* Separate the rows by a <TAB> */					
				else {
					strcat(fullrecord, row[i]);     	/* Replaces a NULL value with a 0 */
					strcat( fullrecord, "\t" ); } } }	/* Separate the rows by a <TAB> */
		fprintf(fp, "%s", fullrecord);
		strcpy(fullrecord, "\0"); }	
	fflush(fp);
	int fclose(FILE *fp);
	mysql_free_result(res);
	fflush(stdout);
	return 0;	
}


/* Execute provided SQL statement */
int __sqlCMD (char *opt_sql_stmt)
{
	char *sqlQuery = "\0";
	char *sqlEnd = "\0";
//	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	char* buffer = (char*) malloc(strlen(opt_sql_stmt) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlCMD: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, opt_sql_stmt);
		strcat(buffer, sqlEnd);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCMD: Failed to execute query");
		fprintf(stderr, "sqlCMD: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	mysql_query(conn, "COMMIT");
	free (buffer);
	opt_sql_stmt = "\0";
	fflush(stdout);
	return 0;
}


/* Execute provided SQL statement by USE */
int __sqlUseResult (char *opt_sql_stmt)
{
	if (mysql_query(conn, opt_sql_stmt)) {
		print_error (conn, "sqlUseResult: Failed to execute query");			
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	res_set = mysql_use_result(conn);
	if (res_set == NULL) {
		print_error (conn, "sqlUseResult: Query returned NULL");			
		fprintf(stderr, "sqlUseResult: sqlQuery = %s\n", opt_sql_stmt);
		mysql_close (conn);
		mysql_free_result(res_set);
		fflush(stdout);
		return 4; }	
	fflush(stdout);
	return 0;
}


char* __sqlFetchRow (void)
{
	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	strcpy(fullrecord, "\0");    // Needed to clear buffer if function is reused
	MYSQL_ROW row;
	int i = 0;
	int recLength = 0;
	if (res_set) {
		row = mysql_fetch_row (res_set);
		int columns = mysql_num_fields(res_set);
		for (i = 0; i < columns; i++) {
			if (i == columns-1) {
				if (row[i] == NULL) {
					strcat(fullrecord, "0"); } 			// Replace a NULL with a Zero
				else {
					strcat(fullrecord, row[i]); } }   	// Adds the row to fullrecord  
			else {
				if (row[i] == NULL) {
					strcat(fullrecord, "0");     		// Copy name into full name 
					strcat( fullrecord, "\t" ); }     	// Separate the rows by a <TAB> 				
				else {
					strcat(fullrecord, row[i]);     	// Replaces a NULL value with a 0 
					strcat(fullrecord, "\t"); } } }     // Separate the rows by a <TAB> 	
		if (mysql_errno (conn) != 0) {		
			print_error (conn, "sqlFetchRow: mysql_fetch_row failed");			
			mysql_close (conn);
			mysql_free_result(res_set);
			fflush(stdout);
			return "3"; } }
	else {
		printf ("sqlFetchRow: Number of rows returned: %lu\n", (unsigned long) mysql_num_rows (res_set));
		fflush(stdout); }
	char* buffer = (char*) malloc(strlen(fullrecord) + 1);
	if (buffer == NULL) {
		print_error (conn, "sqlFetchRow: Buffer out of memory");			
		mysql_free_result(res_set);
		mysql_close (conn);
		fflush(stdout);
		return "99"; } 
    else {
		strcpy(buffer, fullrecord); }		
	char* sqlReturn = (char*) malloc(strlen(buffer) + 1);
	if (sqlReturn == NULL) {
		print_error (conn, "sqlFetchRow: sqlReturn out of memory");			
		mysql_free_result(res_set);
		mysql_close (conn);
		fflush(stdout);
		return "99"; } 
    else {
		strcpy(sqlReturn, buffer); }
	free (buffer);
	strcpy(fullrecord, "\0");
	fflush(stdout);
	return sqlReturn;	
}


/* Drop Database */
int __sqlDropDatabase (char *opt_db_name)
{
	char *sqlQuery = "DROP DATABASE IF EXISTS ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_db_name) + 1);
	if (buffer == NULL) {
		print_error (conn, "sqlDropDatabase: Buffer out of memory");			
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_db_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error (conn, "sqlDropDatabase: Failed to execute query.");			
		fprintf(stderr, "sqlDropDatabase: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Drop Table */
int __sqlDropTable (char *opt_tbl_name)
{
	char *sqlQuery = "DROP TABLE IF EXISTS ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	if (buffer == NULL) {
		print_error (conn, "sqlDropTable: Buffer out of memory");			
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error (conn, "sqlDropTable: Failed to execute query");			
		fprintf(stderr, "sqlDropTable: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Drop View  */
int __sqlDropView (char *opt_tbl_name)
{
	char *sqlQuery = "DROP VIEW IF EXISTS ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlDropView: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlDropView: Failed to execute query");
		fprintf(stderr, "sqlDropView: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Create Database IF NOT EXISTS  */
/* NOTE: This should have additional parameters to override IF NOT EXISTS 
 *       or make it so that the user needs to use __sqlDropDatabase first */
int __sqlCreateDatabase (char *opt_db_name)
{
	char *sqlQuery = "CREATE DATABASE IF NOT EXISTS ";
	char *sqlEnd = "\'\0";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_db_name) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlCreateDatabase: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_db_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCreateDatabase: Failed to execute query");
		fprintf(stderr, "sqlCreateDatabase: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Change User & Database of current SQL Session */
int __sqlChangeUser (char *opt_user_name, char *opt_password, char *opt_db_name)
{
	if (mysql_change_user(conn, opt_user_name, opt_password, opt_db_name)) {
		print_error (conn, "sqlChangeUser: mysql_change_user() failed");	
		mysql_close (conn);
		fflush(stdout);
		return 99; }
	fflush(stdout);
	return 0;
}


/* Select Database */
int __sqlSelectDatabase (char *opt_db_name)
{
	if (mysql_select_db(conn, opt_db_name)) {
		print_error(conn, "sqlSelectDatabase: Failed to select database");
		fprintf(stderr, "sqlSelectDatabase: sqlQuery = %s\n", opt_db_name);
		mysql_close (conn);
		fflush(stdout);
		return false;
	}
	fflush(stdout);
	return true;
}


/* Create SQL OUTFILE */
int __sqlCreateOutFile (char *opt_select_what, char *opt_select_from, char *opt_select_filename)
{
	char *sqlQuery = "SELECT ";
	char *sqlQuery1 = " FROM ";
	char *sqlQuery2 = " INTO OUTFILE \'";
	char *sqlEnd = "\'\0";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_select_what) + strlen(sqlQuery1) + strlen(opt_select_from) + strlen(sqlQuery2) + strlen(opt_select_filename) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlCreateOutFile: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_select_what);
		strcat(buffer, sqlQuery1);
		strcat(buffer, opt_select_from);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_select_filename);
		strcat(buffer, sqlEnd);
		sqlQuery = buffer; }			
	remove(opt_select_filename);		
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCreateOutFile: Failed to execute query");
		fprintf(stderr, "sqlCreateOutFile: sqlQuery = %s\n", sqlQuery);
		fflush(stdout);
		return 3;
	}
	free (buffer);
	fflush(stdout);
	return 0;
}


/* Select USER (Check/verify user exists) */
int __sqlVerifyUser (char *opt_user_name, char *opt_language_id)
{
	int nbr_rows; /* Stores the number of rows (either 1 or 0) returned from selecting user  */
	MYSQL_RES *res;
	MYSQL_ROW row;	
	char *sqlQuery1 = "SELECT COUNT(*) \'"; 
	char *sqlQuery2 = "\' FROM mysql.user WHERE user = \'";
	char *sqlEnd = "\'\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_user_name) + strlen(sqlQuery2) + strlen(opt_user_name) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlVerifyUser: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlEnd); }
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 					
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlVerifyUser: Failed to execute query");
		fprintf(stderr, "sqlVerifyUser: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		free(buffer);
		return 99; }	
	res = mysql_use_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlVerifyUser: Query returned NULL");
		fprintf(stderr, "sqlVerifyUser: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 99; }	
	int columns = mysql_num_fields(res);
	int i = 0;
	int ctr = 0;
	while ((row = mysql_fetch_row(res))) {
		for (i = 0; i < columns; i++) {
			nbr_rows = atoi(row[i]); } }			
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
// Code for QB64 only: True returns -1, False returns 0
// Code for C/C++: True returns 1, False returns 0
// Most other languages conform to the C/C++ standards, but check its documentation
	if (opt_language_id == "QB64") {
		if (nbr_rows) return -1; else return 0; }
	else {
		if (nbr_rows == 1) return true; else return false; }
	print_error(conn, "sqlVerifyUser: Results from Query not as expected (1 or 0)");
	fflush(stdout);
	return 99;
}


/* Create USER (IF USER DOESN'T EXIST) */
int __sqlCreateUser (char *opt_user_name, char *opt_password)
{
	char *sqlQuery1 = "CREATE USER IF NOT EXISTS \'"; 
	char *sqlQuery2 = "\' IDENTIFIED WITH mysql_native_password BY \'";
	char *sqlEnd = "\'\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_user_name) + strlen(sqlQuery2) + strlen(opt_password) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlCreateUser: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_password);
		strcat(buffer, sqlEnd); }
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 		
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCreateUser: Failed to execute query");
		fprintf(stderr, "sqlCreateUser: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;		
}


/* Drop (Delete) USER (IF USER EXIST) */
int __sqlDropUser (char *opt_user_name)
{
	char *sqlQuery1 = "DROP USER IF EXISTS "; 
	char *sqlEnd = "\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_user_name) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlDropUser: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlEnd); }
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 		
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlDropUser: Failed to execute query");
		fprintf(stderr, "sqlDropUser: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;		
}


/* GRANT Privileges */
int __sqlGrant (char *opt_user_name, char *opt_db_name, char *opt_tbl_name, char *opt_privileges)
{
	char *sqlQuery1 = "GRANT "; 
	char *sqlQuery2 = " ON ";
	char *sqlQuery3 = ".";
	char *sqlQuery4 = " TO \'";
	char *sqlEnd = "\'\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_privileges) + 
	                              strlen(sqlQuery2) + strlen(opt_db_name) + 
	                              strlen(sqlQuery3) + strlen(opt_tbl_name) +
	                              strlen(sqlQuery4) + strlen(opt_user_name) +
	                              strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlGrant: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_privileges);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_db_name);
		strcat(buffer, sqlQuery3);
		strcat(buffer, opt_tbl_name);
		strcat(buffer, sqlQuery4);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlEnd); }	
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlGrant: Failed to execute query");
		fprintf(stderr, "sqlGrant: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	opt_sql_stmt = "\0";
	fflush(stdout);
	return 0;		
}


/* REVOKE Privileges */
int __sqlRevoke (char *opt_user_name, char *opt_db_name, char *opt_tbl_name, char *opt_privileges)
{
	char *sqlQuery1 = "REVOKE "; 
	char *sqlQuery2 = " ON ";
	char *sqlQuery3 = ".";
	char *sqlQuery4 = " FROM \'";
	char *sqlEnd = "\'\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_privileges) + 
	                              strlen(sqlQuery2) + strlen(opt_db_name) + 
	                              strlen(sqlQuery3) + strlen(opt_tbl_name) +
	                              strlen(sqlQuery4) + strlen(opt_user_name) +
	                              strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlRevoke: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_privileges);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_db_name);
		strcat(buffer, sqlQuery3);
		strcat(buffer, opt_tbl_name);
		strcat(buffer, sqlQuery4);
		strcat(buffer, opt_user_name);
		strcat(buffer, sqlEnd); }	
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 		
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlRevoke: Failed to execute query");
		fprintf(stderr, "sqlRevoke: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	opt_sql_stmt = "\0";
	fflush(stdout);
	return 0;		
}


/* INSERT Values into a Table */
int __sqlInsert (char *opt_tbl_name, char *opt_values)
{
	char *sqlQuery1 = "INSERT INTO "; 
	char *sqlQuery2 = " VALUES (";
	char *sqlQuery3 = ")";
	char *sqlEnd = "\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(opt_tbl_name) + 
	                              strlen(sqlQuery2) + strlen(opt_values) + 
	                              strlen(sqlQuery3) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlInsert: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, opt_tbl_name);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_values);
		strcat(buffer, sqlQuery3);
		strcat(buffer, sqlEnd); }	
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 		
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlInsert: Failed to execute query");
		fprintf(stderr, "sqlInsert: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	mysql_query(conn, "COMMIT");
	free (buffer);
	fflush(stdout);
	return 0;		
}


/* Select TABLE (Check/verify table exists) */
int __sqlVerifyTable (char *opt_tbl_name, char *opt_language_id)
{
	int nbr_rows; /* Stores the number of rows (either 1 or 0) returned from selecting user  */
	MYSQL_RES *res;
	MYSQL_ROW row;	
	char *sqlQuery1 = "SELECT COUNT(TABLE_NAME) ";
	char *sqlQuery2 = "FROM information_schema.TABLES WHERE TABLE_NAME = \'";
	char *sqlEnd = "\'\0";
	char *buffer = (char*) malloc(strlen(sqlQuery1) + strlen(sqlQuery2) + strlen(opt_tbl_name) + strlen(sqlEnd) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlVerifyTable: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, sqlQuery1);
		strcat(buffer, sqlQuery2);
		strcat(buffer, opt_tbl_name);
		strcat(buffer, sqlEnd); }
	char *sqlQuery = (char*) malloc(strlen(buffer) + 1);
	sqlQuery = buffer; 					
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlVerifyTable: Failed to execute query");
		fprintf(stderr, "sqlVerifyTable: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		free(buffer);
		return 99; }	
	res = mysql_use_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlVerifyTable: Query returned NULL");
		fprintf(stderr, "sqlVerifyTable: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 99; }	
	int columns = mysql_num_fields(res);
	int i = 0;
	int ctr = 0;
	while ((row = mysql_fetch_row(res))) {
		for (i = 0; i < columns; i++) {
			nbr_rows = atoi(row[i]); } }			
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
// Code for QB64 only: True returns -1, False returns 0
// Code for C/C++: True returns 1, False returns 0
// Most other languages conform to the C/C++ standards, but check its documentation
	if (opt_language_id == "QB64") {
		if (nbr_rows) return -1; else return 0; }
	else {
		if (nbr_rows == 1) return true; else return false; }
	print_error(conn, "sqlVerifyTable: Results from Query not as expected (1 or 0)");
	fflush(stdout);
	return 99;
}
