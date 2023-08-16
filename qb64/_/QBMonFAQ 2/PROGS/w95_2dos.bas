'****************************************************************************
' W95_2DOS.BAS = Wandelt lange Windows-Dateinamen in 8+3 DOS-Dateinamen um
' ============
'
' Win95 -> DOS - Dateinamen-Konverter
'    
' Wenn du dieses Programm veraenderst (es funktioniert noch nicht ganz
' perfekt), sende mir bitte die neue Version. Wenn du dieses Programm
' in deinen eigenen nutzt, erwaehne bitte meinen Namen!
' Besuche auch meine Homepage: http://privat.schlund.de/c-t
'
' Wichtige Variablen
' -------------------
' vflag  :  Wenn 1, dann wurde etwas ver�ndert
' erwflag:  Wenn 1, dann ist eine Erweiterung vorhanden
' pp     :  Position des Punktes, der Haupt-Name von Erweiterung trennt
' w95$   :  Am Anfang der Windows-95-Dateiname, wird im Laufe des Programms
'           veraendert
' erw$   :  Erweiterung (z.B. txt)
'
' (c) by Carlo Teubner, 1997 -  cteubner*geocities.com
'****************************************************************************
'
DECLARE FUNCTION XUCASE$ (in$)   '<- auch auf meiner Homepage erhaeltlich -
                                 '   dokumentiert
DECLARE FUNCTION Ext$ (file$, pp%)
DEFINT A-Z
CLS
PRINT "Win95 -> DOS - Dateinamen-Konverter"
PRINT
LINE INPUT "Windows-95-Dateinamen eingeben:", w95$
w95$ = XUCASE$(w95$)
DIM verboten$(7)
verboten$(0) = "<"  '\
verboten$(1) = ">"  'ver-
verboten$(2) = "*"  'bo-
verboten$(3) = "?"  'te-
verboten$(4) = "/"  'ne-
verboten$(5) = "\"  'Zei-
verboten$(6) = ":"  'chen
verboten$(7) = "|"  '/
'<Pr�fen, ob der Dateiname g�ltig ist...
FOR i = 0 TO 7
 IF INSTR(w95$, verboten$(i)) > 0 THEN PRINT "Dieser Dateiname enth�lt unzul�ssige Zeichen.": SYSTEM
NEXT i
'...>
'<Ein Sonderfall...
IF RIGHT$(w95$, 1) = "." THEN w95$ = LEFT$(w95$, LEN(w95$) - 1)
'...>
'<Dateinamenerweiterung kriegen...
erw$ = Ext$(w95$, pp): IF erw$ > "" THEN erwflag = 1
'...und auf die richtige L�nge zurechtstutzen...
IF LEN(erw$) > 3 THEN erw$ = LEFT$(erw$, 3): vflag = 1
'...>
'<Die Erweiterung brauchen wir jetzt nicht mehr (wir haben sie als erw$)...
IF erwflag = 1 THEN w95$ = LEFT$(w95$, pp - 1)
'...>
IF LEN(w95$) > 8 THEN vflag = 1
'<Leerzeichen entfernen und anderes...
FOR i = 1 TO LEN(w95$)
 IF MID$(w95$, i, 1) = " " THEN w95$ = LEFT$(w95$, INSTR(w95$, " ") - 1) + RIGHT$(w95$, LEN(w95$) - INSTR(w95$, " ")): vflag = 1
 IF MID$(w95$, i, 1) = "." THEN w95$ = LEFT$(w95$, INSTR(w95$, ".") - 1) + RIGHT$(w95$, LEN(w95$) - INSTR(w95$, ".")): vflag = 1
 IF MID$(w95$, i, 1) = "," THEN MID$(w95$, i, 1) = "_": vflag = 1
 IF MID$(w95$, i, 1) = ";" THEN MID$(w95$, i, 1) = "_": vflag = 1
 IF MID$(w95$, i, 1) = "]" THEN MID$(w95$, i, 1) = "_": vflag = 1
 IF MID$(w95$, i, 1) = "[" THEN MID$(w95$, i, 1) = "_": vflag = 1
NEXT i
'...>
'<Letzte �nderungen...
IF erwflag = 1 THEN p$ = "."
IF vflag = 0 AND LEN(w95$) > 8 THEN dos$ = LEFT$(w95$, 8) + p$ + erw$ ELSE dos$ = w95$ + p$ + erw$
IF vflag = 1 AND LEN(w95$) > 6 THEN dos$ = LEFT$(w95$, 6) + "~1" + p$ + erw$ ELSE dos$ = w95$ + p$ + erw$
'...>
'<Fertig!...
PRINT "DOS-Dateiname: "; dos$
'...>

FUNCTION Ext$ (file$, pp)
FOR i = 1 TO LEN(file$)
 IF MID$(file$, i, 1) = "." THEN pp = i
NEXT i
Ext.$ = RIGHT$(file$, LEN(file$) - pp)
IF Ext.$ = file$ THEN Ext.$ = ""
Ext$ = Ext.$
END FUNCTION
'
FUNCTION XUCASE$ (in$)
'+++ Ersetzungstabelle definieren und f�llen +++
DIM r(30, 1) AS STRING
r(0, 0) = "�": r(0, 1) = "�"
r(1, 0) = "�": r(1, 1) = "�"
r(2, 0) = "�": r(2, 1) = "�"
r(3, 0) = "�": r(3, 1) = "�"
r(4, 0) = "�": r(4, 1) = "�"
r(5, 0) = "�": r(5, 1) = "�"
r(6, 0) = "�": r(6, 1) = "�"
r(7, 0) = "�": r(7, 1) = "�"
r(8, 0) = "�": r(8, 1) = "�"
r(9, 0) = "�": r(9, 1) = "�"
r(10, 0) = "�": r(10, 1) = "�"
r(11, 0) = "�": r(11, 1) = "�"
r(12, 0) = "�": r(12, 1) = "�"
r(13, 0) = "�": r(13, 1) = "�"
r(14, 0) = "�": r(14, 1) = "�"
r(15, 0) = "�": r(15, 1) = "�"
r(16, 0) = "�": r(16, 1) = "�"
r(17, 0) = "�": r(17, 1) = "�"
r(18, 0) = "�": r(18, 1) = "�"
r(19, 0) = "�": r(19, 1) = "�"
r(20, 0) = "�": r(20, 1) = "�"
r(21, 0) = "�": r(21, 1) = "�"
r(22, 0) = "�": r(22, 1) = "�"
r(23, 0) = "�": r(23, 1) = "Y"
r(24, 0) = "�": r(24, 1) = "�"
r(25, 0) = "�": r(25, 1) = "�"
r(26, 0) = "�": r(26, 1) = "�"
r(27, 0) = "�": r(27, 1) = "�"
r(28, 0) = "�": r(28, 1) = "I"
r(29, 0) = "�": r(29, 1) = "�"
r(30, 0) = "�": r(30, 1) = "�"
'+++ Die Hauptschleife +++
FOR i% = 1 TO LEN(in$)
 FOR j = 0 TO 30
  IF MID$(in$, i%, 1) = r(j, 0) THEN MID$(in$, i%, 1) = r(j, 1)
 NEXT j
NEXT i%
XUCASE$ = UCASE$(in$)
END FUNCTION

