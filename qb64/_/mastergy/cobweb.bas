     
    RANDOMIZE TIMER
    CONST pip180 = 3.141592 / 180
    monx = 800: mony = 800: mon = _NEWIMAGE(monx, mony, 32): SCREEN mon
     
    gravity = 1
    obj_c = 15 'number objects
    DIM obj(obj_c - 1, 9) '0,1 posX,Y 3fix/mover
     
     
     
    cent_x = monx / 2: cent_y = 20: zoom = 2
     
    'install "garland of pearls"
     
     
    'garland
    min_weight = 6
    FOR a = 0 TO obj_c - 1
        obj(a, 0) = (RND(1) - .5) * 100
        obj(a, 1) = (RND(1) - .5) * 100
        obj(a, 2) = min_weight + min_weight / 2 * RND(1)
        obj(a, 3) = 1 '<---- 0 if fix, 1 if fly
     
    NEXT a
    obj(0, 0) = -64.5: obj(0, 1) = 5: obj(0, 3) = 0
    obj(obj_c - 1, 0) = 183.5: obj(obj_c - 1, 1) = -.5: obj(obj_c - 1, 3) = 0
     
    'connections
    conn_c = 100: DIM conn(conn_c - 1, 4)
    FOR a = 0 TO obj_c - 2
        conn(a, 0) = a
        conn(a, 1) = a + 1
        conn(a, 2) = 20 'rope width
        conn(a, 3) = 1
    NEXT a
     
     
     
     
     
    DO: _LIMIT 100
     
        'show info
        wch = -1: FOR a = 0 TO obj_c - 1
            IF _MOUSEX < 200 AND INT(_MOUSEY / 16) = a THEN wch = a: COLOR _RGB32(255, 255, 255) ELSE COLOR _RGB32(100, 100, 100)
            LOCATE a + 1, 1: PRINT a; "# weight:"; INT(obj(a, 2) * 10) / 10;: IF obj(a, 3) = 0 THEN PRINT "FIX";
            IF wch = a THEN PRINT "<--- using mousewheel !"
            IF wch <> -1 THEN obj(wch, 2) = obj(wch, 2) + mw / 10: IF obj(wch, 2) < min_weight THEN obj(wch, 2) = min_weight
        NEXT a
        LOCATE mony / 16 - 1, 1: IF moving THEN PRINT "press SPACE to FIX/FLY"; ELSE PRINT "grab the ball with the mouse and move it!";
     
        'draw objects
        FOR a = 0 TO obj_c - 1
            x = cent_x + obj(a, 0) * zoom
            y = cent_y + obj(a, 1) * zoom
            IF mouse_near = a THEN COLOR _RGB32(255, 0, 0) ELSE COLOR _RGB32(200, 200, 200)
            CIRCLE (x, y), obj(a, 2) * zoom
            _PRINTSTRING (x, y), LTRIM$(STR$(a))
        NEXT a
     
        'draw connections
     
        COLOR _RGB32(150, 150, 150)
        FOR a = 0 TO conn_c - 1: IF conn(a, 3) = 0 THEN _CONTINUE
            x1 = obj(conn(a, 0), 0) * zoom + cent_x
            y1 = obj(conn(a, 0), 1) * zoom + cent_y
            x2 = obj(conn(a, 1), 0) * zoom + cent_x
            y2 = obj(conn(a, 1), 1) * zoom + cent_y
        LINE (x1, y1)-(x2, y2): NEXT a
     
        'calculate moving
     
     
        FOR a = 0 TO obj_c - 1: IF obj(a, 3) = 0 OR (mouse_near = a AND _MOUSEBUTTON(1)) THEN _CONTINUE
     
            'connections vector
            vec_x = 0: vec_y = 0: vec_c = 0
            FOR t = 0 TO conn_c - 1: IF conn(t, 3) = 0 THEN _CONTINUE
                x = -1: FOR t2 = 0 TO 1: IF conn(t, t2) = a THEN x = conn(t, t2 XOR 1)
                NEXT t2
                IF x <> -1 THEN
                    disx = obj(a, 0) - obj(x, 0)
                    disy = obj(a, 1) - obj(x, 1)
                    ang = (-degree(disx, disy) + 0) * pip180
                    dis = SQR(disx * disx + disy * disy)
                    power = dis / obj(a, 2) / 5
                    '  IF dis < (obj(a, 2) + obj(x, 2)) THEN power = -power / 10000
                    vec_x = vec_x + SIN(ang) * power
                    vec_y = vec_y - COS(ang) * power
                    vec_c = vec_c + 1
                END IF
            NEXT t
     
            gravity = .1
            lass = .98
     
            obj(a, 4) = (obj(a, 4) + vec_x / vec_c) * lass
            obj(a, 5) = (obj(a, 5) + vec_y / vec_c) * lass + gravity
     
            lx = obj(a, 0) + obj(a, 4)
            ly = obj(a, 1) + obj(a, 5)
     
            obj(a, 0) = obj(a, 0) + obj(a, 4)
            obj(a, 1) = obj(a, 1) + obj(a, 5)
     
     
     
        NEXT a
     
        mw = 0: WHILE _MOUSEINPUT: mw = mw + _MOUSEWHEEL: WEND
     
        'mouse moving activing
        IF moving = 0 THEN
            mouse_near = -1
            FOR a = 0 TO obj_c - 1
                disx = (cent_x + obj(a, 0) * zoom) - _MOUSEX
                disy = (cent_y + obj(a, 1) * zoom) - _MOUSEY
                dis = SQR(disx * disx + disy * disy)
                IF dis < 10 THEN mouse_near = a
            NEXT a
        END IF
     
        IF (_MOUSEBUTTON(1) AND mouse_near <> -1) OR moving THEN
            moving = 1
            obj(mouse_near, 0) = (_MOUSEX - cent_x) / zoom
            obj(mouse_near, 1) = (_MOUSEY - cent_y) / zoom
        END IF
     
        moving = moving AND _MOUSEBUTTON(1)
     
     
        'change weights with mousewheel
     
     
     
        _DISPLAY: CLS
     
        'commands
        inkey2$ = INKEY$: IF inkey2$ = CHR$(27) THEN END
        IF inkey2$ = " " AND _MOUSEBUTTON(1) AND moving THEN obj(mouse_near, 3) = obj(mouse_near, 3) XOR 1
     
     
    LOOP
     
     
     
     
    FUNCTION degree (a, b): degreex = ATN(a / (b + .00001)) / pip180: degreex = degreex - 180 * ABS(0 > b): degreex = degreex - 360 * (degreex < 0): degree = degreex: END FUNCTION
     