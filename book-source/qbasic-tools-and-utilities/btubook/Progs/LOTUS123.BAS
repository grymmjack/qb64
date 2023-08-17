'*********** LOTUS123.BAS - shows how to read and write Lotus 1-2-3 files

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB GetFormat (Format, Row, Column)
DECLARE SUB WriteColWidth (Column, ColWidth)
DECLARE SUB WriteInteger (Row, Column, ColWidth, Temp)
DECLARE SUB WriteLabel (Row, Column, ColWidth, Msg$)
DECLARE SUB WriteNumber (Row, Col, ColWidth, Fmt$, Num#)

DIM SHARED CellFmt AS STRING * 1        'to read one byte
DIM SHARED ColNum(40)                   'max columns to write
DIM SHARED FileNum                      'the file number to use

CLS
PRINT "Read an existing 123 file or ";
PRINT "Create a sample file (R/C)? ";
LOCATE , , 1
DO
   X$ = UCASE$(INKEY$)
LOOP UNTIL X$ = "R" OR X$ = "C"
LOCATE , , 0
PRINT X$

IF X$ = "R" THEN

  '----- read an existing file
  INPUT "Lotus file to read: ", FileName$
  IF INSTR(FileName$, ".") = 0 THEN
    FileName$ = FileName$ + ".WKS"
  END IF
  PRINT

  '----- get the next file number and open the file
  FileNum = FREEFILE
  OPEN FileName$ FOR BINARY AS #FileNum

  DO UNTIL Opcode = 1                   'until End of File code

     GET FileNum, , Opcode              'get the next opcode
     GET FileNum, , Length              'and the data length

     SELECT CASE Opcode                 'filter the Opcodes

    CASE 0                              'Beginning of File record
      PRINT "Beginning of file, Lotus ";
      GET FileNum, , Temp

      SELECT CASE Temp
        CASE 1028
          PRINT "1-2-3 version 1.0 or 1A"
        CASE 1029
          PRINT "Symphony version 1.0"
        CASE 1030
          PRINT "123 version 2.x"
        CASE ELSE
          PRINT "NOT a Lotus File!"
      END SELECT

    CASE 1                                  'End of File
      PRINT "End of File"

    CASE 12                                 'Blank cell
       'Note that Lotus saves blank cells only if they are formatted or
       'protected.
       CALL GetFormat(Format, Row, Column)
       PRINT "Blank:      Format ="; Format,
       PRINT "Row ="; Row,
       PRINT "Col ="; Column

    CASE 13                                 'Integer
       CALL GetFormat(Format, Row, Column)
       GET FileNum, , Temp
       PRINT "Integer:    Format ="; Format,
       PRINT "Row ="; Row,
       PRINT "Col ="; Column,
       PRINT "Value ="; Temp

    CASE 14                                 'Floating point
       CALL GetFormat(Format, Row, Column)
       GET FileNum, , Number#
       PRINT "Number:     Format ="; Format,
       PRINT "Row ="; Row,
       PRINT "Col ="; Column,
       PRINT "Value ="; Number#

    CASE 15                                 'Label
       CALL GetFormat(Format, Row, Column)
       'Create a string to hold the label.  6 is subtracted to exclude the
       'Format, Column, and Row information.

       Info$ = SPACE$(Length - 6)
       GET FileNum, , Info$                 'read the label
       GET FileNum, , CellFmt$              'eat the CHR$(0)
       PRINT "Label:      Format ="; Format,
       PRINT "Row ="; Row,
       PRINT "Col ="; Column, Info$

    CASE 16                                 'Formula
       CALL GetFormat(Format, Row, Column)
       GET FileNum, , Number#               'read cell value
       GET FileNum, , Length                'and formula length
       SEEK FileNum, SEEK(FileNum) + Length 'skip formula
       PRINT "Formula:    Format ="; Format,
       PRINT "Row ="; Row,
       PRINT "Col ="; Column,
       PRINT "Value ="; Number#

    CASE ELSE
       Dummy$ = SPACE$(Length)              'skip the record
       GET FileNum, , Dummy$                'read it in
       PRINT "Opcode: "; Opcode             'show its Opcode

     END SELECT

     '----- pause when the screen fills
     IF CSRLIN > 21 THEN
       PRINT
       PRINT "Press <ESC> to end or ";
       PRINT "any other key for more"
       DO
         K$ = INKEY$
       LOOP UNTIL LEN(K$)
       IF K$ = CHR$(27) THEN EXIT DO
       CLS
     END IF

     NumRecs = NumRecs + 1                  'count the records

  LOOP
  PRINT "Number of Records Processed ="; NumRecs
  CLOSE

ELSE

  '----- write a sample file
  FileNum = FREEFILE                        'as above
  OPEN "SAMPLE.WKS" FOR BINARY AS #FileNum

  Temp = 0                                  'OpCode for Start of File
  PUT FileNum, , Temp                       'write that
  Temp = 2                                  'its data length is 2
  PUT FileNum, , Temp                       'since it's an integer
  Temp = 1030                               'Lotus version 2.x
  PUT FileNum, , Temp

  Row = 0                                   'write this in Row 1
  DO
     CALL WriteLabel(Row, 0, 16, "This is a Label")
     CALL WriteLabel(Row, 1, 12, "So is this")
     CALL WriteInteger(Row, 2, 7, 12345)
     CALL WriteNumber(Row, 3, 9, "C2", 57.23#)
     CALL WriteNumber(Row, 4, 9, "F5", 12.3456789#)
     CALL WriteInteger(Row, 6, 9, 99)       'skip a column for fun
     Row = Row + 1                          'go on to the next row
  LOOP WHILE Row < 6

  '----- Write the End of File record and close the file
  Temp = 1                                  'Opcode for End of File
  PUT FileNum, , Temp
  Temp = 0                                  'the data length is zero
  PUT FileNum, , Temp
  CLOSE

END IF
END

SUB GetFormat (Format, Row, Column) STATIC
  GET FileNum, , CellFmt$: Format = ASC(CellFmt$)
  GET FileNum, , Column
  GET FileNum, , Row
END SUB

SUB WriteColWidth (Column, ColWidth) STATIC

  '----- allow a column width only once for each column
  IF NOT ColNum(Column) THEN
    Temp = 8
    PUT FileNum, , Temp
    Temp = 3
    PUT FileNum, , Temp
    PUT FileNum, , Column
    Temp$ = CHR$(ColWidth)
    PUT FileNum, , Temp$
    '----- show we wrote this column's width
    ColNum(Column) = -1
  END IF

END SUB

SUB WriteInteger (Row, Column, ColWidth, Integ) STATIC

  Temp = 13                                 'OpCode for an integer
  PUT FileNum, , Temp
  Temp = 7                                  'Length + 5 byte header
  PUT FileNum, , Temp
  Temp$ = CHR$(127)                         'the format portion
  PUT FileNum, , Temp$
  PUT FileNum, , Column
  PUT FileNum, , Row
  PUT FileNum, , Integ
  CALL WriteColWidth(Column, ColWidth)

END SUB

SUB WriteLabel (Row, Column, ColWidth, Msg$)

  IF LEN(Msg$) > 240 THEN                   '240 is the maximum length
    Msg$ = LEFT$(Msg$, 240)
  END IF

  Temp = 15                                 'OpCode for a label
  PUT FileNum, , Temp
  Temp = LEN(Msg$) + 7                      'Length plus 5-byte header
                                            'plus "'" plus CHR$(0)
  PUT FileNum, , Temp
  Temp$ = CHR$(127)                         '127 is the default format
  PUT FileNum, , Temp$
  PUT FileNum, , Column
  PUT FileNum, , Row
  Temp$ = "'" + Msg$ + CHR$(0)              'a "'" left-aligns a label
                                            'use "^" instead to center
  PUT FileNum, , Temp$
  CALL WriteColWidth(Column, ColWidth)

END SUB

SUB WriteNumber (Row, Col, ColWidth, Fmt$, Num#) STATIC

  IF LEFT$(Fmt$, 1) = "F" THEN                    'fixed
    '----- specify the number of decimal places
     Format$ = CHR$(0 + VAL(RIGHT$(Fmt$, 1)))
  ELSEIF LEFT$(Fmt$, 1) = "C" THEN                'currency
     Format$ = CHR$(32 + VAL(RIGHT$(Fmt$, 1)))
  ELSEIF LEFT$(Fmt$, 1) = "P" THEN                'percent
     Format$ = CHR$(48 + VAL(RIGHT$(Fmt$, 1)))
  ELSE                                            'default
     Format$ = CHR$(127)                    'use CHR$(255) for protected
  END IF

  Temp = 14                                 'Opcode for a number
  PUT FileNum, , Temp
  Temp = 13                                 'Length (8) + 5 = 13
  PUT FileNum, , Temp

  PUT FileNum, , Format$
  PUT FileNum, , Col
  PUT FileNum, , Row
  PUT FileNum, , Num#

  CALL WriteColWidth(Column, ColWidth)

END SUB
