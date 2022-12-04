REM Calculating an Arithmetic Expression
REM \CHAP7\CH7_1.BAS

DECLARE SUB AddIdent (IdentVar$)
DECLARE SUB BinaryOp (OpChar$)
DECLARE SUB CalcExpression ()
DECLARE SUB GetFromStack (Margin$)
DECLARE FUNCTION ICP% (OpChar$)
DECLARE SUB InExpression ()
DECLARE SUB InfToPostf ()
DECLARE SUB InStackVl (Value AS DOUBLE)
DECLARE SUB InStackCh (OpChar$)
DECLARE SUB InValues ()
DECLARE FUNCTION ISP% ()
DECLARE FUNCTION NewIdent$ (TestIdent$)
DECLARE FUNCTION NoIdent$ (TestIdent$)
DECLARE SUB OutStackVl (NOp%)
DECLARE SUB OutStackCh (DelCh$)
DECLARE SUB PutToStack (OpChar$)
DECLARE SUB ReplUnaryMinus ()
DECLARE SUB StopError (Message%, Symbol$)
DECLARE SUB TestExpression ()
DECLARE SUB UnaryMinus ()
    '************************************************************
    '*  Program of Calculating Arithmetic Expressions           *
    '************************************************************
' Declaration of variables
' A record containing variable identifier and value
TYPE IdVal
       Ident AS STRING * 2
       Value AS DOUBLE
END TYPE
' Common variables:
'     - array of records for 20 variables,
'     - number of variables in an expression,
'     - source expression,
'     - the exprerssion in a postfix form
DIM SHARED IVArray(20) AS IdVal, NIdent%, ExpressVar$, PostExpress$
'     - character array to organize a stack of operations,
'     - numeric array to organize a stack of operands,
'     - a variable for storing stack top's index
DIM SHARED OpStack(20) AS STRING * 1, ValStack(20) AS DOUBLE, HeadStack%
'     - array for the values of the first and of the second operand
DIM SHARED Operand(2) AS DOUBLE
ON ERROR GOTO BadOp
InExpression
TestExpression
InfToPostf
InValues
CalcExpression
PRINT
PRINT ExpressVar$; "=";
PRINT USING "######.##"; ValStack(1)
END
BadOp:
  StopError ERR, ""
  RESUME NEXT
END

' Subprogram of adding a next identifier
' Input parameter IdentVar$ transmits a next
' identifier
' If it is valid and is encountered for the first
' time, it pushed into the stack
SUB AddIdent (IdentVar$)
  IF NoIdent$(IdentVar$) = "TRUE" THEN
    StopError 1, IdentVar$
  END IF
  IF NIdent% = 0 THEN
    NIdent% = NIdent% + 1
    IVArray(NIdent%).Ident = IdentVar$
  ELSEIF NewIdent$(IdentVar$) = "TRUE" THEN
      NIdent% = NIdent% + 1
      IVArray(NIdent%).Ident = IdentVar$
  END IF
END SUB

'    The subprogram performs a binary operation
' It retrieves from stack two values and stores in stack
' the result of the operation over them
SUB BinaryOp (OpChar$)
  OutStackVl 2
  OutStackVl 1
  SELECT CASE OpChar$
   CASE "+"
     InStackVl Operand(1) + Operand(2)
   CASE "-"
     InStackVl Operand(1) - Operand(2)
   CASE "*"
     InStackVl Operand(1) * Operand(2)
   CASE "/"
     InStackVl Operand(1) / Operand(2)
   CASE "^"
     InStackVl Operand(1) ^ Operand(2)
   END SELECT
END SUB

'     Subprogram of calculating the expression
'     after its converting into a postfix form
SUB CalcExpression
'     Local variables:
'     - CurrentChar$ - for a current character of expression
'     - CurrentIdent$ - for a current identifier of expression
  HeadStack% = 0
  FOR i% = 1 TO LEN(PostExpress$)
    CurrentChar$ = MID$(PostExpress$, i%, 1)
    SELECT CASE CurrentChar$
      CASE "A" TO "H"
        CurrentIdent$ = CurrentChar$
      CASE "1" TO "9"
        CurrentIdent$ = CurrentIdent$ + CurrentChar$
        FOR j% = 1 TO NIdent%
          IF CurrentIdent$ = IVArray(j%).Ident THEN
            InStackVl IVArray(j%).Value
          END IF
        NEXT j%
      CASE "+", "-", "*", "/", "^"
        BinaryOp CurrentChar$
      CASE "~"
        UnaryMinus
      END SELECT
    NEXT i%
END SUB

' Subprogram of popping the contents of the stack
' of operations up to the boundary character
' transmitted in the input parameter Margin$
SUB GetFromStack (Margin$)
  WHILE OpStack(HeadStack%) <> Margin$
    OutStackCh DelCh$
    PostExpress$ = PostExpress$ + DelCh$
  WEND
  OutStackCh DelCh$
END SUB

'     Function of calculating priority of
'     a current sign of operation.
'     Input parameter  OpChar$ contains the sign
'     of operation to be tested
FUNCTION ICP% (OpChar$)
  SELECT CASE OpChar$
    CASE "("
      ICP% = 0
    CASE "~"
      ICP% = 1
    CASE "^"
      ICP% = 2
    CASE "*", "/"
      ICP% = 3
    CASE "+", "-"
      ICP% = 4
  END SELECT
END FUNCTION

'    Subroutine of entering an expression and
'    of its preparing for transformation
SUB InExpression
  CLS
  LOCATE 2, 3
  INPUT "Expression>", ExpressVar$
  ExpressVar$ = UCASE$(ExpressVar$)
  FOR i% = 1 TO LEN(ExpressVar$)
    IF MID$(ExpressVar$, i%, 1) = " " THEN
      Rear$ = RIGHT$(ExpressVar$, LEN(ExpressVar$) - i%)
      ExpressVar$ = LEFT$(ExpressVar$, i% - 1) + Rear$
    END IF
  NEXT i%
  ReplUnaryMinus
END SUB

'     Subroutine of converting the source expression
'     into a postfix record
SUB InfToPostf

  ' Preparing stack:
  HeadStack% = 1
  ' First character - indication of an empty stack
  OpStack(1) = "#"
  PostExpress$ = ""
  ' Scanning the source expression
  FOR i% = 1 TO LEN(ExpressVar$)
    CurrentChar$ = MID$(ExpressVar$, i%, 1)
    SELECT CASE CurrentChar$
      CASE "A" TO "Z", "1" TO "9"
        ' Identifiers in a postfix expression
        PostExpress$ = PostExpress$ + CurrentChar$
      CASE ")"
        ' Popping up operation till the first opening bracket "("
        GetFromStack "("
      CASE ELSE
        ' A sign of operation is met, push it into stack
        PutToStack CurrentChar$
    END SELECT
  NEXT i%
  'Extracting remaining operations from stack
   GetFromStack "#"
   PRINT PostExpress$
END SUB

'    Subroutine of adding a sign of operation to the stack
'    Input parameter  OpChar$ contains the character
'    to be added
SUB InStackCh (OpChar$)
  HeadStack% = HeadStack% + 1
  OpStack(HeadStack%) = OpChar$
END SUB

'     Subprogram of pushing a variable value into the stack
SUB InStackVl (Value AS DOUBLE)
  HeadStack% = HeadStack% + 1
  ValStack(HeadStack%) = Value
END SUB

'     Subprogram of entering variable values
SUB InValues
  FOR i% = 1 TO NIdent%
    LOCATE i% + 3, 10
    PRINT IVArray(i%).Ident + "="
    LOCATE i% + 3, 13
    INPUT "", IVArray(i%).Value
  NEXT i%
END SUB

'    Function of calculating intrastack priority
'    of operation, the sign of which is in the top of stack
FUNCTION ISP%
   SELECT CASE OpStack(HeadStack%)
     CASE "~"
       ISP% = 1
     CASE "^"
       ISP% = 2
     CASE "*", "/"
       ISP% = 3
     CASE "+", "-"
       ISP% = 4
     CASE "(", "#"
       ISP% = 5
   END SELECT
END FUNCTION

'    Pseudologic function determining
'    "the newness" of a current identifier.
'    If the identifier had been already met, the function
'    returns FALSE
'    Input parameter TestIdent$ contains the variable
'    identifier
FUNCTION NewIdent$ (TestIdent$)
 NewIdent$ = "TRUE"
 FOR i% = 1 TO NIdent%
   IF TestIdent$ = IVArray(i%).Ident THEN
     NewIdent$ = "FALSE"
     EXIT FOR
   END IF
 NEXT i%
END FUNCTION

'    Pseudologic function determining
'    the validity of current identifier.
'    If the identifier is invalid, the function returns
'    FALSE
'    Input parameter TestIdent$ contains the variable
'    identifier
FUNCTION NoIdent$ (TestIdent$)
  NoIdent$ = "TRUE"
  IF LEN(TestIdent$) = 2 THEN
    IdentChar1$ = MID$(TestIdent$, 1, 1)
    IdentChar2$ = MID$(TestIdent$, 2, 1)
    IF IdentChar1$ >= "A" AND IdentChar2$ <= "9" THEN
      NoIdent$ = "FALSE"
    END IF
  END IF
END FUNCTION

'     Subprogram of extracting a character from the stack
SUB OutStackCh (DelCh$)
  DelCh$ = OpStack(HeadStack%)
  HeadStack% = HeadStack% - 1
END SUB

'     Subprogram of popping from stack a variable value
'     Input parameter  NOp% contains an operand's index-number
'     into which the variable value is chosen
SUB OutStackVl (NOp%)
  Operand(NOp%) = ValStack(HeadStack%)
  HeadStack% = HeadStack% - 1
END SUB

'    Subprogram of pushing into stack a current sign
'    of operation
'    The output parameter OpChar$ accepts a character to be deleted
SUB PutToStack (OpChar$)
  Ch$ = OpStack(HeadStack%)
  WHILE ISP% < ICP%(OpChar$)
    OutStackCh DelCh$
    PostExpress$ = PostExpress$ + DelCh$
  WEND
  InStackCh OpChar$
END SUB

'    Subroutine of replacing an unary minus by a special
'    character ~
SUB ReplUnaryMinus
  FOR i% = 1 TO LEN(ExpressVar$)
    IF MID$(ExpressVar$, i%, 1) = "-" THEN
      ' Either a minus starting the expression is replaced, or the one
      ' preceeded by an opening bracket
      IF i% = 1 OR i% > 1 AND MID$(ExpressVar$, i% - 1, 1) = "(" THEN
        MID$(ExpressVar$, i%, 1) = "~"
      END IF
    END IF
  NEXT i%
END SUB

'     Subprogram of printing error messages
'     Source parameters:
'     Message% - error number
'     Symbol$ - text for output
SUB StopError (Message%, Symbol$)
  SELECT CASE Message%
    CASE 1
      MessageString$ = "Invalid identifier " + Symbol$
    CASE 2
      MessageString$ = "Invalid character " + Symbol$
    CASE 3
      MessageString$ = "Unbalanced ( )"
    CASE 5
      MessageString$ = "Illegal operands in ^"
    CASE 11
      MessageString$ = "Division by zero"
  END SELECT
  PRINT MessageString$ + ". Program Halted!"
  END
END SUB

'    Subroutine of checking the source expression
'    for syntax correctness
'     Local variables:
'     - CurrentChar$ - for a current character
'     - CurrentIdent$ - for a current identifier
'     - OpenBracket% - number of opening brackets
'     - CloseBracket% -number of closing brackets
SUB TestExpression
  'Setting up initial conditions
  NIdent% = 0
  CurrentIdent$ = ""
  CurrentChar$ = ""
  OpenBrackets% = 0
  CloseBrackets% = 0
  FOR i% = 1 TO LEN(ExpressVar$)
    CurrentChar$ = MID$(ExpressVar$, i%, 1)
    SELECT CASE CurrentChar$
      CASE "A" TO "H", "1" TO "9"
        'Forming an identifier
        CurrentIdent$ = CurrentIdent$ + CurrentChar$
      CASE "+", "-", "*", "/", "^"
        'Adding the identifier to the array IdVal
        AddIdent CurrentIdent$
        CurrentIdent$ = ""
      CASE "("
        'Counting the number of opening brackets
        OpenBrackets% = OpenBrackets% + 1
      CASE ")"
        'Counting the number of closing brackets
        CloseBrackets% = CloseBrackets% + 1
      CASE "~"
' Skiping unary minus
      CASE ELSE
        ' An inadmissible character is encountered
        StopError 2, CurrentChar$
    END SELECT
  NEXT i%
  'Adding the last identifier to the IdVal array
  IF LEN(CurrentIdent$) > 0 THEN
    AddIdent CurrentIdent$
  END IF
  IF CloseBrackets% <> OpenBrackets% THEN
    'Brackets are arranged wrong
    StopError 3, ""
  END IF
END SUB

'   Subprogram of popping a variable value from stack and
'   pushing to stack the inverted value
SUB UnaryMinus
  OutStackVl 1
  InStackVl Operand(1) * (-1)
END SUB

