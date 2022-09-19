SCREEN _NEWIMAGE(1024, 768, 32)
i& = _LOADIMAGE("ASSETS/STARFIGHTER-RGB32.png") '<<<<<<<<<<<<< use any 24 bit image file

FOR n! = 1 TO 0.01 STEP -0.01
    i2& = _COPYIMAGE(i&)
    DarkenImage i2&, n!
    _PUTIMAGE (0, 0), i2&
    _FREEIMAGE i2&
    _DISPLAY
NEXT

SUB DarkenImage (Image AS LONG, Value_From_0_To_1 AS SINGLE)
    IF Value_From_0_To_1 <= 0 OR Value_From_0_To_1 >= 1 OR _PIXELSIZE(Image) <> 4 THEN EXIT SUB
    DIM Buffer AS _MEM: Buffer = _MEMIMAGE(Image) 'Get a memory reference to our image
    DIM Frac_Value AS LONG: Frac_Value = Value_From_0_To_1 * 65536 'Used to avoid slow floating point calculations
    DIM O AS _OFFSET, O_Last AS _OFFSET
    O = Buffer.OFFSET 'We start at this offset
    O_Last = Buffer.OFFSET + _WIDTH(Image) * _HEIGHT(Image) * 4 'We stop when we get to this offset
    'use on error free code ONLY!
    $CHECKING:OFF 
    DO
        _MEMPUT Buffer, O, _MEMGET(Buffer, O, _UNSIGNED _BYTE) * Frac_Value \ 65536 AS _UNSIGNED _BYTE
        _MEMPUT Buffer, O + 1, _MEMGET(Buffer, O + 1, _UNSIGNED _BYTE) * Frac_Value \ 65536 AS _UNSIGNED _BYTE
        _MEMPUT Buffer, O + 2, _MEMGET(Buffer, O + 2, _UNSIGNED _BYTE) * Frac_Value \ 65536 AS _UNSIGNED _BYTE
        O = O + 4
    LOOP UNTIL O = O_Last
    'turn checking back on when done!
    $CHECKING:ON 
    _MEMFREE Buffer
END SUB