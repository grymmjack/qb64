'***************************************************************************
' SHOPLIST.BAS Demo fuer laengenbegrenzte Tastatureingaben in Tabellenfelder
' ============
' Edit function for easy input of strings.
'
' (c) Wouter Bergmann Tiest  - W.M.BergmannTiest*fys.ruu.nl
'     8th December 1995
'***************************************************************************
'To use this function, replace the code between the dashed lines with your
'own.
'
DEFINT A-Z
DECLARE FUNCTION Edit (Column, Row, Length, Text$)
'
'Colours (light grey and blue) and ASCII or scan codes of keys
CONST FgCol = 7, BgCol = 1, Enter = 13, Escape = 27, UpArrow = 72
CONST DownArrow = 80, LeftArrow = 75, RightArrow = 77, Home = 71
CONST EndKey = 79, Ins = 82, Del = 83, Backspace = 8
'
'----------------------------------------------------------------------------
'The following code is an example of the use of the Edit function.
'It is an input routine for a shopping list, with two fields:
'Item and Price. After input, the list is printed on screen.
'
'The dimensions of the shopping list
CONST ItemLength = 20, PriceLength = 10, NumberOfItems = 10
CONST FirstRow = 5, ItemColumn = 5, PriceColumn = ItemColumn + ItemLength + 2
CONST NumberOfFields = 2, ItemField = 1, PriceField = 2
'
'The items and prices are stored in two arrays
DIM Item$(1 TO NumberOfItems), Price$(1 TO NumberOfItems)
'
'The screen is set up
COLOR FgCol, BgCol
CLS
PRINT "Please enter your shopping list below."
PRINT "Use arrow keys, Enter, Ins, Del, Home, End and BackSpace for editing."
PRINT "Press Escape when ready."
LOCATE FirstRow, ItemColumn
PRINT "Item"
LOCATE FirstRow, PriceColumn
PRINT "Price"
FOR Counter = 1 TO NumberOfItems
  LOCATE Counter + FirstRow, 1
  PRINT USING "##."; Counter
NEXT Counter
'
'Initial values
FieldCounter = ItemField
ItemCounter = 1
'
'Main loop of input routine
DO
  SELECT CASE FieldCounter
    CASE ItemField
      KeyPressed = Edit(ItemColumn, ItemCounter + FirstRow, ItemLength, Item$(ItemCounter))
    CASE PriceField
      KeyPressed = Edit(PriceColumn, ItemCounter + FirstRow, PriceLength, Price$(ItemCounter))
  END SELECT
  SELECT CASE KeyPressed
    CASE UpArrow
      ItemCounter = ItemCounter - 1
      IF ItemCounter < 1 THEN ItemCounter = NumberOfItems
    CASE DownArrow
      ItemCounter = ItemCounter + 1
      IF ItemCounter > NumberOfItems THEN ItemCounter = 1
    CASE Enter
      FieldCounter = FieldCounter + 1
      IF FieldCounter > NumberOfFields THEN
        FieldCounter = 1
        ItemCounter = ItemCounter + 1
        IF ItemCounter > NumberOfItems THEN ItemCounter = 1
      END IF
  END SELECT
LOOP UNTIL KeyPressed = Escape
'
'Printing the data
CLS
PRINT "This is your shopping list:"
PRINT
FOR Counter = 1 TO NumberOfItems
  PRINT USING "##."; Counter;
  LOCATE , ItemColumn
  PRINT Item$(Counter);
  LOCATE , PriceColumn
  PRINT Price$(Counter)
NEXT Counter
'
END
'----------------------------------------------------------------------------

FUNCTION Edit (Column, Row, Length, Text$)
'This function takes two screen coordinates (Row, Column) and paints an
'edit field in reverse video of length Length with Text$ as default value.
'The text can be edited using the left and right arrow keys, Home, End, Del
'and Backspace. Ins switches between insert mode (default) and typeover mode.
'On completion, the parameter Text$ contains the edited string.
'The function returns the ASCII or scan code of the key that was used to
'end the editing (can be up or down arrow, Enter or Escape).
'
  'Initial values
  KeyPressed = 0
  InsertSwitch = -1 'True
  COLOR BgCol, FgCol
  Position = LEN(Text$)
'
  'Main loop
  DO
    LOCATE Row, Column, 0
    PRINT Text$; SPACE$(Length - LEN(Text$));
    IF InsertSwitch = -1 THEN
      LOCATE Row, Position + Column, 1, 7, 8 'Line cursor
    ELSE
      LOCATE Row, Position + Column, 1, 0, 8 'Block cursor
    END IF
    DO
      Key$ = INKEY$
    LOOP WHILE Key$ = ""
    SELECT CASE ASC(Key$)
      CASE Escape
        KeyPressed = Escape
      CASE Enter
        KeyPressed = Enter
      CASE Backspace
        IF Position > 0 THEN
          Text$ = LEFT$(Text$, Position - 1) + RIGHT$(Text$, LEN(Text$) - Position)
          Position = Position - 1
        END IF
      CASE 0 'Extended codes
        SELECT CASE ASC(RIGHT$(Key$, 1))
         CASE Home
            Position = 0
          CASE LeftArrow
            IF Position > 0 THEN Position = Position - 1
          CASE RightArrow
            IF Position < LEN(Text$) THEN Position = Position + 1
          CASE EndKey
            Position = LEN(Text$)
          CASE Del
            IF Position < LEN(Text$) THEN Text$ = LEFT$(Text$, Position) + RIGHT$(Text$, LEN(Text$) - Position - 1)
          CASE Ins
            InsertSwitch = -1 - InsertSwitch
          CASE UpArrow
            KeyPressed = UpArrow
          CASE DownArrow
            KeyPressed = DownArrow
        END SELECT
      CASE IS >= 32 'Normal characters
        IF InsertSwitch = -1 THEN
          IF LEN(Text$) < Length THEN
            Text$ = LEFT$(Text$, Position) + Key$ + RIGHT$(Text$, LEN(Text$) - Position)
            Position = Position + 1
          END IF
        ELSEIF Position < Length THEN
          IF Position = LEN(Text$) THEN
            Text$ = Text$ + Key$
          ELSE
            MID$(Text$, Position + 1, 1) = Key$
          END IF
          Position = Position + 1
        END IF
    END SELECT
  LOOP UNTIL KeyPressed > 0
  LOCATE Row, Column, 0
  COLOR FgCol, BgCol
  PRINT Text$; SPACE$(Length - LEN(Text$));
  Edit = KeyPressed
END FUNCTION

