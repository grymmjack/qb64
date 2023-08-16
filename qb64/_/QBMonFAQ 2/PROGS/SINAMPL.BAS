'************************************************
' SINAMPL.BAS - Sinuskurve mit waehlbarer
' ===========   Amplitude und Frequenz anzeigen
'
' (c) Skilltronic (skillfinger*gmx.de), 8.3.2004
'************************************************
CLS
SCREEN 12
pi = 3.141593
INPUT "Amplitude "; amplitude
INPUT "Frequenz "; frequenz
LINE (0, 0)-(0, 479), 15
LINE (0, 240)-(639, 240), 15
FOR xpixel = 0 TO 639 STEP .1
  winkel = 2 * pi * xpixel / 639
y = amplitude * SIN(winkel * frequenz)
ypixel = y * -24 + 240
PSET (xpixel, ypixel), 12
NEXT
SLEEP
END

