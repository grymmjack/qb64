DECLARE SUB DrawGridCursor (x AS INTEGER, y AS INTEGER, maxy AS INTEGER, c AS INTEGER)
DECLARE SUB DrawGridBounds (x AS INTEGER, y AS INTEGER)
DECLARE SUB DrawUnit (x AS INTEGER, y AS INTEGER, c AS INTEGER)
DECLARE SUB DrawGrid ()
DEFINT A-Z
DECLARE SUB ClearScreen ()
SCREEN 9, , 1, 0

fileopen = 0
filename$ = ""
DIM frs1 AS STRING * 1
DIM frs3 AS STRING * 3
DIM frs6 AS STRING * 6
DIM frs16 AS STRING * 16
DIM frs48 AS STRING * 48

DIM p(0 TO 59, 0 TO 59) AS INTEGER
DIM gd(0 TO 128) AS STRING
DIM gby(0 TO 128) AS INTEGER
DIM gbw(0 TO 128) AS INTEGER
DIM gbh(0 TO 128) AS INTEGER
DIM gchar(0 TO 128) AS INTEGER
fontname$ = ""
cyu = 0
cyd = 0
numglyphs = 0
g = 0
pmaxx = 0
pmaxy = 0
px = 0
py = 0
plotting = 0

StartProgram:
RedrawEditor:
ON ERROR GOTO 0
ClearScreen
IF fileopen = 0 GOTO MainWaitLoop
DrawGrid
DrawGridBounds pmaxx, pmaxy
DrawGridCursor px, py, pmaxy, 14
GOSUB RedrawGridContents

RunEditor:
IF fileopen = 0 GOTO MainWaitLoop
LOCATE 3, 1: COLOR 11: PRINT "  Glyph"; g;
LOCATE 4, 1: COLOR 10: PRINT "  Char"; gchar(g); " ("; CHR$(gchar(g)); ")";
LOCATE 6, 1: COLOR 14: PRINT "  Y-Pos Up:"; gby(g);
LOCATE 7, 1: COLOR 14: PRINT "  Width:   "; gbw(g);
LOCATE 8, 1: COLOR 14: PRINT "  Height:  "; gbh(g);
SELECT CASE plotting
      CASE 1: LOCATE 3, 63: COLOR 13: PRINT "Auto-Plot: Solid"
      CASE 2: LOCATE 3, 63: COLOR 13: PRINT "Auto-Plot: Erase"
END SELECT

MainWaitLoop:
PCOPY 1, 0
DO: a$ = INKEY$: LOOP WHILE a$ = ""
IF MID$(a$, 2, 1) = CHR$(59) THEN GOTO HelpScreen
IF MID$(a$, 2, 1) = CHR$(60) THEN GOTO NewFont
IF MID$(a$, 2, 1) = CHR$(62) THEN GOTO LoadFont
IF a$ = CHR$(27) THEN GOTO QuitProgram
IF fileopen <> 0 THEN
      IF a$ = CHR$(8) THEN GOTO ClearGlyph
      IF a$ = "=" THEN GOTO AddGlyph
      IF a$ = "-" THEN GOTO RemoveGlyph
      IF a$ = "[" AND g > 0 THEN GOTO PrevGlyph
      IF a$ = "]" AND g < numglyphs - 1 THEN GOTO NextGlyph
      IF UCASE$(a$) = "G" THEN GOTO GotoGlyph
      IF UCASE$(a$) = "F" THEN GOTO FindGlyph
      IF UCASE$(a$) = "Z" THEN GOTO PlotMode
      IF MID$(a$, 2, 1) = CHR$(61) THEN GOTO SaveFont
      IF MID$(a$, 2, 1) = CHR$(63) THEN GOTO InputFontData
      IF MID$(a$, 2, 1) = CHR$(64) THEN GOTO InputGlyphData
      IF pmaxy > 0 THEN
            IF MID$(a$, 2, 1) = "H" THEN GOSUB MoveCursorUp
            IF MID$(a$, 2, 1) = "P" THEN GOSUB MoveCursorDown
            IF MID$(a$, 2, 1) = "K" THEN GOSUB MoveCursorLeft
            IF MID$(a$, 2, 1) = "M" THEN GOSUB MoveCursorRight
            IF a$ = " " THEN GOSUB PlotPixel
      END IF
END IF
GOTO MainWaitLoop

PlotMode:
plotting = plotting + 1
IF plotting > 2 THEN plotting = 0
GOTO RedrawEditor

GotoGlyph:
GOSUB CommitGlyphToData
SCREEN , , 0, 0
LOCATE 21, 1: COLOR 15
INPUT "  Goto > ", v
PRINT
IF v < 0 THEN
      COLOR 12: PRINT "  Negative numbers? Really? Press any key to continue, Mr. QA Tester."
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
ELSEIF v >= numglyphs THEN
      COLOR 12: PRINT "  No glyph IDs greater than "; LTRIM$(RTRIM$(STR$(numglyphs - 1))); ". Press any key to continue."
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
ELSE
      g = v
END IF
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

FindGlyph:
GOSUB CommitGlyphToData
SCREEN , , 0, 0
LOCATE 21, 1: COLOR 15
INPUT "  Find > ", a$
PRINT
ON ERROR GOTO SpaceCharFindError
v = ASC(a$)
ResumeGlyphFind:
ON ERROR GOTO 0
FOR z = 0 TO numglyphs - 1
      IF gchar(z) = v THEN
            g = z
            SCREEN , , 1, 0
            GOSUB PrepGlyphGrid
            GOTO RedrawEditor
      END IF
NEXT z
COLOR 12: PRINT "  Glyph not found. "; LTRIM$(RTRIM$(STR$(numglyphs - 1))); ". Press any key to continue."
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

SpaceCharFindError:
v = 32
RESUME ResumeGlyphFind

SaveFont:
GOSUB CommitGlyphToData
SCREEN , , 0, 0
ClearScreen
LOCATE 3, 1: COLOR 15
PRINT "  Previous Filename: "; filename$
PRINT
INPUT "  File to Save     > ", filename$
PRINT
ON ERROR GOTO SaveError1
OPEN filename$ FOR OUTPUT AS #1
WRITE #1, "clear"
CLOSE #1
OPEN filename$ FOR BINARY AS #1
ON ERROR GOTO SaveError2
frs6 = CHR$(27) + ")s64W"
PUT #1, , frs6
frs48 = STRING$(7, 0) + CHR$(cyu) + CHR$(cyd) + STRING$(2, 0) + CHR$(cyu + cyd + 1) + STRING$(36, 0)
PUT #1, , frs48
frs16 = fontname$
PUT #1, , frs16
FOR z = 0 TO numglyphs - 1
      frs3 = CHR$(27) + "*c"
      PUT #1, , frs3
      a$ = LTRIM$(RTRIM$(STR$(gchar(z))))
      FOR zz = 1 TO LEN(a$)
            frs1 = MID$(a$, zz, 1)
            PUT #1, , frs1
      NEXT zz
      frs1 = "E": PUT #1, , frs1
      frs3 = CHR$(27) + "(s"
      PUT #1, , frs3
      v = (((gbw(z) - 1) \ 8) + 1) * gbh(z)
      a$ = LTRIM$(RTRIM$(STR$(v + 16)))
      FOR zz = 1 TO LEN(a$)
            frs1 = MID$(a$, zz, 1)
            PUT #1, , frs1
      NEXT zz
      frs1 = "W": PUT #1, , frs1
      a$ = CHR$(4) + CHR$(0) + CHR$(14) + CHR$(1) + STRING$(5, 0)
      a$ = a$ + CHR$(gby(z)) + CHR$(0) + CHR$(gbw(z)) + CHR$(0)
      a$ = a$ + CHR$(gbh(z)) + CHR$(0) + CHR$(gbw(z) * 4) + CHR$(0)
      frs16 = a$
      PUT #1, , frs16
      IF v > 0 THEN
            FOR zz = 1 TO v
                  frs1 = MID$(gd(z), zz, 1)
                  PUT #1, , frs1
            NEXT zz
      END IF
NEXT z
ON ERROR GOTO 0
CLOSE #1
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

SaveError1:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  Unable to create file! Press any key to continue.";
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
RESUME RedrawEditor

SaveError2:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  Error while writing file! Press any key to continue.";
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
RESUME RedrawEditor

LoadFont:
GOSUB CommitGlyphToData
IF fileopen <> 0 THEN
      LOCATE 23, 1: COLOR 12: PRINT "  Abandon current font? (y/N)"
      PCOPY 1, 0
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
      IF UCASE$(a$) <> "Y" THEN GOTO RedrawEditor
END IF
SCREEN , , 0, 0
ClearScreen
LOCATE 3, 1: COLOR 15
INPUT "  File to Load> ", filename$
PRINT
ON ERROR GOTO LoadError4
OPEN filename$ FOR INPUT AS #1
CLOSE #1
ON ERROR GOTO LoadError1
OPEN filename$ FOR BINARY AS #1
ON ERROR GOTO LoadError2
GET #1, , frs6
a$ = CHR$(27) + ")s64W"
IF frs6 <> a$ GOTO LoadError3
GET #1, , frs48
cyu = ASC(MID$(frs48, 8, 1))
cyd = ASC(MID$(frs48, 9, 1))
GET #1, , frs16
fontname$ = frs16
g = 0
DO WHILE LOC(1) < LOF(1)
      GET #1, , frs1: IF frs1 <> CHR$(27) THEN ERROR 77
      GET #1, , frs1: IF frs1 <> "*" THEN ERROR 77
      GET #1, , frs1: IF frs1 <> "c" THEN ERROR 77
      a$ = ""
      DO
            GET #1, , frs1
            IF frs1 <> "E" THEN a$ = a$ + frs1
      LOOP WHILE frs1 <> "E"
      gchar(g) = VAL(a$)
      GET #1, , frs1: IF frs1 <> CHR$(27) THEN ERROR 77
      GET #1, , frs1: IF frs1 <> "(" THEN ERROR 77
      GET #1, , frs1: IF frs1 <> "s" THEN ERROR 77
      a$ = ""
      DO
            GET #1, , frs1
            IF frs1 <> "W" THEN a$ = a$ + frs1
      LOOP WHILE frs1 <> "W"
      v = VAL(a$) - 16
      GET #1, , frs16
      gby(g) = ASC(MID$(frs16, 10, 1))
      gbw(g) = ASC(MID$(frs16, 12, 1))
      gbh(g) = ASC(MID$(frs16, 14, 1))
      gd(g) = ""
      a$ = ""
      IF v > 0 THEN
            FOR z = 1 TO v
                  GET #1, , frs1
                  gd(g) = gd(g) + frs1
            NEXT z
      END IF
      g = g + 1
LOOP
numglyphs = g
g = 0
fileopen = 1
ON ERROR GOTO 0
CLOSE #1
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

LoadError1:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  Unable to open file! Press any key to continue.";
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
RESUME RedrawEditor

LoadError2:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  Error while reading file! Current font reset to prevent corruption.";
PRINT "  Press any key to continue."
DO: a$ = INKEY$: LOOP WHILE a$ = ""
fileopen = 0
SCREEN , , 1, 0
RESUME RedrawEditor

LoadError3:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  Not a valid font file! Press any key to continue.";
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
GOTO RedrawEditor

LoadError4:
IF FREEFILE <> 1 THEN CLOSE #1
COLOR 12: PRINT "  File not found! Press any key to continue.";
DO: a$ = INKEY$: LOOP WHILE a$ = ""
SCREEN , , 1, 0
RESUME RedrawEditor

ClearGlyph:
gd(g) = ""
GOSUB PrepGlyphGrid
GOTO RedrawEditor

PlotPixel:
IF p(px, py) = 1 THEN p(px, py) = 0 ELSE p(px, py) = 1
DrawUnit px, py, p(px, py) * 15
PCOPY 1, 0
RETURN

MoveCursorUp:
DrawGridCursor px, py, pmaxy, 8
IF py > 0 THEN py = py - 1
DrawGridBounds pmaxx, pmaxy
DrawGridCursor px, py, pmaxy, 14
GOSUB PlottingCheck
PCOPY 1, 0
RETURN

MoveCursorDown:
DrawGridCursor px, py, pmaxy, 8
IF py < pmaxy - 1 THEN py = py + 1
DrawGridBounds pmaxx, pmaxy
DrawGridCursor px, py, pmaxy, 14
GOSUB PlottingCheck
PCOPY 1, 0
RETURN

MoveCursorLeft:
DrawGridCursor px, py, pmaxy, 8
IF px > 0 THEN px = px - 1
DrawGridBounds pmaxx, pmaxy
DrawGridCursor px, py, pmaxy, 14
GOSUB PlottingCheck
PCOPY 1, 0
RETURN

MoveCursorRight:
DrawGridCursor px, py, pmaxy, 8
IF px < pmaxx - 1 THEN px = px + 1
DrawGridBounds pmaxx, pmaxy
DrawGridCursor px, py, pmaxy, 14
GOSUB PlottingCheck
PCOPY 1, 0
RETURN

PlottingCheck:
IF plotting = 1 THEN
      p(px, py) = 1
      DrawUnit px, py, p(px, py) * 15
ELSEIF plotting = 2 THEN
      p(px, py) = 0
      DrawUnit px, py, p(px, py) * 15
END IF
RETURN

InputFontData:
GOSUB CommitGlyphToData
SCREEN , , 0, 0
ClearScreen
LOCATE 3, 1: COLOR 15
PRINT "  Present Font Data:"
PRINT
PRINT "  Internal Name   : "; fontname$
PRINT "  Y Above Baseline:"; cyu
PRINT "  Y Below Baseline:"; cyd
PRINT "  Cursor Height   :"; cyu + cyd + 1
PRINT
PRINT
PRINT "  Please Input New Data:"
PRINT
INPUT "  Internal Name    > ", fontname$
IF LEN(fontname$) > 16 THEN
      fontname$ = LEFT$(fontname$, 16)
      COLOR 12: PRINT "  Name truncated to: "; fontname$
      COLOR 15
ELSE
      fontname$ = LEFT$(fontname$ + "                ", 16)
END IF
INPUT "  Y Above Baseline > ", cyu
INPUT "  Y Below Baseline > ", cyd
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

InputGlyphData:
GOSUB CommitGlyphToData
SCREEN , , 0, 0
ClearScreen
LOCATE 3, 1: COLOR 15
PRINT "  Glyph"; g; "Present Data:"
PRINT
PRINT "  Character:"; gchar(g); "("; CHR$(gchar(g)); ")"
PRINT "  Y-Pos Up:"; gby(g)
PRINT "  Width:   "; gbw(g)
PRINT "  Height:  "; gbh(g)
PRINT
PRINT
PRINT "  Please Input New Data:"
PRINT
INPUT "  Character (Decimal) > ", gchar(g)
PRINT "  New Character       : "; CHR$(gchar(g))
PRINT
INPUT "  Y-Pos Up            > ", gby(g)
INPUT "  Width               > ", gbw(g)
INPUT "  Height              > ", gbh(g)
SCREEN , , 1, 0
GOSUB PrepGlyphGrid
GOTO RedrawEditor

PrevGlyph:
GOSUB CommitGlyphToData
g = g - 1
GOSUB PrepGlyphGrid
GOTO RedrawEditor

NextGlyph:
GOSUB CommitGlyphToData
g = g + 1
GOSUB PrepGlyphGrid
GOTO RedrawEditor

AddGlyph:
IF numglyphs = 128 THEN
      LOCATE 23, 1: COLOR 12: PRINT "  Too many glyphs! Press any key to continue.";
      PCOPY 1, 0
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
      GOTO RedrawEditor
END IF
GOSUB CommitGlyphToData
FOR z = numglyphs TO g + 1 STEP -1
      gd(z) = gd(z - 1)
      gby(z) = gby(z - 1)
      gbw(z) = gbw(z - 1)
      gbh(z) = gbh(z - 1)
      gchar(z) = gchar(z - 1)
NEXT z
numglyphs = numglyphs + 1
g = g + 1
gchar(g) = gchar(g) + 1
GOSUB PrepGlyphGrid
GOTO RedrawEditor

RemoveGlyph:
IF numglyphs < 2 THEN
      LOCATE 23, 1: COLOR 12: PRINT "  Can't remove only glyph! Press any key to continue.";
      PCOPY 1, 0
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
      GOTO RedrawEditor
END IF
FOR z = g TO numglyphs - 1
      gd(z) = gd(z + 1)
      gby(z) = gby(z + 1)
      gbw(z) = gbw(z + 1)
      gbh(z) = gbh(z + 1)
      gchar(z) = gchar(z + 1)
NEXT z
numglyphs = numglyphs - 1
IF g >= numglyphs THEN g = numglyphs - 1
GOSUB PrepGlyphGrid
GOTO RedrawEditor

HelpScreen:
ClearScreen
PRINT "  This is a very simple program for making fonts for use with Deluxe Paint 2E."
PRINT "  You can only create monochrome fonts as colour fonts are not supported."
PRINT "  Loading the fonts which came with DP2E is not recommended, as fonts greater"
PRINT "  than 60 pixels tall may become corrupted."
PRINT
PRINT "  [F1] - Shows this help screen"
PRINT "  [F2] - Create a new font file from scratch"
PRINT "  [F3] - Save the current font to a file that can be read by DP2E"
PRINT "  [F4] - Load an existing DP2E font"
PRINT "  [F5] - Set global data for the font, specifically the name and cursor size"
PRINT "         data, note that DP2E itself shows the filename, not internal name"
PRINT "  [F6] - Set size and positional data for the current glyph"
PRINT
PRINT "  [Arrow Keys] - Move Cursor                    [Spacebar] - Plot/Remove Pixel  "
PRINT "  [Square Brackets] - Change Glyph              [Backspace] - Clear Glyph       "
PRINT "  [+] - Add New Glyph                           [-] - Remove Current Glyph      "
PRINT "  [G] - Goto Gylph #                            [F] - Find Gylph by Character   "
PRINT "  [Z] - Auto-Plot Mode"
PRINT
COLOR 10
PRINT "                     Press any key to return to the editor                     "
PCOPY 1, 0
DO: a$ = INKEY$: LOOP WHILE a$ = ""
GOTO RedrawEditor

NewFont:
IF fileopen <> 0 THEN
      LOCATE 23, 1: COLOR 12: PRINT "  Abandon current font? (y/N)"
      PCOPY 1, 0
      DO: a$ = INKEY$: LOOP WHILE a$ = ""
      IF UCASE$(a$) <> "Y" THEN GOTO RedrawEditor
END IF
fileopen = 1
fontname$ = ""
numglyphs = 1
cyu = 8
cyd = 2
g = 0
gd(0) = ""
gby(0) = 8
gbw(0) = 8
gbh(0) = 0
gchar(0) = 32
GOSUB PrepGlyphGrid
GOTO RedrawEditor

PrepGlyphGrid:
pmaxx = gbw(g)
pmaxy = gbh(g)
IF pmaxy > 0 THEN
      IF px > pmaxx - 1 THEN px = pmaxx - 1
      IF py > pmaxy - 1 THEN py = pmaxy - 1
END IF
FOR z = 0 TO 59
      FOR zz = 0 TO 59
            p(z, zz) = 0
      NEXT zz
NEXT z
ndc = 1
z = 0: zz = 0
IF pmaxy > 0 THEN
      DO WHILE ndc <= LEN(gd(g)) AND zz < pmaxy
            v = ASC(MID$(gd(g), ndc, 1))
            p(z, zz) = (v AND 128) \ 128
            p(z + 1, zz) = (v AND 64) \ 64
            p(z + 2, zz) = (v AND 32) \ 32
            p(z + 3, zz) = (v AND 16) \ 16
            p(z + 4, zz) = (v AND 8) \ 8
            p(z + 5, zz) = (v AND 4) \ 4
            p(z + 6, zz) = (v AND 2) \ 2
            p(z + 7, zz) = (v AND 1)
            z = z + 8: ndc = ndc + 1
            IF z >= gbw(g) THEN
                  z = 0
                  zz = zz + 1
            END IF
      LOOP
END IF
RETURN

CommitGlyphToData:
gd(g) = ""
IF pmaxy > 0 THEN
      FOR zz = 0 TO pmaxy - 1
            z = 0
            DO WHILE z < pmaxx
                  v = p(z, zz) * 128
                  v = v + p(z + 1, zz) * 64
                  v = v + p(z + 2, zz) * 32
                  v = v + p(z + 3, zz) * 16
                  v = v + p(z + 4, zz) * 8
                  v = v + p(z + 5, zz) * 4
                  v = v + p(z + 6, zz) * 2
                  v = v + p(z + 7, zz)
                  gd(g) = gd(g) + CHR$(v)
                  z = z + 8
            LOOP
      NEXT zz
END IF
RETURN

RedrawGridContents:
FOR z = 0 TO 59
      FOR zz = 0 TO 59
            DrawUnit z, zz, p(z, zz) * 15
      NEXT zz
NEXT z
RETURN

QuitProgram:
SCREEN 0, , 0, 0: WIDTH 80, 25: COLOR 7, 0: CLS
SYSTEM

DEFSNG A-Z
SUB ClearScreen
COLOR 15: CLS
LOCATE 1, 1: COLOR 7: PRINT " Deluxe Paint 2E Font Editor                                 (C)2013 Kris Asick ";
LOCATE 25, 1: COLOR 7: PRINT " [F1]=Help   [F2]=New   [F3]=Save   [F4]=Load    [F5]=FileData   [F6]=GlyphData ";
LOCATE 3, 1: COLOR 15
END SUB

DEFINT A-Z
SUB DrawGrid
LINE (170, 24)-(470, 324), 8, B
FOR z = 1 TO 59
LINE (z * 5 + 170, 24)-(z * 5 + 170, 324), 8
LINE (170, z * 5 + 24)-(470, z * 5 + 24), 8
NEXT z
END SUB

SUB DrawGridBounds (x AS INTEGER, y AS INTEGER)
IF y > 0 THEN LINE (170, 24)-(x * 5 + 170, y * 5 + 24), 10, B
END SUB

SUB DrawGridCursor (x AS INTEGER, y AS INTEGER, maxy AS INTEGER, c AS INTEGER)
IF maxy > 0 THEN
      LINE (x * 5 + 170, y * 5 + 24)-(x * 5 + 175, y * 5 + 29), c, B
END IF
END SUB

SUB DrawUnit (x AS INTEGER, y AS INTEGER, c AS INTEGER)
LINE (x * 5 + 171, y * 5 + 25)-(x * 5 + 174, y * 5 + 28), c, BF
END SUB

