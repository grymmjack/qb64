'**********************************************************************
' ROMANUM.BAS - Roman to Arabic number translator
' ==========    Umwandlung von roemischen in arabische Zahlen
'
' Subject: ROMAN TO ARABIC # TRANSLATOR      Date: 02-11-96 (10:30)      
' Author:  Jeff S. Root                      Code: QB, QBasic, PDS       
' Origin:  FidoNet QUIK_BAS Echo             Packet: ALGOR.ABC
'===========================================================================
'
' There are 7 letters used as roman numerals:
'    I=1, V=5, X=10, L=50, C=100, D=500, M=1000
' Sometimes, also the lower-case letters are used.
' In fact, lower-case letters were not invented until the Middle
' Ages, well after the Roman Empire had dissolved.  And until a
' couple of hundred years ago, there was no subtraction in Roman
' numbers.  The number "4" was always written as "IIII", and "9"
' was always written as "VIIII", for example.  The shorthand use
' of "IV" and "IX" is a relatively recent invention.  The old
' form is easier for doing calculations.
'
' (c) MCMXCV by Jeff S. Root, Minneapolis, MN
'**********************************************************************
'
DEFINT A-Z: DIM Num(22)
CLS : PRINT
DO
   Roman$ = "": Arabic = 0: BadFlag = 0: ERASE Num
   PRINT "Roman numerals: ";
   LOCATE , , 1, 12, 13       'Cursor on
   DO
     DO: k$ = UCASE$(INKEY$): LOOP WHILE k$ = ""
     IF k$ = CHR$(27) THEN Roman$ = "": EXIT DO  'Esc
     IF k$ = CHR$(8) AND Roman$ > "" THEN
       Roman$ = LEFT$(Roman$, LEN(Roman$) - 1)   'Backspace
       PRINT CHR$(29); " "; CHR$(29);
     ELSEIF INSTR(1, "IVXLCDM", k$) THEN
       IF LEN(Roman$) < 21 THEN
         Roman$ = Roman$ + k$: PRINT k$;         'Add character
       END IF
     END IF
   LOOP UNTIL k$ = CHR$(13)                      'Enter
   LOCATE , 1, 0: PRINT TAB(38); : LOCATE , 1    'Cursor off
'
   IF Roman$ = "" THEN END   'Exit ROMANUM
   FOR n = 1 TO LEN(Roman$)
     SELECT CASE MID$(Roman$, n, 1)
       CASE "I": Num(n) = 1
       CASE "V": Num(n) = 5
       CASE "X": Num(n) = 10
       CASE "L": Num(n) = 50
       CASE "C": Num(n) = 100
       CASE "D": Num(n) = 500
       CASE "M": Num(n) = 1000
     END SELECT
   NEXT n
   FOR n = 1 TO LEN(Roman$) - 1
     IF Num(n) < Num(n + 1) OR Num(n) < Num(n + 2) THEN
       IF INSTR(1, "VLD", MID$(Roman$, n, 1)) THEN
         IF BadFlag = 0 THEN BadFlag = 1
       ELSEIF Num(n - 1) = Num(n) AND Num(n) = Num(n + 1) THEN
         IF BadFlag = 0 THEN BadFlag = 2
       ELSEIF Num(n) = Num(n + 2) THEN
         IF BadFlag = 0 THEN BadFlag = 3
       ELSEIF Num(n) < Num(n + 2) AND Num(n) <> Num(n + 1) THEN
         IF BadFlag = 0 THEN BadFlag = 4
       END IF
       Arabic = Arabic - Num(n)
     ELSE
       Arabic = Arabic + Num(n)
     END IF
   NEXT n
   Arabic = Arabic + Num(n)   'Add final character
   IF BadFlag THEN
     PRINT Roman$; " is bad format:  ";
     SELECT CASE BadFlag
       CASE 1: PRINT "Multiples of five may not be subtracted.";
       CASE 2: PRINT "Only two subtractions allowed together.";
       CASE 3: PRINT "This adds and subtracts the same value.";
       CASE 4: PRINT "Put high values before low values.";
     END SELECT
     LOCATE , 1: SLEEP 4: k$ = INKEY$   'Clear keybuffer
     PRINT TAB(80); : LOCATE , 1
   ELSE
     PRINT CHR$(30);   'Up a line
     PRINT TAB(22 - LEN(Roman$)); Roman$; "  = "; Arabic
     PRINT
   END IF
LOOP

