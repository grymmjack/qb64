INPUT "What is your name? ", name$
PRINT "Hi, " + name$ + "!"
INPUT "What year were you born? ", birthyear
thisyear = VAL(RIGHT$(DATE$, 4))
age = thisyear - birthyear
PRINT "You are "; age; " years old."


