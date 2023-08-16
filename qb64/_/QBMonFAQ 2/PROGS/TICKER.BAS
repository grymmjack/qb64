'************************************************************
' TICKER.BAS - Text-Ticker - weich eingeblendeter Lauftext
' ==========   in SREEN 13
' Weich eingeblendeter farbigen Text-Ticker im
' Grafikscreen 13
'
' Erklaerung der Subs und Variablen:
' ------------------------------------
' InitDelay ==> Diese Sub initialisiert Die Delay-Sub
' Delay     ==> Das is die Pausenfunktion, Del& gibt die
'               Dauer der Pause in Sek. an.
' HighLight ==> Das is die Hauptfunktion des Text-Tickers.
'               Zu den Variablen:
' Text$     ==> Hier kommt der Text hin.
' Row%      ==> Hier kommt hin in welche
'               Zeile der Text soll.
' Column%   ==> Und hier in welche Spalte.
' ColType%  ==> Dies gibt den Farbtyp an:
'                 1 = Rot
'                 2 = Gruen
'                 3 = Blau
' Speed#    ==> Dauer der Pause in Sek.
'
' (c) ZaPPa aKa David Wosnitza von DC-WARE SoftLoad
'     ( dc-ware*onlinehome.de )
'************************************************************
DECLARE SUB Delay (Del#)
DECLARE SUB HighLight (Text$, Row%, Column%, ColType%, Speed#)
COMMON SHARED Idel AS LONG
ON TIMER(1) GOSUB Test
TIMER ON
WHILE t% = 0: Idel = Idel + 1: WEND
TIMER OFF
GOTO weiter
Test:
t% = 1
RETURN
weiter:
SCREEN 13
CLS
A$ = "Hallo! Das ist ein Test!"
CALL HighLight(A$, 10, 4, 3, .0005)

'
SUB Delay (Del#)
DO: tim& = tim& + 1: LOOP UNTIL tim& >= Idel * Del#
END SUB

'
SUB HighLight (Text$, Row%, Column%, ColType%, Speed#)
IF ColType% < 1 OR ColType% > 3 THEN
  PRINT "Farbtyp nicht Vorhanden! Abbruch."
  SYSTEM
END IF
FOR l = 1 TO LEN(Text$)
  PALETTE l, 0
  LOCATE Row%, Column% + l: COLOR l: PRINT MID$(Text$, l, 1)
NEXT
FOR l = 1 TO LEN(Text$)
  FOR q = 0 TO 63
    Delay Speed#
      IF ColType% = 1 THEN Col& = q
      IF ColType% = 2 THEN Col& = 256 * q
      IF ColType% = 3 THEN Col& = 65536 * q
      PALETTE l, Col&
  NEXT
NEXT
PALETTE
END SUB