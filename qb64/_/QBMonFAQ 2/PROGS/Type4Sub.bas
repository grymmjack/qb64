'***************************************************************************
' TYPE4SUB.BAS = Anwenderdefiniertes Feld (TYPE..END TYPE) an SUB uebergeben
' ============
' Dieses QBasic-Programm demonstriert, wie man ein mit TYPE...END TYPE
' deklariertes anwenderdefiniertes Feld an eine SUB oder FUNCTION uebergeben
' kann. Dazu gehst Du wie folgt vor:
' - Im Unterprogramm musst Du das Anwenderdefinierte Feld in der
'   Parameter-Klammer mit "feldname() AS feldtyp" angeben.
' - Bei der SUB-Deklaration am Anfang des Hauptprogramms erfolgt die
'   Angabe das Anwedenderdefinierten Feldes in der Parameterklammer
'   mit "feldname() AS ANY" (wird von QB automatisch eingefügt)
' - Beim Aufruf der SUB im Hauptprogramm wird der Name des
'   Anwenderdefinierten Feldes gefolgt von leeren Klammern angegeben
'   ( "feldname()" )
'
' (c) Thomas Antoni, 1.6.2004
'***************************************************************************
DECLARE SUB Upro (anwenderfeld() AS ANY)
'
TYPE quiz 'Typdeklaration
frage AS STRING * 70
antw1 AS STRING * 50
antw2 AS STRING * 50
antw3 AS STRING * 50
oknr AS INTEGER
END TYPE
'
DIM anwenderfeld(13) AS quiz 'Deklaration d. Anwenderdef.Feldes
'
CALL Upro(anwenderfeld())    'Aufruf der SUB
PRINT anwenderfeld(3).oknr   'Es wird die von Upro eingetragene 2 angezeigt
SLEEP

'***************** Unterprogramm Upro ***************************************
SUB Upro (anwenderfeld() AS quiz)
anwenderfeld(3).oknr = 2
END SUB

