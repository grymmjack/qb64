TYPE BALL_OBJECT
    X       AS INTEGER
    Y       AS INTEGER
    X_DIR   AS INTEGER
    Y_DIR   AS INTEGER
    SPEED   AS INTEGER
    KOLOR   AS INTEGER
    DISPLAY AS STRING
END TYPE

DIM SHARED BALL AS BALL_OBJECT
DIM SHARED BALL_9GRID(1 TO 3, 1 TO 3) AS INTEGER

' PRINT " 123"
' PRINT "1"
' PRINT "2"
' PRINT "3" 
' FOR y%=1 TO 3
'     LOCATE y%+1
'     FOR x%=1 TO 3
'         DIM v AS INTEGER
'         DIM s AS STRING
'         READ v%
'         BALL_9GRID(y%, x%) = v%
'         LOCATE , x%+1
'         IF v% = 1 THEN s$ = "X" ELSE s$ = " "
'         PRINT s$;
'     NEXT x%
'     PRINT
' NEXT y%

' DATA 1, 1, 1 
' DATA 0, 0, 1
' DATA 0, 0, 1
