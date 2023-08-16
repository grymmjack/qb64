'*************************************************************************
' VISISORT.BAS = Demonstrates 9 sort algorithms ans compairs their speed
' ============   Demonstriert 9 Sortieralgorithmen und misst deren
'                  Geschwindigkeit
'
' Deutsche Beschreibung
' ------------------------------
' (von Thomas Antoni, 11.3.2006)
' Dieses Q(uick)Basic-Programm demonstriert 9 verschiedene
' Sortieralgorithmen und misst deren Geschwindigkeit im Vergleich. Dazu
' wird ein Feld mit 200 Integerzahlen ain abfallender Reihenfolge gefuellt
' und anschliessend in aufsteigende Reihenfolge umsortiert. Die Folge der
' unsortierten und sortierten zahlen werden jeweils als gelbe Punkte
' auf einer Linie visualisiert - daher der Name "VisiSort". Das Programm
' wurde von einem alten Apple 3-Programm abgeleitet.
' In der folgenden Liste sind die Sortieralgrithmen und die auf meinem
' Pentium 100 MHz gemessenenen Sortierzeiten aufgefuehrt:
'
' BubbleSort....22.9 sec
' ShakerSort....26.6 sec
' SelectionSort..0.5 sec
' InsertSort....26.5 sec
' ShellSort......0,9 sec
' ShellSort2.....4.2 sec
' QuickSort......0.3 sec (iteratives, nicht-rekursives verfahren)
' Fastsort.......0.2 sec
' RapidSort......0.0 sec (scheint nicht zu funktionieren)
'
' English-language Description
' -------------------------------
' On the business of sort algorithm's, It made me think of a program
' that was out on the Apple 2 systems, way back when, called
' Visi-Sort Plus, which let you actuallly see how a sort program
' really works. Intrigued by it, I decided to make one for the IBM
' (VGA monitors). The only sort I could not fit in was RapidSort,
' other from that there are 9 different sorts you can view.
'
' (c) by LUIS ESPINOZA, May 28, 1993
'***********************************************************************
'
DECLARE SUB BubbleSort (Item%(), Count%)
DECLARE SUB ShakerSort (Item%(), Count%)
DECLARE SUB ShellSort (Item%(), Count%)
DECLARE SUB Fastsorti (Item%(), Lower%, Upper%)
DECLARE SUB QuickSort (Item%(), Lower%, Upper%)
DECLARE SUB ShellSort2 (Item%(), Count%)
DECLARE SUB SelectSort (Item%(), Count%)
DECLARE SUB InsertSort (Item%(), Count%)
DECLARE SUB IntRapidSort (IntArray%(), LowestElement%, HighestElement%, LowestVal%, HighestVal%)
DECLARE SUB CreateArray (Item%())
DECLARE SUB ShuffleArray (Item%())
DECLARE SUB PlotIt (A%, b%, A%())
DEFINT A-Z
'
'DIM SHARED MaxArray AS LONG
CONST MaxArray = 200
REDIM Item(MaxArray)
CLS
'CONST NoPlot = 1      'Remove Comment for speed
'
TYPE stacktype         'for QuickSort
  low AS INTEGER
  hi AS INTEGER
END TYPE
'
SCREEN 12
'
FOR Ds = 1 TO 9
  SELECT CASE Ds
    CASE 1
      A$ = "Bubble Sort"
    CASE 2
      A$ = "Shaker Sort"
    CASE 3
      A$ = "Selection Sort"
    CASE 4
      A$ = "Insert Sort"
    CASE 5
      A$ = "Shell Sort"
    CASE 6
      A$ = "Shell Sort2"
    CASE 7
      A$ = "Quick Sort"
    CASE 8
      A$ = "Fast Sort"
    CASE 9
      A$ = "Rapid Sort"
  END SELECT
  '
  LINE (0, 0)-(450, 480), 0, BF
  LOCATE 1 + (2 * (Ds - 1)), 59
  PRINT A$
  CreateArray Item()
  'ShuffleArray Item()
  '
  FOR i = 1 TO MaxArray
    PSET (i, Item(i)), 14
    '--Test code by Thomas Antoni
    LOCATE 28, 59
    PRINT Item(i); SPACE$(2)
    t! = TIMER: DO: LOOP UNTIL TIMER <> t!
    '--End Test
  NEXT
  '
  LOCATE 22, 60
  PRINT "Sorting........."
  b! = TIMER
  '
  SELECT CASE Ds
    CASE 1
      BubbleSort Item(), MaxArray
    CASE 2
      ShakerSort Item(), MaxArray
    CASE 3
      SelectSort Item(), MaxArray
    CASE 4
      InsertSort Item(), MaxArray
    CASE 5
      ShellSort Item(), MaxArray
    CASE 6
      ShellSort2 Item(), MaxArray
    CASE 7
      QuickSort Item(), 1, MaxArray
    CASE 8
      Fastsorti Item(), 1, MaxArray
    CASE 9
      IntRapidSort Item(), 1, MaxArray, 1, MaxArray
  END SELECT
  '
  C! = TIMER
  FOR i = 1 TO MaxArray
    PSET (i, Item(i)), 14
    '--Test code by Thomas Antoni
    LOCATE 28, 59
    PRINT Item(i); SPACE$(2)
    t! = TIMER: DO: LOOP UNTIL TIMER <> t!
    '--End Test
  NEXT
  SLEEP 1
  FOR i = 1 TO MaxArray
    PSET (i, Item(i)), 14
  NEXT
  LOCATE 22, 60
  PRINT "                   "
  LOCATE 23, 40
  IF C! < b! THEN C! = C! + b!
  LOCATE 2 + (2 * (Ds - 1)), 59
  PRINT USING "  Elaps: ##.####### s"; (C! - b!)
NEXT
'
END

'
'***
'
SUB BubbleSort (Item(), Count)
  n = Count
  k = n - 1
  FOR i = 1 TO k
    l = n - i
    FOR J = 1 TO l
       IF Item(J) > Item(J + 1) THEN
         SWAP Item(J), Item(J + 1)
         PlotIt J, J + 1, Item()
       END IF
    NEXT
  NEXT
END SUB

'
'***
SUB CreateArray (Item())
  LOCATE 22, 60
  PRINT "Creating Array"
  FOR i = 1 TO MaxArray
    Item(MaxArray - i + 1) = i
  NEXT
END SUB

'
'***
'
SUB Fastsorti (InArray%(), Lower%, Upper%)
  ' This routine was writen by Ryan Wellman.
  ' Copyright 1992, Ryan Wellman, all rights reserved.
  ' Released as Freeware October 22, 1992.
  ' You may freely use, copy & modify this code as you see
  ' fit. Under the condition that I am given credit for
  ' the original sort routine, and partial credit for modified
  ' versions of the routine.

  ' Thanks to Richard Vannoy who gave me the idea to compare
  ' entries further than 1 entry away.
  '
  Increment = (Upper + Lower)
  l2 = Lower - 1
'
  DO
    Increment = Increment \ 2
    i2 = Increment + l2
    FOR Index = Lower TO Upper - Increment
      IF InArray(Index) > InArray(Index + Increment) THEN
        SWAP InArray(Index), InArray(Index + Increment)
        PlotIt Index, Index + Increment, InArray()
          IF Index > i2 THEN
            cutpoint = Index
            stopnow = 0
            DO
              Index = Index - Increment
              IF SGN(Index + Increment) = 1 AND SGN(Index) = 1 THEN
                IF InArray(Index) > InArray(Index + Increment) THEN
                  SWAP InArray(Index), InArray(Index + Increment)
                  PlotIt Index, Index + Increment, InArray()
                ELSE
                  stopnow = -1
                  Index = cutpoint
                END IF
              ELSE
                stopnow = -1
                Index = cutpoint
              END IF
            LOOP UNTIL stopnow
         END IF
      END IF
    NEXT Index
  LOOP UNTIL Increment <= 1
END SUB

'
'***
'
SUB InsertSort (Item(), Count)
  FOR A = 2 TO Count
    t = Item(A)
    b = A - 1
    WHILE b >= 1 AND (t < Item(b))
      Item(b + 1) = Item(b)
      PlotIt b + 1, b, Item()
      b = b - 1
    WEND
    Item(b + 1) = t
    PlotIt b + 1, t, Item()
  NEXT
END SUB

'
'***
'
SUB IntRapidSort (IntArray(), LowestElement, HighestElement, LowestVal, HighestVal)
REDIM SortArray(LowestVal TO HighestVal)
  FOR n = LowestElement TO HighestElement
     Value = IntArray(n)
     SortArray(Value) = SortArray(Value) + 1
  NEXT n
'
  FOR arr = LowestVal TO HighestVal
     rep = SortArray(arr)
     FOR n = 1 TO rep
    ptr = ptr + 1
    IntArray(ptr) = arr
     NEXT n
  NEXT arr
'
ERASE SortArray
END SUB

'
'***
'
SUB PlotIt (A, b, A())
  IF NoPlot THEN EXIT SUB
  LINE (A, 0)-(A, 480), 0
  PSET (A, A(A)), 8
  LINE (b, 0)-(b, 480), 0
  PSET (b, A(b)), 8
END SUB

'
'***
'
SUB QuickSort (SortArray(), Lower%, Upper%)
  'QuickSort iterative (rather than recursive) by Cornel Huth
  DIM lstack(1 TO 128) AS stacktype   'our stack
  DIM sp AS INTEGER                   'out stack pointer
  sp = 1
  'maxsp = sp
  lstack(sp).low = Lower%
  lstack(sp).hi = Upper%
  sp = sp + 1
  DO
    sp = sp - 1
    low = lstack(sp).low
    hi = lstack(sp).hi
    DO
      i = low
      J = hi
      mid = (low + hi) \ 2
      compare = SortArray(mid)
      DO
        DO WHILE SortArray(i) < compare
          i = i + 1
        LOOP
        DO WHILE SortArray(J) > compare
          J = J - 1
        LOOP
        IF i <= J THEN
          SWAP SortArray(i), SortArray(J)
          PlotIt i, J, SortArray()
          i = i + 1
          J = J - 1
        END IF
        LOOP WHILE i <= J
          IF J - low < hi - i THEN
            IF i < hi THEN
              lstack(sp).low = i
              lstack(sp).hi = hi
             sp = sp + 1
            END IF
            hi = J
          ELSE
            IF low < J THEN
              lstack(sp).low = low
              lstack(sp).hi = J
               sp = sp + 1
            END IF
            low = i
          END IF
          LOOP WHILE low < hi
            'IF sp > maxsp THEN maxsp = sp
          LOOP WHILE sp <> 1
            'PRINT "MAX SP"; maxsp
END SUB

'
'***
'
SUB SelectSort (Item(), Count)
  FOR A = 1 TO Count - 1
    C = A
    t = Item(A)
    FOR b = A + 1 TO Count
      IF Item(b) < t THEN
        C = b
        t = Item(b)
      END IF
    NEXT
    Item(C) = Item(A)
    Item(A) = t
    PlotIt C, A, Item()
  NEXT
END SUB

'
'***
'
SUB ShakerSort (Item(), Count)
  C = 1
  b = Count
  d = b - 1
  DO
    FOR A = d TO C STEP -1
      IF Item(A) > Item(A + 1) THEN
        SWAP Item(A), Item(A + 1)
        PlotIt A, A + 1, Item()
        b = A
      END IF
    NEXT
    C = b + 1
    FOR A = C TO d
      IF Item(A) > Item(A + 1) THEN
        SWAP Item(A), Item(A + 1)
         PlotIt A, A + 1, Item()
         b = A
      END IF
    NEXT
    d = b
  LOOP WHILE C < d
END SUB

'
'***
'
SUB ShellSort (Item(), Count)
  M = Count
  DO WHILE INT(M / 2)
    M = INT(M / 2)
    FOR X = 1 TO Count - M
      h = X
      DO
        v = h + M
        IF Item(h) < Item(v) THEN EXIT DO
        SWAP Item(h), Item(v)
        PlotIt h, v, Item()
        h = h - M
      LOOP WHILE h >= 1
    NEXT
  LOOP
END SUB

'
'***
'
SUB ShellSort2 (Item(), Count)
  DIM A(5)
  A$ = "95321"
  FOR i = 1 TO 5
    A(i) = ASC(MID$(A$, i, 1)) - ASC("0")
  NEXT
  FOR w = 1 TO 5
   k = A(w)
   FOR i = k TO Count
     X = Item(i)
     J = i - k
     DO WHILE X < Item(ABS(J)) AND J > 0 AND J < Count
       Item(J + k) = Item(J)
       PlotIt J + k, J, Item()
       J = J - k
     LOOP
     Item(J + k) = X
     PlotIt J + k, X, Item()
   NEXT
  NEXT
END SUB

'
'***
'
SUB ShuffleArray (Item() AS INTEGER)
  LOCATE 22, 60
  PRINT "Shuffling Array";
  FOR i = 1 TO MaxArray
    SWAP Item(INT(RND * MaxArray) + 1), Item(INT(RND * MaxArray) + 1)
  NEXT
END SUB

