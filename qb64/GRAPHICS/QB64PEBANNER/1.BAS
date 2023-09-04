CONST W = 1400
CONST H = 256
DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(W, H, 32)
SCREEN CANVAS&

TYPE SHAPE
    name     AS STRING
    x        AS INTEGER
    y        AS INTEGER
    w        AS SINGLE
    h        AS SINGLE
    shape    AS INTEGER
    shape_p1 AS SINGLE
    shape_p2 AS SINGLE
    k_fill   AS _UNSIGNED LONG
    k_stroke AS _UNSIGNED LONG
    stroke_w AS SINGLE
END TYPE

TYPE LAYER
    name    AS STRING
    img     AS LONG
    z_index AS INTEGER
    x       AS INTEGER
    y       AS INTEGER
    opacity AS SINGLE
END TYPE

TYPE ANIMATION
    name           AS STRING
    frame_start    AS INTEGER
    frame_end      AS INTEGER
    frame_duration AS SINGLE
    anim_duration  AS SINGLE
END TYPE

TYPE FRAME
    img      AS LONG
    duration AS SINGLE
END TYPE

TYPE KEYFRAME
    x        AS INTEGER
    y        AS INTEGER
    w        AS INTEGER
    h        AS INTEGER
    ease_in  AS INTEGER
    ease_out AS INTEGER
    scale_w  AS SINGLE
    scale_h  AS SINGLE
    opacity  AS SINGLE
END TYPE

DIM AS _UNSIGNED LONG k_pumpkin_orange, k_pumpkin_black, k_pumpkin_candle
k_pumpkin_orange~& = _RGB32(&HFF, &H99, &H00)
k_pumpkin_black~&  = _RGB32(&H39, &H00, &H71)
k_pumpkin_candle~& = _RGB32(&HFF, &HFF, &H82)
