'---------------------
'- Declare variables -
'---------------------

DIM Phrase$ '       the sentence to be scanned
DIM Ascii% '        ASCII value counter 65 to 90
DIM LetterCount% '  number of each letter found
DIM Count% '        length of string counter

'----------------
'- Main program -
'----------------

PRINT "Letter Count" '                                      print directions
PRINT "------------"
PRINT "Type in a sentence to be scanned."
LINE INPUT "> ", Phrase$ '                                  get sentence to be scanned
PRINT
PRINT "Letters found:"
Phrase$ = UCASE$(Phrase$) '                                 convert sentence to upper case
FOR Ascii% = 65 TO 90 '                                     cycle from A to Z in ASCII table
    LetterCount% = 0 '                                      reset letter counter
    FOR Count% = 1 TO LEN(Phrase$) '                        cycle through the length of the string
        IF ASC(MID$(Phrase$, Count%, 1)) = Ascii% THEN '    does this letter = current ASCII value?
            LetterCount% = LetterCount% + 1 '               yes, increment the letter counter
        END IF
    NEXT Count%
    IF LetterCount% THEN '                                  was this letter found?
        PRINT CHR$(Ascii%); " ->"; LetterCount% '           yes, print result to the screen
    END IF
NEXT Ascii%


