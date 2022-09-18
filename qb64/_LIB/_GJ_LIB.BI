''
' GRYMMJACK'S LIB FOR QB64
'
' This is the master BI file, which includes the other BI files for the library.
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DICT.BI
' @uses DUMP.BI
' @uses ANSI.BI
' @uses STRINGS.BI
'
$LET GJ_LIB = 1
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

DIM SHARED GJ_LIB_NL AS STRING
$IF WIN THEN
    GJ_LIB_NL$ = CHR$(13)
$ELSE
    GJ_LIB_NL$ = CHR$(10)
$END IF

' Enable and disable debugging by setting this variable to TRUE or FALSE:
GJ_LIB_DEBUGGING = TRUE

'$INCLUDE:'DICT.BI'
'$INCLUDE:'DUMP.BI'
'$INCLUDE:'ANSI.BI'
'$INCLUDE:'STRINGS.BI'