'****************************************************************************
' xKey.bas = Tastenauswertung direkt mit dem INP-Befehl ohne INPUT u.INKEX$
' ========
' Dieses Programm demonstriert die Tastatur-Direkt-Eingabe.
' Es greift direkt auf den Tastaurpuffer zu und erkennt in Echtzeit, ob
' eine oder mehrere Taste gedrueckt werden oder nicht. Es erkennt auch
' Sondertasten wie Alt und Strg. Ausserdem erfolgt eine Anzeige des
' Tastatur-Abfragecodes der gerade gedrueckten Taste(n). Dieser Code
' kann fuer den Befehl INP(&H60) verwendet werden. Das Programm arbeitet
' ganz ohne Assembler.
'
' Die Tastatur-Abfragecodes ("Scancodes") der einzelnen Tasten gehen auch
' aus der QBasic-Onlinehilfe hervor und sind dort aufgelistet unter
' "Inhalt | Tastatur-Abfragecodes"
'
' Wichtig!!!! [NumLock] muss AUS sein, da es sonst zu Problemen mit den
' Cursortasten kommt.
'
' Autor : Soeren Dressler
' eMail : soeren01*t-online.de
' WWW   : http://qmystic.xxn.de
'
'****************************************************************************
DIM SHARED xkey%(128)
DIM SHARED tasten AS STRING * 300
'
CLS
DO   ' Routine zum Ermitteln der Tasten
        ii% = i%
        i% = INP(&H60)
        IF ii% <> i% AND i% < 128 THEN xkey%(i%) = -1
        IF ii% <> i% AND i% >= 128 THEN xkey%(i% - 128) = 0
        ' Das war's schon
        ' Ausgabe der Tasten
        tasten$ = ""
        FOR n% = 1 TO 128
        IF xkey%(n%) = -1 THEN MID$(tasten$, n% * 3, 3) = STR$(n%)
        NEXT
        LOCATE 1, 1
        PRINT tasten$
'
' Verlasse Schleife wenn ESC gedrueckt wird und leere den Tastaturpuffer,
' um dessen Ieberlauf und das nervige Piepsen zu vermeiden. Das tut der
' INP-Befehl nicht.
LOOP UNTIL INKEY$ = CHR$(27)


