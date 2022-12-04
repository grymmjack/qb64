REM Statements CLS and VIEW PRINT demonstration
REM \CHAP3\CH3_7.BAS

CLS

'GET the CLS mode
INPUT "Which type of CLS 0 1 or 2"; Type.of.Clear
PRINT "Press any key to clear text"
VIEW PRINT 10 to 15
FOR i% = 101 to 180
    PRINT i%;
NEXT i%
f$ = INPUT$(1)

'Now clear as chosen
CLS Type.of.Clear

END