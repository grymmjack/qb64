/* mysqlClient.h - connect to and execute SQL from MySQL/mariaDB server */

#include <stdio.h>
#include <mysql.h>
#include <string.h>   /* for all the new-fangled string functions */


/* initialize pointers (static keeps values until process ends) */
static char *opt_host_name = "";      	/* server host (default=localhost)  */
static char *opt_user_name = "";   		/* username (default=login name)    */
static char *opt_password = "";  	    /* password (default=none)          */
static unsigned int opt_port_num = 0;  	/* port number (use built-in value) */
static char *opt_socket_name = NULL;   	/* socket name (use built-in value) */
static char *opt_db_name = "";      	/* database name (default=none)     */
static char *opt_tbl_name = "";			/* table name (default=none)        */    
static char *opt_sql_stmt = "";			/* sql statement (default=none)     */    
static unsigned int opt_flags = 0;     	/* connection flags (none)          */
static MYSQL *conn;                    	/* pointer to connection handler    */
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
	if (mysql_real_connect (conn, opt_host_name, opt_user_name, opt_password, opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL) {
		print_error (conn, "sqlConnect: mysql_real_connect() failed");			
		mysql_close (conn);
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


/* Fetch number of rows in table */
int __sqlRows (char *opt_tbl_name)
{
	char *sqlQuery = "SELECT * FROM ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	
	MYSQL_RES *res;
	if (buffer == NULL) {
		print_error (conn, "sqlRows: Buffer out of memory");			
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else  {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlRows: Failed to execute query");
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlRows: Query returned NULL");
		mysql_close (conn);
		fflush(stdout);
		return 4; }
	int rows = mysql_num_rows(res);
	mysql_free_result(res);
	free (buffer);
	fflush(stdout);
	return rows;
}


/* Fetch number of columns in table */
int __sqlCols (char *opt_tbl_name)
{
	char *sqlQuery = "SELECT * FROM ";
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_tbl_name) + 1);
	MYSQL_RES *res;
	if (buffer == NULL) {
		print_error(conn, "sqlCols: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else  {
		strcpy(buffer, sqlQuery);
		strcat(buffer, opt_tbl_name);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCols: Failed to execute query");
		fprintf(stderr, "sqlCols: sqlQuery = %s", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	res = mysql_store_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlCols: Query returned NULL");
		mysql_close (conn);
		return 4; }
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
		fprintf(stderr, "sqlStoreResult: filename = sqlResults.txt");
		fflush(stdout);
		mysql_close (conn);
		exit ( EXIT_FAILURE ); }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlStoreResult: Failed to execute query");
		fprintf(stderr, "sqlStoreResult: sqlQuery = %s", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	res = mysql_use_result(conn);
	if (res == NULL) {
		print_error(conn, "sqlStoreResult: Query returned NULL");
		fprintf(stderr, "sqlStoreResult: sqlQuery = %s", sqlQuery);
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


/* Execute provided SQL statement */
int __sqlCMD (char *opt_sql_stmt)
{
	char *sqlQuery = "\0";
	char fullrecord[100000]; /* Big enough to hold all columns from SQL Query */
	char* buffer = (char*) malloc(strlen(opt_sql_stmt) + 1);
	if (buffer == NULL) {
		print_error(conn, "sqlCMD: Buffer out of memory");
		mysql_close (conn);
		fflush(stdout);
		return 99; } 
    else {
		strcpy(buffer, opt_sql_stmt);
		sqlQuery = buffer; }	
	if (mysql_query(conn, sqlQuery)) {
		print_error(conn, "sqlCMD: Failed to execute query");
		fprintf(stderr, "sqlCMD: sqlQuery = %s\n", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
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
		fprintf(stderr, "sqlUseDatabase: sqlQuery = %s", sqlQuery);
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
		fprintf(stderr, "sqlShowDatabases: filename = sqlResults.txt");
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
		fprintf(stderr, "sqlShowTables: filename = sqlResults.txt");
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


int __sqlProcessStmt (char *opt_sql_stmt)
/* This function is not yet complete. It will process SQL that does not
 * return any data. But if it does, then all that it does now is print
 * the rows and columns to the terminal.
*/
{
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	if (mysql_query (conn, opt_sql_stmt) != 0) {
		print_error (conn, "sqlProcessStmt: Query returned NULL. Error");			
		mysql_close (conn);
		fflush(stdout);
		return 99; }
	res_set = mysql_store_result (conn);
	if (res_set) {
		int i;
		while ((row = mysql_fetch_row (res_set)) != NULL) {
			for (i = 0; i < mysql_num_fields (res_set); i++) {
				if (i > 0) {
					fputc ('\t', stdout);
					printf ("%s", row[i] != NULL ? row[i] : "NULL"); }
				fputc ('\n', stdout); } }	
		if (mysql_errno (conn) != 0) {
			print_error (conn, "sqlProcessStmt: mysql_fetch_row failed");			
			mysql_close (conn);
			mysql_free_result(res_set);
			fflush(stdout);
			return 3; } 
		else {
			printf ("sqlProcessStmt: Number of rows returned: %lu\n", (unsigned long) mysql_num_rows (res_set)); } }
	else {
		if (mysql_field_count (conn) == 0) {
			printf ("sqlProcessStmt: Number of rows affected: %lu\n", (unsigned long) mysql_affected_rows (conn)); }
		else {
			print_error (conn, "sqlProcessStmt: Could not retrieve result set");			
			mysql_close (conn);
			mysql_free_result(res_set);
			fflush(stdout);
			return 4; } }
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
		fprintf(stderr, "sqlUseResult: sqlQuery = %s", opt_sql_stmt);
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
//	recLength = strlen(fullrecord);	
	char* buffer = (char*) malloc(strlen(fullrecord) + 1);
	if (buffer == NULL) {
		print_error (conn, "sqlFetchRow: Buffer out of memory");			
		mysql_free_result(res_set);
		mysql_close (conn);
		fflush(stdout);
		return "99"; } 
    else {
		strcpy(buffer, fullrecord); }		
	char* sqlReturn = (char*) malloc(strlen(buffer));
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
		fprintf(stderr, "sqlDropDatabase: sqlQuery = %s", sqlQuery);
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
		fprintf(stderr, "sqlDropTable: sqlQuery = %s", sqlQuery);
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
		fprintf(stderr, "sqlDropView: sqlQuery = %s", sqlQuery);
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
	char* buffer = (char*) malloc(strlen(sqlQuery) + strlen(opt_db_name) + 1);
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
		fprintf(stderr, "sqlCreateDatabase: sqlQuery = %s", sqlQuery);
		mysql_close (conn);
		fflush(stdout);
		return 3; }
	free (buffer);
	fflush(stdout);
	return 0;
}




