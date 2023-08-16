'*************************************************************************
' SORTSHEL.BAS = ShellSort example
' ============   Demonstration des Sortierverfahrens ShellSort
'
' English-language Description
' -----------------------------
' This (Q(uick)Basic programm sorts some text words using the
' ShellSort method. It can be easily modified for sorting
' numerical values.
'
' Deutsche Beschreibung
' -----------------------------
' Dieses Q(uick)Basic-Programm sortiert ein paar von Anwender
' eingegebene Worte mit Hilfe des ShellSort-Verfahrens
' Das Programm kann leicht so abgewandelt werden, dass es
' Zahlenwerte statt Texte sortiert.
'
' (c) Released to Public Domain, 1993, by R.A. Coates
'**************************************************************************
'
DECLARE SUB ShellSort (col0%, array$())
'
DIM word$(5)   'Text array to be sorted
col10% = 5     'Number of array elements - 1
CLS
PRINT "You will be pompted to type in 6 text words"
PRINT
FOR i% = 0 TO 5
  INPUT "Type a Word"; word$(i%)
NEXT
CALL ShellSort(col10%, word$())
PRINT
PRINT "The words in sorted order:"
FOR i% = 0 TO 5
  PRINT word$(i%)
NEXT
SLEEP

'
'---------------------------------------------------------------------------
' Procedure uses the Shell-Metzger algorithm for sorting an array of string
' variables.  Adapted from an article by Donald Shell and disassembled IBM
' 360 machine language.  This sorting algorithm is extremely efficient for
' sorting small and medium sized arrays.
'
' PARAMETERS: col0%    = number of elements - 1 in the string array array$()
'             array$() = string variable array to be sorted.
' RETURNS:    array$() = sorted string variable array
'----------------------------------------------------------------------------
'
SUB ShellSort (col0%, array$())
    col1% = col0%
'
    WHILE col1% <> 0
      col1% = col1% \ 2
      col2% = col0% - col1%
'
      FOR count% = 1 TO col2%
        col3% = count%
sort1:
        col4% = col3% + col1%

        IF array$(col3%) <= array$(col4%) THEN
          GOTO sort2
        ELSE
          SWAP array$(col3%), array$(col4%)
          col3% = col3% - col1%
        END IF
'
        IF col3% > 0 THEN
          GOTO sort1
        END IF
sort2:
      NEXT count%
    WEND
END SUB 'ShellSort()

