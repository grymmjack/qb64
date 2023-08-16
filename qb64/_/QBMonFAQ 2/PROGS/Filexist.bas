'********************************************************
' FILEXIST.EXE = Testet ob eine Datei existiert
' ============
' Dieses QBasic-Programm stellt fest, ob eine Datei
' mit dem angegebenen Pfad- und Dateinamen existiert.
' Es ist ein einfacher Ersatz fÅr file_exists() aus PHP
'
' (c) Andreas Meile, 25.10.2004
'    ("Dreael"; qbasicde*dreael.ch)
'********************************************************
'
DECLARE FUNCTION DateiExistiert% (d$)
'
INPUT "Dateiname"; d$
'
IF DateiExistiert(d$) THEN
  PRINT "Datei "; d$; " existiert."
ELSE
  PRINT "Datei "; d$; " gibt es nicht!"
END IF
'
END
'
Fehler:
ex% = 0
RESUME NEXT
'
FUNCTION DateiExistiert% (d$)
  SHARED ex%
'
  ex% = -1
  ON ERROR GOTO Fehler
  OPEN d$ FOR INPUT AS 1
  CLOSE 1
  ON ERROR GOTO 0
  DateiExistiert% = ex%
END FUNCTION

