REM Demonstration of PCOPY - Blinds
REM \CHAP8\CH8_19.BAS
 
 SCREEN 7, 0, 1, 1

 LOCATE 10, 10: PRINT "It's curtains for me”
 WHILE INKEY$ = "": WEND

 FOR T = 1 TO 84 STEP 4
 SCREEN 7, 0, 2, 0: PCOPY 1, 2
 LINE (0, 0)-(T, 200), 1, 2
 LINE (80, 0)-(80 + T, 200), 1, BF
 LINE (160, 0)-(160 + T, 200), 1, BF
 LINE (240, 0)-(240 + T, 200), 1, BF
 SCREEN 7, 0, 0, 0: PCOPY 2, 0: PCOPY 1, 2
 NEXT

 SCREEN 7, 0, 1, 0
 CLS
 LOCATE 10, 10: PRINT "But not for me….!"
 FOR T = 84 TO 0 STEP -4
 SCREEN 7, 0 2, 0: PCOPY 1, 2
 LINE (0, 0)-(T, 200), 1 ,BF
 LINE (80, 0)-(80 + T, 200), 1 BF
 LINE (160, 0)-(160 + T, 200), 1, BF
 LINE (240, 0)-(240 + T, 200), 1, BF
 SCREEN 7, 0, 0, 0: PCOPY 2, 0: PCOPY 1, 2
 NEXT

 SCREEN 7, 0, 1, 1
 WHILE INKEY$ = "": WEND
 CLS