REM Demonstration of Escape Sequences
REM \CHAP3\CH3_27.BAS
 
WIDTH "LPT1:", 80          'Setting line width of 80 characters
LPRINT CHR$(27); "@";      'Initializing the printer
LPRINT CHR$(27); "x0";     'Printing in a draft mode
LPRINT "Hello my friend!"
LPRINT CHR$(27); "x1";     'Printing in NLQ mode
LPRINT "Hello my friend!"
LPRINT CHR$(27); "!8";     'Enhanced printing
LPRINT "Hello my friend!"
LPRINT CHR$(&H1B); "!B";   'Printing in italic"
LPRINT "Hello my friend!"
LPRINT CHR$(&H1B); CHR$(&H21); CHR$(128); 'Printing with
LPRINT "Hello my friend!"                 'underlining

END