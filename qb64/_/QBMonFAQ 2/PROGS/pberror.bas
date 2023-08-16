'**************************************************************
' PBERROR.BAS - PowerBASIC-Programm mit Fehlerbearbeitung
' ===========
' Dieses Programm demonstriert, wie man bei PowerBASIC mit
' $ERROR ALL ON die Fehlerbearbeitung aktiviert und mit
' ON ERROR GOTO...RESUME auftretende Fehler abfaengt und
' bearbeitet. Der Metabefehl $ERROR...ON ist nur bei
' PB, nicht bei QB erforderlich.
'
' Dieses  Beispielprogramm berechnet die Fakultaet n! =
' 1 * 2 * 3 *...*(n-1) * n der eingegebenen Zahl n. Fuer
' n wird das EXTended 80-Bit-Gleitpunktformat verwendet,
' das nur in PB, nicht in QB zur Verfuegung steht. Beim
' Eingabewert n = 5000 tritt ein Zahlnueberlauf-Fehler auf.
' Die Fehlerbearbeitung faengt diesen ab und fordert eine
' Neueingabe an.
'
' (c) Thomas Antoni, 24.7.2003 - 28.1.2006  
'**************************************************************
$ERROR ALL ON 'alle Fehlerüberwachungen aktivieren
on error goto fehler
cls
neu:
do
input "n=", n##
fak##=1
for i## =1 to n##
  fak##=fak## * i##
next i##
print "n!="; fak##
do: t$=inkey$: loop while t$ =""
if t$=chr$(27) then end
loop
'
fehler:
print "Ueberlauf"
resume neu
