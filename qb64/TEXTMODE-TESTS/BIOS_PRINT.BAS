DEFINT A-Z

DECLARE SUB BIOSPRINT (x%, y%, Text$, clr%)

SCREEN 13

BIOSPRINT 12, 12, "Hello", 15

DEFSNG A-Z
SUB BIOSPRINT (x%, y%, Text$, clr%)
'================================
'x%, y% = location to print.
'Text$ = Text to print
'clr% = Color of text
'================================

FOR d% = 1 TO LEN(Text$)
   FOR c% = 0 TO 7
     DEF SEG = &HFFA6
     l% = PEEK(14 + 8 * ASC(MID$(Text$, d%, 1)) + c%)
     x1% = x% + d% * 8 - 1
     x2% = x% + d% * 8 + 15: a% = 7
     FOR b% = x1% TO x2%
       IF l% AND 2 ^ a% THEN
         PSET (b%, c% + y%), clr%
       END IF: a% = a% - 1
     NEXT
   NEXT
NEXT

DEF SEG

END SUB