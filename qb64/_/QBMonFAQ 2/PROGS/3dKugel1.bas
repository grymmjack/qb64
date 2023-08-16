'**************************************************************************
' 3DKUGEL1.BAS = Zeigt 3D-Kugeln an
' ============
' Dieses QBasic-Programm zeigt nacheinander verschiedene dreidimensionale
' Kugeln mit zufaelliger Farbe an zufaelliger Stelle und mit zufaelligem
' Radius an.
' (c) Skilltronik, 3.3.2005
'**************************************************************************
SCREEN 12
WIDTH , 60'60 Textzeilen
PRINT
PRINT " Anzeige von 3d-Kugeln - Abbruch mit Esc-Taste"
pi = 3.141593
wla = 2
wlb = -.5
RANDOMIZE TIMER
GOSUB farben
DO
 DO
  r = FIX(RND ^ 2 * 30) + 5
  st = 1 / r
  xe = RND * 640
  ye = RND * 480
  FOR wa = 0 TO pi STEP st
   da = ABS(wa - wla)
   FOR wb = -pi / 2 TO pi / 2 STEP st
    db = ABS(wb - wlb)
    dw = SQR(da ^ 2 + db ^ 2)
    IF dw >= pi / 2 THEN f = 0: GOTO schwarz
    f = 15 - FIX(dw / (pi / 32))
schwarz:
    y = SIN(wb) * r + ye
    xr = COS(wb) * r
    x = COS(wa) * xr + xe
    PSET (x, y), f
   NEXT
  NEXT
  t$ = INKEY$
 LOOP WHILE t$ = ""
 IF ASC(t$) = 27 THEN END ELSE GOSUB farben
LOOP
'
farben:
ra = RND * 4
rb = RND * 4
rc = RND * 4
FOR a = 0 TO 15
 OUT 968, a
 OUT 969, a * ra
 OUT 969, a * rb
 OUT 969, a * rc
NEXT
RETURN

