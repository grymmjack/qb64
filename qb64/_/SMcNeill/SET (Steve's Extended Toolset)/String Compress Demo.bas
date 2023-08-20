'$include:'SET.BI'

FOR i = 1 TO 50
    text$ = text$ + "I like cheese"
NEXT
de$ = Deflate(text$)
PRINT "ORIGNIAL TEXT -- Length = "; LEN(text$)
PRINT
PRINT text$
SLEEP
PRINT
PRINT
PRINT "Deflated from "; LEN(text$); " to "; LEN(de$); " bytes"
PRINT
PRINT de$
SLEEP
PRINT
PRINT
PRINT "Inflated back to the original text"
PRINT
t$ = Inflate(de$)
PRINT t$

SLEEP
x = TextScreenToImage(0) 'And a quick example of how to turn a text screen into a 256 color image screen
SCREEN x 'swap screens
CIRCLE (320, 240), 100, 40 'And draw a circle on it

'$include:'SET.BM'


