_DEFINE A-Z AS LONG
OPTION _EXPLICIT

DIM SHARED notes(1 TO 8) AS LONG
DIM SHARED shapes(1 TO 4) AS STRING
DIM SHARED AS LONG duration, decay, gain, ky, lastNote, shape, voice

shape = 1
duration = 5
decay = 50
gain = 100

notes(1) = 262 ' C4
notes(2) = 294 ' D4
notes(3) = 330 ' E4
notes(4) = 349 ' F4
notes(5) = 392 ' G4
notes(6) = 440 ' A4
notes(7) = 494 ' B4
notes(8) = 523 ' C5

shapes(1) = " square"
shapes(2) = "sawtooth"
shapes(3) = "triangle"
shapes(4) = "  sine"

WIDTH , 27

COLOR 15
PRINT
PRINT "     QB64-PE Sound Demo": COLOR 8
PRINT "     Press a number key 1-8 to play a note": COLOR 7
PRINT
COLOR 3
PRINT "     ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿  ÚÄÄÄÄÄ¿"
PRINT "     ³  1  ³  ³  2  ³  ³  3  ³  ³  4  ³  ³  5  ³  ³  6  ³  ³  7  ³  ³  8  ³"
PRINT "     ³  C  ³  ³  D  ³  ³  E  ³  ³  F  ³  ³  G  ³  ³  A  ³  ³  B  ³  ³  C  ³"
PRINT "     ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ  ÀÄÄÄÄÄÙ"
PRINT "     Do  [ ]  Re  [ ]  Mi  [ ]  Fa  [ ]  So  [ ]  La  [ ]  Ti  [ ]  Do  [ ]"
COLOR 7
PRINT
PRINT
PRINT "                                     0%                100%                  "
PRINT "      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  /\ = '+' Key    "
PRINT "      ³    Shape    ³      Duration: ³                    ³                  "
PRINT "      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄ´                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  \/ = '-' Key    "
PRINT "      ³             ³                                                        "
PRINT "      ³             ³                0%                100%                  "
PRINT "      ³             ³                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  /\ = Up Arrow   "
PRINT "      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          Gain: ³                    ³                  "
PRINT "        Press 0 to                   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  \/ = Down Arrow "
PRINT "       Change Shape                                                          "
PRINT "                                     0%                100%                  "
PRINT "                                     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  /\ = Right Arrow"
PRINT "                              Decay: ³                    ³                  "
PRINT "                                     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  \/ = Left Arrow ";
COLOR 8
LOCATE 24, 2
PRINT " Press ESC to Quit";
ShowShape
ShowLevel 14, duration
ShowLevel 19, gain
ShowLevel 24, decay

DO
    ky = _KEYHIT
    IF ky >= 49 AND ky <= 56 THEN
        voice = (voice + 1) AND 3
        ' Play a note
        DIM n AS LONG
        n = ky - 48
        SOUND 0, 0, , , 1, 0.01!, voice
        SOUND 0, 0, , , 4, decay / 100!, voice
        SOUND notes(n), duration, gain / 100!, , shape, , voice
        IF lastNote > 0 THEN ShowKey lastNote, -1
        ShowKey n, 0
        lastNote = n

    ELSEIF ky = 48 THEN
        ' Change the current shape
        shape = shape + 1
        IF shape > 4 THEN shape = 1
        ShowShape

    ELSEIF ky = 61 THEN ' + Key
        IF duration < 100 THEN duration = duration + 1
        ShowLevel 14, duration

    ELSEIF ky = 45 THEN ' - Key
        IF duration > 0 THEN duration = duration - 1
        ShowLevel 14, duration

    ELSEIF ky = 18432 THEN ' Up Arrow
        IF gain < 100 THEN gain = gain + 1
        ShowLevel 19, gain

    ELSEIF ky = 20480 THEN ' Down Arrow
        IF gain > 0 THEN gain = gain - 1
        ShowLevel 19, gain

    ELSEIF ky = 19712 THEN ' Right Arrow
        IF decay < 100 THEN decay = decay + 1
        ShowLevel 24, decay

    ELSEIF ky = 19200 THEN ' Left Arrow
        IF decay > 0 THEN decay = decay - 1
        ShowLevel 24, decay

    END IF

    _LIMIT 60
LOOP UNTIL ky = 27 'Esc to Quit

COLOR 8
LOCATE 24, 2
END


SUB ShowKey (note AS LONG, hide AS LONG)
    DIM col AS LONG: col = 6 + (note - 1) * 9

    LOCATE 9, col + 5
    IF hide THEN
        COLOR 3
        PRINT " ";
    ELSE
        COLOR 11
        PRINT LTRIM$(STR$(voice));
    END IF

    LOCATE 5, col: PRINT "ÚÄÄÄÄÄ¿";
    LOCATE 6, col: PRINT "³  " + LTRIM$(STR$(note)) + "  ³";
    LOCATE 7, col: PRINT "³";
    LOCATE 7, col + 6: PRINT "³";
    LOCATE 8, col: PRINT "ÀÄÄÄÄÄÙ";
END SUB

SUB ShowShape
    COLOR 14
    LOCATE 17, 10: PRINT "         ";
    LOCATE 17, 11: PRINT shapes(shape);
END SUB

SUB ShowLevel (row AS LONG, level AS LONG)
    COLOR 6
    LOCATE row, 39: PRINT "                    ";
    LOCATE row, 39: PRINT STRING$(level \ 5, "±");

    COLOR 14
    LOCATE row - 2, 46: PRINT "      ";
    LOCATE row - 2, 47: PRINT USING "###%"; level;
END SUB
