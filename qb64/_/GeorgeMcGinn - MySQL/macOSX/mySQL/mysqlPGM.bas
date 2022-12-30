_TITLE "ebacCalculator.bas"
'------------------------------------------------------------------------------------------------
' SQL Libraries v1.0 by George McGinn, July, 2021
' Copyright (C)2021 by George McGinn
'                      All Rights Reserved.
'
'------------------------------------------------------------------------------------------------
' Program provides FUNCTIONS and example code on how to use mySQL in a QB64 program.
'
' The FUNCTIONS and the variables defined are in two INCLUDE files, and the code in this QBMain
' shows how to set the variables and call the SQL commands.
'
'------------------------------------------------------------------------------------------------
' Program Copyright (C)2021 by George McGinn
' All Rights Reserved.
'
' SQL Libraries by George McGinn is licensed under a Creative Commons
' Attribution 4.0 International License.
'
' Full License Link: https://creativecommons.org/licenses/by/4.0/
'
' You are free to:
'     Share          - copy and redistribute the material in any medium or format.
'     Adapt          - remix, transform, and build upon the material for any purpose, even commercially.
'     Attribution    - You must give appropriate credit, provide a link to
'                      the license, and indicate if changes were made. You may do so in any
'                      reasonable manner, but not in any way that suggests the licensor
'                      endorses you or your use.
'     Commercial     - You may use the material for commercial purposes.
'
'    No additional restrictions - You may not apply legal terms or technological measures that legally
'                                 restrict others from doing anything the license permits.
'
'
' *** NOTICES ***
'    You do not have to comply with the license for elements of the material in the public domain or
'    where your use is permitted by an applicable exception or limitation.
'    No warranties are given. The license may not give you all of the permissions necessary for your
'    intended use. For example, other rights such as publicity, privacy, or moral rights may limit
'    how you use the material.
'
' *** None of this code is considered in the Public Domain. Rights granted under CC 4.0
'     are outlined as above and the disclaimer below:
'
' *** DISCLAIMER ***
' Unless otherwise separately undertaken by the Licensor, to the extent possible,
' the Licensor offers the Licensed Material as-is and as-available, and makes no
' representations or warranties of any kind concerning the Licensed Material, whether
' express, implied, statutory, or other. This includes, without limitation, warranties
' of title, merchantability, fitness for a particular purpose, non-infringement, absence
' of latent or other defects, accuracy, or the presence or absence of errors, whether or
' not known or discoverable. Where disclaimers of warranties are not allowed in full or
' in part, this disclaimer may not apply to You.
'
' To the extent possible, in no event will the Licensor be liable to You on any legal theory
' (including, without limitation, negligence) or otherwise for any direct, special, indirect,
' incidental, consequential, punitive, exemplary, or other losses, costs, expenses, or damages
' arising out of this Public License or use of the Licensed Material, even if the Licensor has
' been advised of the possibility of such losses, costs, expenses, or damages. Where a limitation
' of liability is not allowed in full or in part, this limitation may not apply to You.
'
' The disclaimer of warranties and limitation of liability provided above shall be interpreted
' in a manner that, to the extent possible, most closely approximates an absolute disclaimer and
' waiver of all liability.
'------------------------------------------------------------------------------------------------

'SHELL "echo 'CREATE DATABASE contact_db' | mysql -ugjmcginn -pmysql"
'SHELL "echo 'CREATE TABLE plu (item CHAR(20), price CHAR(20), grp CHAR(20), tax CHAR(20), kit CHAR(20))' | mysql -ugjmcginn -pmysql contact_db"

'DO
'INPUT "item>   ", item$
'INPUT "price>  ", price$
'INPUT "group>  ", grp$
'INPUT "tax>    ", tax$
'INPUT "kitchen ", kit$
'PRINT ""
'SHELL "echo " + CHR$(34) + "INSERT INTO plu (item, price, grp, tax, kit) VALUES ('" + item$ + "', " + price$ + ", " + grp$ + ", " + tax$ + ", " + kit$ + ")" + CHR$(34) + " | mysql -uroot epos"
'LOOP

'-------------------------------------------------------------
'*** Initialize for SQL Functions'

'*** Variables for SQL Functions
DECLARE FUNCTION sql_select ()
DECLARE FUNCTION sql_createDB ()
DECLARE FUNCTION sql_deleteDB ()
DECLARE FUNCTION sql_createTABLE ()
DECLARE FUNCTION sql_deleteTABLE ()
DIM SHARED mysqlCMD$, mysqlTable$, mysqlDB$, mysqlSelect$, mysqlWhere$, mysql_userid$, mysql_password$, q$

'*** Variables needed for StrTok$ Function
DECLARE FUNCTION StrTok$ ()
DIM SHARED AS STRING Srce
DIM SHARED Token$, Delim$

'*** Variables for pipecom
DIM SHARED AS STRING cmd, stdout, stderr

'--------------------------------
'*** Setup NUMERIC Check Table
DIM SHARED numeric(255)
FOR I = 48 TO 57
    numeric(I) = -1
NEXT

'------------------------------------------------------------
'*** MAIN Logic for SQL Calls
'
QBMain:

'*** Perform SQL Search
    mysql_userid$ = "gjmcginn"
    mysql_password$ = "mysql"
'mysqlCMD$ = " | mysql -ugjmcginn -pmysql -s "
    mysqlTable$ = "contacts"
    mysqlDB$ = "contact_db"
    mysqlSelect$ = "id, first_name, phone_number"
    mysqlWhere$ = "last_name"
    mysqlCMD$ = " | mysql -u" + mysql_userid$ + " -p" + mysql_password$ + " -s "
    PRINT "Name Search"
    INPUT "Enter Last Name > ", q$

    result = sql_select
    PRINT "Return from FUNCTION = "; result

    END


'-----------------------------------------------------------------------------------------------------
'*** SQL Functions
'

FUNCTION sql_select ()
'-----------------------------------------------------------------------------------------------------
'* Execute a SQL Table Search & return all rows
'
'    DIM cmd AS STRING
    DIM errtag AS STRING

'*** Execute SQL SELECT Command
    IF q$ = "" THEN EXIT FUNCTION
    cmd = ("echo " + CHR$(34) + "SELECT " + mysqlSelect$ + " FROM " + mysqlTable$ + " WHERE " + mysqlWhere$ + " = '" + q$ + "'" + CHR$(34) + mysqlCMD$ + mysqlDB$)
    result = pipecom(cmd, stdout, stderr)
    'PRINT "the result of " + q$ + " is " + stdout
    PRINT "stdout = "; stdout
    PRINT "stderr = "; stderr

'*** Load SQL results into an array
    IF result = 0 THEN
        Srce = stdout
        Token$ = " "
        Delim$ = "" + CHR$(9) + CHR$(10) + CHR$(13)
        DO WHILE Token$ <> ""
            Token$ = StrTok$
            IF Token$ = "" THEN EXIT DO
            PRINT "Token$="; Token$
        LOOP
    ELSE
        sql_select = 1
    END IF

    errtag = MID$(stderr, 8, 9)
    IF errtag <> "[Warning]" AND errtag <> "" THEN
        PRINT "errtag = "; errtag
        PRINT "stderr = "; stderr
    END IF
    PRINT "Result = "; result
    q$ = ""
    cmd = ""

'-------------------------------------------
'*** Create a temp file for the mySQL output
    OPEN "sqltempfile" FOR OUTPUT AS #1
    PRINT #1, stdout
    PRINT #1, stderr
    CLOSE #1


'    _DELAY 5
END FUNCTION


FUNCTION sql_createDB ()
'-----------------------------------------------------------------------------------------------------
'*** Execute a SQL Create Database
'*** Usage:
'***    CREATE DATABASE <mysqlDB>' | mysql -u<sql_userid> -p<sql_password>"
'

    DIM cmd AS STRING
    DIM errtag AS STRING
    IF q$ = "" THEN END
    cmd = ("echo " + CHR$(34) + "CREATE DATABASE " + mysqlDB$ + CHR$(34) + mysqlCMD$)
    result = pipecom(cmd, stdout, stderr)
    'PRINT "the result of " + q$ + " is " + stdout
    PRINT "stdout = "; stdout
    PRINT "stderr = "; stderr
    PRINT "Result = "; result

'-------------------------------------------
'*** Create a temp file for the mySQL output
'
    OPEN "sqltempfile" FOR OUTPUT AS #1
    PRINT #1, stdout
    PRINT #1, stderr
    CLOSE #1

    IF result <> 0 THEN
        sql_createDB = 1
        EXIT FUNCTION
    END IF

    errtag = MID$(stderr, 8, 9)
    IF errtag <> "[Warning]" AND errtag <> "" THEN
        PRINT "errtag = "; errtag
        PRINT "stderr = "; stderr
    END IF
    cmd = ""


END FUNCTION


FUNCTION sql_createTABLE ()
'-----------------------------------------------------------------------------------------------------
'* Execute a SQL Create Table
'
    SHELL "echo 'CREATE TABLE plu (item CHAR(20), price CHAR(20), grp CHAR(20), tax CHAR(20), kit CHAR(20))' | mysql -ugjmcginn -pmysql contact_db"

END FUNCTION


FUNCTION sql_deleteDB ()
'-----------------------------------------------------------------------------------------------------
'* Execute a SQL Create Table
'
    SHELL "echo 'CREATE TABLE plu (item CHAR(20), price CHAR(20), grp CHAR(20), tax CHAR(20), kit CHAR(20))' | mysql -ugjmcginn -pmysql contact_db"

END FUNCTION


FUNCTION sql_deleteTABLE ()
'-----------------------------------------------------------------------------------------------------
'* Execute a SQL Create Table
'
    SHELL "echo 'CREATE TABLE plu (item CHAR(20), price CHAR(20), grp CHAR(20), tax CHAR(20), kit CHAR(20))' | mysql -ugjmcginn -pmysql contact_db"

END FUNCTION


'
'*** End SQL Functions
'-----------------------------------------------------------------------------------------------------


'-----------------------------------------------------------------------------------------------------
'*** FUNCTIONS/SUBS/INCLUDES
'

FUNCTION StrTok$
'-----------------------------------------------------------------------------
'*** Split a STRING based on provided Delimiter(s)
'***      Srce and Delim$ are SHARED and populated before execution
'
    STATIC Start%, SaveStr$

'*** If first call, make a copy of the string.
    IF Srce <> "" THEN
        Start% = 1: SaveStr$ = Srce
    END IF

    BegPos% = Start%: ln% = LEN(SaveStr$)

'*** Look for start of a token (character that isn't delimiter).
    WHILE BegPos% <= ln% AND INSTR(Delim$, MID$(SaveStr$, BegPos%, 1)) <> 0
        BegPos% = BegPos% + 1
    WEND

'*** Test for token start found.
    IF BegPos% > ln% THEN
        StrTok$ = "": EXIT FUNCTION
    END IF

'*** Find the end of the token.
    EndPos% = BegPos%
    WHILE EndPos% <= ln% AND INSTR(Delim$, MID$(SaveStr$, EndPos%, 1)) = 0
        EndPos% = EndPos% + 1
    WEND
    StrTok$ = MID$(SaveStr$, BegPos%, EndPos% - BegPos%)

'*** Set starting point for search for next token.
    Start% = EndPos%

'*** Wipe out Srce for multiple calls to FUNCTION
    Srce = ""

END FUNCTION


FUNCTION ISNUMERIC (A$)
'-----------------------------------------------------------------------------
'*** Numeric Check of a STRING
    l = LEN(A$)
    FOR I = 1 TO l
        ACODE = ASC(A$, I)
        IF numeric(ACODE) THEN
            ISNUMERIC = TRUE
        ELSE
            ISNUMERIC = FALSE
            EXIT FUNCTION
        END IF
    NEXT I
END FUNCTION


'$INCLUDE:'pipecom.bas'

'
'*** End FUNCTIONS/SUBS
'-----------------------------------------------------------------------------------------------------


'    Sex = MID$(stdout, 1, INSTR(stdout, "ERROR") - 1)
'    stdout = MID$(stdout, INSTR(stdout, "|") + 1)


'    QSqlDatabase db_conn =
'            QSqlDatabase::addDatabase("QMYSQL", "contact_db");
'
'    db_conn.setHostName("127.0.0.1");
'    db_conn.setDatabaseName("contact_db");
'    db_conn.setUserName("gjmcginn");
'    db_conn.setPassword("mysql");
'    db_conn.setPort(3306);
'
'        QString id = record.value("id").toString();
'        QString last_name = record.value("last_name").toString();
'        QString first_name = record.value("first_name").toString();
'        QString phone_number = record.value("phone_number").toString();

