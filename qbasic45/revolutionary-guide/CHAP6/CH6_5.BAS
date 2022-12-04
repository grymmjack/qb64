REM Example for Text File in System Data Format
REM \CHAP6\CH6_5.BAS

CLS
OPEN "CANDIES.TXT" FOR OUTPUT AS #1
DO
   'Read entries from the keyboard
   INPUT "   Candy   :              ", Candy$
   INPUT "   Weight  :              ", Weight
   INPUT "   Calories:              ", Cal%
   'Write entries to SDF-File
   PRINT #1, Candy$; Weight; Cal%
   INPUT "Add another entry"; r$
LOOP WHILE UCASE$(r$) = "y"
CLOSE #1

END  