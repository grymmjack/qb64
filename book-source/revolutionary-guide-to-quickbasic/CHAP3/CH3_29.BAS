REM Demonstration of graphics printing
REM \CHAP3\CH3_29.BAS

'The automatic transfer of line feed and carriage
'return codes is cancelled
WIDTH LPRINT 255

'The line space of 8/72 inch, which provides dense
'vertical printing without intervals
LPRINT CHR$(27); "A"; CHR$(8);

'The loop for filling the buffer is specified
FOR I = 1 TO 5
    LPRINT CHR$(27); "K"; CHR$(100); CHR$(0);
    FOR X = 1 TO 50
        'Specifies printing two columns - of a normal and a turned
        'over exclamation mark
        LPRINT CHR$(170); CHR$(85);
    NEXT X
    'The empty LPRINT prints an empty graphic line
    LPRINT
NEXT I

'Initializes the printer, restoring its initial printing parameters
LPRINT CHR$(27); "@"

END