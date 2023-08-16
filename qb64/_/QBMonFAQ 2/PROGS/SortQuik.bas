'*************************************************************************
' SORTQUIK.BAS = Recursive QuickSort example
' ============   Demonstration des rekursiven Sortierverfahrens QuickSort
'
' English-language Description
' -----------------------------
' This (Q(uick)Basic programm sorts somw text words using the
' recursive QuickSort method. It can be easily modified for sorting
' numerical values.
'
' Deutsche Beschreibung
' -----------------------------
' Dieses Q(uick)Basic-Programm sortiert ein paar von Anwender
' eingegebene Worte mit Hilfe des rekursiven QuickSort-Verfahrens
' Das Programm kann leicht so abgewandelt werden, dass es
' Zahlenwerte statt Texte sortiert.
'**************************************************************************
'
DECLARE SUB QuickSortSTR (Array() AS STRING, Low%, High%)
DIM word$(5)
CLS
PRINT "You will be pompted to type in 6 text words"
PRINT
FOR i% = 0 TO 5
  INPUT "Type a Word"; word$(i%)
NEXT
CALL QuickSortSTR(word$(), 0, 5)
PRINT
PRINT "The words in sorted order:"
FOR i% = 0 TO 5
  PRINT word$(i%)
NEXT
SLEEP

DEFINT A-Z
'
SUB QuickSortSTR (Array() AS STRING, Low, High)
'            /^\              /^\
'             |                |
'    Change these to any BASIC data type for this routine to
'    handle other types of data arrays other than strings.
'
'============================== QuickSortXXX ================================
'  QuickSortXXX works by picking a random "pivot" element in Array(), then
'  moving every element that is bigger to one side of the pivot, and every
'  element that is smaller to the other side.  QuickSortXXX is then  called
'  recursively with the two subdivisions created by the pivot.  Once the
'  number of elements in a subdivision reaches two, the recursive calls end
'  and the array is sorted.
'===========================================================================
'
'            Microsoft's source code modified as needed
'

STATIC BeenHere

IF NOT BeenHere THEN
        Low = LBOUND(Array)
        High = UBOUND(Array)
        BeenHere = -1
END IF

DIM Partition AS STRING  ' Change STRING to any BASIC data type
                         ' for this QuickSort routine to work with
                         ' things other than strings.

   IF Low < High THEN

      ' Only two elements in this subdivision; swap them if they are out
      ' of order, then end recursive calls:

      IF High - Low = 1 THEN ' we have reached the terminating condition!
         IF Array(Low) > Array(High) THEN
            SWAP Low, High
            BeenHere = 0
         END IF
      ELSE

         ' Pick a pivot element at random, then move it to the end:
         RandIndex = INT(RND * (High - Low + 1)) + Low
         SWAP Array(High), Array(RandIndex)
         Partition = Array(High)
         DO

            ' Move in from both sides towards the pivot element:
            i = Low: J = High
            DO WHILE (i < J) AND (Array(i) <= Partition)
               i = i + 1
            LOOP
            DO WHILE (J > i) AND (Array(J) >= Partition)
               J = J - 1
            LOOP

            ' If we haven't reached the pivot element, it means that two
            ' elements on either side are out of order, so swap them:
            IF i < J THEN
               SWAP Array(i), Array(J)
            END IF
         LOOP WHILE i < J

         ' Move the pivot element back to its proper place in the array:
         SWAP Array(i), Array(High)

         ' Recursively call the QuickSortSTR procedure (pass the smaller
         ' subdivision first to use less stack space):
         IF (i - Low) < (High - i) THEN
            QuickSortSTR Array(), Low, i - 1
            QuickSortSTR Array(), i + 1, High
         ELSE
            QuickSortSTR Array(), i + 1, High
            QuickSortSTR Array(), Low, i - 1
         END IF
      END IF
   END IF
END SUB

