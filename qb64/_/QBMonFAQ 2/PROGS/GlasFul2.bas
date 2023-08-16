'****************************************************************************
' GLASFUL2.BAS = Animiertes Befuellen eines Glases
' ============
' Dieses QBasic-Programm demonstriert die animierte Grafikanzeige des
' Befuellens eines Glases mit gelber Apfelsaftschorle,
' Grafisch nicht aufwendig, aber einfach.
'
' (c) Sebastian Steiner, 25.12.04
'***************************************************************************
SCREEN 9, , 0, 1
fuellstand% = 0
DO
 fuellstand% = fuellstand% + 1
 GOSUB GlasZeichnen
 GOSUB SaftAnzeigen
 GOSUB Eichstriche
 PCOPY 0, 1
 GOSUB Warten
LOOP
SLEEP
END
'
GlasZeichnen:
        LINE (0, 0)-(640, 350), 0, BF
        LINE (220, 20)-(420, 330), 7, B
        LINE (221, 20)-(419, 20), 0
        RETURN
'
Eichstriche:
        FOR i% = 50 TO 320 STEP 20
         LINE (220, i%)-(240, i%), 7
        NEXT i%
        RETURN
'
SaftAnzeigen:
        G% = 308
        EinProzent% = G% / 100
        FuellHoehe% = FIX(CSNG(EinProzent% * fuellstand%))
        LINE (221, G% - FuellHoehe%)-(419, 329), 14, BF
        IF G% - FuellHoehe% < 21 THEN
         SOUND 200, 1
         SOUND 500, 1
         SOUND 200, 1
         SOUND 500, 1
         SLEEP: END
        END IF
        RETURN
'
Warten:
        t! = TIMER
        DO: LOOP UNTIL TIMER > t! + .05
        RETURN

