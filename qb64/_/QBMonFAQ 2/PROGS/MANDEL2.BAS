'********************************************************
' MANDEL2.BAS - Erstellen einer Mandelbrotbaumgrafik
' ===========
' Das Aussehen der Grafik laesst sich mit der Maus und
' mit folgenden Tasten veraendern:
' - Hoch, Runter  - Zoomen (Groesse d. Grafik veraendern)
' - Rechts, Links - Farbverschiebung und Aufloesung
' - b             - Abbruch des Zeichnens
' - Esc           - Abbruch des Programms
'
' (c) Tomtitom, 8.12.03 - 3.4.04
'       Thomas.Sperling*gmx.net
'       http://de.geocities.com/qbreise
'********************************************************
'
'-------- Deklarationen ---------------------------------
DECLARE SUB viereck (x1%, y1%, x2%, y2%)
DECLARE SUB man ()
DECLARE SUB maus ()
DECLARE SUB mreset ()
DECLARE SUB mstatus (lmb%, rmb%, mmb%, x%, y%)
DECLARE FUNCTION MX% ()
DECLARE FUNCTION MY% ()
DECLARE FUNCTION MTaste% (Nr%)
'
DEFINT L-M, R
DEFDBL A-B, S, X-Y
'
TYPE RegType
AX AS INTEGER
BX AS INTEGER
CX AS INTEGER
DX AS INTEGER
bp AS INTEGER
si AS INTEGER
flags AS INTEGER
ds AS INTEGER
es AS INTEGER
END TYPE
'
DIM SHARED Regs AS RegType
DIM mm1(100)
z = .2          'Zoomfaktor also 1:0,2 -> 5x Zoom
xrand = -2.2    'Koordinaten fr die
yrand = -1.752  'Mandelbrotbaumgrafik
seite = 3.5     'Groesse des Ausschnitts (haengt mit Zoom zusammen)
'
'-------- Hauptprogramm -------------------------------------
SCREEN 13
mreset
CLS 'Anfangsk„stchen fuer die Maus erstellen
LINE (0, 0)-(10, 10), 15, B
GET (0, 0)-(10, 10), mm1
CLS
'
FOR i = 0 TO 30 'Palette von schwarz ueber gelb, rot und gruen bis blau
  PALETTE i, 256 * i * 2 + i * 2
NEXT
FOR i = 0 TO 30
  PALETTE i + 30, 60 + 256 * 60 - i * 256 * 2
NEXT
FOR i = 0 TO 30
  PALETTE i + 60, 60 - i * 2 + 256 * 2 * i
NEXT
FOR i = 0 TO 30
  PALETTE i + 90, 256 * 60 - 256 * 2 * i + 65536 * 2 * i
NEXT
'
DO 'Hauptschleife
FOR i = 0 TO 319 'Zeichnen der Mandelbrotbaumgrafik
  a = xrand + (seite * (i / 319))
  FOR j = 0 TO 199
    b = yrand + (seite * (j / 199))
    x = 0: y = 0: y2 = 0: x2 = 0
    zaehler = 0
    DO
      y = 2 * x * y + b: x = x2 - y2 + a
      x2 = x ^ 2: y2 = y ^ 2
      zaehler = zaehler + 1
      aa$ = INKEY$
      SELECT CASE aa$
        CASE CHR$(27): END          'Programm beenden
        CASE "b": i = 320: j = 200  'Vorgang abbrechen
      END SELECT
    LOOP UNTIL ((x2 + y2) > 10) OR (zaehler = 120 + r)
    IF zaehler < 120 + r THEN PSET (i, 199 - j), zaehler
  NEXT
NEXT
'
DO 'Auswertung von Tastatur oder Mauseingabe
mstatus lmb, rmb, mmb, MX, MY
IF mmx <> MX OR mmy <> MY THEN
  IF index = 1 THEN
    viereck mmx - .5 * 319 * z, mmy - .5 * 199 * z, mmx + .5 * 319 * z, mmy + .5 * 199 * z
  END IF
  viereck MX - .5 * 319 * z, MY - .5 * 199 * z, MX + .5 * 319 * z, MY + .5 * 199 * z
  mmx = MX: mmy = MY
  index = 1
END IF
'
IF lmb <> 0 THEN
  myy = 199 - MY
  xrand = xrand + (MX / 319) * seite - z * .5 * seite
  yrand = yrand + (myy / 199) * seite - z * .5 * seite
  seite = seite * z
  index = 0
  EXIT DO
END IF
a$ = INKEY$
'
SELECT CASE a$
  CASE CHR$(0) + CHR$(72)
    viereck mmx - .5 * 319 * z, mmy - .5 * 199 * z, mmx + .5 * 319 * z, mmy + .5 * 199 * z
    z = z - .01
    IF z < .01 THEN z = .01
    viereck MX - .5 * 319 * z, MY - .5 * 199 * z, MX + .5 * 319 * z, MY + .5 * 199 * z
'
  CASE CHR$(0) + CHR$(80)
    viereck mmx - .5 * 319 * z, mmy - .5 * 199 * z, mmx + .5 * 319 * z, mmy + .5 * 199 * z
    z = z + .01
    IF z > 2 THEN z = 2
    viereck MX - .5 * 319 * z, MY - .5 * 199 * z, MX + .5 * 319 * z, MY + .5 * 199 * z
'
  CASE CHR$(0) + CHR$(75)
    IF r > 0 THEN r = r - 1
    FOR i = 0 TO 30
      PALETTE i + r, 256 * i * 2 + i * 2
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 30 + r, 60 + 256 * 60 - i * 256 * 2
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 60 + r, 60 - i * 2 + 256 * 2 * i
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 90 + r, 256 * 60 - 256 * 2 * i + 65536 * 2 * i
    NEXT
'
  CASE CHR$(0) + CHR$(77)
    IF r < 120 THEN r = r + 1
    FOR i = 0 TO 30
      PALETTE i + r, 256 * i * 2 + i * 2
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 30 + r, 60 + 256 * 60 - i * 256 * 2
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 60 + r, 60 - i * 2 + 256 * 2 * i
    NEXT
    FOR i = 0 TO 30
      PALETTE i + 90 + r, 256 * 60 - 256 * 2 * i + 65536 * 2 * i
    NEXT
'
  CASE CHR$(27): END
END SELECT
'
LOOP
maus
CLS
'
LOOP

DEFINT A-K, N-Q, S-Z
'
SUB man
'----- Maus anschalten
Regs.AX = 1
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB maus
'----- Maus ausschalten
Regs.AX = 2
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB mreset
'----- Maus neustarten?
Regs.AX = 0
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB mstatus (lmb, rmb, mmb, x, y)
'----- alles abfragen
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
lmb = Regs.BX AND 1
rmb = (Regs.BX AND 2) \ 2
mmb = (Regs.BX AND 4) \ 4
y = Regs.DX
x = Regs.CX / 2
END SUB

'
FUNCTION MTaste (Nr)
'----- spezielle Taste abfragen
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
MTaste = (Regs.BX AND Nr) * -1
END FUNCTION

'
FUNCTION MX
'----- X-Koordinate der Maus
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
MX = Regs.CX / 2
END FUNCTION

'
FUNCTION MY
'Y-Koordinate der Maus
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
MY = Regs.DX
END FUNCTION

DEFSNG A-Z
SUB viereck (x1%, y1%, x2%, y2%)
'Routine zum Zeichnen des Mausvierecks
'
FOR x% = x1% TO x2%
PSET (x%, y1%), 120 - POINT(x%, y1%)
PSET (x%, y2%), 120 - POINT(x%, y2%)
NEXT
FOR y% = y1% + 1 TO y2% - 1
PSET (x1%, y%), 120 - POINT(x1%, y%)
PSET (x2%, y%), 120 - POINT(x2%, y%)
NEXT
END SUB

