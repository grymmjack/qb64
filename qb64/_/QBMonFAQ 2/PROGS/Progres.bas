'***************************************************************************
' PROGRES.BAS = QBasic-Programm zur Erzeugung eines Fortschrittbalkens
' ===========
' (Demonstration der SUB  ProgressBar)
'
'
'   \         (c) Thomas Antoni, 30.05.99
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'***************************************************************************
DECLARE SUB ProgressBar (prozent%)
'
COLOR 0, 7
CLS
FOR p% = 0 TO 100
  CALL ProgressBar(p%)
  zeit = TIMER: WHILE TIMER < zeit + .05: WEND   'Wartezeit ca. 0.05 sec
  IF INKEY$ = CHR$(27) THEN END                  'Abbruch mit Esc-Taste
NEXT p%
WHILE INKEY$ = "": WEND
END
'
SUB ProgressBar (prozent%)
'***************************************************************************
' Subroutine ProgressBar
' ----------------------
' Gibt einen Fortschrittsbalken in Zeile 24,25 aus, deren L„nge durch den
' Uebergabeparameter prozent% (0...100) vorgegeben wird (je 2% =ein Zeichen).
' Vor der erstmaligen Nutzung des Progess Bars muá die Subroutine mit dem
' Aufruf ProgressBar(0) initialisiert werden.
'
' Die Cursorposition wird durch die SUB nicht ver„ndert: Die vor dem Aufruf
' der SUB bestehende Cursorposition wird abgespeichert und vor Verlassen der
' SUB wieder restauriert.
'
' Der Progress Bar ben”tigt nur 2 Bildschirmzeilen, ist also sehr platz-
' sparend!
'
' (c) T.Antoni, 10.5.99 -17.05.99
'***************************************************************************
'
zeile% = CSRLIN                    'Cursorsposition abspeichern (merken)
spalte% = POS(0)
'
IF prozent% = 0 THEN               'Fortschrittsbalken initialisieren
  LOCATE 24, 1
  COLOR 15, 4                      'weiá auf rot
  PRINT " Berechne... "; STRING$(50, "Ü"); "  Abbruch: Esc   ";
  LOCATE 25, 1
  PRINT "             "; STRING$(50, "ß"); "                 ";
ELSE
  COLOR 2, 4
  IF prozent% >= 100 THEN prozent% = 99
  balkenlaenge% = INT(prozent% / 2) + 1
  LOCATE 24, 14
  PRINT STRING$(balkenlaenge%, "Ü");
  LOCATE 25, 14
  PRINT STRING$(balkenlaenge%, "ß");
END IF
'
LOCATE zeile%, spalte%             'alte Cursorsposition restaurieren
COLOR 0, 7                         'alte Farbe ebenso (sw auf hellgrau)
END SUB

