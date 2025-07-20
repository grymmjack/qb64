CONST KEY_CAPSLOCK& = 100301
DO:
    IF _KEYDOWN(KEY_CAPSLOCK&) THEN
        PRINT "Caps Lock is on"
    ELSE
        PRINT "Caps Lock is off"
    END IF
LOOP UNTIL INKEY$ = CHR$(27)