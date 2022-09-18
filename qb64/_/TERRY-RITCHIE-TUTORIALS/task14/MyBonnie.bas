SCREEN 13
COLOR 1
FOR i% = 1 TO 21
    LOCATE 2 + i%, 2: PRINT CHR$(178)
    LOCATE 2 + i%, 39: PRINT CHR$(178)
NEXT i%
FOR i% = 2 TO 39
    LOCATE 2, i%: PRINT CHR$(223)
    LOCATE 23, i%: PRINT CHR$(220)
NEXT i%
COLOR 9
LOCATE 3, 16: PRINT CHR$(34); "MY BONNIE"; CHR$(34)
SLEEP 3
FOR i% = 1 TO 34
    SELECT CASE i%
        CASE 1: LOCATE 5, 5
        CASE 10: LOCATE 10, 5
        CASE 18: LOCATE 15, 5
        CASE 27: LOCATE 20, 5
    END SELECT
    READ note%, duration%, word$
    SOUND note%, duration%: PRINT word$;
NEXT i%
LOCATE 23, 16: PRINT "Thank You!"
SLEEP 4
SYSTEM
DATA 392,8,"My ",659,8,"Bon-",587,8,"nie ",523,8,"lies ",587,8,"O-",523,8,"Ver ",440,8,"the "
DATA 392,8,"O-",330,32,"cean ",392,8,"My ",659,8,"Bon-",587,8,"nie ",523,8,"lies "
DATA 523,8,"O-",494,8,"ver ",523,8,"the ",587,40,"sea ",392,8,"My ",659,8,"Bon-",587,8,"nie"
DATA 523,8," lies ",587,8,"O-",523,8,"ver ",440,8,"the ",392,8,"O-",330,32,"cean ",392,8,"Oh "
DATA 440,8,"bring ",587,8,"back ",523,8,"my ",494,8,"Bon-",440,8,"nie ",494,8,"to ",523,32,"me..!"

