DIM names$(10)
names$(1) = "John"
names$(2) = "Debra"
names$(3) = "Kip"
names$(4) = "Napoleon"
names$(5) = "Grandma"
names$(6) = "Pedro"
names$(7) = "Summer"
names$(8) = "Steve"
names$(9) = "Mr. Tennyson"
names$(10) = "Uncle Rico"

'stupid way
PRINT names$(1)
PRINT names$(2)
PRINT names$(3)
PRINT names$(4)
PRINT names$(5)
PRINT names$(6)
PRINT names$(7)
PRINT names$(8)
PRINT names$(9)
PRINT names$(10)
PRINT ""

'smart way
FOR n = 1 TO 10
    PRINT names$(n)
NEXT n
PRINT ""


DIM numbers(101)
FOR n = 1 TO 100
    numbers(n) = RND * 100
NEXT n

FOR A = 1 TO 100
    PRINT numbers(A);
NEXT A


