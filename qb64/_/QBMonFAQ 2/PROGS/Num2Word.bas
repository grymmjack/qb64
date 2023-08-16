'**************************************************************************
' NUM2Word.BAS = Converts a numerical Dollar value to a string
' ============   Konvertiert einen numerischen Dollarbetrag in Text
'
' This function takes a number up to 99999.99 and returns
' a string in the form of
'
' "Ninety Nine Thousand Nine Hundred Ninety Nine Dollars and 99/100"  .
'
' If the pad% parameter is TRUE (e.g.pad%  = 1) then the
' string is centered in a string of ***asteriks*** and will always be 72
' characters long.
'
' Please don't make fun of my variable names, I just threw
' this together because I needed it at the time You are free to use or
' modify this in any way you wish.
'
'*************************************************************************
'
DECLARE FUNCTION monstring$ (cash AS SINGLE, pad%)
CLS
INPUT "Enter a number with a decimal point $ "; number
PRINT monstring(number, 1)
'

'
FUNCTION monstring$ (cash AS SINGLE, pad%)
IF cash < 0 THEN
monstring$ = ""
EXIT FUNCTION
END IF
DIM one$(10), ten$(9), teen$(9)
one$(0) = "": one$(1) = "One ": one$(2) = "Two ": one$(3) = "Three "
one$(4) = "Four ": one$(5) = "Five ": one$(6) = "Six ": one$(7) = "Seven "
one$(8) = "Eight ": one$(9) = "Nine ": one$(10) = "Ten "
ten$(1) = "Ten ": ten$(2) = "Twenty ": ten$(3) = "Thirty ": ten$(4) = "Forty "
ten$(5) = "Fifty ": ten$(6) = "Sixty ": ten$(7) = "Seventy ":
ten$(8) = "Eighty ": ten$(9) = "Ninety "

teen$(1) = "Eleven ": teen$(2) = "Twelve ": teen$(3) = "Thirteen "
teen$(4) = "Fourteen ": teen$(5) = "Fifteen ": teen$(6) = "Sixteen "
teen$(7) = "Seventeen ": teen$(8) = "Eighteen ": teen$(9) = "Nineteen "

cccash$ = LTRIM$(STR$(cash))
ll! = LEN(cccash$)
lw! = INSTR(cccash$, ".")
IF ll! - lw! < 2 THEN cccash$ = cccash$ + "0"
IF lw! = 0 THEN
cccash$ = cccash$ + ".00": lw! = ll!
ELSE
lw! = lw! - 1
END IF
IF lw! > 5 THEN
monstring$ = STRING$(72, 32)
EXIT FUNCTION
END IF
ccccash$ = LEFT$(cccash$, lw!)
ccash! = VAL(LEFT$(cccash$, lw!))
SELECT CASE lw!
    CASE 1
        temp$ = one$(ccash!)
    CASE 2
        SELECT CASE ccash!
            CASE 11 TO 19
            temp$ = teen$(ccash! - 10)
            CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
            temp$ = ten$(ccash! \ 10)
            CASE ELSE
            temp$ = ten$(ccash! \ 10) + one$(VAL(RIGHT$(STR$(ccash!), 1)))
            END SELECT
    CASE 3
        SELECT CASE ccash!
            CASE 100, 200, 300, 400, 500, 600, 700, 800, 900
            temp$ = one$(ccash! \ 100) + "Hundred "
            CASE ELSE
            temp$ = one$(ccash! \ 100) + "Hundred "
            crash! = VAL(RIGHT$(ccccash$, 2))
                SELECT CASE crash!
                CASE 0 TO 10
                    temp$ = temp$ + one$(crash!)
                CASE 11 TO 19
                    temp$ = teen$(crash! - 10)
                CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
                    temp$ = temp$ + ten$(crash! \ 10)
                CASE ELSE
                    temp$ = temp$ + ten$(crash! \ 10) + one$(VAL(RIGHT$(STR$(crash!), 1)))
                END SELECT
            END SELECT
    CASE 4
        SELECT CASE ccash!
            CASE 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000
                temp$ = one$(ccash! \ 1000) + "Thousand "
            CASE 1100 TO 1999
                temp$ = teen$(ccash! \ 100 - 10) + "Hundred "
                crash! = VAL(RIGHT$(ccccash$, 2))
                SELECT CASE crash!
                    CASE 0 TO 10
                        temp$ = temp$ + one$(crash!)
                    CASE 11 TO 19
                        temp$ = teen$(crash! - 10)
                    CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
                        temp$ = temp$ + ten$(crash! \ 10)
                    CASE ELSE
                        temp$ = temp$ + ten$(crash! \ 10) + one$(VAL(RIGHT$(STR$(crash!), 1)))
                END SELECT
            CASE 2001 TO 9999
                part1 = VAL(LEFT$(ccccash$, 2))
                crash! = VAL(RIGHT$(ccccash$, 2))
                SELECT CASE part1
                    CASE 20, 30, 40, 50, 60, 70, 80, 90
                        temp$ = one$(part1 \ 10) + "Thousand "
                    CASE ELSE
                    temp$ = ten$(part1 \ 10) + one$(VAL(MID$(ccccash$, 2, 1))) + "Hundred "
                    END SELECT
                SELECT CASE crash!
                    CASE 0 TO 10
                        temp$ = temp$ + one$(crash!)
                    CASE 11 TO 19
                        temp$ = teen$(crash! - 10)
                    CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
                        temp$ = temp$ + ten$(crash! \ 10)
                    CASE ELSE
                        temp$ = temp$ + ten$(crash! \ 10) + one$(VAL(RIGHT$(STR$(crash!), 1)))
                END SELECT
            CASE ELSE
            END SELECT
    CASE 5
        part1 = VAL(LEFT$(ccccash$, 2))
        part2 = VAL(MID$(ccccash$, 3, 1))
        crash! = VAL(RIGHT$(ccccash$, 2))
        SELECT CASE part1
            CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
                temp$ = ten$(part1 \ 10) + "Thousand "
            CASE 11 TO 19
                temp$ = teen$(part1 - 10) + "Thousand "
            CASE ELSE
                temp$ = ten$(part1 \ 10) + one$(VAL(RIGHT$(STR$(part1), 1))) + "Thousand "
        END SELECT
        SELECT CASE part2
            CASE 0
            temp$ = temp$ + ""
            CASE 1 TO 9
            temp$ = temp$ + one$(part2) + "Hundred "
            CASE ELSE
         END SELECT
         SELECT CASE crash!
            CASE 0 TO 10
                temp$ = temp$ + one$(crash!)
            CASE 11 TO 19
                temp$ = temp$ + teen$(crash! - 10)
            CASE 10, 20, 30, 40, 50, 60, 70, 80, 90
                temp$ = temp$ + ten$(crash! \ 10)
            CASE ELSE
                temp$ = temp$ + ten$(crash! \ 10) + one$(VAL(RIGHT$(STR$(crash!), 1)))
            END SELECT
    CASE ELSE
END SELECT
IF temp$ = "One " THEN ext$ = "" ELSE ext$ = "s"
IF temp$ = "" THEN temp$ = "Zero ": ext$ = "s"
temp$ = temp$ + "Dollar" + ext$ + " and " + RIGHT$(cccash$, 2) + "/100"
zz% = LEN(temp$)
zzy% = zz% \ 2
zzx% = zz% - zzy%
IF pad% <> 0 THEN
pad$ = STRING$(72, "*")
FOR x = 2 TO 72 STEP 4
MID$(pad$, x, 2) = "  "
NEXT x
MID$(pad$, 36 - zzy%, zz%) = temp$
monstring$ = pad$
ELSE
monstring$ = temp$
END IF
END FUNCTION

