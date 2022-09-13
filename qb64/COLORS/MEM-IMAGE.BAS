SCREEN _NEWIMAGE(512, 256, 32)
i = _LOADIMAGE("STARFIGHTER-RGBA32.png", 32)
_PUTIMAGE (0, 0), i
DIM m AS _MEM
m = _MEMIMAGE(i)
'try uncommenting the following line and see what happens
_MEMFREE m
t = m.TYPE
IF t AND 2048 THEN
  PRINT "this is/was an image"
  IF _MEMEXISTS(m) THEN 'check if memory m is still available
    PRINT t AND 7; "bytes per pixel"
    PRINT "image handle "; m.IMAGE
    PRINT "image width"; _WIDTH(m.IMAGE)
    PRINT "image height"; _HEIGHT(m.IMAGE)
  ELSE PRINT "Memory already freed!"
  END IF
END IF 