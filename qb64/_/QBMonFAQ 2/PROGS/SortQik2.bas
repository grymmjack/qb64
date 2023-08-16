'****************************************************************
' SORTQIK2.BAS = Iterative QuickSort example
' ============   Demonstration des Sortierverfahrens QuickSort
'                (nicht-rekursive Variante)
'
' English-language Description
' ------------------------------
' This (Q(uick)Basic programm sorts some text words using the
' iterative (non-recursive) QuickSort method. It can be easily
' modified for sorting numerical values instaed of strings.
'
' Deutsche Beschreibung
' -----------------------
' Dieses Q(uick)Basic-Programm sortiert ein paar von Anwender
' eingegebene Worte mit Hilfe des iterativen (nicht-rekursiven)
' QuickSort-Verfahrens Das Programm kann leicht so abgewandelt
' werden, dass es Zahlenwerte statt Texte sortiert.
'
' (c) Cornel Huth
'*****************************************************************
'
DECLARE SUB subHuthSortSTR (Array() AS STRING)
'
TYPE StackType
  low AS INTEGER
  hi AS INTEGER
END TYPE
'
DIM word$(5)
CLS
PRINT "You will be pompted to type in 6 text words"
PRINT
FOR i% = 0 TO 5
  INPUT "Type a Word"; word$(i%)
NEXT
CALL subHuthSortSTR(word$())
PRINT
PRINT "The words in sorted order:"
FOR i% = 0 TO 5
  PRINT word$(i%)
NEXT
SLEEP

'
SUB subHuthSortSTR (Array() AS STRING)
'               ^  TWEAK THESE    ^
'               | FOR OTHER TYPES |
'               `--+--------------'
'                  V
'
'
DIM aStack(1 TO 128) AS StackType
DIM compare AS STRING

  StackPtr = 1
  aStack(StackPtr).low = LBOUND(Array)
  aStack(StackPtr).hi = UBOUND(Array)
  StackPtr = StackPtr + 1

  DO
    StackPtr = StackPtr - 1
    low = aStack(StackPtr).low
    hi = aStack(StackPtr).hi
    DO
      i = low
      j = hi
      mid = (low + hi) \ 2
      compare = Array(mid)
      DO
        DO WHILE Array(i) < compare
          i = i + 1
        LOOP
    DO WHILE Array(j) > compare
          j = j - 1
        LOOP
        IF i <= j THEN
          SWAP Array(i), Array(j)
          i = i + 1
          j = j - 1
        END IF

      LOOP WHILE i <= j
      IF j - low < hi - i THEN
        IF i < hi THEN
          aStack(StackPtr).low = i
          aStack(StackPtr).hi = hi
          StackPtr = StackPtr + 1
        END IF
        hi = j
      ELSE
        IF low < j THEN
          aStack(StackPtr).low = low
          aStack(StackPtr).hi = j
          StackPtr = StackPtr + 1
        END IF
        low = i
      END IF
    LOOP WHILE low < hi
    'IF StackPtr > maxsp THEN maxsp = StackPtr
  LOOP WHILE StackPtr <> 1
END SUB

