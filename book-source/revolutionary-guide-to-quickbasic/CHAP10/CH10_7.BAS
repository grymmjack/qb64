 REM Drawing a cone with painted rings
 REM \CHAP10\CH10_7.BAS

 SCREEN 9: R = 10: dH = 15: COLOR 0, 7
 FOR I = 0 TO 15
     C = 15 - I
     LINE (320, 20)-(320 - 15 * R, 20 + 15 * dH), C
     LINE (320, 20)-(320 + 15 * R, 20 + 15 * dH), C
     CIRCLE (320, 20 + 15 * dH), R * 15, C, .27, 2.95, .2
     IF I <> 15 THEN CIRCLE (320, 20 + I * dH), R * I, C, .23, 2.9, .2
     PAINT (320, 24 + I * 13), C
 NEXT I
 CIRCLE (320, 20 + 15 * dH - 1), R * 15 - 2, 1, , , .2

 END