CANVAS& = _NEWIMAGE(800, 600, 32)
SCREEN CANVAS&

speed = 7
limit = 30

w = 512
h = 256
x = (800-w) \ 2
y = (600-h) \ 2

img& = _LOADIMAGE("ASSETS/STARFIGHTER-RGB32b.png", 32)
_PUTIMAGE (x,y), img&, CANVAS&

DO
    _LIMIT limit
    FOR i = &H75 TO &HFF STEP speed
        oldC& = _RGB32(i, i, i)
        iStep = i+speed
        IF iStep > &HFE THEN iStep = &HFF
        newC& = _RGB32(iStep, iStep, iStep)
        ReplaceColorInBitmap CANVAS&, oldC&, newC&
        _PRINTSTRING (0, 500), HEX$(oldC&) + " -> " + HEX$(newC&), CANVAS&
    NEXT i
    FOR i = &HFF TO &H75 STEP -speed
        oldC& = _RGB32(i, i, i)
        iStep = i-speed
        IF iStep < &H76 THEN iStep = &H75
        newC& = _RGB32(iStep, iStep, iStep)
        ReplaceColorInBitmap CANVAS&, oldC&, newC&
        _PRINTSTRING (0, 500), HEX$(oldC&) + " -> " + HEX$(newC&), CANVAS&
    NEXT i
LOOP UNTIL _KEYHIT = 27

SUB ReplaceColorInBitmap (img&, srcColor&, destColor&)
    bpp = _PIXELSIZE(img&) : w = _WIDTH(img&) : h = _HEIGHT(img&)

    ' Only 32bpp images allowed
    IF bpp <> 4 THEN EXIT SUB 

    ' Setup buffer and offset
    DIM buffer AS _MEM
    buffer = _MEMIMAGE(img&)
    DIM AS _OFFSET o, oLast
    o = buffer.OFFSET                   ' Start here
    oLast = buffer.OFFSET + w * h * bpp ' Stop here

    ' s = Source, c = Check, d = Destination
    DIM AS _UNSIGNED _BYTE sR, sG, sB, cR, cG, cB, dR, dG, dB

    ' Source color RGB
    sR = _RED(srcColor&)
    sG = _GREEN(srcColor&)
    sB = _BLUE(srcColor&)

    ' Destination color RGB
    dR = _RED(destColor&)
    dG = _GREEN(destColor&)
    dB = _BLUE(destColor&)

    ' Check every color in the image
    DO
        ' Get colors from image
        cB = _MEMGET(buffer, o, _UNSIGNED _BYTE) : o = o + 1
        cG = _MEMGET(buffer, o, _UNSIGNED _BYTE) : o = o + 1
        cR = _MEMGET(buffer, o, _UNSIGNED _BYTE) : o = o + 1

        ' Check if they match and...
        IF (sR = cR AND sG = cG AND sB = cB) THEN
            ' ...replace if they do
            o = o - 3
            _MEMPUT buffer, o, dB AS _UNSIGNED _BYTE : o = o + 1
            _MEMPUT buffer, o, dG AS _UNSIGNED _BYTE : o = o + 1
            _MEMPUT buffer, o, dR AS _UNSIGNED _BYTE : o = o + 1
        END IF
        o = o + 1
    LOOP UNTIL o = oLast
    _MEMFREE buffer
END SUB