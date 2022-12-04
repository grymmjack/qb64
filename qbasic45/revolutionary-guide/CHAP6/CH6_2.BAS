REM Reading and using the sequential FTEL file from disk and 
REM outputting onto the screen the information it contains
REM \CHAP6\CH6_2.BAS

CLS
CHDIR "C:\WROXDATA"
OPEN "FTEL.DAT" FOR INPUT AS #1
INPUT #1, Num%
INPUT #1, Name$, Tel$
PRINT "LOF ="; LOF(1)
PRINT "LOC ="; LOC(1)
PRINT "EOF ="; EOF(1)
CLOSE #1
PRINT "Data:"
PRINT Num%; " "; Name$; " "; Tel$

END 