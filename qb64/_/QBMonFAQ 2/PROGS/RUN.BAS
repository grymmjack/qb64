'******************************************************************
' RUN.BAS - An animated stick man runs over the screen
' ======
' Ein animiertes Strichmaennchen laeuft ueber den Bildschirm
' (c) by  Dave Shea November 22nd, 1996.
' Released to Public Domain
' No Warantees expressed or   implied.
'******************************************************************
SCREEN 13:  CLS            'Set Screen 13, of course!
PSET (25, 71), 31: DRAW "rdld2l2ngr3fnehld3rfrdngulhlg2lh"
PSET (45, 71), 31: DRAW "rdld2lgnder2dnr2ld2rfdnguhld2lg"
PSET (65, 71), 31: DRAW "rdld2ldrnednrddrfndhldlg"
PSET (85, 71), 31: DRAW "rdld2lgnderdnr2d2rfdnguhlgdl2"
'The above draws four different frames of a Stick man running
'Diese 4 Befehle zeichnen ein Strichmaennchen in 4 Bewegungsphasen
'(Frames)
DIM Guy1%(134), Guy2%(134), Guy3%(134), Guy4%(134)
'Set aside the memory required for each frame.
'Speicherplatz fuer jeden der 4 Frames reservieren
'
GET (16, 69)-(34, 82), Guy1%  'Stick each frame into memory
GET (36, 69)-(54, 82), Guy2%  '(X and Y values calculated by
GET (56, 69)-(74, 82), Guy3%  'pure trial and error. =u)
GET (76, 69)-(94, 82), Guy4%  'Frames abspeichern
'
CLS                           'Guess what THIS does!
'
FOR a = 1 TO 300 STEP 2                'Begin Loop
  b = b + 1: IF b = 5 THEN b = 1        'Increase b until it
                                       'reaches a value of 5,
                                       'reset it to 1
'
  IF b = 1 THEN PUT (a, 100), Guy1%    'Determine which frame to
  IF b = 2 THEN PUT (a, 100), Guy2%    'PUT, then PUT it.
  IF b = 3 THEN PUT (a, 100), Guy3%
  IF b = 4 THEN PUT (a, 100), Guy4%
'Frame aus dem Speicher lesen und anzeigen
 WAIT 986, 8                           'Wait for Vertical
                                       'Retrace
'Bildaufbau abwarten fuer flimmerfreie Animation
  Start = TIMER                        'Small delay loop to
  WHILE TIMER < Start + .1: WEND       'slow it down a bit.
                                       'Wartezeit 0,1 sec
  IF b = 1 THEN PUT (a, 100), Guy1%    'Erase current frame by
  IF b = 2 THEN PUT (a, 100), Guy2%    'PUTting it again.
  IF b = 3 THEN PUT (a, 100), Guy3%
  IF b = 4 THEN PUT (a, 100), Guy4%
'Aktuellen Frame durch nochmaliges PUTen loeschen
NEXT                                   'Loop!

