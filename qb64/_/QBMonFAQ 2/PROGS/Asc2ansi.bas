'**********************************************************
' ASC2ANSI.BAS = ASCII-ANSI-Konvertierung fuer Eingabetext
' ============
' Text mit deutschen Umlauten von DOS-ASCII
' nach Windows-ANSI konvertieren
'
' (c) "Charly", erweitert von Thomas Antoni, 22.10.02
'**********************************************************
DECLARE FUNCTION AsciAnsi$ (Text$)
CLS
PRINT "Gib einen Text mit Umlauten ein"
INPUT ; Text$
OPEN "c:\~ansitmp.txt" FOR OUTPUT AS #1
WRITE #1, AsciAnsi$(Text$)
CLOSE #1
PRINT
PRINT "Der Text wurde in ANSI umgewandelt"
PRINT "und unter c:\~ansitmp.txt abgelegt"
SLEEP
END
'
FUNCTION AsciAnsi$ (Text$)
REM -------------------------------------------------------
REM ASCIANSI Filtern deutsche Umlaute von ASCII nach ANSI
REM -------------------------------------------------------
FOR i% = 1 TO LEN(Text$)
IF MID$(Text$, i%, 1) = CHR$(132) THEN 'a-Umlaut
MID$(Text$, i%, 1) = CHR$(228)
END IF
IF MID$(Text$, i%, 1) = CHR$(148) THEN 'o-Umlaut
MID$(Text$, i%, 1) = CHR$(246)
END IF
IF MID$(Text$, i%, 1) = CHR$(129) THEN 'u-Umlaut
MID$(Text$, i%, 1) = CHR$(252)
END IF
IF MID$(Text$, i%, 1) = CHR$(142) THEN 'A-Umlaut
MID$(Text$, i%, 1) = CHR$(196)
END IF
IF MID$(Text$, i%, 1) = CHR$(153) THEN 'O-Umlaut
MID$(Text$, i%, 1) = CHR$(214)
END IF
IF MID$(Text$, i%, 1) = CHR$(154) THEN 'U-Umlaut
MID$(Text$, i%, 1) = CHR$(220)
END IF
IF MID$(Text$, i%, 1) = CHR$(225) THEN 'eszet
MID$(Text$, i%, 1) = CHR$(223)
END IF
NEXT
AsciAnsi$ = Text$
END FUNCTION

