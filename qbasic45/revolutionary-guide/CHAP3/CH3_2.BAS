REM Demonstration of the PRINT USING statement
REM \CHAP3\CH3_2.BAS

CLS
PRINT "Demonstration of the PRINT USING statement"
Pi = 3.141593
PRINT "Number Pi ="; Pi
PRINT "#.# -> "; : PRINT USING "#.#"; Pi
PRINT "#.### -> "; : PRINT USING "#.###"; Pi
PRINT "###.## -> "; : PRINT USING "###.##"; Pi
PRINT "+#.### -> "; : PRINT USING "+#.###"; Pi
PRINT "+#>### -> "; : PRINT USING "+#.###"; Pi; : PRINT " for Pi"
PRINT "-#.### -> "; : PRINT USING "-#.###"; Pi; : PRINT " for -Pi"
PRINT ".###^^^^ -> "; : PRINT USING ".###^^^^"; Pi
PRINT "#.###^^^^ -> "; : PRINT USING "#.###^^^^"; Pi
PRINT "###.###^^^^ -> "; : PRINT USING "###.###^^^^"; Pi
PRINT "$$#.## -> "; : PRINT USING "$$#.##"; Pi
PRINT "#- -> "; : PRINT USING "#-"; -Pi
PRINT "****#.### -> "; : PRINT USING "****#.###"; Pi
PRINT "#.### -> "; : PRINT USING "#.###"; Pi * 1000: PRINT "for 1000*Pi"
PRINT "Pi=#.### -> "; : PRINT USING "Pi=#.###"; Pi
PRINT "#.##_% -> "; : PRINT USING "#.##_%"; Pi
PRINT
s$ = "String"
PRINT s$
PRINT "! -> "; : PRINT USING "!"; s$
PRINT "& -> "; : PRINT USING "&"; s$
PRINT "\ \ -> "; : PRINT USING "\ \"; s$

END