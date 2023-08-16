'******************************************************************
' CPRINT.BAS = Text zentriert anzeigen
' ==========
' von Pawel (www.pkworld.de), 1999
'******************************************************************
DECLARE SUB CPRINT (Text$)
'
t$= "Dieser Text wird zentriert ausgegeben"
CALL CPRINT (t$)
'
SUB CPRINT (Text$)
 LOCATE , 41 - LEN(Text$) / 2 ' Position des Texes im Zusammenhang
                              ' mit Bildschirmbreite und Textlaenge
                              ' (80 Zeichen maximal) berechnen
 PRINT Text$
END SUB


