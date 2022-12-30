_TITLE "mysqlDemo2.bas"

$CONSOLE:ONLY
'$DYNAMIC
 
'-------------------------------------------------------------
' *** Initialize Section
'
DIM SHARED AS STRING Query(100), sqlStmt(100)
DIM SHARED AS STRING Answer(1000, 1000)
DIM SHARED AS INTEGER lenstr, retcode, nbrRows, nbrCols, nbrLines, nbrUpdates
DIM SHARED mysqlCMD$, mysqlTable$, mysqlView$, mysqlDB$, mysql_userid$, mysql_password$, mysql_outputdir$
DIM SHARED qString$, battingfile$, pitchingfile$, leaguefile$, ReportFile$, ConfigFile$
DIM SHARED mysql_battingTable$, mysql_pitchingTable$


DIM SHARED AS STRING teamName, cmd

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


'------------------------------------------------------------
' *** MAIN Program Logic
'
QBMain:

' *** Connect to the mySQL Server
	PRINT "QB64: Connecting to mySQL Server"
	retcode = sqlConnect("localhost", "<userid>", "<password>", "<sqlDatabase>")
	IF retcode <> 0 THEN
		PRINT "QB64: Connection to server failed. Please check and run again. Return Code ="; retcode
		retcode = sqlDisonnect
		SYSTEM 99
	END IF
  
    
processSQL:
' *** Initialize variables for token replacement in SQL statements
	teamName = "Yankees"
	mysqlDB$ = "baseballTDB"
	mysql_battingTable$ = "batting"
	mysql_pitchingTable$ = "pitching"
	mysql_outputdir$ = "/var/lib/mysql-files/"
	nbr_innings$ = "9"

' *** Delete the <TEAM> battingstats file from mysql-files
' *** Cannot use KILL here as this file expects a "y" response to delete
	battingfile$ = mysql_outputdir$ + teamName + "-battingstats.file"
	IF _FILEEXISTS(battingfile$) THEN KILL battingfile$


createYankeesbattingStatsView:
' *** Create the SQL command to execute createTempBatting View
	FOR x1 = 1 TO 3
		rows = 0: nbrLines = 0: idx = 1
		READ qString$
		nbrLines = VAL(qString$): rows = VAL(qString$)
		REDIM AS STRING sqlStmt(1 TO nbrLines)
		FOR idx = 1 TO nbrLines
			READ sqlStmt(idx)
		NEXT idx
		mysqlCMD$ = replaceTokens$   
' *** Execute the SQL statements using pipecom to create the SQL Database/Tables
		retcode = sqlCMD(mysqlCMD$ + CHR$(0))
		IF retcode <> 0 THEN
			PRINT "QB64: SQL Command Failed. Please check output and run again. Return Code ="; retcode
			retcode = sqlDisonnect
			SYSTEM 99
		END IF
	NEXT x1
	
        
freeFetchRow:
' *** Free Fetch Row process
	PRINT "QB64: Freeing Fetch Row Pointers"
	retcode = sqlFreeFetchRow
	IF retcode <> 0 THEN
		PRINT "QB64: Free Fetch Row failed. Program terminated. Return Code ="; retcode
		retcode = sqlDisonnect
		SYSTEM 99
	END IF


displaySQLResults:
' *** Retrieve the number of rows from YankeesbattingStatsView
	PRINT "QB64: Retrieve number of rows"
	retcode = sqlRows("YankeesbattingStatsView")
	nbrRows = retcode
	PRINT "QB64: Number of rows returned (YankeesbattingStatsView) = "; retcode
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
     

disconnectMYSQL:
' *** Disconnect from mySQL Server
	PRINT "QB64: Disconnecting from mySQL Server"
	retcode = sqlDisonnect
	IF retcode <> 0 THEN
		PRINT "QB64: Disconnection from server failed. Program terminated. Return Code ="; retcode
		SYSTEM 99
	END IF


	SYSTEM 0



' *** DATA statements to build SQL statements for VIEW/FILE creation
createTempBatting:
DATA "22"
DATA "CREATE OR REPLACE VIEW tempbattingStatsView AS "
DATA "SELECT playerName AS 'PLAYER', "
DATA "SUM(games) AS 'GMSP', "
DATA "SUM(atbats) AS 'AB', "
DATA "SUM(runs) AS 'R', "
DATA "SUM(hits) AS 'H', "
DATA "SUM(rbis) AS 'RBI', "
DATA "SUM(doubles) AS '2B', "
DATA "SUM(triples) AS '3B', "
DATA "SUM(homeruns) AS 'HR', "
DATA "SUM(walks) AS 'BB', "
DATA "SUM(strikeouts) AS 'K', "
DATA "SUM(hitbypitch) AS 'HBP', "
DATA "SUM(sacrifices) AS 'SAC', "
DATA "SUM(stolenbases) AS 'SB', "
DATA "SUM(attstolenbases) AS 'ASB', "
DATA "SUM(putouts) AS 'PO', "
DATA "SUM(assists) AS 'AST', "
DATA "SUM(errors) AS 'E' "
DATA "FROM <BATSQLTBL> "
DATA "WHERE teamName='<TEAMNAME>' "
DATA "GROUP BY playerName "

createYankeeTeamBatting:
DATA "24"
DATA "CREATE OR REPLACE VIEW <TEAMNAME>battingStatsView AS "
DATA "SELECT PLAYER, GMSP, AB, R, H, RBI, 2B, 3B, HR, BB, K, HBP, SAC, SB, ASB, PO, AST, E, "
DATA "CASE "
DATA "WHEN AB > 0 THEN FORMAT(AVG(H/AB), 3) "
DATA "ELSE FORMAT(0, 3) "
DATA "END AS 'AVG', "
DATA "CASE "
DATA "WHEN AB > 0 THEN FORMAT((((H-(2B+3B+HR))+(2B*2)+(3B*3)+(HR*4))/AB) ,3) "
DATA "ELSE FORMAT(0, 3) "
DATA "END AS 'SLUG', "
DATA "CASE "
DATA "WHEN AB > 0 THEN FORMAT((H+BB+HBP)/(AB+BB+HBP+SAC) ,3) "
DATA "ELSE FORMAT(0, 3) "
DATA "END AS 'OBP', "
DATA "CASE "
DATA "WHEN AB > 0 THEN FORMAT(((((H-(2B+3B+HR))+(2B*2)+(3B*3)+(HR*4))/AB)+((H+BB+HBP)/(AB+BB+HBP+SAC))), 3) "
DATA "ELSE FORMAT(0, 3) "
DATA "END AS 'OPS', "
DATA "CASE "
DATA "WHEN (PO+AST+E) > 0 THEN FORMAT(((PO+AST)/(PO+AST+E)), 3) "
DATA "ELSE FORMAT(0, 3) "
DATA "END AS 'FPCT' "
DATA "FROM tempbattingStatsView "
DATA "GROUP BY PLAYER "

createBattingOutfile:
DATA "1"
DATA "SELECT * FROM <TEAMNAME>battingStatsView INTO OUTFILE '<SQLOUTDIR><TEAMNAME>-battingstats.file'"



' *** Start of processing FUNCTIONS/SUBS

FUNCTION replaceTokens$

    ' *** Replace the token <SQLDB> with mysqlDB$
    Token$ = "<SQLDB>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, mysqlDB$)
    NEXT x

    ' *** Replace the token <BATSQLTBL> with battingTable$ inputted from Config File
    Token$ = "<BATSQLTBL>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, mysql_battingTable$)
    NEXT x

    ' *** Replace the token <PITCHSQLTBL> with pitchingTable$ inputted from Config File
    Token$ = "<PITCHSQLTBL>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, mysql_pitchingTable$)
    NEXT x

    ' *** Replace the token <SQLOUTDIR> with SQL Output Directory inputted from Config File
    Token$ = "<SQLOUTDIR>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, mysql_outputdir$)
    NEXT x

    ' *** Replace the token <TEAMNAME> with teamName inputted from console input
    Token$ = "<TEAMNAME>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, teamName)
    NEXT x

    ' *** Replace the token <INNINGS> with innings from the Config File
    Token$ = "<INNINGS>"
    FOR x = 1 TO nbrLines
        qString$ = sqlStmt(x)
        sqlStmt(x) = TokenReplace$(qString$, Token$, nbr_innings$)
    NEXT x

    ' *** Create the SQL command to execute createTempBatting View
    cmd = ""
    FOR x = 1 TO nbrLines
        cmd = cmd + sqlStmt(x)
    NEXT x
    cmd = cmd + CHR$(0)
    
    replaceTokens$ = cmd


END FUNCTION


FUNCTION TokenReplace$ (qString$, Token$, TokReplace$)
    '-----------------------------------------------------------------------------
    ' *** Replace a provided token in a strink with a provided value
    ' *** (case sensitive)
    '
    lenstr = LEN(qString$): startpos = 1
    DO
        findpos% = INSTR(findpos% + 1, qString$, Token$) ' find another occurance
        IF findpos% THEN
            nbrbytes = findpos% - startpos
            startpos = findpos% + 1
            Tokenlen = LEN(Token$)
            qString$ = LEFT$(qString$, findpos% - 1) + TokReplace$ + RIGHT$(qString$, lenstr - (nbrbytes + Tokenlen))
            startpos = 1: findpos% = -1: lenstr = LEN(qString$)
        END IF
    LOOP UNTIL findpos% = 0
    
    TokenReplace$ = qString$

END FUNCTION


FUNCTION StrRemove$ (myString$, whatToRemove$) 'noncase sensitive
    '-----------------------------------------------------------------------------
    ' *** String Remove - remove text from a string value
    ' *** (noncase sensitive)
    '
    a$ = myString$
    b$ = LCASE$(whatToRemove$)
    i = INSTR(LCASE$(a$), b$)
    DO WHILE i
        a$ = LEFT$(a$, i - 1) + RIGHT$(a$, LEN(a$) - i - LEN(b$) + 1)
        i = INSTR(LCASE$(a$), b$)
    LOOP
    StrRemove$ = a$
END FUNCTION


FUNCTION StrReplace$ (myString$, find$, replaceWith$)
    '-----------------------------------------------------------------------------
    ' *** Replace a provided string with a provided value
    ' *** (noncase sensitive)
    '
    IF LEN(myString$) = 0 THEN EXIT FUNCTION
    a$ = myString$
    b$ = LCASE$(find$)
    basei = 1
    i = INSTR(basei, LCASE$(a$), b$)
    DO WHILE i
        a$ = LEFT$(a$, i - 1) + replaceWith$ + RIGHT$(a$, LEN(a$) - i - LEN(b$) + 1)
        basei = i + LEN(replaceWith$)
        i = INSTR(basei, LCASE$(a$), b$)
    LOOP
    StrReplace$ = a$
END FUNCTION


FUNCTION StrSplit$ (qString$, Delim$)
    '-----------------------------------------------------------------------------
    ' *** Split a STRING based on provided Delimiter
    ' ***      qString$ and Delim$ are passed to this function
    '
    lenstr = LEN(qString$)
    idx = 1
    startpos = 1
    DO
        findpos% = INSTR(findpos% + 1, qString$, Delim$) ' find another occurance
        IF findpos% THEN
            nbrbytes = findpos% - startpos
            Query(idx) = MID$(qString$, startpos, nbrbytes)
            startpos = findpos% + 1
            idx = idx + 1
        END IF
    LOOP UNTIL findpos% = 0
    nbrbytes = lenstr - startpos + 1
    Query(idx) = MID$(qString$, startpos, nbrbytes)
    
    StrSplit$ = "0"

END FUNCTION


FUNCTION strFormat$ (text AS STRING, template AS STRING)
    '-----------------------------------------------------------------------------
    ' *** Return a formatted string to a variable
    '
    TIMER(__UI_RefreshTimer) OFF
    d = _DEST: s = _SOURCE
    n = _NEWIMAGE(80, 80, 0)
    _DEST n: _SOURCE n
    PRINT USING template; VAL(text)
    FOR i = 1 TO 79
        t$ = t$ + CHR$(SCREEN(1, i))
    NEXT
    IF LEFT$(t$, 1) = "%" THEN t$ = MID$(t$, 2)
    strFormat$ = _TRIM$(t$)
    _DEST d: _SOURCE s
    _FREEIMAGE n
    TIMER(__UI_RefreshTimer) ON
END FUNCTION


FUNCTION ISNUMERIC (A$)
    '-----------------------------------------------------------------------------
    ' *** Numeric Check of a STRING
    '
    lenstr = LEN(A$)
    FOR I = 1 TO lenstr
        ACODE = ASC(A$, I)
        IF numeric(ACODE) THEN
            ISNUMERIC = TRUE
        ELSE
            ISNUMERIC = FALSE
            EXIT FUNCTION
        END IF
    NEXT I
    
END FUNCTION

