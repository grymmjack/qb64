INPUT "What is your first name"; first$
INPUT "What is your last name"; last$
fullname$ = Combine(first$, last$)
PRINT "Hello, "; fullname$; "."

FUNCTION Combine$ (A$, B$)
both$ = A$ + " " + B$
Combine$ = both$
END FUNCTION

