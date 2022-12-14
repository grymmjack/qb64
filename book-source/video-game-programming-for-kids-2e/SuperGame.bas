_TITLE "Super Squirt Gun Laser Bazooka"
DIM SHARED k$, bg&, ship&, ship_x, ship_y
DIM SHARED submarine&, sub1_x, sub1_y, sub2_x, sub2_y
DIM SHARED player&, player_x, player_y
DIM SHARED shot_x, shot_y, shooting
shooting = 0
DIM SHARED boom&, booming, boom_x, boom_y
booming = 0
DIM SHARED score
score = 0

CALL Load
DO
    CALL Update
LOOP
END

SUB Load ()
scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&

'make background
bg& = _NEWIMAGE(800, 600, 32)
_DEST bg&
blue1& = _RGB(100, 100, 255)
blue2& = _RGB(40, 40, 220)
blue3& = _RGB(40, 40, 180)
LINE (0, 0)-(799, 100), blue1&, BF
LINE (0, 101)-(799, 300), blue2&, BF
LINE (0, 301)-(799, 599), blue3&, BF

'make a ship
ship& = _NEWIMAGE(60, 60, 32)
_DEST ship&
tanned& = _RGB(180, 180, 0)
brown& = _RGB(150, 150, 0)
dkbrown& = _RGB(100, 100, 0)
LINE (0, 30)-(59, 30), tanned&
LINE (0, 30)-(15, 45), tanned&
LINE (15, 45)-(45, 45), tanned&
LINE (45, 45)-(59, 30), tanned&
PAINT (30, 40), tanned&
LINE (10, 25)-(50, 30), brown&, BF
LINE (20, 20)-(40, 25), dkbrown&, BF
LINE (15, 25)-(5, 20), dkbrown&
LINE (45, 25)-(55, 20), dkbrown&
ship_x = 800
ship_y = 60

'make a sub
submarine& = _NEWIMAGE(60, 60, 32)
_DEST submarine&
yellow& = _RGB(220, 220, 20)
LINE (0, 28)-(59, 32), yellow&, BF
LINE (58, 25)-(59, 35), yellow&, BF
LINE (3, 27)-(54, 33), yellow&, BF
LINE (7, 26)-(47, 34), yellow&, BF
LINE (15, 24)-(40, 35), yellow&, BF
LINE (28, 20)-(32, 24), yellow&, BF
LINE (30, 13)-(30, 20), yellow&, BF
LINE (28, 13)-(30, 13), yellow&, BF
sub1_x = 500
sub1_y = 160
sub2_x = 200
sub2_y = 300

'make the player's gun
player& = _NEWIMAGE(60, 60, 32)
_DEST player&
white& = _RGB(255, 255, 255)
LINE (10, 40)-(50, 59), white&, BF
LINE (20, 30)-(40, 40), white&, BF
LINE (29, 15)-(31, 30), white&, BF
player_x = 370
player_y = 535

'make explosion
boom& = _NEWIMAGE(60, 60, 32)
_DEST boom&
red& = _RGB(255, 0, 0)
CIRCLE (30, 30), 28, red&
PAINT (30, 30), red&

_DEST scrn&
END SUB

SUB Update ()
_PUTIMAGE (0, 0), bg&
_PUTIMAGE (ship_x, ship_y), ship&
_PUTIMAGE (sub1_x, sub1_y), submarine&
_PUTIMAGE (sub2_x, sub2_y), submarine&
_PUTIMAGE (player_x, player_y), player&
IF shooting = 1 THEN
    red& = _RGB(255, 0, 0)
    LINE (shot_x - 2, shot_y - 2)-(shot_x + 2, shot_y + 2), red&, BF
    shot_y = shot_y - 1.0
    IF shot_y < 0 THEN shooting = 0
END IF
_PRINTMODE _KEEPBACKGROUND
_PRINTSTRING (0, 0), STR$(score)
_DISPLAY

'move the ship
ship_x = ship_x - 0.5
IF ship_x < -60 THEN ship_x = 800

'move the subs
sub1_x = sub1_x - 0.4
IF sub1_x < -60 THEN sub1_x = 800
sub2_x = sub2_x - 0.3
IF sub2_x < -60 THEN sub2_x = 800

'look for a collision
IF shooting = 1 THEN
    'hit the ship?
    IF shot_x > ship_x AND shot_x < ship_x + 60 THEN
        IF shot_y > ship_y AND shot_y < ship_y + 60 THEN
            shooting = 0
            booming = 1
            boom_x = ship_x
            boom_y = ship_y
            ship_x = 800
        END IF
    END IF

    'hit sub1?
    IF shot_x > sub1_x AND shot_x < sub1_x + 60 THEN
        IF shot_y > sub1_y AND shot_y < sub1_y + 60 THEN
            shooting = 0
            booming = 1
            boom_x = sub1_x
            boom_y = sub1_y
            sub1_x = 800
        END IF
    END IF

    'hit sub2?
    IF shot_x > sub2_x AND shot_x < sub2_x + 60 THEN
        IF shot_x > sub2_y AND shot_y < sub2_y + 60 THEN
            shooting = 0
            booming = 1
            boom_x = sub2_x
            boom_y = sub2_y
            sub2_x = 800
        END IF
    END IF
END IF

'explosion time?
IF booming = 1 THEN
    _PUTIMAGE (boom_x, boom_y), boom&
    _DISPLAY
    SLEEP 1 'pause for 1 second
    booming = 0
    score = score + 1
END IF

k$ = INKEY$
IF k$ = CHR$(27) THEN END
IF k$ = CHR$(32) AND shooting = 0 THEN
    shooting = 1
    shot_x = 400
    shot_y = 550
END IF
END SUB

