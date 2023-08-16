'*******************************************************************************
' BMP-LOAD.BAS = BMP-Loader zum Anzeigen von BMP-Grafiken
' ============
' Dieses Q(uick)Basic-Programm zeigt BMP-Bilder an.
' Die Bilddateien muessen eine Farbtiefe von 8 Bit (256 Farben) aufweisen.
' Bei Bedarf kann man die Farbtiefe mit jedem beliebigen Bildbearbeitungs-
' Programm anpassen, z.B. mit IrfanView ueber den Menuepunkt "Bild ->
' Farbtiefe erhoehen bzw. Farbtiefe reduzieren"
'
' QB BITMAP READER Copyright (c) 1999 XFlareSoft
'*******************************************************************************
DEFINT A-Z
DIM byte AS STRING * 1
DIM xsz AS LONG 'x-Size
DIM ysz AS LONG 'y-Size
P$ = "test.bmp"
SCREEN 13
'
'--- Datei oeffnen ---
OPEN "c:\tmp\example.bmp" FOR BINARY AS #1
'
'--- Dateiheader auslesen ---
'Die ersten 54 Byte der Datei sind fest vorgegeben und beinhalten den
'Dateiheader:
'Position =  1 -> Am Anfang einer BMP-Datei muss die Zahl 19778 stehen
'         = 29 -> In diesem Beispiel muss hier eine 8 stehen, da dieses
'                  Programm nur bei 8-Bit-BMP-Datein funktioniert
'         = 19 -> Bildbreite in Pixel
'         = 23 -> Bildhöhe in Pixel
GET #1, 1, ftype
GET #1, 29, bits
GET #1, 19, xsz
GET #1, 23, ysz
'
'--- 8-Bit-BMP-Datei erkannt ---
IF ftype = 19778 AND bits = 8 THEN
  '--- Farbpalette auslesen und setzen ---
  FOR attr = 0 TO 255
    OUT &H3C8, attr
    FOR rgb = 1 TO 3
       GET #1, attr * 4 + 58 - rgb, byte
       OUT &H3C9, INT(ASC(byte) * .2471)
    NEXT
  NEXT
'
'--- Bild zeichnen ---
  FOR ypl& = 1 TO ysz
    IF ypl& > 200 THEN EXIT FOR
    FOR xpl& = 1 TO xsz
      IF xpl& > 320 THEN EXIT FOR
      bpl& = LOF(1) - (ypl& * (3 - (xsz + 3) MOD 4)) - ypl& * xsz + xpl&
      GET #1, bpl&, attr
      PSET (xpl& - 1, ypl& - 1), attr
    NEXT
  NEXT
'
'--- Fehlermeldung: Keine 8-Bit-BMP-Datei ---
ELSEIF ftype = 19778 THEN
  PRINT "You are trying to load a Bit-Map image"
  PRINT "which has been saved in"; bits; "bit format."
  PRINT "For coding efficiency, this program"
  PRINT "only reads 8 bit files. Please save the"
  PRINT "image as a 256 color BMP and try again."
'
'--- Fehlermeldung: Datei nicht vorhanden ---
ELSEIF LOF(1) = 0 THEN
  PRINT "You have specified an invalid file name"
  PRINT "to be opened. Please verify that your"
  PRINT "P$ variable setting is correct."
  del = 1 'Datei löschen
'
'--- Fehlermeldung: Datei ist keine BMP-Datei ---
ELSE
  PRINT "You are trying to load a non Bit-Map"
  PRINT "file. Check to see if your file name is"
  PRINT "correct. "
END IF
'
'--- Datei schliessen ---
CLOSE #1
IF del THEN KILL P$
DO: LOOP WHILE INKEY$ = "": SYSTEM

