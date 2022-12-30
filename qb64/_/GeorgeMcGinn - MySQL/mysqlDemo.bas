_TITLE "mysqlDemo.bas"

$CONSOLE:ONLY
'$DYNAMIC

'-------------------------------------------------------------
' *** Initialize Section
'

' *** MYSQL definitions
DECLARE LIBRARY "./mysqlClient"
    FUNCTION sqlConnect## ALIAS __sqlConnect (opt_host_name AS STRING, opt_user_name AS STRING, opt_password AS STRING, opt_db_name AS STRING)
    FUNCTION sqlDisconnect## ALIAS __sqlDisconnect ()
    FUNCTION sqlPing## ALIAS __sqlPing ()
    FUNCTION sqlShowDatabases## ALIAS __sqlShowDatabases ()
    FUNCTION sqlShowTables## ALIAS __sqlShowTables ()
    FUNCTION sqlCMD## ALIAS __sqlCMD (opt_sql_stmt AS STRING)
    FUNCTION sqlStoreResult## ALIAS __sqlStoreResult (opt_sql_stmt AS STRING)
    FUNCTION sqlChangeUser## ALIAS __sqlChangeUser (opt_user_name AS STRING, opt_password AS STRING, opt_db_name AS STRING)
    FUNCTION sqlSelectDatabase## ALIAS __sqlSelectDatabase (opt_db_name AS STRING)
    FUNCTION sqlUseDatabase## ALIAS __sqlUseDatabase (opt_db_name AS STRING)
    FUNCTION sqlDropDatabase## ALIAS __sqlDropDatabase (opt_db_name AS STRING)
    FUNCTION sqlCreateDatabase## ALIAS __sqlCreateDatabase (opt_db_name AS STRING)
    FUNCTION sqlCreateOutFile## ALIAS __sqlCreateOutFile (opt_select_what AS STRING, opt_select_from AS STRING, opt_select_filename AS STRING)
    FUNCTION sqlDropTable## ALIAS __sqlDropTable (opt_tbl_name AS STRING)
    FUNCTION sqlDropView## ALIAS __sqlDropView (opt_tbl_name AS STRING)
    FUNCTION sqlNumRows## ALIAS __sqlNumRows (opt_tbl_name AS STRING)
    FUNCTION sqlNumFields## ALIAS __sqlNumFields (opt_tbl_name AS STRING)
    FUNCTION sqlUseResult## ALIAS __sqlUseResult (opt_sql_stmt AS STRING)
    FUNCTION sqlFetchRow$ ALIAS __sqlFetchRow ()
    FUNCTION sqlFreeFetchRow## ALIAS __sqlFreeFetchRow ()
    FUNCTION sqlVerifyUser## ALIAS __sqlVerifyUser (opt_user_name AS STRING, opt_language_id AS STRING)
    FUNCTION sqlCreateUser## ALIAS __sqlCreateUser (opt_user_name AS STRING, opt_password AS STRING)
    FUNCTION sqlDropUser## ALIAS __sqlDropUser (opt_user_name AS STRING)
    FUNCTION sqlGrant## ALIAS __sqlGrant (opt_user_name AS STRING, opt_db_name AS STRING, opt_tbl_name AS STRING, opt_privileges AS STRING)
    FUNCTION sqlRevoke## ALIAS __sqlRevoke (opt_user_name AS STRING, opt_db_name AS STRING, opt_tbl_name AS STRING, opt_privileges AS STRING)
    FUNCTION sqlInsert## ALIAS __sqlInsert (opt_tbl_name AS STRING, opt_values AS STRING)
    FUNCTION sqlVerifyTable## ALIAS __sqlVerifyTable (opt_tbl_name AS STRING, opt_language_id AS STRING)
END DECLARE




'-----------------------------------------------------------------------
' *** MAIN Program Logic
'
QBMain:

DIM AS INTEGER TRUE, FALSE, retcode
DIM AS STRING NULL
TRUE = -1: FALSE = 0
NULL = ""


' *** Connect to the mySQL Server
PRINT "QB64: Connecting to mySQL Server"
retcode = sqlConnect("localhost", "<userid>", "<password>", NULL) ' *** NULL can be replaced with a database name
IF retcode <> 0 THEN
    PRINT "QB64: Connection to server failed. Please check and run again. Return Code ="; retcode: PRINT
    retcode = sqlDisonnect
    SYSTEM 99
END IF
    

' *** PING the SQL Server to make sure it's running
PRINT "QB64: Ping SQL Server"
retcode = sqlPing
PRINT "QB64: Ping returned = "; retcode: PRINT
IF retcode <> 0 THEN
    PRINT "QB64: SQL PING Command Failed. Please check output and run again. Return Code ="; retcode: PRINT
    retcode = sqlDisonnect
    SYSTEM 99
END IF
    

' *** The following test creates a SQL user if not found and grants limited privileges.
' *** If the user is found, then it revokes all privileges.
' *** You can verify that this works by executing in mysql/mariaDB terminal prompt:
' ***       mysql> select * from mysql.user where user='testbaseball'\G
sqlUserID$ = "testbaseball" + CHR$(0)
PRINT "QB64: Looking up user testbaseball"
IF sqlVerifyUser(sqlUserID$, "QB64") THEN
    PRINT "QB64: *** User exists in mysql.user table."
    sqlUserID$ = "testbaseball" + CHR$(0)
    sqlDB$ = "*" + CHR$(0)
    sqlTBL$ = "*" + CHR$(0)
    sqlPRIVL$ = "ALL" + CHR$(0)
    PRINT "QB64: Revoking privileges to user testbaseball: "; sqlPRIVL$
    retcode = sqlRevoke(sqlUserID$, sqlDB$, sqlTBL$, sqlPRIVL$)
    IF retcode <> 0 THEN
        PRINT "QB64: *** User privileges not revoked.": PRINT
    ELSE
        PRINT "QB64: *** User privileges revoked.": PRINT
    END IF
ELSE
    PRINT "QB64: *** User not found in mysql.user table."
    sqlUserID$ = "testbaseball" + CHR$(0)
    sqlPasswd$ = "mysql" + CHR$(0)
    sqlDB$ = "*" + CHR$(0)
    sqlTBL$ = "*" + CHR$(0)
    sqlPRIVL$ = "SELECT, CREATE, CREATE VIEW, UPDATE, INSERT, DELETE, DROP, EXECUTE, FILE" + CHR$(0)
    PRINT "QB64: Creating user testbaseball"
    retcode = sqlCreateUser(sqlUserID$, sqlPasswd$)
    IF retcode <> 0 THEN
        PRINT "QB64: *** User not created."
    ELSE
        PRINT "QB64: *** User created."
    END IF
    PRINT "QB64: Granting privileges to user testbaseball: "; sqlPRIVL$
    retcode = sqlGrant(sqlUserID$, sqlDB$, sqlTBL$, sqlPRIVL$)
    IF retcode <> 0 THEN
        PRINT "QB64: *** User privileges not granted."
    ELSE
        PRINT "QB64: *** User privileges granted."
    END IF
END IF


' *** Test the Create and Drop User Functions
sqlUserID$ = "testbaseball2" + CHR$(0)
sqlPasswd$ = "mysql" + CHR$(0)
PRINT "QB64: Creating user testbaseball2"
retcode = sqlCreateUser(sqlUserID$, sqlPasswd$)
IF retcode <> 0 THEN
	PRINT "QB64: *** User not created."
ELSE
    PRINT "QB64: *** User created."
END IF
IF sqlVerifyUser(sqlUserID$, "QB64") THEN
    PRINT "QB64: *** User exists in mysql.user table."
END IF
PRINT "QB64: Drop user testbaseball2"
retcode = sqlDropUser(sqlUserID$)
IF retcode <> 0 THEN
    PRINT "QB64: *** User not dropped."
ELSE
    PRINT "QB64: *** User dropped."
END IF
    
' *** Change User to the mySQL Server, leave database as NULL (Does not select a database)
PRINT "QB64: Changing mySQL user for further processing"
retcode = sqlChangeUser("testbaseball", "mysql", NULL)
IF retcode <> 0 THEN
    PRINT "QB64: Connection to server as new user failed. Please check and run again. Return Code ="; retcode: PRINT
    retcode = sqlDisonnect
    SYSTEM 99
END IF
    
    
' *** Change/Select database from initial connection/change user to mySQL Server
PRINT "QB64: Changing mySQL database for further processing"
retcode = sqlSelectDatabase("baseballTDB")
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode: PRINT
    SYSTEM 99
ELSE
    PRINT "QB64: New Database Selected: baseballTDB": PRINT
END IF


'-----------------------------------------------------------------------
' *** The following now tests each of the C/C++ Functions
'

' *** Retrieve lists of databases
PRINT "QB64: Retrieve list of databases"
retcode = sqlShowDatabases
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF
PRINT "QB64: Display list of databases"
IF _FILEEXISTS("sqlResults.txt") THEN
    f1% = FREEFILE: rows = 0
    OPEN "sqlResults.txt" FOR INPUT AS #f1%
    DO UNTIL EOF(f1%)
        LINE INPUT #f1%, qString$
        PRINT "QB64: " + qString$
        rows = rows + 1
    LOOP
    CLOSE #f1%
    PRINT "QB64: Number of databases found ="; rows
ELSE
    PRINT "QB64: sqlResults.txt file not found. Please check and run again.": PRINT
    SYSTEM 99
END IF
PRINT
        
' *** Retrieve lists of tables
PRINT "QB64: Retrieve list of tables"
retcode = sqlShowTables
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF
PRINT "QB64: Display list of tables"
IF _FILEEXISTS("sqlResults.txt") THEN
    f1% = FREEFILE: rows = 0
    OPEN "sqlResults.txt" FOR INPUT AS #f1%
    DO UNTIL EOF(f1%)
        LINE INPUT #f1%, qString$
        PRINT "QB64: "; qString$
        rows = rows + 1
    LOOP
    CLOSE #f1%
    PRINT "QB64: Number of tables found ="; rows: PRINT
ELSE
    PRINT "QB64: sqlResults.txt file not found. Please check and run again.": PRINT
    SYSTEM 99
END IF


' *** Retrieve the number of rows and columns from batting table
PRINT "QB64: Retrieve number of rows"
retcode = sqlNumRows("batting")
PRINT "QB64: Number of rows returned from batting = "; retcode
PRINT "QB64: Retrieve number of columns"
retcode = sqlNumFields("batting")
PRINT "QB64: Number of columns returned from batting = "; retcode
PRINT

' *** Retrieve the number of rows and columns from pitching table
PRINT "QB64: Retrieve number of rows"
retcode = sqlNumRows("pitching")
PRINT "QB64: Number of rows returned from pitching = "; retcode
' *** Retrieve the number of columns from pitching table
PRINT "QB64: Retrieve number of columns"
retcode = sqlNumFields("pitching")
PRINT "QB64: Number of columns returned from pitching = "; retcode
PRINT

'-----------------------------------------------------------------------
' *** Use the UseResult and FetchRow functions to read from a SQL View
'

' *** Create the Temp Batting Stats View
    sqlStmt$ =  "CREATE OR REPLACE VIEW tempbattingStatsView AS SELECT " + _
                "playerName AS 'PLAYER', " + _
                "SUM(games) AS 'GMSP', " + _   
                "SUM(atbats) AS 'AB', " + _  
                "SUM(runs) AS 'R', " + _   
                "SUM(hits) AS 'H', " + _   
                "SUM(rbis) AS 'RBI', " + _  
                "SUM(doubles) AS '2B', " + _  
                "SUM(triples) AS '3B', " + _  
                "SUM(homeruns) AS 'HR', " + _  
                "SUM(walks) AS 'BB', " + _  
                "SUM(strikeouts) AS 'K', " + _  
                "SUM(hitbypitch) AS 'HBP', " + _  
                "SUM(sacrifices) AS 'SAC', " + _ 
                "SUM(stolenbases) AS 'SB', " + _ 
                "SUM(attstolenbases) AS 'ASB', " + _  
                "SUM(putouts) AS 'PO', " + _  
                "SUM(assists) AS 'AST', " + _  
                "SUM(errors) AS 'E' " + _  
                "FROM batting  WHERE teamName='Yankees' " + _  
                "GROUP BY playerName" + CHR$(0)
PRINT "QB64: Creating Team Batting Status View"
retcode = sqlCMD(sqlStmt$)
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF

' *** Retrieve the number of rows from tempbattingStatsView view
PRINT "QB64: Retrieve number of rows"
nbrRows = sqlNumRows("tempbattingStatsView")
PRINT "QB64: Number of rows returned = "; nbrRows
            
' *** Set the pointer for fetch_row from tempbattingStatsView
' *** Retrieve each row in the table using mysql_fetch_row
PRINT "QB64: Processing sqlUseResult"
retcode = sqlUseResult("SELECT * FROM tempbattingStatsView")
IF retcode = 0 THEN
    PRINT "QB64: Processing sqlFetchRow"
    FOR i = 1 TO nbrRows
        qString$ = sqlFetchRow$
        PRINT "QB64: Record Fetched: "; qString$
    NEXT i
ELSE
    PRINT "QB64: Disconnection fro server failed. Program terminated. Return Code ="; retcode
    SYSTEM 99
END IF

' *** Free Fetch Row process
PRINT "QB64: Freeing Fetch Row Pointers"
retcode = sqlFreeFetchRow
IF retcode <> 0 THEN
    PRINT "QB64: Free Fetch Row failed. Program terminated. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF
PRINT

'-----------------------------------------------------------------------
' *** Use the previous view, create another view and use StoreResult to
' *** create the sqlResults.txt temporary file, then read/display the
' *** file contents.
'

' *** Create the Yankees Team Batting Stats View
    sqlStmt$ = "CREATE OR REPLACE VIEW YankeesbattingStatsView AS " + _
               "SELECT PLAYER, GMSP, AB, R, H, RBI, 2B, 3B, HR, BB, K, HBP, SAC, SB, ASB, PO, AST, E, " + _                
               "CASE " + _ 
               "WHEN AB > 0 THEN FORMAT(AVG(H/AB), 3) " + _
               "ELSE FORMAT(0, 3) " + _
               "END AS 'AVG', " + _
               "CASE " + _
               "WHEN AB > 0 THEN FORMAT((((H-(2B+3B+HR))+(2B*2)+(3B*3)+(HR*4))/AB) ,3) " + _
               "ELSE FORMAT(0, 3) " + _
               "END AS 'SLUG', " + _
               "CASE " + _
               "WHEN AB > 0 THEN FORMAT((H+BB+HBP)/(AB+BB+HBP+SAC) ,3) " + _
               "ELSE FORMAT(0, 3) " + _
               "END AS 'OBP', " + _
               "CASE " + _
               "WHEN AB > 0 THEN FORMAT(((((H-(2B+3B+HR))+(2B*2)+(3B*3)+(HR*4))/AB)+((H+BB+HBP)/(AB+BB+HBP+SAC))), 3) " + _
               "ELSE FORMAT(0, 3) " + _
               "END AS 'OPS', " + _
               "CASE " + _
               "WHEN (PO+AST+E) > 0 THEN FORMAT(((PO+AST)/(PO+AST+E)), 3) " + _
               "ELSE FORMAT(0, 3) " + _
               "END AS 'FPCT' " + _        
               "FROM tempbattingStatsView " + _ 
               "GROUP BY PLAYER" + CHR$(0)
PRINT "QB64: Creating Yankees Team Batting Status View"
retcode = sqlCMD(sqlStmt$)
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF

' *** Retrieve the number of rows from YankeesbattingStatsView
PRINT "QB64: Retrieve number of rows"
retcode = sqlNumRows("YankeesbattingStatsView")
nbrRows = retcode
PRINT "QB64: Number of rows returned (YankeesbattingStatsView) = "; retcode
        
' *** Retrieve the number of columns from YankeesbattingStatsView
PRINT "QB64: Retrieve number of columns"
retcode = sqlNumFields("YankeesbattingStatsView")
PRINT "QB64: Number of columns returned (YankeesbattingStatsView) = "; retcode

' *** Perform a StoreResult against YankeesbattingStatsView & create sqlResults.txt results file
PRINT "QB64: Performing a SELECT Query on YankeesbattingStatsView"
retcode = sqlStoreResult("SELECT * FROM YankeesbattingStatsView")
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again."
    retcode = sqlDisonnect
    SYSTEM 99
END IF
IF _FILEEXISTS("sqlResults.txt") THEN
    f1% = FREEFILE: rows = 0
    OPEN "sqlResults.txt" FOR INPUT AS #f1%
    DO UNTIL EOF(f1%)
        LINE INPUT #f1%, qString$
        PRINT "QB64: "; qString$
        rows = rows + 1
    LOOP
    CLOSE #f1%
    PRINT "QB64: Number of rows processed ="; rows
ELSE
    PRINT "QB64: sqlResults.txt file not found. Please check and run again."
    SYSTEM 99
END IF
PRINT

'-----------------------------------------------------------------------
' *** Using the previously created view, execute UseResult and FetchRow
' *** functions to read from it and display the results (should match)
' *** the run created from the sqlResults.txt temporary file.
'

' *** Set the pointer for fetch_row from tempbattingStatsView
' *** Retrieve each row in the table using mysql_fetch_row
PRINT "QB64: Processing sqlUseResult"
retcode = sqlUseResult("SELECT * FROM YankeesbattingStatsView")
IF retcode = 0 THEN
    PRINT "QB64: Processing sqlFetchRow"
    FOR i = 1 TO nbrRows ' *** value set from: Retrieve the number of rows from YankeesbattingStatsView
        qString$ = sqlFetchRow$
        PRINT "QB64: Record Fetched: "; qString$
    NEXT i
ELSE
    PRINT "QB64: Disconnection fro server failed. Program terminated. Return Code ="; retcode
    SYSTEM 99
END IF
        
' *** Free Fetch Row process
PRINT "QB64: Freeing Fetch Row Pointers"
retcode = sqlFreeFetchRow
IF retcode <> 0 THEN
    PRINT "QB64: Free Fetch Row failed. Program terminated. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF
PRINT

'-----------------------------------------------------------------------
' *** Using the previously created view, execute CreateOutFile to create
' *** an OUTFILE from SQL.
'

' *** Create the Yankees Team Batting Stats text OUTFILE
PRINT "QB64: Creating Yankees Batting Status File"
select_what$ = "*"
select_from$ = "YankeesbattingStatsView"
select_filename$ = "/var/lib/mysql-files/Yankees-battingstats.file"
retcode = sqlCreateOutFile(select_what$, select_from$, select_filename$ + CHR$(0))
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode: PRINT
    SYSTEM 99
END IF
PRINT

'-----------------------------------------------------------------------
' *** Executed all SQL commands, delete (DROP) views and OUTFILE, then
' *** disconnect from SQL
'

' *** NOTE: YOU MAY WANT TO COMMENT THIS OUT TO VERIFY THAT THESE FILES (OUTFILE) WAS CREATED CORRECTLY
' *** Drop/delete tempbattingStatsView & YankeesbattingStatsView from currently connected mySQL database
' *** Note: YankeesbattingStatsView depends on tempbattingStatsView, and deleting temp makes Yankees unusable
''  PRINT "QB64: Drop mySQL View from connected database"
retcode = sqlDropView("tempbattingStatsView")
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF
retcode = sqlDropView("YankeesbattingStatsView")
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF
IF _FILEEXISTS("/var/lib/mysql-files/Yankees-battingstats.file") THEN KILL "/var/lib/mysql-files/Yankees-battingstats.file"
PRINT


' *** Drop User testbaseball
PRINT "QB64: Dropping user testbaseball IF EXISTS"
sqlUserID$ = "testbaseball" + CHR$(0)
IF sqlVerifyUser(sqlUserID$, "QB64") THEN
    PRINT "QB64: *** User exists in mysql.user table."
	retcode = sqlDropUser(sqlUserID$)
	IF retcode <> 0 THEN
		PRINT "QB64: *** User not dropped."
	ELSE
		PRINT "QB64: *** User dropped."
	END IF
END IF


' *** Disconnect from mySQL Server
PRINT "QB64: Disconnecting from mySQL Server"
retcode = sqlDisonnect
IF retcode <> 0 THEN
    PRINT "QB64: Disconnection from server failed. Program terminated. Return Code ="; retcode: PRINT
    SYSTEM 99
END IF


SYSTEM 0

' =======================================================================================================
'
