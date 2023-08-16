'*********************************************************
' BEWEG2.BAS = Einen Sprite ueber den Bildschirm bewegen
' ===========
' Dieses QBasic-Programm demonstriert, wie man eine
' Grafikfigur (Sprite) mit den Cursor-Tasten flimmer- und
' ruckelfrei ueber den Bildschirm bewegen kann.
'
' (c) Andreas Meile (qbasicde*dreael.ch), 9.5.2004
'*********************************************************
DECLARE FUNCTION Polarwinkel! (x!, y!)
DECLARE SUB engine ()
DECLARE SUB viereck ()
DECLARE SUB hinter ()

DIM SHARED sprite%(715), sprAnd%(715), Pi!
Pi! = 4! * ATN(1!)

SCREEN 7, , 2
hinter
SCREEN 7, , 1, 0
viereck

engine

' Beenden
SCREEN 0
WIDTH 80, 25

SUB engine
  x% = 100
  y% = 100
  speed% = 1

  DO
    PCOPY 2, 1
    PUT (x%, y%), sprAnd%, AND
    PUT (x%, y%), sprite%, XOR
    PCOPY 1, 0
 
    DO
      t$ = INKEY$
    LOOP UNTIL t$ <> ""
    SELECT CASE t$
    CASE CHR$(0) + "H"
      y% = y% - speed%
      IF y% < 0 THEN
        y% = 0
      END IF
    CASE CHR$(0) + "K"
      x% = x% - speed%
      IF x% < 0 THEN
        x% = 0
      END IF
    CASE CHR$(0) + "M"
      x% = x% + speed%
      IF x% + 51 > 319 THEN
        x% = 319 - 51
      END IF
    CASE CHR$(0) + "P"
      y% = y% + speed%
      IF y% + 51 > 199 THEN
        y% = 199 - 51
      END IF
    END SELECT
  LOOP UNTIL t$ = CHR$(27)
END SUB

SUB hinter
  LINE (0, 0)-(320, 200), 5, BF
  ' Erg„nzung dreael: Etwas mehr "Action" :-)
  FOR i% = 1 TO 200
    f% = CINT(INT(16! * RND))
    IF f% <> 5 THEN
      LINE (320! * RND, 200! * RND)-(320! * RND, 200! * RND), f%
    END IF
  NEXT i%
END SUB

FUNCTION Polarwinkel! (x!, y!)
  IF y! = 0! THEN
    IF x! > 0! THEN
      Polarwinkel! = 0!
    ELSE
      Polarwinkel! = Pi!
    END IF
  ELSE
    IF y! > 0! THEN
      Polarwinkel! = Pi! / 2! - ATN(x! / y!)
    ELSE
      Polarwinkel! = 1.5 * Pi! - ATN(x! / y!)
    END IF
  END IF
END FUNCTION

SUB viereck
  ' Žnderung dreael: Etwas interessanteres Sprite... :-)
  Pi! = 4! * ATN(1!)
  FOR y% = 0 TO 50
    y! = CSNG(y% - 25)
    FOR x% = 0 TO 50
      x! = CSNG(x% - 25)
      d! = SQR(x! * x! + y! * y!)
      IF d! > 14.5 AND d! < 25.5 THEN
        w! = Polarwinkel(x!, y!)
        PSET (x%, y%), CINT(INT(w! * 16! / 2! / Pi!))
        PSET (x% + 51, y%), 0
      ELSE
        PSET (x%, y%), 0
        PSET (x% + 51, y%), 15
      END IF
    NEXT x%
  NEXT y%
  GET (0, 0)-(50, 50), sprite%
  GET (51, 0)-STEP(50, 50), sprAnd%
END SUB

