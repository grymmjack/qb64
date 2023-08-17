'*********** WORDWRAP.BAS - shows how to wrap words within a text window

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB WordWrap (X$, Wide, LeftMargin)

SUB WordWrap (X$, Wide, LeftMargin) STATIC

    Length = LEN(X$)            'remember the length
    Pointer = 1                 'start at the beginning of the string
    IF LeftMargin = 0 THEN LeftMargin = 1       'trap an illegal margin

    'Scan a block of Wide characters backwards, looking for a blank.
    'Stop at the first blank or if we reach the beginning of the string.
    DO
       FOR X = Pointer + Wide TO Pointer STEP -1
           IF MID$(X$, X, 1) = " " OR X = Length + 1 THEN
              LOCATE , LeftMargin
              PRINT MID$(X$, Pointer, X - Pointer);
              Pointer = X + 1
              WHILE MID$(X$, Pointer, 1) = " "
                 Pointer = Pointer + 1
              WEND
              IF POS(0) > 1 THEN PRINT
              EXIT FOR
           END IF
       NEXT
    LOOP WHILE Pointer < Length

END SUB
