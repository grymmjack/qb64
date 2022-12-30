Option Explicit
$NoPrefix
$Console:Only

On Error GoTo ERRHANDLE
ERRHANDLE:
If Err Then
    If _InclErrorLine Then
        CriticalError Err, _InclErrorLine, _InclErrorFile$
        Resume Next
    Else
        CriticalError Err, _ErrorLine, ""
        Resume Next
    End If
End If

' $ExeIcon:'databases.ico'
' Icon

Const SQLITE_ABORT = 4
Const SQLITE_AUTH = 23
Const SQLITE_BUSY = 5
Const SQLITE_CANTOPEN = 14
Const SQLITE_CONSTRAINT = 19
Const SQLITE_CORRUPT = 11
Const SQLITE_DONE = 101
Const SQLITE_EMPTY = 16
Const SQLITE_ERROR = 1
Const SQLITE_FORMAT = 24
Const SQLITE_FULL = 13
Const SQLITE_INTERNAL = 2
Const SQLITE_INTERRUPT = 9
Const SQLITE_IOERR = 10
Const SQLITE_LOCKED = 6
Const SQLITE_MISMATCH = 20
Const SQLITE_MISUSE = 21
Const SQLITE_NOLFS = 22
Const SQLITE_NOMEM = 7
Const SQLITE_NOTADB = 26
Const SQLITE_NOTFOUND = 12
Const SQLITE_NOTICE = 27
Const SQLITE_OK = 0
Const SQLITE_PERM = 3
Const SQLITE_PROTOCOL = 15
Const SQLITE_RANGE = 25
Const SQLITE_READONLY = 8
Const SQLITE_ROW = 100
Const SQLITE_SCHEMA = 17
Const SQLITE_TOOBIG = 18
Const SQLITE_WARNING = 28

Const SQLITE_INTEGER = 1
Const SQLITE_FLOAT = 2
Const SQLITE_BLOB = 4
Const SQLITE_NULL = 5
Const SQLITE_TEXT = 3

Type SQLITE_FIELD
    As Long Type
    As String ColumnName, Value
End Type

ConsoleTitle "SQLite Test"

Declare Dynamic Library "sqlite3"
    Function sqlite3_open& (filename As String, Byval ppDb As Offset)
    Sub sqlite3_open (filename As String, Byval ppDb As Offset)
    Function sqlite3_prepare& (ByVal db As Offset, zSql As String, Byval nByte As Long, Byval ppStmt As Offset, Byval pzTail As Offset)
    Function sqlite3_step& (ByVal sqlite3_stmt As Offset)
    Function sqlite3_changes& (ByVal sqlite3_stmt As Offset)
    Function sqlite3_column_count& (ByVal sqlite3_stmt As Offset)
    Function sqlite3_column_type& (ByVal sqlite3_stmt As Offset, Byval iCol As Long)
    Function sqlite3_column_name$ (ByVal sqlite3_stmt As Offset, Byval N As Long)
    Function sqlite3_column_text$ (ByVal sqlite3_stmt As Offset, Byval iCol As Long)
    Function sqlite3_last_insert_rowid&& (ByVal db As Offset)
    Function sqlite3_errmsg$ (ByVal db As Offset)
    Function sqlite3_errcode& (ByVal db As Offset)
    Sub sqlite3_finalize (ByVal sqlite3_stmt As Offset)
    Sub sqlite3_close (ByVal db As Offset)
End Declare

Dim Shared As Offset hSqlite, hStmt
Dim As String sql
ReDim Shared As SQLITE_FIELD DB_Result(1 To 1, 1 To 1)

' Dim As String db: db = ":memory:"
Dim As String db: db = "db1.db"
If DB_Open(db) Then
    Dim As String conTitle: conTitle = "SQLite Test - " + db: ConsoleTitle conTitle
    ' If DB_Query("CREATE TABLE memoryTest (Column1  VARCHAR(20), Column2 BOOL)") = SQLITE_OK Then
    '     If DB_Query("INSERT INTO memoryTest(Column1, Column2) VALUES ('A memory test',True)") = SQLITE_OK Then
    '         'Print DB_AffectedRows, DB_LastInsertId
            If DB_Query("SELECT * FROM configuration") = SQLITE_OK Then
                Dim As Long column, row
                For row = 1 To UBound(DB_Result, 2)
                    Print "Row"; row
                    For column = 1 To UBound(DB_Result, 1)
                        Print , GetDataType(DB_Result(column, row).Type), DB_Result(column, row).ColumnName, DB_Result(column, row).Value
                    Next
                Next
                DB_Close
            End If
    '     End If
    ' End If
End If

DB_Close

Function DB_Open%% (sqlitedb As String)
    Dim As String sqlitedbcopy: sqlitedbcopy = sqlitedb + Chr$(0)
    If sqlite3_open(sqlitedbcopy, Offset(hSqlite)) = SQLITE_OK Then
        DB_Open = -1
    Else
        Print sqlite3_errcode(hSqlite), sqlite3_errmsg(hSqlite)
        DB_Open = 0
    End If
End Function

Sub DB_Open (sqlitedb As String)
    Dim As String sqlitedbcopy: sqlitedbcopy = sqlitedb + Chr$(0)
    sqlite3_open sqlitedbcopy, Offset(hSqlite)
End Sub

Sub DB_Query (sql_command As String)
    Dim As String sql_command_copy: sql_command_copy = sql_command + Chr$(0)
    If sqlite3_prepare(hSqlite, sql_command_copy, Len(sql_command_copy), Offset(hStmt), 0) = SQLITE_OK Then
        Dim As Long colCount: colCount = sqlite3_column_count(hStmt)
        Dim As Long column, row, ret
        ret = sqlite3_step(hStmt)
        If ret = SQLITE_ROW Then
            Do
                row = row + 1
                For column = 0 To colCount - 1
                    ReDim Preserve As SQLITE_FIELD DB_Result(colCount, row)
                    DB_Result(column + 1, row).Type = sqlite3_column_type(hStmt, column)
                    DB_Result(column + 1, row).ColumnName = sqlite3_column_name(hStmt, column)
                    DB_Result(column + 1, row).Value = sqlite3_column_text(hStmt, column)
                Next
                ret = sqlite3_step(hStmt)
            Loop While ret = SQLITE_ROW
        ElseIf ret <> SQLITE_DONE Then
            'do some error catching
            SoftError "Error" + Str$(sqlite3_errcode(hSqlite)) + "in " + __FUNCTION_NAME, sqlite3_errmsg(hSqlite)
        End If
        sqlite3_finalize hStmt
    End If
End Sub

Function DB_Query& (sql_command As String)
    Dim As String sql_command_copy: sql_command_copy = sql_command + Chr$(0)
    If sqlite3_prepare(hSqlite, sql_command_copy, Len(sql_command_copy), Offset(hStmt), 0) = SQLITE_OK Then
        Dim As Long colCount: colCount = sqlite3_column_count(hStmt)
        Dim As Long column, row, ret
        ret = sqlite3_step(hStmt)
        If ret = SQLITE_ROW Then
            DB_Query = SQLITE_OK
            Do
                row = row + 1
                For column = 0 To colCount - 1
                    ReDim Preserve As SQLITE_FIELD DB_Result(colCount, row)
                    DB_Result(column + 1, row).Type = sqlite3_column_type(hStmt, column)
                    DB_Result(column + 1, row).ColumnName = sqlite3_column_name(hStmt, column)
                    DB_Result(column + 1, row).Value = sqlite3_column_text(hStmt, column)
                Next
                ret = sqlite3_step(hStmt)
            Loop While ret = SQLITE_ROW
        ElseIf ret = SQLITE_DONE Then DB_Query = SQLITE_OK
        Else DB_Query = SQLITE_ERROR
            'do some error catching
            SoftError "Error" + Str$(sqlite3_errcode(hSqlite)) + "in " + __FUNCTION_NAME, sqlite3_errmsg(hSqlite)
        End If
        sqlite3_finalize hStmt
    End If
End Function

Function DB_QueryToCSV& (sql_command As String, csvstring As String)
    Dim As String sql_command_copy: sql_command_copy = sql_command + Chr$(0)
    If sqlite3_prepare(hSqlite, sql_command_copy, Len(sql_command_copy), Offset(hStmt), 0) = SQLITE_OK Then
        Dim As Long colCount: colCount = sqlite3_column_count(hStmt)
        Dim As Long column, row, ret
        ret = sqlite3_step(hStmt)
        If ret = SQLITE_ROW Then
            DB_QueryToCSV = SQLITE_OK
            For column = 0 To colCount - 1
                If column = colCount - 1 Then
                    csvstring = csvstring + Chr$(34) + sqlite3_column_name(hStmt, column) + Chr$(34) + Chr$(13) + Chr$(10)
                Else
                    csvstring = csvstring + Chr$(34) + sqlite3_column_name(hStmt, column) + Chr$(34) + ","
                End If
            Next
            Do
                row = row + 1
                For column = 0 To colCount - 1
                    If column = colCount - 1 Then
                        csvstring = csvstring + Chr$(34) + sqlite3_column_text(hStmt, column) + Chr$(34) + Chr$(13) + Chr$(10)
                    Else
                        csvstring = csvstring + Chr$(34) + sqlite3_column_text(hStmt, column) + Chr$(34) + ","
                    End If
                Next
                ret = sqlite3_step(hStmt)
            Loop While ret = SQLITE_ROW
        ElseIf ret = SQLITE_DONE Then DB_QueryToCSV = SQLITE_OK
        Else DB_QueryToCSV = SQLITE_ERROR
            'do some error catching
            SoftError "Error" + Str$(sqlite3_errcode(hSqlite)) + "in " + __FUNCTION_NAME, sqlite3_errmsg(hSqlite)
        End If
        sqlite3_finalize hStmt
    End If
End Function

Sub DB_Query_NoResults (sql_command As String, dbreturn As String, lasterrorcode As Long)
    Dim As String sql_command_copy: sql_command_copy = sql_command + Chr$(0)
    If sqlite3_prepare(hSqlite, sql_command_copy, Len(sql_command_copy), Offset(hStmt), 0) = SQLITE_OK Then
        Dim As Long ret
        ret = sqlite3_step(hStmt)
        If ret = SQLITE_ROW Then
            Do
                ret = sqlite3_step(hStmt)
            Loop While ret = SQLITE_ROW
        End If
        lasterrorcode = sqlite3_errcode(hSqlite)
        dbreturn = LTrim$(Str$(sqlite3_errcode(hSqlite))) + Chr$(9) + sqlite3_errmsg(hSqlite)
        sqlite3_finalize hStmt
    End If
End Sub

Function DB_Query_NoResults& (sql_command As String, dbreturn As String)
    Dim As String sql_command_copy: sql_command_copy = sql_command + Chr$(0)
    If sqlite3_prepare(hSqlite, sql_command_copy, Len(sql_command_copy), Offset(hStmt), 0) = SQLITE_OK Then
        Dim As Long ret
        ret = sqlite3_step(hStmt)
        If ret = SQLITE_ROW Then
            Do
                ret = sqlite3_step(hStmt)
            Loop While ret = SQLITE_ROW
        End If
        DB_Query_NoResults = sqlite3_errcode(hSqlite)
        dbreturn = LTrim$(Str$(sqlite3_errcode(hSqlite))) + Chr$(9) + sqlite3_errmsg(hSqlite)
        sqlite3_finalize hStmt
    End If
End Function

Function DB_AffectedRows& ()
    DB_AffectedRows = sqlite3_changes(hSqlite)
End Function

Function DB_LastInsertId& ()
    DB_LastInsertId = sqlite3_last_insert_rowid(hSqlite)
End Function

Function GetDataType$ (dataType As Long)
    Select Case dataType
        Case SQLITE_INTEGER
            GetDataType = "INTEGER"
        Case SQLITE_FLOAT
            GetDataType = "FLOAT"
        Case SQLITE_BLOB
            GetDataType = "BLOB"
        Case SQLITE_NULL
            GetDataType = "NULL"
        Case SQLITE_TEXT
            GetDataType = "TEXT"
    End Select
End Function

Sub DB_Close ()
    sqlite3_close hSqlite
End Sub

'$Include:'MessageBox.BM'
