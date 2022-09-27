'==========
'FMBOOM.BAS
'==========
'Creates a small explosion through SoundCard with an FM chip.
'Coded by Dav

BOOM$ = "B12124414461648184A1BDC1E1E4B100C0400000C1C2B4D474C000000021"
FOR s% = 1 TO 30 STEP 2
  OUT 904, VAL("&H" + MID$(BOOM$, s%, 2))
  OUT 905, VAL("&H" + MID$(BOOM$, 30 + s%, 2))
NEXT

