 REM Demonstration of controlling input via WHILE...INKEY$...WEND
 REM \CHAP12\CH12_1.BAS

 LOCATE 1,1:PRINT "Press a key to test this routine"
 a$=""
 WHILE a$=""   
 a$=UCASE$(INKEY$)
 WEND
 LOCATE 5,5:PRINT "You pressed the ";a$;" key"

 END