/*
* testPGM1.c    Version 1.0  04/18/22
***********************************************************************
*       PROGRAM: testPGM1.c
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
//#include <mysql.h>
#include <string.h>   /* for all the new-fangled string functions */
#include "mysqlClient.h"


// int main(int argc, char **argv)
int main(void)
{
	MYSQL_ROW row;
	__sqlConnect("localhost", "gjmcginn", "mysql", "baseballTDB");
	opt_sql_stmt = "SELECT * FROM tempbattingStatsView";	
	__sqlUseResult (opt_sql_stmt);
	__process_result_set ();
	mysql_free_result (res_set); 
	__sqlDisconnect();
	return 0;  
}


void __process_result_set (void)
{
	MYSQL_ROW row;
	int i;
	while ((row = mysql_fetch_row(res_set))) {
		for (i = 0; i < mysql_num_fields (res_set); i++) { 
			if (i <  mysql_num_fields (res_set) + 1) {
				fputc ('\t', stdout); 
				printf ("%s", row[i] != NULL ? row[i] : "NULL"); } }
		fputc ('\n', stdout); 
		if (mysql_errno (conn) != 0) {
			mysql_num_fields (res_set); } 		
		else {
			(unsigned long) mysql_num_rows (res_set); } }
}

