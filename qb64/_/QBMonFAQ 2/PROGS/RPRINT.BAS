'**************************************************************
' RPRINT.BAS - Text rechtsbuendig anzeigen
' ==========
' (c) Pawel (www.pkworld.de), 1999
'**************************************************************
DECLARE SUB RPRINT (Text$)
'
RPRINT "Dieser Text wird rechtsbuendig ausgegeben"
'
SUB RPRINT (Text$)
 LOCATE , 81 - LEN(Text$) 'Position des Texes im Zusammenhang
                          'mit Bildschirmbreite und Textlaenge
                          '(80 Zeichen maximal) berechnen
 PRINT Text$
END SUB

