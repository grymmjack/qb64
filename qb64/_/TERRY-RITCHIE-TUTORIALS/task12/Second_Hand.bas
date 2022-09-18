SCREEN 12
Pi2! = 8 * ATN(1) '                             2 * Pi
sec! = Pi2! / 60 '                              (2 * pi) / 60 movements per rotation
DO
    LOCATE 1, 1
    PRINT TIME$
    Seconds% = VAL(RIGHT$(TIME$, 2)) - 15 '     update seconds
    S! = Seconds% * sec! '                      radian from the TIME$ value
    Sx% = CINT(COS(S!) * 60) '                  pixel columns (60 = circular radius)
    Sy% = CINT(SIN(S!) * 60) '                  pixel rows
    LINE (320, 240)-(Sx% + 320, Sy% + 240), 12
    DO
        Check% = VAL(RIGHT$(TIME$, 2)) - 15
    LOOP UNTIL Check% <> Seconds% '             wait loop
    LINE (320, 240)-(Sx% + 320, Sy% + 240), 0 ' erase previous line
LOOP UNTIL INKEY$ = CHR$(27) '                  escape keypress exits

