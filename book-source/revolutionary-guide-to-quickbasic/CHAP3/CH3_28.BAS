REM Define new printer symbol - airplane
REM \CHAP3\CH3_28.BAS
 
A = 60: 'The variable A defines the code of a character to be redefined
        '(in our case this is the character < with the code 60)

'This control sequence copies the new character into memory
LPRINT CHR$(27); ":"; CHR$(0); CHR$(0); CHR$(0);

'This control sequence specifies the choice of the set - the
'standard one or the user-defined set (latter - in our case)
LPRINT CHR$(27); "%"; CHR$(1); CHR$(0);

'This control sequence defines the codes of the characters to be
'redefined (code 60 in our case)
LPRINT CHR$(27); "&"; CHR$(0); CHR$(A); CHR$(A);

'Enter the definition of a new character into the printer's memory
LPRINT CHR$(128);
FOR I = 1 TO 9
    READ D
    LPRINT CHR$(D);
NEXT I

'Specifies the selection of a new character
LPRINT CHR$(0); CHR$(0);

'Contains the code set for defining a new character
DATA 56,0,16,0,16,130,84,40,16

'Specifies printing five new characters with spaces
FOR I = 1 TO 5
    LPRINT "< ";
NEXT I
LPRINT

END 