100 PRINT "What is your name: ";
200 INPUT name$
300 PRINT "Welcome to the dungeon, " + name$ + "!"
400 PRINT "What is your command: ";
500 INPUT c$
600 IF c$ = "attack" THEN 700
650 PRINT "You ran away."
660 GOTO 800
700 PRINT "You destroyed the monster!"
800 END



