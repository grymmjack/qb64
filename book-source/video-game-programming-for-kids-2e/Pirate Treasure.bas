_TITLE "Pirate Treasure"

DIM SHARED scrn&, island&, cloud&, pirate&, treasure&
DIM SHARED white&, black&, green&, gold&, brown&, sky&, darksand&, sand&
DIM SHARED ocean&, counter

RANDOMIZE TIMER

scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&
CALL MakeColors
CALL MakeIsland

CALL MakeCloud

CALL MakePirate
pirate_x = 10 + RND * 700
pirate_y = 280 + RND * 220

CALL MakeTreasure
treasure_x = 10 + RND * 700
treasure_y = 280 + RND * 220

'start a stopwatch timer
t = _FREETIMER
ON TIMER(t, 1) CountDown
TIMER(t) ON
counter = 31

_DEST display&
gameover$ = "false"

DO
    CLS
    _PUTIMAGE (0, 0), island&, scrn&
    _PUTIMAGE (100, 40), cloud&, scrn&
    _PUTIMAGE (600, 70), cloud&, scrn&
    _PUTIMAGE (treasure_x, treasure_y), treasure&, scrn&
    _PUTIMAGE (pirate_x, pirate_y), pirate&, scrn&
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (350, 10), "Time:" + STR$(counter)

    k$ = INKEY$
    IF k$ <> "" THEN
        code = ASC(k$)
        IF code = 0 THEN
            code = ASC(k$, 2)
            IF code = 72 THEN 'move up
                pirate_y = pirate_y - 5
            ELSEIF code = 80 THEN 'move down
                pirate_y = pirate_y + 5
            ELSEIF code = 75 THEN 'move left
                pirate_x = pirate_x - 5
            ELSEIF code = 77 THEN 'move right
                pirate_x = pirate_x + 5
            END IF
        ELSE
            IF k$ = CHR$(27) THEN gameover$ = "true"
        END IF
    END IF

    'see if you got the treasure
    px = pirate_x + 30
    py = pirate_y + 30
    IF px > treasure_x AND py > treasure_y THEN
        IF px < treasure_x + 60 AND py < treasure_y + 60 THEN
            _PRINTSTRING (350, 50), "YOU GOT THE TREASURE!"
            gold = INT((30 - counter) * 100 + RND * 100)
            _PRINTSTRING (350, 70), "You found" + STR$(gold) + " gold!"
            _PRINTSTRING (350, 120), "Press ESC to quit"
            gameover$ = "true"
        END IF
    END IF
    IF py < 270 THEN
        _PRINTSTRING (350, 50), "YOU DROWNED IN THE OCEAN!"
        gameover$ = "true"
    END IF

    _DISPLAY

LOOP UNTIL gameover$ = "true"
DO
    _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM

SUB CountDown ()
counter = counter - 1
END SUB

SUB MakeColors ()
white& = _RGB(255, 255, 255)
black& = _RGB(0, 0, 0)
green& = _RGB(0, 255, 0)
gold& = _RGB(255, 215, 0)
brown& = _RGB(100, 100, 40)
sky& = _RGB(110, 110, 240)
darksand& = _RGB(214, 165, 116)
sand& = _RGB(234, 185, 136)
ocean& = _RGB(60, 60, 240)
END SUB

SUB MakePirate ()
pirate& = _NEWIMAGE(60, 60)
_DEST pirate&
'make the pirate's shadow
LINE (7, 11)-(19, 0), black&
LINE (19, 1)-(31, 11), black&
LINE (7, 11)-(31, 11), black&
PAINT (19, 9), black&
CIRCLE (19, 16), 6, black&
LINE (19, 23)-(19, 37), black&
LINE (19, 27)-(12, 31), black&
LINE (19, 27)-(26, 31), black&
LINE (19, 37)-(14, 49), black&
LINE (19, 37)-(24, 49), black&
'draw the pirate
LINE (8, 12)-(20, 1), green&
LINE (20, 1)-(32, 12), green&
LINE (8, 12)-(32, 12), green&
PAINT (20, 10), green&
CIRCLE (20, 17), 6, green&
LINE (20, 24)-(20, 38), green&
LINE (20, 28)-(13, 32), green&
LINE (20, 28)-(27, 32), green&
LINE (20, 38)-(15, 50), green&
LINE (20, 38)-(25, 50), green&
END SUB

SUB MakeTreasure ()
treasure& = _NEWIMAGE(60, 60)
_DEST treasure&
CIRCLE (20, 20), 20, brown&
PAINT (20, 10), brown&
CIRCLE (20, 20), 17, gold&
PAINT (20, 20), gold&
LINE (0, 20)-(40, 49), brown&, BF
LINE (2, 22)-(38, 45), gold&, BF
LINE (17, 17)-(23, 25), black&, BF
END SUB

SUB MakeIsland ()
island& = _NEWIMAGE(800, 600)
_DEST island&
LINE (0, 0)-(799, 200), sky&, BF
LINE (0, 200)-(799, 270), ocean&, BF
LINE (0, 270)-(799, 350), sand&, BF
LINE (0, 350)-(799, 599), darksand&, BF
END SUB

SUB MakeCloud ()
cloud& = _NEWIMAGE(100, 100)
_DEST cloud&
CIRCLE (20, 20), 20, white&
PAINT (20, 20), white&
CIRCLE (45, 25), 25, white&
PAINT (45, 30), white&
CIRCLE (70, 45), 28, white&
PAINT (70, 45), white&
CIRCLE (35, 45), 30, white&
PAINT (35, 60), white&
END SUB


