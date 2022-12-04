REM Falling bomb, clock and siren sound effects
REM \CHAP11\CH11_4.BAS
 
 t0 = TIMER
 FOR i = 1 to 500: NEXT i
 loopsPerSec = 500 / (TIMER - t0)
 'loopsPerSec = # of passes through loop to delay about 1 second
 CLS

 'Bomb
 PRINT "Falling Bomb"
 FOR n = 1000 to 700 Step -5
     SOUND n, 1
 NEXT n
 FOR n = 1 to 500
     SOUND 50 * rnd + 37, .03
 NEXT n
 SLEEP 1

 'Clock
 PRINT "Clock"
 FOR n = 1 to 5
     SOUND 500, .1
     FOR i = 1 to loopsPerSec * .4: NEXT i
     SOUND 2000, .1
     FOR i = 1 to loopsPerSec * .4: NEXT i
 NEXT n
 SLEEP 1

 'Siren
 PRINT "Siren"
 FOR n = 1 to 10
     SOUND 1700, 5
     SOUND 1000, 5
 NEXT n
 SLEEP 1

 END  

