'****************************************************************
' BISEARCH.BAS = Binary Search in sorted arrays
' ============   Binaere Suche in sortierten Feldern
'
' Deutsche Beschreibung
' -----------------------------
' Dieses Q(uick)Basic-Programm demonstriert den binaeren
' Suchalgorithmus. Dies ist eine sehr schnelle Suchmethode fuer
' sortierte Felder. Das Programm durchsucht ein Feld nach einem
' Suchbegriff, indem es zunaechst das Feld in zwei Haelften teilt
' und das mittlere Feldelement mit dem Suchbegriff vergleicht.
' Ist der Suchbegriff gleich dem Feldelement, dann ist die Suche
' beendet. Ist der Suchbegriff groeser als das Feldelement, dann
' wird die obere Feldhaelfte wiederum in zwei Haelften geteilt,
' ansonsten die untere Feldhaelfte. Dieses Verfahren wird solange
' wiederholt bis der Suchbegriff gefunden ist.
'
' English-languge Description
' -----------------------------
' This Q(uick)Basic programm searches for a search item in a
' sorted array. The array ist split up in 2 halfes. If the middle
' array element equals the search item, the search is finished.
' If the search item's value ist higher than the middle array
' element, the higher half is again split into two halfes;
' otherwise, the lower half ist split into two halfes. This
' process will be repeated until the search item has been found.
' The array position of the found search item is displayed.
'******************************************************************
DECLARE FUNCTION BiSearch% (Find AS STRING, array() AS STRING)
'
DIM Word$(1 TO 6)
Word$(1) = "Bill"
Word$(2) = "Dick"
Word$(3) = "Elisabeth"
Word$(4) = "Frank"
Word$(5) = "George"
Word$(6) = "John"
'
'
CLS
PRINT "The searches element has been found at array position #";
PRINT BiSearch("GFrank", Word$())
SLEEP
END

DEFINT A-Z
'
'
FUNCTION BiSearch (Find AS STRING, array() AS STRING)

Min = LBOUND(array)             'start at first element
Max = UBOUND(array)             'consider through last

DO
  Try = (Max + Min) \ 2         'start testing in middle
  '
  IF array(Try) = Find THEN     'found it!
    BiSearch = Try              'return matching element
    EXIT DO                     'all done
  END IF
  '
  IF array(Try) > Find THEN     'too high, cut in half
    Max = Try' - 1
  ELSE
    Min = Try' + 1               'too low, cut other way
  END IF
LOOP WHILE Max >= Min
'BiSearch = Try
END FUNCTION

