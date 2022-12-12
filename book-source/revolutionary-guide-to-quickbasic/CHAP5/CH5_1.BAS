REM  PROGRAM CH5_1
REM  *************************************************
REM  * Checking the Validity of Brackets Arrangement *
REM  * in an Expression                              *
REM  *************************************************

DECLARE FUNCTION OutStack$ (S() AS STRING)     'The data types of OutStack
DECLARE SUB InStack (S() AS STRING, x$)        'and InStack are redefined
DECLARE FUNCTION EmptyStack! ()                'as required
DECLARE FUNCTION CBracket$ (x$)

DIM SHARED Top, DeepStack

CONST True = -1
CONST false = NOT True

CLS
PRINT "Checking the validity of the arrangement of brackets in an expression"

PRINT
Sign = True                          'Sign of the validity of an expression
PRINT "Enter an expression:"
INPUT "", Expression$
DeepStack = LEN(Expression$)         'The depth of the stack set by expression length
DIM S(DeepStack) AS STRING           'The array for the character stack
Top = 0
I% = 1
WHILE I% <= LEN(Expression$) AND Sign = True
  Symb$ = MID$(Expression$, I%, 1)
  IF Symb$ = "(" OR Symb$ = "[" OR Symb$ = "{" THEN
    CALL InStack(S(), Symb$)         'Push open parenthesis onto stack
  END IF
  IF Symb$ = ")" OR Symb$ = "]" OR Symb$ = "}" THEN
    IF EmptyStack THEN               'Expression incorrect if stack empty
      Sign = false                   'and close parentheses are being processed
    ELSE
      Symb1$ = OutStack$(S())        'Pop top element off the stack
      IF CBracket$(Symb1$) <> Symb$ THEN
        Sign = false 'a character does not correspond to an opening bracket
                                     'Compare parenthesis with "pair" element
                                     'of call to stack Symbl$
      END IF
    END IF
  END IF
  I% = I% + 1
WEND
IF NOT EmptyStack THEN
  Sign = false                       'Last check - is stack empty at end
END IF                               'of expression?
IF Sign = True THEN
  PRINT "Brackets are arranged correctly"
ELSE
  PRINT "Brackets are arranged incorrectly"
END IF
END

FUNCTION CBracket$ (x$)
' ** A Corresponding Bracket **
  SELECT CASE x$
    CASE "("
      CBracket$ = ")"
    CASE "["
      CBracket$ = "]"
    CASE "{"
      CBracket$ = "}"
    CASE ")"
      CBracket$ = "("
    CASE "]"
      CBracket$ = "["
    CASE "}"
      CBracket$ = "{"
  END SELECT
END FUNCTION

FUNCTION EmptyStack
  IF Top = 0 THEN
    EmptyStack = True
  ELSE
    EmptyStack = false
  END IF
END FUNCTION

SUB InStack (S() AS STRING, x$)
  IF Top = DeepStack THEN
    PRINT "Error: Stack is full!"
    STOP
  ELSE
    Top = Top + 1
    S(Top) = x$
  END IF
END SUB

FUNCTION OutStack$ (S() AS STRING)
  IF Top = 0 THEN
    PRINT : PRINT "Error: Stack is empty!"
  STOP
  ELSE
    OutStack$ = S(Top)
    Top = Top - 1
  END IF
END FUNCTION

