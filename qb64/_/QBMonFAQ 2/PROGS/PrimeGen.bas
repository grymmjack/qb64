'******************************************************************
' PRIMEGEN.BAS = Prime Number Generator, finds over 3 Mio primes
' ============   Primzahlen-generator - findet ueber 3 Mio
'                  Primzahlen
'
' Deutsche Beschreibung
' ---------------------
' Dieses Q(uick)Basic-Programm verwendet eine Datei zu Speichern der
' Primzahlen. In dieser Datei werden nicht die Primzahlen selbst,
' sondern die Differenz zwischen jeder primzahl und deren Vorgaenger
' geteilt durch 2 hinterlegt.
' Das Programm stoppt mit der Primzahlsuche, wenn die Esc-Taste
' betaetigt wird oder wenn der Zwischenpuffer voll ist. Nach dem
' Stopp werden alle gefundenen Primzahlen auf dem Bildschirm
' angezeigt.
'
' Auf einem 286ger PC findet das Programm in 2,5 h ca. 3,2 Mio
' Pimzahlen
'
' English description
' ---------------------
' Algorithm from Knuth's "Sorting and Searching" Page 617
' Programmed by Rich Geldreich
'
' Notes:  This  prime   number   generator   uses   a   disk   file
' "PRIMEBUF.BIN" to hold the prime numbers, so little RAM memory is
' needed.   Each  prime  number  is  represented  as the difference
' between the last prime number by  a single byte.  In other words,
' the gap between each prime number is stored instead of each prime
' number itself.  All gaps are even  numbers,  because  all  primes
' must be odd numbers.  Therefore, each byte can represent a gap of
' up  to  510, because the least significant bit of each gap length
' is always unused.  (Except for the special cases of 1-2, and 2-3.
' These primes aren't stored in  the  disk file; they're assumed to
' be present.) Since the maximum gap between all consecutive primes
' up to 436,273,009 is only 286, a single byte is good  enough  for
' this program!)
'
' The  program  stops  when  escape is pressed or when the priority
' queue is full. After termination the found prime numbers are
' displayed on the screen.
'
' On a 286/10, roughly 3.2 million prime numbers were calculated in
' about 2.5 hours by this program.
'
'(c) by RICH GELDREICH, Sept. 18, 1993
'*********************************************************************
'
DEFINT A-Z
'
DECLARE SUB PutPrime (a&)
DECLARE FUNCTION GetPrime& ()
'
'Maximum prime candidate = HeapSize*HeapSize
CONST HeapSize = 4096
CONST IOSize = 2048
'
OPEN "primebuf.bin" FOR OUTPUT AS #1: CLOSE #1
OPEN "primebuf.bin" FOR BINARY AS #1
'
DIM SHARED PrimeBuf1 AS STRING * IOSize, Buf1Loc, Buf1FLoc AS LONG
DIM SHARED PrimeBuf2 AS STRING * IOSize, Buf2Loc, Buf2FLoc AS LONG
DIM SHARED SlideFlag
DIM SHARED LastPrime1&, LastPrime2&
'
Buf1Loc = 1 + (1 - 1): Buf1FLoc = 1
Buf2Loc = 1 + (2 - 1): Buf2FLoc = 1
LastPrime1& = 3
LastPrime2& = 5
'
'Priority queue
DIM HeapQ(1 TO HeapSize) AS LONG
DIM HeapQ1(1 TO HeapSize) AS LONG
DIM HeapQ2(1 TO HeapSize) AS LONG
'
DIM SHARED n AS LONG
DIM t AS LONG
DIM Q AS LONG, Q1 AS LONG, Q2 AS LONG
DIM TQ AS LONG, TQ1 AS LONG
DIM u AS LONG
'
n = 5
d = 2
r = 1
t = 25
HeapQ(1) = 25
HeapQ1(1) = 10
HeapQ2(1) = 30
'
DO
  DO
    Q = HeapQ(1)
    Q1 = HeapQ1(1)
    Q2 = HeapQ2(1)
    '
    TQ = Q + Q1
    TQ1 = Q2 - Q1
    '
    '***Insert Heap(1) into priority queue
    i = 1
    DO
        j = i * 2
        IF j <= r THEN
            IF j < r THEN
                IF HeapQ(j) > HeapQ(j + 1) THEN
                  j = j + 1
                END IF
            END IF

            IF TQ > HeapQ(j) THEN
                HeapQ(i) = HeapQ(j)
                HeapQ1(i) = HeapQ1(j)
                HeapQ2(i) = HeapQ2(j)
                i = j
            ELSE
                EXIT DO
            END IF
        ELSE
            EXIT DO
        END IF
    LOOP
    HeapQ(i) = TQ
    HeapQ1(i) = TQ1
    HeapQ2(i) = Q2
    '***
    '
  LOOP UNTIL n <= Q
  '
  DO WHILE n < Q
    PutPrime n
    n = n + d
    d = 6 - d
  LOOP
  '
  IF n = t THEN
    u = GetPrime
    t = u * u
    '
    '***Find location for new entry
    j = r + 1
    DO
      i = j \ 2
      IF i = 0 THEN
        EXIT DO
      END IF
      IF HeapQ(i) <= t THEN
        EXIT DO
      END IF
      HeapQ(j) = HeapQ(i)
      HeapQ1(j) = HeapQ1(i)
      HeapQ2(j) = HeapQ2(i)
      j = i
    LOOP
    '***
    HeapQ(j) = t
    IF (u MOD 3) = 2 THEN
      HeapQ1(j) = 2 * u
    ELSE
      HeapQ1(j) = 4 * u
    END IF
    HeapQ2(j) = 6 * u
    '
    r = r + 1
    IF r = HeapSize THEN 'Don't overflow priority queue
      EXIT DO
    END IF
    '
  END IF
  '
  n = n + d
  d = 6 - d
  '
LOOP UNTIL LEN(INKEY$)
'
'Print prime numbers calculated. (Except for the last few
'which are still in the output buffer.)
'
CLS
SEEK #1, 1
LastPrime& = 3
PRINT 1; 2; 3;
FOR a = 1 TO LOF(1) \ IOSize
  GET #1, , PrimeBuf1
  FOR b = 1 TO IOSize
    LastPrime& = LastPrime& + ASC(MID$(PrimeBuf1, b, 1)) * 2
    PRINT LastPrime&;
  NEXT
  IF LEN(INKEY$) THEN EXIT FOR
NEXT
CLOSE
END

'
FUNCTION GetPrime&

  IF SlideFlag = 0 THEN
    LastPrime2& = LastPrime2& + 2 * ASC(MID$(PrimeBuf1, Buf2Loc, 1))
  ELSE
    LastPrime2& = LastPrime2& + 2 * ASC(MID$(PrimeBuf2, Buf2Loc, 1))
  END IF
  GetPrime& = LastPrime2&

  Buf2Loc = Buf2Loc + 1
  IF Buf2Loc = (IOSize + 1) THEN
    Buf2FLoc = Buf2FLoc + IOSize
    GET #1, Buf2FLoc, PrimeBuf2
    Buf2Loc = 1
  END IF
END FUNCTION

'
SUB PutPrime (a&)
  STATIC TotalPrimes AS LONG
  MID$(PrimeBuf1, Buf1Loc) = CHR$((a& - LastPrime1&) \ 2)
  Buf1Loc = Buf1Loc + 1
  '
  IF Buf1Loc = (IOSize + 1) THEN
    TotalPrimes = TotalPrimes + IOSize
    LOCATE , 1
    PRINT "Primes found:"; TotalPrimes; "Maximum candidate:"; n;
    '
    PUT #1, Buf1FLoc, PrimeBuf1
    Buf1Loc = 1
    Buf1FLoc = Buf1FLoc + IOSize
    '
    IF SlideFlag = 0 THEN
      SlideFlag = -1
      PrimeBuf2 = PrimeBuf1
    END IF
  END IF
  '
  LastPrime1& = a&
END SUB

