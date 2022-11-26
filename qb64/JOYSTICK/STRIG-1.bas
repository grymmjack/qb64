FOR j = 1 TO 256
    FOR b = 1 TO 256
        ON STRIG((b - 1) * 4, j) JoyButton (j - 1) * 256 + b - 1
    NEXT
NEXT
STRIG ON

DO
    PRINT ".";
    _LIMIT 30
LOOP UNTIL INKEY$ <> ""
END

SUB JoyButton (js AS LONG)
PRINT "Joystick #"; js \ 256 + 1; "button #"; (js AND 255) + 1; "pressed!"
END SUB 
