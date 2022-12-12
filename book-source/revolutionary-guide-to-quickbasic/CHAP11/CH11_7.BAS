REM Demonstration of passing an argument to PLAY
REM \CHAP11\CH11_7.BAS

CLS
Music$ = "MBT128O2P2P8L8GGGL2E-P24P8L8FFFL2D"
PLAY Music$
WHILE PLAY(0) > 5: WEND
PRINT "Almost finished!"

END