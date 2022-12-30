/*
* formatSQLOutput.c    Version 1.0  04/18/22
***********************************************************************
*       PROGRAM: untitled.c
*        AUTHOR: George McGinn
*                
*                <gjmcginn@icloud.com>
*  DATE WRITTEN: 04/18/2022
*       VERSION: 1.0
*       PROJECT: 
*
*
*   DESCRIPTION: 
*
*
* Written by George McGinn
* Copyright ©2022 by George McGinn - All Rights Reserved
* Version 1.0 - Created 04/18/2022
*
*
* CHANGE LOG
***********************************************************************
* 04/18/22 v1.0 GJM - New Program.
***********************************************************************
*  Copyright ©2022 by George McGinn.  All Rights Reserved.
***********************************************************************
*/

#include <stdio.h>
#include <stdlib.h>
#include <mysql.h>

// int main(int argc, char **argv)


int main(void)
{
	MYSQL_RES *res_set;
	if (mysql_query (conn, "SHOW TABLES FROM baseballTDB") != 0)
		print_error (conn, "mysql_query() failed");
	else {
		res_set = mysql_store_result (conn); /* generate result set */
		if (res_set == NULL) {
			print_error (conn, "mysql_store_result() failed"); }
		else {                               /* process result set, then deallocate it */
			process_result_set (conn, res_set);
			mysql_free_result (res_set); }
	}

	return 0;

}

void process_result_set (MYSQL *conn, MYSQL_RES *res_set)
{
MYSQL_ROW
row;
unsigned int i;
while ((row = mysql_fetch_row (res_set)) != NULL)
{
for (i = 0; i < mysql_num_fields (res_set); i++)
{
if (i > 0)
fputc ('\t', stdout);7.4
Processing SQL Statements
printf ("%s", row[i] != NULL ? row[i] : "NULL");
}
fputc ('\n', stdout);
}
if (mysql_errno (conn) != 0)
print_error (conn, "mysql_fetch_row() failed");
else
printf ("Number of rows returned: %lu\n",
(unsigned long) mysql_num_rows (res_set));
}


void process_real_statement (MYSQL *conn, char *stmt_str, unsigned int len)
{
	MYSQL_RES *res_set;
	if (mysql_real_query (conn, stmt_str, len) != 0) { 	/* the statement failed */
		print_error (conn, "Could not execute statement");
		return; }

	res_set = mysql_use_result (conn);					/* the statement succeeded; determine whether it returned data */
	if (res_set) { 										/* a result set was returned */
		process_result_set (conn, res_set); 			/* process rows and free the result set */
		mysql_free_result (res_set); }
	else {												/* no result set was returned */
/*
* does the lack of a result set mean that the statement didn't
* return one, or that it should have but an error occurred?
*/
		if (mysql_errno (conn) == 0) {
/*
* statement generated no result set (it was not a SELECT,
* SHOW, DESCRIBE, etc.); just report rows-affected value.
*/
			printf ("Number of rows affected: %lu\n",
			(unsigned long) mysql_affected_rows (conn)); }
		else /* an error occurred */ {
			print_error (conn, "Could not retrieve result set"); }
		}
}

