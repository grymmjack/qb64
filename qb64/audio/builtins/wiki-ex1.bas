notes$ = "C C#D D#E F F#G G#A A#B "
COLOR 9:LOCATE 5, 20: PRINT "Select an octave (1 - 7) to play (8 quits):"
DO			
  DO: octa$ = INKEY$
    IF octa$ <> "" THEN
      IF ASC(octa$) > 48 AND ASC(octa$) < 58 THEN octave% = VAL(octa$): EXIT DO
    END IF
  LOOP UNTIL octave% > 7 
  IF octave% > 0 AND octave% < 8 THEN
    LOCATE 15, 6: PRINT SPACE$(70)
    LOCATE 16, 6: PRINT SPACE$(70)
    COLOR 14: LOCATE 15, 6: PRINT "Octave"; octave%; ":";
    RESTORE Octaves
    FOR i = 1 TO 12
      READ note!
      snd% = CINT(note! * (2 ^ (octave% - 1)))  'calculate note frequency
      COLOR 14: PRINT STR$(snd%);
      c0l = POS(0)
      COLOR 11: LOCATE 16, c0l - 2: PRINT MID$(notes$, 1 + (2 * (i - 1)), 2)
      LOCATE 15, c0l
      IF snd% > 36 THEN SOUND snd%, 12  'error if sound value is < 36
      _DELAY .8
    NEXT
  END IF
LOOP UNTIL octave% > 7 
END

Octaves:
DATA 32.7,34.65,36.71,38.9,41.2,43.65,46.25,49,51.91,55,58.27,61.74  