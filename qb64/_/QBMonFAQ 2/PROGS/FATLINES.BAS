'***************************************************************************
' FATLINES.BAS - Draws a fat line from (x1|y1) to (x2|y2) with color c and
' ============   thickness t
'                Zeichnet eine dicke Linie von (x1|y1) nach (x2|y2) mit der
'                Farbe c und der Dicke t. Die dicke Linie wird aus mehreren
'                normalen Linien zusammengesetzt.
'
'===========================================================================
' Subject: FAT LINES                         Date: 08-06-99 (20:08)     
' Author:  Marius Andra                      Code: QB, QBasic, PDS      
' Origin:  marius.andra*mail.ee            Packet: GRAPHICS.ABC
'***************************************************************************
DECLARE SUB fline (x1!, y1!, x2!, y2!, c!, t!)
'
SCREEN 12
'
'---- Draw a red house (c=12) with a blue roof (c=9), thickness t=8
CALL fline(20, 200, 20, 460, 12, 8)
CALL fline(20, 460, 619, 460, 12, 8)
CALL fline(619, 460, 619, 200, 12, 8)
CALL fline(619, 200, 320, 100, 9, 8)
CALL fline(320, 100, 20, 200, 9, 8)

'
SUB fline (x1, y1, x2, y2, c, t)
LINE (x1, y1)-(x2, y2), c
IF t = 0 THEN EXIT SUB
r = INSTR(STR$(t), ".")
SELECT CASE r    'r <> 0 if a decimal point existing
'
'----  the thickness t is an integer number
CASE 0
IF x1 = x2 AND y1 <> y2 THEN          'vertical line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1 - i, y1)-(x2 - i, y2), c
    LINE (x1 + i, y1)-(x2 + i, y2), c
  NEXT i
  LINE (x1 - i, y1)-(x2 - i, y2), c
END IF
'
IF y1 = y2 AND x1 <> x2 THEN          'horizontal line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1, y1 - i)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2, y2 + i), c
  NEXT i
  LINE (x1, y1 - i)-(x2, y2 - i), c
END IF
'
IF x1 < x2 AND y2 > y1 THEN           'falling line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1 + i, y1)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2 - i, y2), c
  NEXT i
  LINE (x1 + i, y1)-(x2, y2 - i), c
END IF
'
IF x2 < x1 AND y2 > y1 THEN           'rising line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1 - i, y1)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2 + i, y2), c
  NEXT i
  LINE (x1 - i, y1)-(x2, y2 - i), c
END IF
'
IF x1 < x2 AND y2 < y1 THEN           'rising line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1, y1 - i)-(x2 - i, y2), c
    LINE (x1 + i, y1)-(x2, y2 + i), c
    NEXT i
    LINE (x1, y1 - i)-(x2 - i, y2), c
END IF
'
IF x2 < x1 AND y2 < y1 THEN           'falling line
  FOR i = 1 TO (t - 1) / 2
    LINE (x1, y1 + i)-(x2 - i, y2), c
    LINE (x1 - i, y1)-(x2, y2 + i), c
  NEXT i
  LINE (x1, y1 + i)-(x2 - i, y2), c
END IF
'
'---- the thickness t is a floating point number
CASE ELSE
IF x1 = x2 AND y1 <> y2 THEN
  FOR i = 1 TO t / 2
    LINE (x1 - i, y1)-(x2 - i, y2), c
    LINE (x1 + i, y1)-(x2 + i, y2), c
  NEXT i
END IF
'
IF y1 = y2 AND x1 <> x2 THEN
  FOR i = 1 TO t / 2
    LINE (x1, y1 - i)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2, y2 + i), c
  NEXT i
END IF
'
IF x1 < x2 AND y2 > y1 THEN
  FOR i = 1 TO t / 2
    LINE (x1 + i, y1)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2 - i, y2), c
  NEXT i
END IF
'
IF x2 < x1 AND y2 > y1 THEN
  FOR i = 1 TO t / 2
    LINE (x1 - i, y1)-(x2, y2 - i), c
    LINE (x1, y1 + i)-(x2 + i, y2), c
  NEXT i
END IF
'
IF x1 < x2 AND y2 < y1 THEN
  FOR i = 1 TO t / 2
    LINE (x1, y1 - i)-(x2 - i, y2), c
    LINE (x1 + i, y1)-(x2, y2 + i), c
  NEXT i
END IF
'
IF x2 < x1 AND y2 < y1 THEN
  FOR i = 1 TO t / 2
    LINE (x1, y1 + i)-(x2 - i, y2), c
    LINE (x1 - i, y1)-(x2, y2 + i), c
  NEXT i
END IF
END SELECT
END SUB

