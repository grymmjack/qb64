REM Demonstration of Graphical Fading
REM \CHAP12\CH12_14.BAS

SCREEN 9

FOR boxes = 1 TO 30
  LINE (RND * 640, RND * 350)-(RND * 640, RND * 350), RND * 15, BF
NEXT boxes

WHILE INKEY$ = "": WEND

 FOR colors% = 0 TO 63
   FOR fade% = 0 TO 30
     OUT 967, fade%
     Red = INP(969)
     Green = INP(969)
     Blue = INP(969)
     Red = Red - 1
     Green = Green - 1
     Blue = Blue - 1
 
     IF Red < 0 THEN Red = 0
     IF Green < 0 THEN Green = 0
     IF Blue < 0 THEN Blue = 0

     OUT 968, fade%
 
     OUT 969, Red
     OUT 969, Green
     OUT 969, Blue
    
     FOR delay = 1 TO 15: NEXT delay

   NEXT fade%
 NEXT colors%
                      
 WHILE INKEY$ = "": WEND

 END