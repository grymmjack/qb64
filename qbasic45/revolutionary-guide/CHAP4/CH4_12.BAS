REM Demonstration of the TIMER function
REM \CHAP4\CH4_12.BAS

CLS
TIMER ON                'Timer initial
t = TIMER               'Start time
FOR i% = 1 TO 1000
    a = SIN(1)            'Testing function
NEXT i%
t = TIMER - t           'Calculate time
PRINT t / 1000; " sec"  'Print time

END   
 