'********** EVALUATE.BAS - simple expression evaluator

'Copyright (c) 1992 Ethan Winer

DECLARE FUNCTION Evaluate# (Formula$)

INPUT "Enter an expression: ", Expr$
PRINT "That evaluates to"; Evaluate#(Expr$)

FUNCTION Evaluate# (Formula$)

  'Search for an operator using INSTR as a
  'table lookup.  If found, remember which
  'one and also its position in the string.
  FOR Position% = 1 TO LEN(Formula$)
    Operation% = INSTR("+-*/", MID$(Formula$, Position%, 1))
    IF Operation% THEN EXIT FOR
  NEXT

  'Get the value of the left part, and a
  'tentative value for the right portion.
  LeftVal# = VAL(Formula$)
  RightVal# = VAL(MID$(Formula$, Position% + 1))

  'See if there's another level to evaluate.
  Paren% = INSTR(Position%, Formula$, "(")

  'If there is, call ourself for a new RightVal#.
  IF Paren% THEN RightVal# = Evaluate#(MID$(Formula$, Paren% + 1))

  'No more to evaluate.  Perform the appropriate
  'operation and exit.
  SELECT CASE Operation%
    CASE 1
      Evaluate# = LeftVal# + RightVal#
    CASE 2
      Evaluate# = LeftVal# - RightVal#
    CASE 3
      Evaluate# = LeftVal# * RightVal#
    CASE 4
      Evaluate# = LeftVal# / RightVal#
  END SELECT

END FUNCTION
