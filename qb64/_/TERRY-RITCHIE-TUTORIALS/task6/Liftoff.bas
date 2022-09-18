'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM CountDown% ' the count down timer
DIM LiftOff% '   lift off sequence counter

'----------------------------
'- Main program begins here -
'----------------------------

PRINT "Rocket launch in T minus ..."
FOR CountDown% = 10 TO 0 STEP -1
    SLEEP 1
    PRINT
    PRINT CountDown%; "..."
    IF CountDown% = 3 THEN
        PRINT
        PRINT "We have engine ignition ..."
    END IF
NEXT CountDown%
PRINT
PRINT "and lift-off ... !"
SLEEP 1
PRINT
_DELAY .1
PRINT " /\"
_DELAY .1
PRINT " ||"
_DELAY .1
PRINT " ||"
_DELAY .1
PRINT " ||"
_DELAY .1
PRINT "/||\"
_DELAY .1
PRINT "-||-"
_DELAY .1
PRINT " ^^"
_DELAY .1
FOR LiftOff% = 1 TO 25
    _DELAY .1
    PRINT
NEXT LiftOff%
SYSTEM


