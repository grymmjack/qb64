'****************************************************************
' DOSSORT.BAS = Sortieren mit Hilfe des SORT-Befehls von DOS
' ===========
' Dieses Q(uick)BASIC-Programm nutzt den kaum bekannten Umstand,
' dass MS-DOS und die DOS-Box von Windows ¸ber ein eigenes
' schnelles Sortierprogramm verfuegt, das mit dem DOS-Kommando
' "SORT" aufrufbar ist. DOSSORT.BAS nutzt dieses DOS-Kommando,
' indem es SORT ¸ber den SHELL-Befehl aufruft. Die Idee zu diesem
' Programm entnahm ich dem sehr guten Buch "Das grosse GW-BASIC
' Buch" von H.-J. Bomanns.
'
' (c) Thomas Antoni, 11.3.05 - www.qbasic.de - thomas*antonis.de
'       nach einer Programmidee von Heinz-Josef Bomanns
'****************************************************************
'
CLS
'---- 20 Zufallszahlen zwischen 10 und 99 anzeigen und
'---- in die Datei temp.txt schreiben
PRINT "Unsortierte Zahlen ......... Sortierte Zahlen"
OPEN "tmp.txt" FOR OUTPUT AS #1
RANDOMIZE TIMER
FOR i% = 1 TO 20
  z% = INT(RND * 90) + 10
  PRINT z%
  PRINT #1, z%
NEXT
CLOSE
'
'---- Zahlen sortieren und in Datei tmp.dat schreiben
SHELL "sort tmp.txt > tmp.dat"  'Der Parameter /R" wÅrde die
                                'Sortierreihenfolge umkehren
'
'--- Sortierte Zahlen aus tmp.dat lesen und anzeigen
OPEN "tmp.dat" FOR INPUT AS #1
LOCATE 2                        'Anzeige ab Zeile 2
WHILE NOT EOF(1)                'Bis Dateiende
  INPUT #1, z%
  LOCATE , 30                   'Anzeige ab Spalte 30
  PRINT z%
WEND
CLOSE
KILL "tmp.txt": KILL "tmp.dat" 'Dateien wieder loeschen
END

