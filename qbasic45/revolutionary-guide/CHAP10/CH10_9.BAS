REM Qbasic RayCasting Beta Demo Version 1.0
REM Created By: Dave Valentine (C) 1995, Written for Wrox Press

REM \CHAP10\CH10_9.BAS

REM *** Function Declarations ***
        DECLARE FUNCTION get.key% ()
        DECLARE FUNCTION move.player% (X%, Y%, angle%, KeyPress%)

REM *** Subprogram Declarations ***
        DECLARE SUB intro ()
        DECLARE SUB load.asm.routine ()
        DECLARE SUB display.map (X%, Y%, angle%)
        DECLARE SUB build.tables ()
        DECLARE SUB display.hud (X%, Y%, angle%)
        DECLARE SUB load.world ()
        DECLARE SUB cast.video (X AS INTEGER, Y AS INTEGER, Vang AS INTEGER)
        DECLARE SUB update.screen ()
        DECLARE SUB get.parameters (X%, Y%, angle%)
        DECLARE SUB end.message ()
       

REM *** Constants ***
        CONST ASMFILE = "VIDEOASM.BIN": CONST WORLDFILE = "WORLD.DAT"
       
        CONST MAX.ASM.ROUTINE.SIZE = 100
        CONST PI = 3.141593
        CONST NoZero = 1E-32
        CONST SquareSize = 64
        CONST EscapeChar = 27
        CONST TabChar = 9

        CONST MaxSlope = 30:    CONST MaxScale = 100
        CONST True = -1:        CONST false = 0

        CONST WallChar = "X"
        CONST WorldWide = 15:   CONST WorldHeight = 15
        CONST CordWide = 1024:  CONST CordHigh = 1024
        CONST MinWorld = 0:     CONST WorldSize = 40
       
        CONST MinCordTable = -100
        CONST MaxCordTable = 100

        CONST ViewArc = 60:     CONST HalfViewArc = 30

        CONST MinDeg = 0:       CONST MaxDeg = 360
        CONST MinBeam = 0:      CONST MaxBeam = 1920
       
        CONST minX = 0:         CONST MinY = 0
        CONST maxX = 320:       CONST MaxY = 200
        CONST HalfX = 160
       
        CONST ScanUp = -1:      CONST ScanDown = 1
        CONST ScanLeft = -1:    CONST ScanRight = 1
        CONST NoScan = 0

        CONST Forward = 8:      CONST BackWard = 2
        CONST Left = 4:         CONST Right = 6
        CONST TabHit = "10"

        CONST VideoConst = 5000
        CONST WallColor = 15:   CONST EdgeColor = 0
        CONST SkyColor = 1:     CONST FloorColor = 5
        CONST DefaultX = 95:    CONST DefaultY = 95
                      
        CONST MapView = 1:      CONST RendView = 2
        CONST DefaultVQ = 2
        CONST DefaultAngle = 0
        CONST DefaultAngleShift = 10
        CONST DefaultMove = 10

REM *** Variables ***
   
    DEFINT A-Z

      REM <<< Asm routine >>>
          DIM SHARED DrawBeam(1 TO MAX.ASM.ROUTINE.SIZE)  AS INTEGER

      REM <<< Tables >>>
       ' Degree to video conversion
          DIM SHARED AngleToBeams(MinDeg TO MaxDeg) AS INTEGER

       ' Video to degree conversion
          DIM SHARED BeamsToAngle(MinBeam TO MaxBeam) AS INTEGER

       ' Trig tables
          DIM SHARED TanTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED CosTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED SinTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED InvCosTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED InvSinTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED InvTanTable(MinBeam TO MaxBeam) AS SINGLE

       ' World Conversion table
          DIM SHARED WorldCordTable(-100 TO 100)

       ' View Correction Table
          DIM SHARED ViewFixTable(minX TO maxX) AS SINGLE
         

       ' Step tables
          DIM SHARED YStepTable(MinBeam TO MaxBeam) AS SINGLE
          DIM SHARED XStepTable(MinBeam TO MaxBeam) AS SINGLE
         
      REM <<< World >>>
       ' World
          DIM SHARED WorldData(0 TO WorldHeight, 0 TO WorldWide) AS STRING * 1

      REM <<< Video Buffer >>>
       ' World on screen
          DIM SHARED VideoPlot(minX TO maxX) AS INTEGER
          DIM SHARED VideoColor(minX TO maxX) AS INTEGER

      REM <<< Video Quality Paramteter >>>
          DIM SHARED VideoQuality AS INTEGER
     
      REM <<< Video render mode >>>
          DIM SHARED ViewMode AS INTEGER

REM *** MainCode ***
        intro
        load.asm.routine
        build.tables
        load.world
        get.parameters XUser%, YUser%, AUser%

        SCREEN 13
       
        cast.video XUser%, YUser%, AUser%
       
        IF ViewMode = RendView THEN
            update.screen
        ELSE
            display.map XUser%, YUser%, AUser%
        END IF
       
        display.hud XUser%, YUser%, AUser%
       
       
       
        DO UNTIL NOT move.player(XUser%, YUser%, AUser%, get.key)
                cast.video XUser%, YUser%, AUser%
               
                IF ViewMode = RendView THEN
                        update.screen
                ELSE
                        display.map XUser%, YUser%, AUser%
                END IF

                display.hud XUser%, YUser%, AUser%

        LOOP



        end.message
END

SUB build.tables
       
        REM *** ATB ***
          PRINT "Constructing Angle to Beam table (ATB)"
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR angle = MinDeg TO MaxDeg
                  AngleToBeams(angle) = INT(angle / (MaxDeg) * MaxBeam)
                  LOCATE ROW, COL
                  PRINT STRING$(INT(angle / (MaxDeg) * 50), ".");
          NEXT angle
          PRINT "done."

        REM *** BTA ***
          PRINT "Constructing Beam to Angle table (BTA)"
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR Beams = MinBeam TO MaxBeam
                  BeamsToAngle(Beams) = INT((Beams / (MaxBeam)) * MaxDeg)
                  LOCATE ROW, COL
                  PRINT STRING$(INT(Beams / (MaxBeam) * 50), ".");
          NEXT Beams
          PRINT "done."

        REM *** Trig ***
          PRINT "Constructing Trig Tables."
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR Beams = MinBeam TO MaxBeam
            RadAngle! = (Beams / MaxBeam) * 2 * PI
        
             TanTable(Beams) = TAN(RadAngle!)
             CosTable(Beams) = COS(RadAngle!)
             SinTable(Beams) = SIN(RadAngle!)
             InvCosTable(Beams) = 1 / (COS(RadAngle!) + NoZero)
             InvSinTable(Beams) = 1 / (SIN(RadAngle!) + NoZero)
             InvTanTable(Beams) = 1 / (TAN(RadAngle!) + NoZero)
        
            LOCATE ROW, COL
            PRINT STRING$(INT(Beams / (MaxBeam) * 50), ".");
          NEXT Beams
          PRINT "done."
     
        REM *** View Correction ***
          PRINT "Constructing View Correction Table"
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR Beams = -AngleToBeams(HalfViewArc) TO AngleToBeams(HalfViewArc)
                RadAngle! = (Beams / MaxBeam) * 2 * PI
                ViewFixTable(Beams + HalfX) = 1 / COS(RadAngle!)
                LOCATE ROW, COL
                PRINT STRING$(((Beams + AngleToBeams(HalfViewArc)) / AngleToBeams(60) * 50), ".");
          NEXT Beams
          PRINT "done."
       
        REM *** World Cord Table ***
          PRINT "Constructing World cordinates table"
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR Counter = MinCordTable TO MaxCordTable
                  WorldCordTable(Counter) = Counter * SquareSize
                  LOCATE ROW, COL
                        PRINT STRING$(INT(((Counter + MaxCordTable) / (MaxCordTable * 2)) * 50), ".");
          NEXT Counter
          PRINT "done."

        REM *** Rise and Run Tables  ***
          PRINT "Constructing X and Y Delta Tables."
          ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
          FOR Beams = MinBeam TO MaxBeam
            RadAngle! = (Beams / MaxBeam) * 2 * PI
    
            IF (Beams > AngleToBeams(90)) AND (Beams < AngleToBeams(270)) THEN
                YStepTable(Beams) = -ABS(InvTanTable(Beams) * SquareSize)
            ELSE
                YStepTable(Beams) = ABS(InvTanTable(Beams) * SquareSize)
            END IF
      
            IF (Beams >= AngleToBeams(0)) AND (Beams <= AngleToBeams(180)) THEN
                XStepTable(Beams) = -ABS(TanTable(Beams) * SquareSize)
            ELSE
                XStepTable(Beams) = ABS(TanTable(Beams) * SquareSize)
            END IF

            LOCATE ROW, COL
            PRINT STRING$(INT(Beams / (MaxBeam) * 50), ".");
          NEXT Beams
          PRINT "done."

END SUB

SUB cast.video (X AS INTEGER, Y AS INTEGER, Vang AS INTEGER)
DEFINT A-Z

REM *** Get Render angle, and Compenstate for wrap around ***
        VangRend = Vang - AngleToBeams(HalfViewArc)

REM *** Get Player Cordinates ***
        PlayerY = Y \ SquareSize
        PlayerX = X \ SquareSize

REM *** Prime loop ***
        VideoCol = maxX

FOR Ray = VangRend TO VangRend + AngleToBeams(ViewArc) - 1 STEP VideoQuality

        RayCast = Ray
       
        IF RayCast < MinBeam THEN RayCast = RayCast + MaxBeam
        IF RayCast > MaxBeam THEN RayCast = RayCast - MaxBeam
       
        Slope! = TanTable(RayCast)
        InvSlope! = InvTanTable(RayCast)
        RayHitY = false: RayHitX = false
                        
        IF Slope! > MaxSlope THEN Slope! = MaxSlope
        SELECT CASE RayCast
              REM *** Right ***
                CASE AngleToBeams(0), AngleToBeams(360)
                    DirX = ScanRight
                    DirY = NoScan
                 
              REM *** Up and Right ***
                CASE AngleToBeams(1) TO AngleToBeams(89)
                    DirX = ScanRight
                    DirY = ScanUp
                 
              REM *** Up ***
                CASE AngleToBeams(90)
                    DirX = NoScan
                    DirY = ScanUp

              REM *** Up and Left ***
                CASE AngleToBeams(91) TO AngleToBeams(179)
                    DirX = ScanLeft
                    DirY = ScanUp
                  
              REM **** Left ***
                CASE AngleToBeams(180)
                    DirX = ScanLeft
                    DirY = NoScan
           
              REM *** Down and Left ***
                CASE AngleToBeams(181) TO AngleToBeams(269)
                    DirX = ScanLeft
                    DirY = ScanDown
             
              REM *** Down ***
                CASE AngleToBeams(270)
                    DirX = NoScan
                    DirY = ScanDown
             
              REM *** Down and Right ***
                CASE AngleToBeams(271) TO AngleToBeams(359)
                    DirX = ScanRight
                    DirY = ScanDown
     
        END SELECT
              

        REM *** Render Case ***
          REM *** Scan for Y Intercect ***
              IF DirY THEN
                IF DirY = ScanDown THEN
                        ScanY = PlayerY + 1
                ELSE
                        ScanY = PlayerY
                END IF
               
                XInterSectY = (Y - WorldCordTable(ScanY)) * InvSlope!
                XInterSectY = XInterSectY + X

                DO
                        YInterSectY = WorldCordTable(ScanY)

                        IF DirY = ScanDown THEN
                                GridY = (YInterSectY \ SquareSize)
                        ELSE
                                GridY = (YInterSectY \ SquareSize) - 1
                        END IF

                        IF DirX = ScanLeft THEN
                                GridX = (XInterSectY \ SquareSize)
                        ELSE
                                GridX = (XInterSectY \ SquareSize)
                        END IF

                        IF (GridX < 0 OR GridX > WorldWide) THEN EXIT DO
                        IF (GridY < 0 OR GridY > WorldHeight) THEN EXIT DO
                        RayHitY = WorldData(GridY, GridX) = WallChar
                       
                        IF RayHitY THEN EXIT DO
                        ScanY = ScanY + DirY
                        XInterSectY = INT(XInterSectY + YStepTable(RayCast))
                LOOP
              END IF
                
          REM *** Scan for X Intercect ***
              IF DirX THEN
                IF DirX = ScanRight THEN
                        ScanX = PlayerX + 1
                ELSE
                        ScanX = PlayerX
                END IF
               
                YInterSectX = (X - WorldCordTable(ScanX)) * Slope!
                YInterSectX = YInterSectX + Y
                DO
                        XInterSectX = WorldCordTable(ScanX)
                                             
                        IF DirY = ScanDown THEN
                                GridY = (YInterSectX \ SquareSize)
                        ELSE
                                GridY = (YInterSectX \ SquareSize)
                        END IF

                        IF DirX = ScanLeft THEN
                                GridX = (XInterSectX \ SquareSize) - 1
                        ELSE
                                GridX = (XInterSectX \ SquareSize) '+ 1
                        END IF

                        IF (GridX < 0 OR GridX > WorldWide) THEN EXIT DO
                        IF (GridY < 0 OR GridY > WorldHeight) THEN EXIT DO
                        RayHitX = WorldData(GridY, GridX) = WallChar

                        IF RayHitX THEN EXIT DO
                        ScanX = ScanX + DirX
                        YInterSectX = INT(YInterSectX + XStepTable(RayCast))
                LOOP
              END IF



        REM *** If there are 2 walls then turn one off ***
          IF RayHitX AND RayHitY THEN
                DistanceX! = ABS((XInterSectX% - X) * (InvCosTable(RayCast)))
                DistanceY! = ABS((YInterSectY% - Y) * (InvSinTable(RayCast)))

                IF DistanceX! > DistanceY! THEN
                        RayHitX = false
                ELSE
                        RayHitY = false
                END IF

          ELSEIF RayHitX THEN
                DistanceX! = ABS((XInterSectX% - X) * (InvCosTable(RayCast)))

          ELSEIF RayHitY THEN
                DistanceY! = ABS((YInterSectY% - Y) * (InvSinTable(RayCast)))
          END IF
       
        REM *** Plug into video buffer ***
          IF RayHitX THEN
                Scale! = VideoConst / DistanceX!
                EdgeHit = (YInterSectX% MOD SquareSize = 0)
                EdgeHit = EdgeHit OR ((YInterSectX% + DirX) MOD SquareSize = 0)
                EdgeHit = EdgeHit OR ((YInterSectX% - DirX) MOD SquareSize = 0)
                                                        
          ELSEIF RayHitY THEN
                Scale! = VideoConst / DistanceY!
                EdgeHit = (XInterSectY% MOD SquareSize = 0)
                EdgeHit = EdgeHit OR ((XInterSectY% + DirY) MOD SquareSize = 0)
                EdgeHit = EdgeHit OR ((XInterSectY% - DirY) MOD SquareSize = 0)
          ELSE
                Scale! = 0
          END IF

        VideoPlot(VideoCol) = INT((Scale! * ViewFixTable(VideoCol)))

        IF VideoPlot(VideoCol) > MaxScale THEN VideoPlot(VideoCol) = MaxScale
       
        IF EdgeHit THEN
                VideoColor(VideoCol) = EdgeColor
        ELSE
                VideoColor(VideoCol) = WallColor
        END IF
       
        VideoCol = VideoCol - VideoQuality

NEXT Ray

END SUB

SUB display.hud (X, Y, angle)
        LOCATE 1, 1
        PRINT " QBasic RayCaster Version 1.0 Beta Demo "
        LOCATE 25, 17
        PRINT USING "X:#### Y:#### Angle:####"; X; Y; BeamsToAngle(angle);
END SUB

SUB display.map (X, Y, angle)
        PlayerX = X \ SquareSize
        PlayerY = Y \ SquareSize
       
        LOCATE 4, 1
        PRINT "    Map View   "

        FOR VRow = 0 TO WorldHeight
                FOR VCol = 0 TO WorldWide
                      IF VRow = PlayerY AND VCol = PlayerX THEN
                        PRINT CHR$(1);
                      ELSE
                        IF WorldData(VRow, VCol) = WallChar THEN
                          PRINT CHR$(219);
                        ELSE
                          PRINT " ";
                        END IF
                      END IF
                NEXT VCol
                PRINT
        NEXT VRow
                                                                        
        LOCATE 2, 6: PRINT "Written By: Dave Valentine";
       
        LOCATE 6, 19: PRINT USING "Player X Position:##"; PlayerX;
        LOCATE 7, 19: PRINT USING "Player Y Position:##"; PlayerY;
       
        LOCATE 9, 19: PRINT "Time:"; TIME$
        LOCATE 10, 19: PRINT "Date:"; DATE$
        LOCATE 12, 19: PRINT USING "Video quality:##"; VideoQuality;

        LOCATE 14, 19: PRINT "Copyright (C) 1995"
        LOCATE 15, 23: PRINT "Dave Valentine"

        LOCATE 17, 19: PRINT "Written for Wrox"
        LOCATE 18, 29: PRINT "Press."


        LOCATE 22, 1: PRINT "Press tab to switch to ray cast mode."
        LOCATE 23, 1: PRINT "Press ESC to exit."

END SUB

SUB end.message
  SCREEN 0, 0, 0: WIDTH 80: CLS
  PRINT "Qbasic RayCasting Beta Demo Version 1.0 has terminated normally."
END SUB

FUNCTION get.key%
        Key$ = ""
        WHILE Key$ = ""
                Key$ = INKEY$
               
                SELECT CASE RIGHT$(Key$, 1)
                  CASE IS = "H"
                        Key$ = "8"
                  CASE IS = "K"
                        Key$ = "4"
                  CASE IS = "M"
                        Key$ = "6"
                  CASE IS = "P"
                        Key$ = "2"
                  CASE IS = CHR$(TabChar)
                        ' tab
                        IF ViewMode = RendView THEN
                                ViewMode = MapView
                                Key$ = TabHit
                        ELSE
                                ViewMode = RendView
                                Key$ = TabHit
                        END IF
                        CLS
                END SELECT
              
                SELECT CASE Key$
                  CASE IS = "8", "4", "6", "2", "10"
                  CASE IS = ""
                  CASE IS = CHR$(EscapeChar)
                        Key$ = "0"
                  CASE ELSE
                        Key$ = ""
                  END SELECT

        WEND
        get.key = VAL(Key$)

END FUNCTION

SUB get.parameters (X, Y, angle)
       
        PRINT
        PRINT "Requesting startup parameters."
        INPUT "Please enter Video Quality (0 (Good) -> 3 (Poor)), Default 1:", VideoQuality
        VideoQuality = 2 ^ VideoQuality

        INPUT "Please enter X coordinate, or just enter for default:", X
        INPUT "Please enter Y coordinate, or just enter for default :", Y
        INPUT "Please enter Angle, or just enter for default:", angle

        IF VideoQuality = 0 THEN VideoQuality = DefaultVQ: PRINT "Default video."
        IF X = 0 THEN X = DefaultX: PRINT "Default X"
        IF Y = 0 THEN Y = DefaultY: PRINT "Default Y"
        IF angle = 0 THEN angle = AngleToBeams(DefaultAngle): PRINT "Default Angle"
        ViewMode = RendView

END SUB

SUB intro
REM *** Initializes video screen, and prints intro notices ***

        SCREEN 0, 0, 0: WIDTH 80: CLS

        PRINT "Qbasic RayCasting Beta Demo Version 1.0"
        PRINT STRING$(39, 196)
        PRINT "Created By: Dave Valentine (C) 1995, Written for Wrox Press"
        PRINT "This version is only beta, and has not been fully tested."
        PRINT

END SUB

SUB load.asm.routine
REM *** Loads the asmroutine into the array , with fancy graphicx ;-) ***

      OPEN ASMFILE FOR INPUT AS #1
                             
        REM *** Header ***
          PRINT "Loading asm routine."
       
       REM *** Routine ***
        INPUT #1, ASMBYTES
       
        ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
       
        P = VARPTR(DrawBeam(1))
        DEF SEG = VARSEG(DrawBeam(1))' Change the segment.
       
        FOR I = 0 TO ASMBYTES - 1
                LOCATE ROW, COL
                PRINT STRING$(INT(I / (ASMBYTES - 1) * 50), ".");
                INPUT #1, j
                POKE (P + I), j
        NEXT I
        PRINT "done."
        DEF SEG
       
      CLOSE #1
END SUB

SUB load.world
      PRINT "Loading world."
     
      OPEN WORLDFILE FOR INPUT AS #1
      ROW = CSRLIN: COL = POS(0) 'FOR ... EFFECT Positioning
       
        FOR VRow = 0 TO WorldHeight
                INPUT #1, InputLine$

                FOR VCol = 0 TO LEN(InputLine$) - 1
                      IF MID$(InputLine$, VCol + 1, 1) = WallChar THEN
                            WorldData(VRow, VCol) = MID$(InputLine$, VCol + 1, 1)
                      ELSE
                            WorldData(VRow, VCol) = " "
                      END IF
                NEXT VCol
               
                LOCATE ROW, COL
                PRINT STRING$(INT(VRow / WorldHeight * 50), ".");
        NEXT VRow
        PRINT "done."

      CLOSE #1
END SUB

FUNCTION move.player (X, Y, angle, KeyPress)
NewY = Y: NewX = X
move.player = True

SELECT CASE KeyPress
        CASE IS = Left
                angle = angle + AngleToBeams(DefaultAngleShift)
        CASE IS = Right
                angle = angle - AngleToBeams(DefaultAngleShift)
        CASE IS = Forward
                NewY = Y - SinTable(angle) * DefaultMove
                NewX = X + CosTable(angle) * DefaultMove
        CASE IS = BackWard
                NewY = Y + SinTable(angle) * DefaultMove
                NewX = X - CosTable(angle) * DefaultMove
        CASE IS = 0
                move.player = false
END SELECT

IF angle < MinBeam THEN angle = angle + MaxBeam
IF angle > MaxBeam THEN angle = angle - MaxBeam

IF WorldData(NewY \ SquareSize, NewX \ SquareSize) = WallChar THEN
        BEEP
ELSE
        X = NewX: Y = NewY
END IF


END FUNCTION

SUB update.screen
        DEF SEG = VARSEG(DrawBeam(1))' Change the segment.
        FOR COL% = minX TO maxX - 1 STEP VideoQuality
                FOR RenderTimes = 1 TO VideoQuality
                        CALL ABSOLUTE(SkyColor%, VideoColor(COL%), FloorColor%, VideoPlot(COL%), COL% + RenderTimes - 1, VARPTR(DrawBeam(1)))
                NEXT RenderTimes
        NEXT COL%

        DEF SEG   ' Restore the segment.
END SUB

