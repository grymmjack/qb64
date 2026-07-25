$CONSOLE:ONLY
OPTION _EXPLICIT
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0: CONST TRUE = NOT FALSE
$END IF
'$INCLUDE:'_ALL.BI'

DIM cfg AS DICE3D_CONFIG
dice3d_config_defaults cfg
cfg.DIE_SIZE = 77: cfg.CAM_TILT = 45: cfg.BODY_ALPHA = 0.5
cfg.BODY_KOLOR = _RGB32(255, 140, 0): cfg.MATERIAL = 2: cfg.WIRE_ENABLED = -1
dice3d_config_save cfg, "iotest.txt"

DIM c2 AS DICE3D_CONFIG
dice3d_config_defaults c2
DIM ok AS INTEGER: ok = dice3d_config_load%(c2, "iotest.txt")
PRINT "config load ok ="; ok
PRINT "DIE_SIZE ="; c2.DIE_SIZE, "CAM_TILT ="; c2.CAM_TILT, "BODY_ALPHA ="; c2.BODY_ALPHA
PRINT "MATERIAL ="; c2.MATERIAL, "WIRE ="; c2.WIRE_ENABLED
PRINT "BODY_KOLOR match ="; (c2.BODY_KOLOR = _RGB32(255, 140, 0))

DIM i AS INTEGER
REDIM cset(0 TO 6) AS DICE3D_CONFIG
FOR i = 0 TO 6: dice3d_config_defaults cset(i): cset(i).DIE_SIZE = 30 + i * 5: NEXT
dice3d_set_save cset(), "ioset.txt"
REDIM c3(0 TO 6) AS DICE3D_CONFIG
DIM ok2 AS INTEGER: ok2 = dice3d_set_load%(c3(), "ioset.txt")
PRINT "set load ok ="; ok2
FOR i = 0 TO 6: PRINT dice3d_set_name$(i); " size ="; c3(i).DIE_SIZE: NEXT
SYSTEM

'$INCLUDE:'_ALL.BM'
