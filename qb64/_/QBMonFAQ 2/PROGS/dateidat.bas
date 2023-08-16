'***********************************************************************
' DATEIDAT.BAS = Datei-Erstellungsdatum aendern
' ============
' Dieses QuickBasic-Programm demonstriert, wie man das Erstellungsdatum
' einer Datei Ñndert. Der Anwender kann eine beliebige Datei wÑhlen.
' Das Programm zeigt deren Erstellungsdatum mit Uhrzeit an und fragt das
' neue Datum und die neue Uhrzeit ab. Daraufhin wird das
' Erstellungsdatum entsprechend geaendert.
'
' Weil der CALL INTERRUPT-Befehl verwendet wird, ist das Programm
' nur unter QuickBasic, nicht unter QBasic aublauffÑhig. QuickBasic
' muss mit dem Kommando QB /L aufgerufen werden.
'
' (c) Andreas Meile ("Dreael"; qbasicde*dreael.ch) 10.9.2004
'***********************************************************************

' $INCLUDE: 'qb.bi'

DECLARE FUNCTION FuehrNull$ (w%, b%)

' FÅr den Dateinamen mîglichst eine statische Variable nehmen, die im
' Gegensatz zu dynamischen Strings nicht der Garbage Collection unter-
' worfen ist und somit ihre Speicheradresse nie Ñndert
DIM dname AS STRING * 100, dosIntEin AS RegTypeX, dosIntAus AS RegTypeX

INPUT "Datei"; d$

' Zuerst eine Handle holen
dname = d$ + CHR$(0)
dosIntEin.ax = &H3D02
dosIntEin.ds = VARSEG(dname)
dosIntEin.dx = VARPTR(dname)
CALL INTERRUPTX(&H21, dosIntEin, dosIntAus)
IF dosIntAus.flags AND 1 THEN
	PRINT "Fehler beim Datei îffnen. Code="; dosIntAus.ax
	END
END IF
ha% = dosIntAus.ax  ' Datei-Handle

' bisheriges Modifikationsdatum lesen
dosIntEin.ax = &H5700
dosIntEin.bx = ha%
CALL INTERRUPTX(&H21, dosIntEin, dosIntAus)
IF dosIntAus.flags AND 1 THEN
	PRINT "Fehler. Code="; dosIntAus.ax
ELSE
	' Datum interpretieren
	ta% = dosIntAus.dx AND 31
	mo% = (dosIntAus.dx AND 480) \ 32
	ja% = ASC(RIGHT$(MKI$(dosIntAus.dx), 1)) \ 2 + 1980
	' Zeit interpretieren
	s% = (dosIntAus.cx AND 31) * 2
	m% = (dosIntAus.cx AND 2016) \ 32
	h% = ASC(RIGHT$(MKI$(dosIntAus.cx), 1)) \ 8
	
	PRINT "Die Datei "; d$
	PRINT "wurde zuletzt modifiziert am "; FuehrNull$(ta%, 2); ".";
	PRINT FuehrNull$(mo%, 2); "."; FuehrNull$(ja%, 4); ", ";
	PRINT FuehrNull$(h%, 2); ":"; FuehrNull$(m%, 2); ":"; FuehrNull$(s%, 2); " Uhr"
END IF

' Neues Modifikationsdatum setzen
INPUT "Datum im Format tt,mm,jjjj"; ta%, mo%, ja%
INPUT "Uhrzeit im Format hh,mm,ss"; h%, m%, s%
dosIntEin.ax = &H5701
dosIntEin.bx = ha%
dosIntEin.cx = CVI(CHR$(0) + CHR$(8 * h%)) OR m% * 32 OR s% \ 2
dosIntEin.dx = CVI(CHR$(0) + CHR$(2 * (ja% - 1980))) OR mo% * 32 OR ta%
CALL INTERRUPTX(&H21, dosIntEin, dosIntAus)
IF dosIntAus.flags AND 1 THEN
	PRINT "Fehler beim Datum setzen:"; dosIntAus.ax
ELSE
	PRINT "Zeit erfolgreich gesetzt"
END IF

' Zum Schluss noch Datei wieder schliessen (Handle freigeben)
dosIntEin.ax = &H3E00
dosIntEin.bx = ha%
CALL INTERRUPTX(&H21, dosIntEin, dosIntAus)
IF dosIntAus.flags AND 1 THEN
	PRINT "Fehler beim Schliessen:"; dosIntAus.ax
ELSE
	PRINT "Datei erfolgreich freigegeben"
END IF

FUNCTION FuehrNull$ (w%, b%)
	h$ = LTRIM$(STR$(w%))
	FuehrNull$ = STRING$(b% - LEN(h$), 48) + h$
END FUNCTION

