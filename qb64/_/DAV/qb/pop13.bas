'=========
'POP13.BAS 
'=========
'Coded by Dav
'
'Exploding, translucent popup windows for SCREEN 13.
'Windows pop in and out while preserving background. 
'Windows can be either translucent or normal (solid).
'Five frame types to choose from and exploding speed 
'can be controlled. SEE POP13 SUB FOR INSTRUCTIONS. 
'_____________________________________________________
' | CREDITS | CREDITS | CREDITS | CREDITS | 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' This program uses the ASM translucent routine from 
' the program VGATRANS.BAS written by Victor Woeltjen
' found in the September, 1998 issue of the All Basic
' Code packets (ABC9809.ZIP). 
'=====================================================

DEFINT A-Z
DECLARE SUB POP13 (WAY%, KIND%, x1%, y1%, x2%, y2%, CLR%, FRM%, SPD%)

'=== Array to hold background data.
'=== INCREASE VALUE FOR LARGER WINDOWS!

DIM SHARED popbox%(8000)
DIM SHARED TSRout%(40), Blah(127) 'for the translucent routine

'=================
' DEMO STARTS HERE
'=================
  
SCREEN 13

'=== Make background to show translucent effect.
  
FOR X% = 1 TO 320 STEP 2
    FOR Y% = 30 TO 170 STEP 2
       PSET (X%, Y%), RND * 255
    NEXT
NEXT

'=== A title for our demo program

PRINT "POPUP WINDOW (translucent) FOR SCREEN 13"
PRINT SPACE$(4); "PRESS ANY KEY TO OPEN & CLOSE..."; SPACE$(4);

'=== Let's do six popup windows showing all the frames.

SPD% = 4 'Exploding speed of our windows
CLR% = 55 'Window color to start with.
KIND% = 1 '1 = translucent windows (Use 0 for solid)

FOR FRM% = 5 TO 0 STEP -1
      'Pop it in....
    POP13 1, KIND%, 100, 60, 220, 140, CLR%, FRM%, SPD%
      '=== Show a little info...
    LOCATE 24, 12: PRINT "Frame:"; FRM%; " Speed:"; SPD%;
      'Pause for the cause. Change color too....
    SLEEP: CLR% = CLR% - 6
      'Pop it out....
    POP13 0, KIND%, 100, 60, 220, 140, CLR%, FRM%, SPD%
NEXT

'========
'END DEMO
'========
END

SUB POP13 (WAY%, KIND%, x1%, y1%, x2%, y2%, CLR%, FRM%, SPD%)
'=========================================================
' POP13 SUB creates exploding, translucent windows. 
'=========================================================
' WAY% - Tells the sub which way to pop window, in or out.
' 1 = Opens a window (pop it in) 
' 2 = Closes last opened windows (pop it out) 
'
' KIND% -The kind of window, normal or translucent. 
' Translucent windows display slower and with big
' windows flicker becomes noticable. Display is 
' faster and flicker-free with solid windows. 
' 0 = Normal window (solid) 
' 1 = Translucent window (see through) 
'
' CLR% - The color of the window. Take your pick. 
'
' FRM% - The frame type to use. There are five styles.
' 0 = No frame 
' 1 = Small frame 
' 2 = Highlighted frame 
' 3 = Beveled frame 
' 4 = Medium frame 
' 5 = Large frame 
'
' SPD% - The exploding speed. 
' 1 is the slowest. Higher values are faster. 
'=========================================================

'=== If we are opening a new translucent window...

IF WAY% = 1 AND KIND% = 1 THEN 'Init the TSroutine FIRST!!!
   ASM$ = "1E5589E58B76088B4E128B5610B800A08ED889D389D0C1E008C1E30601C"
   ASM$ = ASM$ + "301CBB800008A0701C68B460A8ED88A048B760850B800A08ED85"
   ASM$ = ASM$ + "88807418B460E39C17ECB8B4E12428B460C39C27EC05D1FCA0600"
   DEF SEG = VARSEG(TSRout%(0))
     FOR p% = 0 TO 81
       POKE VARPTR(TSRout%(0)) + p%, VAL("&H" + MID$(ASM$, p% * 2 + 1, 2))
     NEXT
   DEF SEG
   BCol = CLR% MOD 256 'Make sure BaseColor and spread fit correct bounds
   Sprd = 15 MOD 256 'by assigning new variables to them.
   DIM Bright(0 TO 255) 'Index of brightness
   DIM RGBVal(0 TO 255, 1 TO 3) 'Index of RGB values
   DIM RplVal(0 TO (Sprd - 1)) 'replacement values for specific brightness
   FOR attr = 0 TO 255 'Get all the colors...
     OUT &H3C7, attr 'Get ready to read palette info...
     red = INP(&H3C9) 'And read that info.
     gre = INP(&H3C9)
     blu = INP(&H3C9)
     Bright(attr) = (Sprd - 1) * ((red + gre + blu) / 189!)
     RGBVal(attr, 1) = red 'Store the RGB Values
     RGBVal(attr, 2) = gre
     RGBVal(attr, 3) = blu
   NEXT
   delta! = 1 / Sprd 'Change in percentage per step.
   cp! = 0 'Reset the percentage counter.
   FOR CS = 0 TO Sprd - 1 'Step through the spread...
     cp! = cp! + delta! 'Increment the percentage counter.
     red = RGBVal(BCol, 1) * cp! 'Define the target RGB value.
     gre = RGBVal(BCol, 2) * cp!
     blu = RGBVal(BCol, 3) * cp!
     closest = 0 'Reset closest and maximum difference.
     maxdiff = 255
     FOR check = 0 TO 255 'Check the colors for a match.
       rd = ABS(RGBVal(check, 1) - red) 'Get the difference from the
       gd = ABS(RGBVal(check, 2) - gre) 'target RGB value.
       bd = ABS(RGBVal(check, 3) - blu)
       diff = rd + gd + bd 'Compute the total difference
       IF diff < maxdiff THEN 'If this is the least different so far
         closest = check 'set closest to the current attribute
         maxdiff = diff 'and set the maximum difference.
       END IF
     NEXT
     RplVal(CS) = closest 'Set the replacement value.
   NEXT
   FOR pokeidx = 0 TO 255 'Now save the index into the specified
     DEF SEG = VARSEG(Blah(0)) 'segment and offset.
       POKE VARPTR(Blah(0)) + pokeidx, RplVal(Bright(pokeidx))
     DEF SEG
   NEXT
END IF

'=== Make sure SPD% is above 0...
IF SPD% < 1 THEN SPD% = 1
'=== Compute Center Row and Center Column
CR% = ((x2% - x1%) / 2) + x1%
CC% = ((y2% - y1%) / 2) + y1%

SELECT CASE WAY%
   CASE 0
      UR2% = x1%: LC2% = y1%: LR2% = x2%: RC2% = y2%
   CASE ELSE
      UR2% = CR%: LC2% = CC%: LR2% = CR%: RC2% = CC%
      GET (x1%, y1%)-(x2%, y2%), popbox% 'Grab background
END SELECT

DO
   SELECT CASE WAY%
     CASE 0
        UR2% = UR2% + SPD%: LC2% = LC2% + SPD%
        LR2% = LR2% - SPD%: RC2% = RC2% - SPD%
        IF UR2% > CR% THEN UR2% = CR%
        IF LC2% > CC% THEN LC2% = CC%
        IF LR2% < CR% THEN LR2% = CR%
        IF RC2% < CC% THEN RC2% = CC%
     CASE ELSE
        UR2% = UR2% - SPD%: LC2% = LC2% - SPD%
        LR2% = LR2% + SPD%: RC2% = RC2% + SPD%
        IF UR2% < x1% THEN UR2% = x1%
        IF LC2% < y1% THEN LC2% = y1%
        IF LR2% > x2% THEN LR2% = x2%
        IF RC2% > y2% THEN RC2% = y2%
   END SELECT
   PUT (x1%, y1%), popbox%, PSET
   IF KIND% = 1 THEN
     DEF SEG = VARSEG(TSRout%(0))
       CALL Absolute(BYVAL UR2%, BYVAL LC2%, BYVAL LR2%, BYVAL RC2%, BYVAL VARSEG(Blah(0)), BYVAL VARPTR(Blah(0)), VARPTR(TSRout%(0)))
     DEF SEG
     IF FRM% > 0 THEN LINE (UR2%, LC2%)-(LR2%, RC2%), CLR%, B
   ELSE
     LINE (UR2%, LC2%)-(LR2%, RC2%), CLR%, BF
   END IF
   SELECT CASE FRM%
     CASE 2
       LINE (UR2%, RC2% - 1)-(UR2%, LC2%), 15
       LINE -(LR2%, LC2%), 15
     CASE 3
       LINE (UR2% + 3, LC2% + 3)-(LR2% - 3, RC2% - 3), 7, B
       LINE (UR2% + 4, LC2% + 4)-(LR2% - 4, RC2% - 4), CLR%, B
     CASE 4
       LINE (UR2% + 1, LC2% + 1)-(LR2% - 1, RC2% - 1), 7, B
     CASE 5
       LINE (UR2% + 1, LC2% + 1)-(LR2% - 1, RC2% - 1), 7, B
       LINE (UR2% + 2, LC2% + 2)-(LR2% - 2, RC2% - 2), 15, B
       LINE (UR2% + 3, LC2% + 3)-(LR2% - 3, RC2% - 3), 7, B
       LINE (UR2% + 4, LC2% + 4)-(LR2% - 4, RC2% - 4), CLR%, B
   END SELECT
   SELECT CASE WAY%
     CASE 0: IF UR2% = CR% AND LC2% = CC% THEN EXIT DO
     CASE ELSE: IF UR2% = x1% AND LC2% = y1% THEN EXIT DO
   END SELECT
   WAIT &H3DA, 8
LOOP

IF WAY% = 0 THEN PUT (x1%, y1%), popbox%, PSET

END SUB
