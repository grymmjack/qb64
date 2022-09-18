DIM c% ' color counter
DIM n$ ' color names
PRINT
PRINT " The 16 CGA text colors" '               Demo program showing what is what like to create
PRINT " ----------------------" '               games back in the early 80s using the CGA video
PRINT '                                         adapter.
FOR c% = 0 TO 15
    READ n$
    COLOR c%
    PRINT " This is color number ->";
    COLOR 7
    PRINT c%; "("; n$; ")"
NEXT c%
PRINT
PRINT " Notice how 8 through 15 is a repeat of 0 through 7."
PRINT " 8 through 15 simply have an intensity bit turned on."
SLEEP
SCREEN 1 ' 320x200 4 color graphics mode
FOR c% = 0 TO 3
    LINE (c% * 80, 0)-(c% * 80 + 79, 199), c%, BF
NEXT c%
LOCATE 8, 8: PRINT " CGA SCREEN 1 - 4 COLORS "
LOCATE 12, 3: PRINT "BLACK"
LOCATE 12, 13: PRINT " CYAN "
LOCATE 12, 21: PRINT " MAGENTA "
LOCATE 12, 32: PRINT " WHITE "
LOCATE 16, 13: PRINT " 320x200 PIXELS "
LOCATE 20, 5: PRINT " IMAGINE MAKING GAMES IN THIS! "
SLEEP
DATA "Black","Blue","Green","Cyan","Red","Magenta","Brown (or Orange)","Light Gray"
DATA "Dark Gray","Light Blue","Light Green","Light Cyan","Light Red","Light Magenta","Yellow","White"

