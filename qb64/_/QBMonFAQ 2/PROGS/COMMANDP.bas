'***************************************************************************
' COMMANDP.BAS = COMMAND LINE PARSER, delivers the COMMAND$ line elements
' ============   Liefert die einzelnen Parameter der COMMAND$-Kommandozeile
'
' Deutsche Beschreibung
' ----------------------
' (von Thomas Antoni, 12.3.2006)
' Dieser "Kommandozeilen-Parser" für QuickBASIC analysiert den durch die
' COMMAND$-Funktion gelieferten Kommandozeilen-String. Die Funktion
' DimParse liefert die Anzahl der mit dem EXE-Programm uebergebenen
' Kommandozeilenparameter. Die Funktion Parse liefert den Inhalt des
' i-ten Parameters, wobei i als Parameter an die Funktion uebergeben wird.
' Als Trennzeichen zwischen den einzelnen Parameter wird nur ein
' Leerzeichen anerkannt. Sollen mhrere Leerzeichen oder andere
' Trennzeichen erlaubt sein, dann kannst Du das Program leicht
' entsprechend anpassen.
'
' English Description
' ----------------------
' QUESTION: Hi, I was wondering if anyone had a good (or halfway
' decent) routine or sub for dissecting the COMMAND$ returned by
' QuickBasic 4.5.  I am looking for something that will find two
' filenames and a few flags.
'
' ANSWER: Here you go....
' The DimParse function returns the number of elements in the string, (to
' DIM an array or whatever) the Parse function returns the individual
' parts of the given COMAND$ string, one part per call, until the end of
' the string is entered, then starts over. It works fast and easy. Because
' of my personal preference only a space is recognized as the separation
' between elements. Feel free to change that if you wish, should be easy.
'
' (c) July 24, 1993
'***************************************************************************
DECLARE FUNCTION Parse$ (In$)
DECLARE FUNCTION DimParse% (In$)
'Parse and DimParse functions by Andy Thomas
'
DEFINT A-Z
'
CLS
A$ = "Hello this is a test /d /a"      'test string
PRINT "Teststring: A$ = "; A$
PRINT
PRINT "Elements in A$ = "; DimParse%(A$)
FOR I = 1 TO DimParse%(A$)
  PRINT "Parse$("; I; ") = "; Parse$(A$)
NEXT I
'----------
'The above would generate the following display
'---------
'Elements in A$= 7
'Hello
'this
'is
'a
'test
'/d
'/a
'
SLEEP
END

FUNCTION DimParse% (In$)
  In$ = RTRIM$(LTRIM$(In$))
  Parses = 0
  Length = LEN(In$)
  IF Length = 0 THEN
    DimParse% = 0
    EXIT FUNCTION
  END IF
  FOR I = 1 TO Length
    IF MID$(In$, I, 1) = " " THEN Parses = Parses + 1
  NEXT I
  DimParse% = Parses + 1
END FUNCTION

'
'
FUNCTION Parse$ (In$)
DEFINT A-Z
  STATIC ParseAt%, Length
  IF ParseAt% = 0 THEN
    ParseAt% = 1
    Length = LEN(In$)
  END IF
  IF Length = 0 OR ParseAt% > Length THEN EXIT FUNCTION
  Offset% = INSTR(ParseAt%, In$, " ")
  IF Offset% = 0 THEN Offset% = Length + 1
  Parse$ = MID$(In$, ParseAt%, Offset% - ParseAt%)
  ParseAt% = Offset% + 1
  IF ParseAt% = Length + 2 THEN ParseAt% = 0
END FUNCTION

