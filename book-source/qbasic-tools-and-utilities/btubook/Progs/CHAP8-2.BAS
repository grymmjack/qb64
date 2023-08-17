'*********** CHAP8-2.BAS - simple indexed bubble sort

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB BubbleISort (Array$(), Index())

CONST NumItems% = 20
CONST False% = 0
CONST True% = -1

DIM Array$(1 TO NumItems%)  'this holds the string data
DIM Ndx(1 TO NumItems%)     'this holds the index

FOR X = 1 TO NumItems%
  READ Array$(X)            'read the string data
  Ndx(X) = X                'initialize the index array
NEXT

CALL BubbleISort(Array$(), Ndx())

CLS
FOR X = 1 TO NumItems%
  PRINT Array$(Ndx(X))      'print based on the index
NEXT

DATA Zorba, Cathy, Barbara, Kathy, Josephine
DATA Joseph, Joe, Peter, Arnold, Glen
DATA Ralph, Elli, Lucky, Rocky, Louis
DATA Paula, Paul, Mary lou, Marilyn, Keith

SUB BubbleISort (Array$(), Index()) STATIC

DO
  OutOfOrder = False%                 'assume it's sorted
  FOR X = 1 TO UBOUND(Array$) - 1
    IF Array$(Index(X)) > Array$(Index(X + 1)) THEN
      SWAP Index(X), Index(X + 1)     'if we had to swap
      OutOfOrder% = True%             'we're not done yet
    END IF
  NEXT
LOOP WHILE OutOfOrder%

END SUB
