REM Demonstration of the VARx statements
REM \CHAP4\CH4_8.BAS

CLS
DEF SEG
c$ = "OneTwoThree"
x% = 123
Address = VARPTR(x%)
PRINT "Address x% ="; Address
PRINT "Address c$ ="; SADD(c$)
PRINT PEEK(Address)
PRINT PEEK(Address + 1)
PRINT "x% ="; PEEK(Address) + 256 * PEEK(Address + 1)
FOR i = SADD(c$) TO SADD(c$) + 10
    PRINT CHR$(PEEK(i));
NEXT i
F$ = INPUT$(1)

END 
 