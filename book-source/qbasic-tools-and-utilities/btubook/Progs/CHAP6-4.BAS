'*********** CHAP6-4.BAS - simple text file browser

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

CONST MaxLines% = 5000
REDIM Offset&(1 TO MaxLines%)

CLS
PRINT "Enter the name of file to browse: ";
LINE INPUT "", FileName$

OPEN FileName$ FOR INPUT AS #1

  Offset&(1) = 1                'initialize to offset 1
  CurLine = 1                   'and start with line 1

  WHILE Action$ <> CHR$(27)     'until they press Escape
    SEEK #1, Offset&(CurLine)   'seek to the current line
    LINE INPUT #1, Text$        'read that line
    Offset&(CurLine + 1) = SEEK(1)  'save where the next
                                    '  line starts
    CLS
    IF LEN(Text$) THEN          'if it's not blank
      PRINT Text$               'print the line
    ELSE                        'otherwise
      PRINT "(blank line)"      'show that it's blank
    END IF

    DO                          'wait for a key
      Action$ = INKEY$
    LOOP UNTIL LEN(Action$)

    SELECT CASE ASC(RIGHT$(Action$, 1))
      CASE 71                   'Home
        CurLine = 1

      CASE 72                   'Up arrow
        IF CurLine > 1 THEN
          CurLine = CurLine - 1
        END IF

      CASE 80                   'Down arrow
        IF (NOT EOF(1)) AND CurLine < MaxLines% THEN
          CurLine = CurLine + 1
        END IF

      CASE ELSE
    END SELECT
  WEND
CLOSE
