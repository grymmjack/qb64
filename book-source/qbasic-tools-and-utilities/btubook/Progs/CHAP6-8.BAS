'*********** CHAP6-8.BAS - shows how to pack and unpack date values

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION PackDate$ (D$)
DECLARE FUNCTION UnPackDate$ (D$)

D$ = "03-22-91"
Packed$ = PackDate$(D$)
UnPacked$ = UnPackDate$(Packed$)

PRINT D$
PRINT Packed$
PRINT UnPacked$

FUNCTION PackDate$ (D$) STATIC
  Year = VAL(RIGHT$(D$, 2))
  Month = VAL(LEFT$(D$, 2))
  Day = VAL(MID$(D$, 4, 2))
  PackDate$ = CHR$(Year) + CHR$(Month) + CHR$(Day)
END FUNCTION

FUNCTION UnPackDate$ (D$) STATIC
  Month$ = LTRIM$(STR$(ASC(MID$(D$, 2, 1))))
  Day$ = LTRIM$(STR$(ASC(RIGHT$(D$, 1))))
  Year$ = LTRIM$(STR$(ASC(LEFT$(D$, 1))))
  UnPackDate$ = RIGHT$("0" + Month$, 2) + "-" + RIGHT$("0" + Day$, 2) + "-" + RIGHT$("0" + Year$, 2)
END FUNCTION
