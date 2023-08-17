'********** CHAP10-3.BAS - demonstrates direct speaker control via OUT

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB BSound (Frequency, Duration)

CLS

PRINT "Sweep sound"
FOR X = 1 TO 10
  READ Frequency
  CALL BSound(Frequency, 1)
NEXT
DATA 100, 200, 300, 400, 600, 900, 1200, 1500, 1800, 2100

PRINT "Press a key for more..."
WHILE INKEY$ = "": WEND

PRINT "Telephone"
FOR X = 1 TO 10
  CALL BSound(600, 1)
  CALL BSound(800, 1)
NEXT

PRINT "Press a key for more..."
WHILE INKEY$ = "": WEND

PRINT "Siren"
FOR X = 1 TO 2
  FOR Y = 600 TO 1000 STEP 15
    CALL BSound(Y, -1)          'negative values leave
  NEXT                          '  the speaker turned on
  FOR Y = 1000 TO 600 STEP -15
    CALL BSound(Y, -1)
  NEXT
NEXT
CALL BSound(600, 1)             'force the speaker off

SUB BSound (Frequency, Duration) STATIC
 
  IF Frequency < 33 THEN EXIT SUB

  IF NOT BeenHere THEN          'do this only once for a
    BeenHere = -1               '  smoother sound effect
    OUT &H43, 182               'initialize speaker port
  END IF

  Period = 1193180 \ Frequency  'convert to period
  OUT &H42, Period AND &HFF     'send it as two bytes
  OUT &H42, Period \ 256        '  in succession

  Speaker = INP(&H61)           'read Timer port B
  Speaker = Speaker OR 3        'set the speaker bits on
  OUT &H61, Speaker

  DEF SEG = 0
  FOR X = 1 TO ABS(Duration)    'for each tick specified
    ThisTime = PEEK(&H46C)      '  count changes again
    DO                          'wait until the timer
    LOOP WHILE ThisTime = PEEK(&H46C)
  NEXT

  IF Duration > 0 THEN          'turn off if requested
    Speaker = INP(&H61)         'read Timer port B
    Speaker = Speaker AND &HFC  'set the speaker bits off
    OUT &H61, Speaker
  END IF
  
END SUB
