'***************************************************************
' MenuMaus.bas - Beispielprogramm fr ein Maus-gesteuertes Menue
' ============
' "Mouse Menu Demo 2000"
' Fr QBasic 1.1 und QuickBasic 4.5/7.1
' Nicht vergessen, bei QuickBasic die Quick Library zu laden
' - bei QuickBasic 4.5 mit "QB.exe /L menumaus.bas"
' - bei QuickBasic 7.1 mit "QBX.EXE /L QBX.QLB menumaus.bas"
' Optimiert von Ulrich Schwermann
'***************************************************************
'
REM Unterroutine Bildaufbau
DECLARE SUB M.bildaufbau ()
'
REM Die unterprogramme fr die MOUSE
DECLARE SUB vsMOUSE (action$, a1%, a2%, a3%, a4%)
DECLARE FUNCTION vsINTERR% (ax%, bx%, cx%, dx%)
DECLARE SUB vsMOUSE.INIT ()
'
REM Die unterprogramme fr deine Routinen  (Drcke F2)
DECLARE SUB M.1 ()
DECLARE SUB M.2 ()
DECLARE SUB M.3 ()
DECLARE SUB M.4 ()
DECLARE SUB M.5 ()
DECLARE SUB M.6 ()
DECLARE SUB M.7 ()
'
REM Daten einlesen vorbereiten (Maschienen Programm fr MOUSE)
DIM SHARED mouse1(0 TO 45) AS INTEGER
'
REM Mouse in alle SUB Routienen Zulassen
DIM SHARED mouseX%
DIM SHARED mouseY%
DIM SHARED mouseB%
'
REM Bildaufbau
CALL M.bildaufbau
'
CALL vsMOUSE.INIT
'
vsMOUSE "area", 0, 639, 0, 349
'
Mouse.Init:
vsMOUSE "show", 0, 0, 0, 0
vsMOUSE "position", mouseX%, mouseY%, 0, 0
'
Mouse.Koordinaten:
menue$ = ""
vsMOUSE "get", 0, 0, 0, 0
vsMOUSE "coord", 7, 20, 12, 15
'
SELECT CASE mouseB%
  CASE 1:
    IF mouseX% >= 103 AND mouseX% <= 182 AND mouseY% >= 113 AND mouseY% <= 123 THEN menue$ = "MENUE1": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 103 AND mouseX% <= 182 AND mouseY% >= 155 AND mouseY% <= 165 THEN menue$ = "MENUE2": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 103 AND mouseX% <= 182 AND mouseY% >= 197 AND mouseY% <= 207 THEN menue$ = "MENUE3": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 406 AND mouseX% <= 520 AND mouseY% >= 113 AND mouseY% <= 123 THEN menue$ = "MENUE4": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 406 AND mouseX% <= 520 AND mouseY% >= 155 AND mouseY% <= 165 THEN menue$ = "MENUE5": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 406 AND mouseX% <= 520 AND mouseY% >= 197 AND mouseY% <= 207 THEN menue$ = "MENUE6": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
    IF mouseX% >= 254 AND mouseX% <= 335 AND mouseY% >= 238 AND mouseY% <= 251 THEN menue$ = "ENDE": vsMOUSE "hide", 0, 0, 0, 0: GOTO Mouse.Abfragen
END SELECT
'
'------- Mauskoordinaten anzeigen ------------------
LOCATE 23, 24: PRINT "Mauskoordinaten (x|y) : "; mouseX%, mouseY%
'
'------- Abfragen und SUBroutinen ------------------
Mouse.Abfragen:
IF menue$ = "MENUE1" THEN
   CALL M.1
   GOTO Mouse.Init
END IF
'
IF menue$ = "MENUE2" THEN
   CALL M.2
   GOTO Mouse.Init
END IF
'
IF menue$ = "MENUE3" THEN
   CALL M.3
   GOTO Mouse.Init
END IF
'
IF menue$ = "MENUE4" THEN
   CALL M.4
   GOTO Mouse.Init
END IF
'
IF menue$ = "MENUE5" THEN
   CALL M.5
   GOTO Mouse.Init
END IF
'
IF menue$ = "MENUE6" THEN
   CALL M.6
   GOTO Mouse.Init
END IF

IF menue$ = "ENDE" THEN
   END
END IF
'
GOTO Mouse.Koordinaten
'
'----- Die Maschinen-Sprache Daten fr MOUSE (NICHT UMKOPIEREN)
DataForMouse:
DATA 55,8b,ec,56,57,8b,76,0c,8b,04,8b,76,0a,8b,1c,8b,76,08,8b,0c,8b,76,06,8b
DATA 14,cd,21,8b,76,0c,89,04,8b,76,0a,89,1c,8b,76,08,89,0c,8b,76,06,89,14,5f
DATA 5e,5d,ca,08,00

SUB M.1

LOCATE 25, 1: PRINT "Sie Klickten auf: Menu Punkt 1           ";

END SUB

SUB M.2

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 2           ";

END SUB

SUB M.3

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 3         ";



END SUB

SUB M.4

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 4           ";

END SUB

SUB M.5

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 5           ";

END SUB

SUB M.6

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 6           ";

END SUB

SUB M.7

LOCATE 25, 1: PRINT "Sie Klickten auf: Menue Punkt 7           ";

END SUB

SUB M.bildaufbau
SCREEN 9
COLOR 14, 1
CLS
  PRINT "                         Mouse Menue Demo 2000   "
    LINE (0, 0)-(700, 0)
     LINE (0, 13)-(310, 13)
       LINE (311, 13)-(700, 13)
       PRINT ""
       PRINT ""
     PRINT "                             "
     PRINT ""
     PRINT ""
     PRINT ""




     PRINT ""
     PRINT "             Menue Punkt 1                         Menue Punkt 4 "
     PRINT ""
     PRINT ""
     PRINT "             Menue Punkt 2                         Menue Punkt 5"
     PRINT ""
     PRINT ""
     PRINT "             Menue Punkt 3                         Menue Punkt 6"
     PRINT ""
     PRINT ""
     PRINT "                                 BEENDEN"
     PRINT ""
     PRINT ""
     PRINT ""

END SUB

FUNCTION vsINTERR% (a1%, a2%, a3%, a4%)

'----------------------------------------------------------------------------
SHARED mouse1() AS INTEGER

IF mouse1(0) <> 0 THEN
  a5% = VARPTR(mouse1%(0))
  DEF SEG = VARSEG(mouse1(0))
  POKE a5% + 26, &H33
  CALL ABSOLUTE(a1%, a2%, a3%, a4%, a5%)
  mouseInterr% = ax%
ELSE
  SCREEN 0
  PRINT : PRINT "Mouse error, program stopped"
  SYSTEM
END IF
'----------------------------------------------------------------------------

END FUNCTION

SUB vsMOUSE (action$, a1%, a2%, a3%, a4%)

'----------------------------------------------------------------------------
SHARED mouseX%, mouseY%, mouseB%

SELECT CASE action$
  CASE "get":      R% = vsINTERR%(3, mouseB%, mouseX%, mouseY%)
  CASE "show":     R% = vsINTERR%(1, bx%, cx%, dx%)
  CASE "hide":     R% = vsINTERR%(2, bx%, cx%, dx%)
  CASE "position": R% = vsINTERR%(4, bx%, a1%, a2%)
  CASE "area":     R% = vsINTERR%(7, 0, a1%, a2%)
                   R% = vsINTERR%(8, bx%, a3%, a4%)
'  CASE "coord":    COLOR a3%
'                   LOCATE a1%, a2%: PRINT "X"; mouseX%; "Y"; mouseY%; "    "
'                   COLOR a4%
'  CASE ELSE:       SCREEN 0
'                   PRINT : PRINT "Error - Wrong mouse command"
'                   SYSTEM
END SELECT
'----------------------------------------------------------------------------

END SUB

SUB vsMOUSE.INIT
'-----Info-------------------------------------------------------------------
' vsMOUSE 3.1
' Copyright by Stefan Vogt 1995 - 1998
' http://surf.to/tvp
'----------------------------------------------------------------------------

'-----Instructions-----------------------------------------------------------
' Copy the sub "vsMOUSE", the function "vsINTERR" and the section "Mouse
' Configuration" (further down) into your program. Then you can use the mouse
' commands below.
'
' Note: The program works only together with QuickBasic if you start
' QuickBasic with 'qb.exe /l qb.qlb'. This is not necessary with QBasic.
'
' A mouse command looks like this:
'   vsMOUSE "command", argument 1, argument2, argument3, argument4
'
' Description:
'   COMMAND    ARG1  ARG2  ARG3  ARG4  DESCRIPTION
'   get        0     0     0     0     Gets the actual mouse coordinates
'                                      (mouseX% and mouseY%) and the state
'                                      of the mouse buttons (mouseB%)
'   show       0     0     0     0     Shows the mouse cursor
'   hide       0     0     0     0     Hides the mouse cursor
'   position   a1    a2    0     0     Sets the cursor position, a1 is the x
'                                      (left/right) coordinate and a2 the y
'                                      y (up/down) coordinate
'   area       a1    a2    a3    a4    Defines the area in which the mouse
'                                      can be moved (a1=x1, a2=x2, a3=y1,
'                                      a4=y2 coordinate)
'   coord      a1    a2    a3    a4    Shows the coordinates (x/y) of the
'                                      mouse cursor (a1=x, a2=y, a3=color,
'                                      a4=default color)
'----------------------------------------------------------------------------

'-----Mouse-Configuration----------------------------------------------------

RESTORE DataForMouse
DEF SEG = VARSEG(mouse1(0))
FOR i% = 0 TO 52
  READ Byte$
  POKE VARPTR(mouse1(0)) + i%, VAL("&H" + Byte$)
NEXT
'----------------------------------------------------------------------------

'-----Example----------------------------------------------------------------

'vsMOUSE "area", 0, 639, 0, 192
'vsMOUSE "show", 0, 0, 0, 0
'vsMOUSE "position", 319, 100, 0, 0

'DO

'  vsMOUSE "get", 0, 0, 0, 0
'  vsMOUSE "coord", 7, 20, 12, 15

'  SELECT CASE mouseB%
'    CASE 1: LOCATE 8, 1: PRINT "Left button pressed at ("; mouseX%; "/"; mouseY%; ")      "
'    CASE 2: LOCATE 8, 1: PRINT "Right button pressed at ("; mouseX%; "/"; mouseY%; ")     "
'    CASE 4: LOCATE 8, 1: PRINT "Middle button pressed at ("; mouseX%; "/"; mouseY%; ")    "
'    CASE ELSE
'  END SELECT

'LOOP UNTIL LEN(INKEY$)
'SYSTEM
'----------------------------------------------------------------------------

END SUB

