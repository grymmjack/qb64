'$INCLUDE:'SET.BI'

CONST SaveTextAs256Color = 0 'Flag to Save as 256 color file or 32-bit color file, when converting SCREEN 0 to an image
'                             Set to TRUE (any non-zero value) to save text screens in 256 color mode.
'                             Set to FALSE (zero) to save text screens in 32-bit color mode.


SCREEN _NEWIMAGE(1280, 720, 32)
InitialImage$ = "Volcano Logo.jpg"
exportimage1$ = "testimage.png"
exportimage2$ = "testimage.bmp"



l& = _LOADIMAGE(InitialImage$) 'Remark out this line
_PUTIMAGE , l& 'And this line

'And unremark the following, you watch as we prove that we can Export PNG and BMP files both while in Screen 0 TEXT mode.

'SCREEN 0
'FOR i = 0 TO 15
'    COLOR i
'    PRINT "COLOR i"
'NEXT

Result = SaveImage(exportimage1$, 0, 0, 0, _WIDTH, _HEIGHT)
IF Result = 1 THEN 'file already found on drive
    KILL exportimage1$ 'delete the old file
    Result = SaveImage(exportimage1$, 0, 0, 0, _WIDTH, _HEIGHT) 'save the new one again
END IF
PRINT Result
PRINT "Our initial Image"
IF Result < 0 THEN PRINT "Successful PNG export" ELSE PRINT "PNG Export failed."; Result: ' END

SLEEP


Result = SaveImage(exportimage2$, 0, 0, 0, _WIDTH, _HEIGHT)
IF Result = 1 THEN 'file already found on drive
    KILL exportimage2$ 'delete the old file
    Result = SaveImage(exportimage2$, 0, 0, 0, _WIDTH, _HEIGHT) 'save the new one again
END IF
PRINT Result
PRINT "Our initial Image"
IF Result < 0 THEN PRINT "Successful BMP export" ELSE PRINT "BMP Export failed.": END

SLEEP




CLS
zz& = _LOADIMAGE(exportimage1$, 32) 'Even though we saved them in 256 color mode, we currently have to force load them as 32 bit images as _LOADIMAGE doesn't support 256 color pictures yet
IF zz& <> -1 THEN
    SCREEN zz&
    PRINT "Image Handle: "; zz&, exportimage1$
    PRINT "Successful Import using _LOADIMAGE"
ELSE
    PRINT "ERROR - Not Loading the new image with _LOADIMAGE."
END IF

SLEEP


CLS
zz& = _LOADIMAGE(exportimage1$, 32) 'Even though we saved them in 256 color mode, we currently have to force load them as 32 bit images as _LOADIMAGE doesn't support 256 color pictures yet
IF zz& <> -1 THEN
    SCREEN zz&
    PRINT "Image Handle: "; zz&, exportimage2$
    PRINT "Successful Import using _LOADIMAGE"
ELSE
    PRINT "ERROR - Not Loading the new image with _LOADIMAGE."
END IF


SLEEP
CLS

SYSTEM

'$INCLUDE:'SET.BM'
