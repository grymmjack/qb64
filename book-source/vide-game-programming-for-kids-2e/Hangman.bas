_TITLE "Hangman"
SCREEN _NEWIMAGE(800, 600, 32)
_SCREENMOVE _MIDDLE
White& = _RGB(255, 255, 255)
Green& = _RGB(0, 255, 0)

letters$ = ""
word$ = "basic" 'use only lowercase
correct$ = STRING$(LEN(word$), "_")
wrong = 0

DO
    CLS

    'draw the platform
    LINE (200, 420)-(550, 450), White&, BF
    LINE (200, 10)-(220, 420), White&, BF
    LINE (200, 10)-(400, 20), White&, BF
    LINE (396, 10)-(404, 40), White&, BF

    'draw the hangman
    IF wrong > 0 THEN CIRCLE (400, 90), 40, Green& 'head 'head
    IF wrong > 1 THEN LINE (400, 130)-(400, 280), Green& 'torso
    IF wrong > 2 THEN LINE (400, 180)-(330, 220), Green& 'left arm
    IF wrong > 3 THEN LINE (400, 180)-(470, 220), Green& 'right arm
    IF wrong > 4 THEN LINE (400, 280)-(350, 400), Green& 'left leg
    IF wrong > 5 THEN LINE (400, 280)-(450, 400), Green& 'right leg

    _PRINTSTRING (600, 0), "SAVE THE HANGMAN!"

    _PRINTSTRING (200, 480), correct$
    IF UCASE$(word$) = correct$ THEN
        _PRINTSTRING (360, 240), "YAY! YOU WIN!!!"
    END IF
    IF wrong > LEN(word$) THEN
        _PRINTSTRING (300, 240), "OH NO, HANGMAN! YOU LOSE!!"
    END IF
    _PRINTSTRING (0, 550), "Wrong: " + STR$(wrong)
    _PRINTSTRING (0, 570), "LETTERS: " + UCASE$(letters$)

    _DISPLAY

    k$ = INKEY$
    IF k$ <> "" THEN
        IF k$ >= "a" AND k$ <= "z" THEN
            letters$ = letters$ + k$
            found = 0
            'look for a match
            FOR n = 1 TO LEN(word$)
                c$ = MID$(word$, n, 1)
                IF k$ = c$ THEN
                    MID$(correct$, n, 1) = UCASE$(k$)
                    found = 1
                END IF
            NEXT n
            IF found = 0 THEN wrong = wrong + 1
        END IF
    END IF

LOOP UNTIL k$ = CHR$(27)
SYSTEM


