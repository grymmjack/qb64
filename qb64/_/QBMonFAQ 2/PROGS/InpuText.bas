'***************************************************************************
' INPUTEXT.BAS = Input routine for text input longer than one line
' ============   Eingaberoutine fuer Text, der laenger als eine Zeile ist
'
' Deutsche Beschreibung
' ----------------------------
' Mein folgendes Programm gestattet die Eingabe eines nahezu unendlich
' langen Textes in eine Eingabezeile mit automatischem horizontalen
' Scrolling. Alle relevanten Editiertasten wie Backspace, Cursor
' rechts/links, Einfg, Entfg usw werden unterstützt.
'
' English-language description
' ----------------------------
' These routines will input a line of text of up 32K, within the bounds
' of the window specified.  If more text is inputted than there is room,
' the text scrolls.  Insert, Delete, Home and End keys all perform expected
' functions.  Color is not supported, but could be added without difficulty.
'
' A quirk: Although the text scrolls at 'right', an additional space is
' required for the cursor, and this space -will- overwrite anything at
' that location.  So count on allowing at least one blank space beyond
' 'right'.
'
' This routine works without speed problems on my 386DX/40.. but I have
' not tested on anything slower.  If anybody sees a problem, please let
' me know!

' (c) Jim Little, June 14, 1993
'     This code is not copyrighted.
'     It may be used by anyone for any purpose.
'****************************************************************************
'
DECLARE SUB Printline (topletter AS INTEGER, text AS STRING, left AS INTEGER, right AS INTEGER)
DECLARE SUB cInput (text AS STRING, left AS INTEGER, right AS INTEGER, length AS INTEGER, flag AS INTEGER)
DECLARE SUB GetStroke (keystroke AS INTEGER)
'
'--- ASCII values for some keys, as returned by GetStroke
CONST kBackspace = 8
CONST kTab = 9
CONST kReturn = 13
CONST kEscape = 27
CONST kSpace = 32
CONST kInsert = -82
CONST kDelete = -83
CONST kHome = -71
CONST kEnd = -79
CONST kPageUp = -73
CONST kPageDown = -81
CONST kUpArrow = -72
CONST kDownArrow = -80
CONST kLeftArrow = -75
CONST kRightArrow = -77
'
'--- constants used by 'flag' in cInput
CONST cOk = 0
CONST cUpArrow = 1
CONST cDownArrow = 2
CONST cPageUp = 3
CONST cPageDown = 4
CONST cEscape = 5
CONST cNull = 6   'Note: not returned by cInput
'
CONST False = 0
CONST True = NOT False
'
'--- sample.. delete this and import remainder into your programs.
'--- Beispielprogramm
CLS
LOCATE , 32
PRINT "<-- Input scrolls at this point.";
'
text$ = "This is a test"
cInput text$, 1, 30, 80, flag%
'
PRINT : PRINT
PRINT "Text recieved: "; text$
PRINT
PRINT "Input terminated with ";
SELECT CASE flag%
   CASE cOk
      PRINT "a return."
   CASE cUpArrow
      PRINT "the up arrow."
   CASE cDownArrow
      PRINT "the down arrow."
   CASE cPageUp
      PRINT "a page up."
   CASE cPageDown
      PRINT "a page down."
   CASE cEscape
      PRINT "escape."
   CASE cNull
      PRINT "null.  (Wait.. that isn't possible!)"
END SELECT

'
'
SUB cInput (text AS STRING, left AS INTEGER, right AS INTEGER, length AS INTEGER, flag AS INTEGER)
' Controlled input of text.  Inputs string of text on current line, starting at
' left and continuing to right.  If length is longer than space allows, text
' scrolls to left.
'
' Flag is set to Cescape, CupArrow, CdownArrow, CpageUp, CpageDown, or Cok
' depending on what key the user used to terminate input.
' Cok signifies normal (return) termination.
'
DIM topletter AS INTEGER               'letter at left of window
DIM curletter AS INTEGER               'letter at cursor position
DIM finished AS INTEGER                'true if user finished typing line
DIM keystroke AS INTEGER               'user's last keystroke
DIM tabsp AS INTEGER                   'number of spaces to tab when Tab pressed
STATIC notinsert AS INTEGER            'false if insert is on,  true otherwise

text = RTRIM$(text)        'trim off all extra spaces
topletter = 1
curletter = 1
finished = False
Printline 1, text, left, right

'following in case cursor size changes between calls
IF NOT notinsert THEN
   LOCATE , , , 4, 5  'change cursor size to large block
ELSE
   LOCATE , , , 0, 5    'change cursor size to thin line
END IF
DO
   LOCATE , left + curletter - topletter, 1
   GetStroke keystroke
   LOCATE , , 0
   SELECT CASE keystroke
   CASE kInsert
      notinsert = NOT notinsert
      IF NOT notinsert THEN
         LOCATE , , , 4, 5  'change cursor size to thin line
      ELSE
         LOCATE , , , 0, 5    'change cursor size to large block
      END IF
   CASE kDelete
      IF LEN(text) >= 1 AND curletter <> LEN(text) + 1 THEN
         MID$(text, curletter) = MID$(text, curletter + 1)
         text = LEFT$(text, LEN(text) - 1)
         Printline topletter, text, left, right
      END IF
   CASE kBackspace
      IF curletter > 1 THEN
         text = LEFT$(text, curletter - 2) + RIGHT$(text, LEN(text) - curletter + 1)
         curletter = curletter - 1
         IF curletter < topletter THEN
            topletter = topletter - 1
         END IF
         Printline topletter, text, left, right
      END IF
   CASE kHome
      IF curletter > 1 THEN
         curletter = 1
         IF curletter < topletter THEN
            topletter = 1
         Printline topletter, text, left, right
         END IF
      END IF
   CASE kEnd
      IF curletter < LEN(text) + 1 THEN
         curletter = LEN(text) + 1
         IF curletter > topletter + right - left THEN
            topletter = LEN(text) - right + left + 1
            Printline topletter, text, left, right
         END IF
      END IF
   CASE kLeftArrow
      IF curletter > 1 THEN
         curletter = curletter - 1
         IF curletter < topletter THEN
            topletter = topletter - 1
            Printline topletter, text, left, right
         END IF
      END IF
   CASE kRightArrow
      IF curletter < LEN(text) + 1 THEN
         curletter = curletter + 1
         IF curletter > topletter + right - left THEN
            topletter = topletter + 1
            Printline topletter, text, left, right
         END IF
      END IF
   CASE kPageUp
      flag = cPageUp
      finished = True
   CASE kPageDown
      flag = cPageDown
      finished = True
   CASE kUpArrow
      flag = cUpArrow
      finished = True
   CASE kDownArrow
      flag = cDownArrow
      finished = True
   CASE kEscape
      flag = cEscape
      finished = True
   CASE IS >= 32
      IF keystroke <= 127 AND NOT notinsert AND LEN(text) + 1 <= length THEN
      'valid character, with insert on
         text = LEFT$(text, curletter - 1) + CHR$(keystroke) + RIGHT$(text, LEN(text) - curletter + 1)
         curletter = curletter + 1
         IF curletter > topletter + right - left + 1 THEN
            topletter = topletter + 1
         END IF
         Printline topletter, text, left, right
      END IF
      IF keystroke <= 127 AND notinsert AND (curletter < LEN(text) + 1 OR LEN(text) + 1 <= length) THEN
      'valid character, with insert off
         IF curletter = LEN(text) + 1 THEN
            text = text + CHR$(keystroke)
         ELSE
            MID$(text, curletter, 1) = CHR$(keystroke)
         END IF
         curletter = curletter + 1
         IF curletter > topletter + right - left THEN
            topletter = topletter + 1
            Printline topletter, text, left, right
         ELSE
            PRINT CHR$(keystroke);
         END IF
      END IF
   CASE kTab
      IF length <> LEN(text) THEN
         IF LEN(text) + 3 <= length THEN
            tabsp = 3
         ELSE
            tabsp = length - LEN(text)
         END IF
         text = LEFT$(text, curletter - 1) + STRING$(tabsp, 32) + RIGHT$(text, LEN(text) - curletter + 1)
         curletter = curletter + tabsp
         IF curletter > topletter + right - left THEN
            topletter = topletter + tabsp
         END IF
         Printline topletter, text, left, right
      END IF
   CASE kReturn
      flag = cOk
      finished = True
   END SELECT
'
LOOP UNTIL finished

Printline 1, text, left, right
END SUB

'
'
SUB GetStroke (keystroke AS INTEGER)
'waits for then returns single character as integer.  Extended keystrokes
' returned as a negative.  (See CONST definitions).

DIM k AS STRING                        'key inputted

DO
   k = INKEY$
LOOP UNTIL LEN(k)
IF LEFT$(k, 1) = CHR$(0) THEN
   keystroke = ASC(MID$(k, 2)) * -1
ELSE
   keystroke = ASC(k)
END IF

END SUB

DEFINT A-Z
SUB Printline (topletter AS INTEGER, text AS STRING, left AS INTEGER, right AS INTEGER)
'prints a line of text, starting with topletter,
'within the bounds of left and right

LOCATE , left
PRINT MID$(text, topletter, right - left + 1); SPC(right - POS(0) + 2);
END SUB

