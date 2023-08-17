'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' ANI-RUN.BAS = Running Man animation with GET and PUT
' ===========   Animiertes laufendes Maennchen mit GET und PUT
'
' Deutsche Beschreibung:
' Dieses QBasic-Programm laesst ein Maenchen ueber den Bildschirm
' laufen und demonstriert die Erzeugung animierter Grafiken mit
' GET und PUT.
'
' English Description:
' A simple animation. Demonstrates some techniques behind
' animating in QB.
' Compiler: MicroSoft QBasic, QuickBasic 4.5, PDS 7.1
'
' (Use at your own risk)
'
' (c) by  Dave Shea,
'     Released to Public Domain on January 18th, 1997.
'     Deutscher Kommentar von Thomas Antoni, 9.3.2006
'- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
_FULLSCREEN 
CLS : SCREEN 13               'Set Screen 13, of course!
'
PSET (25, 71), 31: DRAW "rdld2l2ngr3fnehld3rfrdngulhlg2lh"
PSET (45, 71), 31: DRAW "rdld2lgnder2dnr2ld2rfdnguhld2lg"
PSET (65, 71), 31: DRAW "rdld2ldrnednrddrfndhldlg"
PSET (85, 71), 31: DRAW "rdld2lgnderdnr2d2rfdnguhlgdl2"
'
'The above will draw four different frames of a Stick man running.
'Die obenstehenden 4 Befehle zeichnen 4 Strichmaennchen in
'erschiedenen Laufphasen
'
'
DIM Guy1%(134), Guy2%(134), Guy3%(134), Guy4%(134)
'
'Set aside the memory required for each frame.
'Speicherplatz fuer die 4 Strichmaennchen anlegen.
'
'
GET (16, 69)-(34, 82), Guy1%
GET (36, 69)-(54, 82), Guy2%
GET (56, 69)-(74, 82), Guy3%
GET (76, 69)-(94, 82), Guy4%
'
'Stick each frame into memory (X and Y values calculated by
'pure trial and error)
'Strichmaennchen abspeichern (die X- und Y-Werte wurden durch
'Probieren herausgefunden.
'
'
CLS                           'Guess what THIS does!
'
'
FOR a = 1 TO 300 STEP 2                'Begin Loop
 b = b + 1: IF b = 5 THEN b = 1        'Increase b until it
                                       'reaches a value of 5,
                                       'reset it to 1

 IF b = 1 THEN PUT (a, 100), Guy1%     'Determine which frame to
 IF b = 2 THEN PUT (a, 100), Guy2%     'PUT, then PUT it.
 IF b = 3 THEN PUT (a, 100), Guy3%     'Eines der 4 Maennchen mit
                                       'PUT anzeigen
 IF b = 4 THEN PUT (a, 100), Guy4%
 '
 WAIT 986, 8                           'Wait for Vertical
                                       'Retrace. Warten auf Strahl-
                                       'ruecklauf um Flimmern zu
                                       'vermeiden
 '
 Start = TIMER                         '0.056 s delay loop to slow
 DO: LOOP UNTIL TIMER <> Start         'it down a bit.
                                       '0,056 s Verzoegerung
 '
 IF b = 1 THEN PUT (a, 100), Guy1%     'Erase current frame by
 IF b = 2 THEN PUT (a, 100), Guy2%     'PUTting it again.
 IF b = 3 THEN PUT (a, 100), Guy3%     'Aktuelles Maennchen loe-
                                       'schen durch erneutes PUTen
 IF b = 4 THEN PUT (a, 100), Guy4%
 '
 IF INKEY$ <> "" THEN END              'Terminate with any key
NEXT                                   'Loop!

