' *********** CHECK README.1ST FIRST *********************

STRANGEVALUE = 35150  ' This number depends on the picture, so
                      ' you must to try to find correct number for
                      ' each picture

' There is also a bug with color 27, but you can fix it for yourself


OPEN "beast.PCX" FOR INPUT AS #1

SCREEN 13
 DEF SEG = &HA000

 FOR i = 0 TO 255
   naps% = ASC(INPUT$(1, #1))
   IF naps% = &HFE THEN naps% = &H1A
   OUT (&H3C8), i
   OUT (&H3C9), naps%
   naps% = ASC(INPUT$(1, #1))
   IF naps% = &HFE THEN naps% = &H1A
  
   OUT (&H3C9), naps%
   
   naps% = ASC(INPUT$(1, #1))
   IF naps% = &HFE THEN naps% = &H1A
  
   OUT (&H3C9), naps%
 NEXT i

 x& = 0
 y& = 0
 valmis = 0
 ru% = 0

 SEEK #1, 769
              
FOR k = 1 TO STRANGEVALUE     ' This number depends on the picture, so
                          ' you must to try to find correct number to
                          ' each picture
   valmis = 0
   naps% = ASC(INPUT$(1, #1))
   IF naps% = &HFE THEN naps% = &H1A

 IF (naps% AND &HC0) = &HC0 THEN
   ru% = naps% AND &H3F
   naps% = ASC(INPUT$(1, #1))
   IF naps% = &HFE THEN naps% = &H1A
   valmis = 1
 END IF
 
  IF valmis = 0 THEN ru% = 1

 FOR lask& = 1 TO ru%
   POKE x, naps%
   x = x + 1
 NEXT lask&

NEXT k

SLEEP

