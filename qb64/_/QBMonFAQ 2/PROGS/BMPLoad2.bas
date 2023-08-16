'***********************************************************************
' BMPLOAD2.BAS = BMP-Loader zum Anzeigen von BMP-Bildern mit 256-Farben
' ============
' Dieses Q(uick)Basic-Programms zeigt BMP-Bilder an, die eine Farbtiefe
' von 8 Bits (256 Farben) haben muessen.
' 
' (c) Skilltronics  ( www.skilltronics.de ) , 21.6.2005 
'***********************************************************************
SCREEN 13: CLS 
DIM byte AS STRING * 1 
OPEN "bild.bmp" FOR BINARY AS #1 
GET #1, 19, br& 
GET #1, 23, ho& 
FOR f = 0 TO 255 
  OUT 968, f 
  FOR rgb = 0 TO 2 
    GET #1, 57 + f * 4 - rgb, byte 
    OUT 969, FIX(ASC(byte) / 4) 
  NEXT
NEXT 
normbr = 4 * FIX((br& + 3) / 4) 
FOR x = 0 TO br& - 1 
  FOR y = 0 TO ho& - 1 
    GET #1, x + y * normbr + 1079, byte 
    PSET (x, (ho& - 1) - y), ASC(byte) 
  NEXT
NEXT 
CLOSE #1 
