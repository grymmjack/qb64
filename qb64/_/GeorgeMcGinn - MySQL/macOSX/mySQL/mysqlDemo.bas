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
    FUNCTION sqlShowDatabases## ALIAS __sqlShowDatabases ()
    FUNCTION sqlShowTables## ALIAS __sqlShowTables ()
    FUNCTION sqlCMD## ALIAS __sqlCMD (opt_sql_stmt AS STRING)
    FUNCTION sqlStoreResult## ALIAS __sqlStoreResult (opt_sql_stmt AS STRING)
    FUNCTION sqlUseDatabase## ALIAS __sqlUseDatabase (opt_db_name AS STRING)
    FUNCTION sqlDropDatabase## ALIAS __sqlDropDatabase (opt_db_name AS STRING)
    FUNCTION sqlDropTable## ALIAS __sqlDropTable (opt_tbl_name AS STRING)
    FUNCTION sqlDropView## ALIAS __sqlDropView (opt_tbl_name AS STRING)
    FUNCTION sqlRows## ALIAS __sqlRows (opt_tbl_name AS STRING)
    FUNCTION sqlCols## ALIAS __sqlCols (opt_tbl_name AS STRING)
    FUNCTION sqlProcessStmt## ALIAS __sqlProcessStmt (opt_sql_stmt AS STRING)
    FUNCTION sqlUseResult## ALIAS __sqlUseResult (opt_sql_stmt AS STRING)
    FUNCTION sqlFetchRow$ ALIAS __sqlFetchRow ()
    FUNCTION sqlFreeFetchRow## ALIAS __sqlFreeFetchRow ()
END DECLARE

DIM SHARED AS INTEGER retcode
'------------------------------------------------------------
' *** MAIN Program Logic
'
QBMain:

' *** Connect to the mySQL Server
PRINT "QB64: Connecting to mySQL Server"
retcode = sqlConnect("localhost", "gjmcginn", "mysql", "baseballDB")
IF retcode <> 0 THEN
    PRINT "QB64: Connection to server failed. Please check and run again. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF


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
    PRINT "QB64: sqlResults.txt file not found. Please check and run again."
    SYSTEM 99
END IF

        
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
    PRINT "QB64: Number of tables found ="; rows
ELSE
    PRINT "QB64: sqlResults.txt file not found. Please check and run again."
    SYSTEM 99
END IF


' *** Retrieve the number of rows from batting table
PRINT "QB64: Retrieve number of rows"
retcode = sqlRows("batting")
PRINT "QB64: Number of rows returned = "; retcode
    
        
' *** Retrieve the number of columns from batting table
PRINT "QB64: Retrieve number of columns"
retcode = sqlCols("batting")
PRINT "QB64: Number of columns returned = "; retcode
    
    
' *** Change database from initial connection to mySQL Server
PRINT "QB64: Changing mySQL database for further processing"
retcode = sqlUseDatabase("baseballTDB")
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF


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
retcode = sqlProcessStmt(sqlStmt$)
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    retcode = sqlDisonnect
    SYSTEM 99
END IF


' *** Retrieve the number of rows from tempbattingStatsView view
PRINT "QB64: Retrieve number of rows"
retcode = sqlRows("tempbattingStatsView")
PRINT "QB64: Number of rows returned = "; retcode
nbrRows = retcode
    
        
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
retcode = sqlRows("YankeesbattingStatsView")
nbrRows = retcode
PRINT "QB64: Number of rows returned (YankeesbattingStatsView) = "; retcode
    
        
' *** Retrieve the number of columns from YankeesbattingStatsView
PRINT "QB64: Retrieve number of columns"
retcode = sqlCols("YankeesbattingStatsView")
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


' *** Create the Yankees Team Batting Stats text OUTFILE
IF _FILEEXISTS("/var/lib/mysql-files/Yankees-battingstats.file") THEN KILL "/var/lib/mysql-files/Yankees-battingstats.file"
sqlStmt$ = "SELECT * FROM YankeesbattingStatsView INTO OUTFILE '/var/lib/mysql-files/Yankees-battingstats.file'" + CHR$(0)
PRINT "QB64: Creating Yankees Batting Status File"
retcode = sqlCMD(sqlStmt$)
IF retcode <> 0 THEN
    PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
    SYSTEM 99
END IF


' *** Drop/delete tempbattingStatsView & YankeesbattingStatsView from currently connected mySQL database
' *** Note: YankeesbattingStatsView depends on tempbattingStatsView, and deleting temp makes Yankees unusable
PRINT "QB64: Drop mySQL View from connected database"
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


' *** Disconnect from mySQL Server
PRINT "QB64: Disconnecting from mySQL Server"
retcode = sqlDisonnect
IF retcode <> 0 THEN
    PRINT "QB64: Disconnection from server failed. Program terminated. Return Code ="; retcode
    SYSTEM 99
END IF


SYSTEM 0

