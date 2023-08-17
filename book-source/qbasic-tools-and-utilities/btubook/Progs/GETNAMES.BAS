'********** GETNAMES.BAS - demonstrates the GetNames file name reading routine

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION GetNames% (Array$())   'all functions must be declared
DECLARE SUB Sort (Array$(), Direction)

Spec$ = "C:\QB45\*.BAS"         'this is the file spec -- edit as necessary
REDIM Array$(1 TO 1)            'we must establish the array as dynamic
Array$(1) = Spec$               'place it into the first array element

NumFiles = GetNames%(Array$())  'fill the array with the matching names
CALL Sort(Array$(), 0)          'now sort the array before displaying it

CLS
FOR X = 1 TO NumFiles           'for each name that was found
  PRINT Array$(X)               'print it
  IF LEN(INKEY$) THEN           'pause if a key is pressed
    WHILE INKEY$ = "": WEND     'until another key is pressed
  END IF
NEXT

PRINT
PRINT NumFiles; "files matched "; Spec$
