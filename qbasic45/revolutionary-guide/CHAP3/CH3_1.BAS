REM Program to illustrate dialog
REM \CHAP3\CH3_1.BAS
 
CLS
' GET user info
INPUT "What is your name"; name$
PRINT name$; ", what is your surname";
INPUT family$
INPUT "In what year were you born"; year%
LINE INPUT "Now tell me, where do you live? "; address$
INPUT "What is your home telephone number?"; tel$
' Output user info
PRINT
PRINT name$; " "; family$; " was born in"; year%
PRINT "and lives in "; address$
PRINT "His telephone number is "; tel$
a$ = INPUT$(1)

END