'*********************************************************************
' RAHMFARB.BAS = Zeichnet ein farbiges Fester mit Titeltext
' ============
' Dieses Q(uick)Basic-Programm zeigt ein farbiges Fenster an
' einer waehlbaren Stelle des Bildschirms an. Das Programm ist
' sehr flexibel konfigurierbar. Die Fensterfarbe und der Fenster-
' Titel koennen frei gew„hlt werden.
'
' (c) Armin Gr„we ( www.agfunk.de), 18.3.2005
'********************************************************************
DECLARE SUB makeframe (kopf$, o%, l%, u%, r%, rty%, cov%, coh%, rev%, fil%)
'
T$ = "Schoenes Fenster"
CALL makeframe(T$, 10, 15, 20, 70, 1, 14, 1, 0, 1)
SLEEP
END

SUB makeframe (kopf$, o%, l%, u%, r%, rty%, cov%, coh%, rev%, fil%)
'******************************************************************
'Zeichnet einen Rahmen nach Vorgaben
'kopf$= Name der Fensters (Titeltext, erscheint als Ueberschrift)
' o%  = Position oberer Rand
' l%  = Position linker Rand
' u%  = Position unterer Rand
' r%  = Position rechter Rand
'rty% = Rahmentyp 0=einfacher Rahmen, jeder andere Wert = Doppelrahmen
'cov% = Vordergrundfarbe
'coh% = Hintergrundfarbe
'rev% = 1=reverse Color, 0=normal color
'fil% = 1=Festerhintergrund mit Farbe mit Farbe fil% fuellen
'       0=nicht gefuellt
'
        IF rty% THEN
           eol$ = CHR$(201)
           eor$ = CHR$(187)
           eul$ = CHR$(200)
           eur$ = CHR$(188)
           hlin% = 205
           vlin% = 186
        ELSE
           eol$ = CHR$(218)
           eor$ = CHR$(191)
           eul$ = CHR$(192)
           eur$ = CHR$(217)
           hlin% = 196
           vlin% = 179
        END IF
'
        COLOR cov%, coh%
'
        LOCATE o%, l%: PRINT eol$; STRING$(r% - l% - 1, hlin%); eor$;
'   
        FOR x% = o% + 1 TO u% - 1
           LOCATE x%, l%: PRINT CHR$(vlin%);
           LOCATE x%, r%: PRINT CHR$(vlin%);
        NEXT x%
'
        LOCATE u%, l%: PRINT eul$; STRING$(r% - l% - 1, hlin%); eur$;
'
        IF kopf$ <> "" THEN
           xkopf$ = " " + kopf$ + " "
           anf% = INT(r% - l% - LEN(xkopf$) - 1) / 2
           IF rev% THEN
              COLOR coh%, cov%
           END IF
           LOCATE o%, l% + anf% + 1: PRINT xkopf$;
           IF rev% THEN
              COLOR cov%, coh%
           END IF
        END IF
'     
        IF fil% THEN
           COLOR cov%, fil%
           FOR x% = o% + 1 TO u% - 1
              LOCATE x%, l% + 1
              PRINT STRING$(r% - l% - 1, 32)
           NEXT x%
           COLOR cov%, coh%
        END IF
'
END SUB

