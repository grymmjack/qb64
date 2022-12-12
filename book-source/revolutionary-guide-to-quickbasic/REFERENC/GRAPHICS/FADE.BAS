REM Fading Screen
REM \REFERENC\GRAPHICS\FADE.BAS

SCREEN 7, 0, 0, 0

colour% = 4
time% = 1000
flag% = 0
XStart% = 20: xfinish% = 300: xstep% = 40
YStart% = 20: yfinish% = 180: ystep% = 40
                                               
LOCATE 10, 11: PRINT "This is before..."
WHILE INKEY$ = "": WEND

FOR xval% = XStart% TO xfinish% STEP xstep%
        FOR yval% = YStart% TO yfinish% STEP ystep%
                xcount% = 0
                ycount% = 0
                PSET (xval% + xcount%, yval% + ycount%), colour%
        NEXT yval%
NEXT xval%
xcount% = xcount% + 1
ycount% = ycount% + 1
loopy:
FOR xval% = XStart% TO xfinish% STEP xstep%
        FOR yval% = YStart% TO yfinish% STEP ystep%
                a2% = xval% + xcount%: b2% = yval% - ycount%
                a1% = xval% + xcount%: b1% = yval% + ycount%
                LINE (a1%, b1%)-(a2%, b2%), colour%
        NEXT yval%
NEXT xval%
FOR xval% = XStart% TO xfinish% STEP xstep%
        FOR yval% = YStart% TO yfinish% STEP ystep%
                a2% = xval% + xcount%: b2% = yval% + ycount%
                a1% = xval% - xcount%: b1% = yval% + ycount%
                LINE (a1%, b1%)-(a2%, b2%), colour%
        NEXT yval%
NEXT xval%
FOR xval% = XStart% TO xfinish% STEP xstep%
        FOR yval% = YStart% TO yfinish% STEP ystep%
                a2% = xval% - xcount%: b2% = yval% + ycount%
                a1% = xval% - xcount%: b1% = yval% - ycount%
                LINE (a1%, b1%)-(a2%, b2%), colour%
        NEXT yval%
NEXT xval%
xcount% = xcount% + 1
FOR xval% = XStart% TO xfinish% STEP xstep%
        FOR yval% = YStart% TO yfinish% STEP ystep%
                a2% = xval% - xcount%: b2% = yval% - ycount%
                a1% = xval% + xcount%: b1% = yval% - ycount%
                LINE (a1%, b1%)-(a2%, b2%), colour%
        NEXT yval%
NEXT xval%
ycount% = ycount% + 1

FOR counter% = 1 TO time%: NEXT counter%
flag% = flag% + 1: IF flag% > (XStart% - 1) THEN GOTO finish
GOTO loopy

finish:
COLOR 15, colour%: LOCATE 10, 11: PRINT "...and this is after"
WHILE INKEY$ = "": WEND
END


