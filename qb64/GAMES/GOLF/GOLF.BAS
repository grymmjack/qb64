OPTION _EXPLICIT
OPTION _EXPLICITARRAY

DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(300,200,32)
SCREEN CANVAS&

DO:
   _LIMIT 30
LOOP UNTIL _KEYHIT=27

SYSTEM
