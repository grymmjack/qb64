'*********************************************************************
' SCREENER.BAS = Bildschirmeigenschaften ermitteln
' ============
' Dieses QuickBASIC-Programm ermittelt die Bildschirmaufloesung und
' Die Farbtiefe. Es handelt sich um einen Code-Ausschnitt aus meiner
' unter BMP-Bibliothek (QB4.5-Compilerversion), die auf meiner
' "Heimseite" unter der folgenden URL veroeffentlicht ist:
' http://dreael.catty.ch/Deutsch/Download/WindowsBitmapBibliothek.html
'
' Das Programm verwendet den Interrupt INT 10h AH=0Fh. xAufl% und
' yAufl% geben Dir die Aufloesung zurueck, bpp% die Farbtiefe (# Bits
' pro Pixel)
'
' ACHTUNG: Das Programm verwendet den INTERRUPT-Befehl und ist daher
' =======  nur unter QuickBASIC, nicht unter QBasic ablauffaehig.
'          QuickBASIC muss mit "QB /L" aufgerufen werden.  
'
' (c) Andreas Meile, 1.4.2004
'*********************************************************************
'$INCLUDE: 'qb.bi'
SCREEN 9
DIM dosIntEin AS RegType, dosIntAus AS RegType
dosIntEin.ax = &HFFE ' Funktion 0Fh (Videomodus auslesen)
CALL INTERRUPT(&H10, dosIntEin, dosIntAus)
vMod% = dosIntAus.ax AND &HFF
xGr% = ASC(RIGHT$(MKI$(dosIntAus.ax), 1))
dosIntEin.ax = &H1130
dosIntEin.bx = &H0
CALL INTERRUPT(&H10, dosIntEin, dosIntAus)
yGr% = (dosIntAus.dx AND &HFF) + 1
xAufl% = 8 * xGr%            'Horizontal-Aufloesung (Zeichen bei
			     'EGA/EGA/VGA immer 8 Pixel breit
yAufl% = dosIntAus.cx * yGr% 'Vertikal-Aufloesung (Hier entsprechende
			     'Zeichenmatrix
SELECT CASE vMod%
  CASE 0, 2, 7 ' Textmodus monochrom
    bpp% = 1
    tm% = -1
  CASE 1, 3 ' Textmodus farbig
    bpp% = 4
    tm% = -1
  CASE 6, 17
    bpp% = 1
    tm% = 0
  CASE 4, 5, 15
    bpp% = 2 ' Bemerkung: Nicht unterstÅtzt!
    tm% = 0
  CASE 13, 14, 16, 18
    bpp% = 4
    tm% = 0
  CASE 19
    bpp% = 8
    tm% = 0
  CASE ELSE
    PRINT "Nicht unterstÅtzter Videomodus"
    ERROR 5
END SELECT
'
PRINT vMod%, tm%, xAufl%, yAufl%, bpp%
SLEEP

