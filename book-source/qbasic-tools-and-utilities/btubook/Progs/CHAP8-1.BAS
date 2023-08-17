'*********** CHAP8-1.BAS - simple bubble sort

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB BubbleSort (Array$())

CONST NumItems% = 20
CONST False% = 0
CONST True% = -1

DIM Array$(1 TO NumItems%)
FOR X = 1 TO NumItems%
  READ Array$(X)
NEXT

CALL BubbleSort(Array$())

CLS
FOR X = 1 TO NumItems%
  PRINT Array$(X)
NEXT

DATA Zorba, Cathy, Barbara, Kathy, Josephine
DATA Joseph, Joe, Peter, Arnold, Glen
DATA Ralph, Elli, Lucky, Rocky, Louis
DATA Paula, Paul, Mary lou, Marilyn, Keith

SUB BubbleSort (Array$()) STATIC

  DO
    OutOfOrder = False%                 'assume it's sorted
    FOR X = 1 TO UBOUND(Array$) - 1
      IF Array$(X) > Array$(X + 1) THEN
        SWAP Array$(X), Array$(X + 1)   'if we had to swap
        OutOfOrder% = True%             'we're not done yet
      END IF
    NEXT
  LOOP WHILE OutOfOrder%

END SUB
