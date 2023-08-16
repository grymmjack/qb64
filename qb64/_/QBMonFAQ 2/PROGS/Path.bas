'****************************************************************************
' PATH.BAS = QBasic-Programm zum Ermitteln des aktuellen Pfadnamens
' ========================================================================
' Der aktuelle Pfadname wird ermittelt und in die Variable pfad$ eingetragen.
'
' Mit Hilfe des DOS-Befehls "CD"  ('Change Directory' ohne Uebergabeparameter)
' wird der aktuelle Pfad ermittelt. Die Ausgabeumleitung "> x.txt" bewirkt,
' daá der Pfadname in die Datei "x.txt" statt auf den Bildschirm ausgegeben
' wird. Der Pfadname wird mit INPUT aus der Datei ausgelesen und in die
' Variable Pfad eingetragen.
' Anschlieáend kann die Datei x.txt mit KILL wieder geloescht werden.
'
'
'   \         (c) Thomas Antoni, 29.10.99
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************

CLS
SHELL "cd > x.txt"              'aktuellen Pfad mit DOS-Befehl CD erfragen u.
                                'per Ausgabeumleitung in Datei x.txt eintragen
OPEN "x.txt" FOR INPUT AS #1    'sequentielle Datei x.txt zum Lesen oeffnen
INPUT #1, pfad$                 'Inhalt von x.,txt in pfad$ eintragen
CLOSE #1
KILL "x.txt"                    'x.txt wieder loeschen
PRINT "aktueller Pfad: "; pfad$
SLEEP
END

