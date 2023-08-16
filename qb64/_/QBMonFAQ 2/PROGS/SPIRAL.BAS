'*************************************************************************
'
' SPIRAL.BAS = Zeichnen von Spiralen
' ===========
' QBasic-Programm zum Zeichnen von Spiralen
'
' (c) Andreas Meile, CH-8242 Hofen SH  (qbasicde*dreael.ch)
'*************************************************************************
' Kreiskonstante ã
Pi! = 4! * ATN(1!)
'
SCREEN 12
DO
  COLOR 7
  CLS
  PRINT "Bitte Art der Spirale ausw„hlen:"
  PRINT "1.) archimedische Spirale"
  PRINT "2.) logarithmische Spirale"
  PRINT "3.) Evolvente"
  PRINT "4.) Programmende"
  DO
    INPUT "Ihre Wahl:"; auswahl%
  LOOP UNTIL auswahl% >= 1 AND auswahl% <= 4
  SELECT CASE auswahl%
  CASE 1
    ' Archimedische Spirale
    DO
      INPUT "Steigung in Pixel"; s!
    LOOP UNTIL s! > 0!
    aSeg% = CINT(20! + 15000! / s!)
    rSchritt! = 235! / CSNG(aSeg%)
    wSchritt! = rSchritt! * 2! * Pi! / s!
    w0! = 100! * 2! * Pi! / s!
    COLOR 12
    ' Fadenkreuz darstellen
    LINE (0, 240)-(649, 240)
    LINE (320, 0)-(320, 479)
    ' Mass darstellen
    LOCATE 13, 53: PRINT s!; "Pixel"
    LINE (420, 240)-STEP(0, -30)
    LINE STEP(0, 3)-STEP(6, -3)
    LINE -STEP(0, 6)
    LINE -STEP(-6, -3)
    LINE -STEP(CINT(s!), 0)
    LINE -STEP(-6, -3)
    LINE -STEP(0, 6)
    LINE -STEP(6, -3)
    LINE STEP(0, -3)-STEP(0, 30)
    ' eigentliche Spiralenkurve zeichnen
    COLOR 15
    PSET (320, 240)
    FOR i% = 1 TO aSeg%
      r! = CSNG(i%) * rSchritt!
      w! = CSNG(i%) * wSchritt! - w0!
      LINE -(320! + r! * COS(w!), 240! - r! * SIN(w!))
    NEXT i%
    d$ = INPUT$(1)
  CASE 2
    ' Logarithmische Spirale
    DO
      INPUT "Steigungswinkel in ø"; wStGrad!
    LOOP UNTIL wStGrad! > 0! AND wStGrad! < 90!
    COLOR 12
    wSt! = wStGrad! * Pi! / 180!  ' in Radiant umrechnen
    aSeg% = CINT(40! + 250! / TAN(wSt!))
    rSchritt! = LOG(235! / .1) / CSNG(aSeg%)
    wSchritt! = rSchritt! / TAN(wSt!)
    w0! = LOG(100! / .1) / TAN(wSt!)
    ' Fadenkreuz darstellen
    COLOR 12
    LINE (0, 240)-(649, 240)
    LINE (320, 0)-(320, 479)
    LOCATE 11, 53: PRINT wStGrad!; "ø"
    LINE (420, 240)-STEP(0, -60)
    LINE (420, 240)-STEP(60! * SIN(wSt!), -60! * COS(wSt!))
    CIRCLE (420, 240), 55, , Pi! / 2! - wSt!, Pi! / 2!, 1!
    ' eigentliche Spiralenkurve zeichnen
    COLOR 15
    PSET (320, 240)
    FOR i% = 1 TO aSeg%
      w! = CSNG(i%) * wSchritt! - w0!
      r! = .1 * EXP(CSNG(i%) * rSchritt!)
      LINE -(320! + r! * COS(w!), 240! - r! * SIN(w!))
    NEXT i%
    d$ = INPUT$(1)
  CASE 3
    ' Evolvente
    DO
      INPUT "Durchmesser des Zylinders in Pixel"; d!
    LOOP UNTIL d! > 0! AND d! < 470!
    r! = d! / 2!
    ' Fadenkreuz darstellen
    COLOR 12
    LINE (0, 240)-(649, 240)
    LINE (320, 0)-(320, 479)
    LOCATE 13, 42: PRINT d!; "Pixel"
    ' Zylinder und Abwickellinien
    COLOR 9
    CIRCLE (320, 240), r!, , , , 1!
    aSeg% = CINT(12! + r! / 10!)
    wSchritt! = 2! * Pi! / CSNG(aSeg%)
    l! = SQR(238! ^ 2! - r! ^ 2!)
    FOR i% = 0 TO aSeg% - 1
      w! = CSNG(i%) * wSchritt!
      x! = 320! + r! * COS(w!)
      y! = 240! - r! * SIN(w!)
      LINE (x!, y!)-(x! + l! * SIN(w!), y! + l! * COS(w!))
    NEXT i%
    ' Mass in der Mitte
    COLOR 12
    LINE (320 - CINT(r!), 240)-STEP(0, -30)
    LINE STEP(0, 3)-STEP(6, -3)
    LINE -STEP(0, 6)
    LINE -STEP(-6, -3)
    LINE -STEP(CINT(r!) * 2, 0)
    LINE -STEP(-6, -3)
    LINE -STEP(0, 6)
    LINE -STEP(6, -3)
    LINE STEP(0, -3)-STEP(0, 30)
    ' eigentliche Evolventenkurve zeichnen
    aSeg% = CINT(20! + 10000! / d!)
    wSchritt! = SQR(235! ^ 2! - r! ^ 2!) / r! / CSNG(aSeg%)
    COLOR 15
    PSET (320! + r!, 240!)
    FOR i% = 1 TO aSeg%
      w! = CSNG(i%) * wSchritt!
      rx! = r! * COS(w!)
      ry! = r! * SIN(w!)
      LINE -(320! + rx! + w! * ry!, 240! - ry! + w! * rx!)
    NEXT i%
    d$ = INPUT$(1)
  END SELECT
LOOP UNTIL auswahl% = 4
SCREEN 0
WIDTH 80, 25

