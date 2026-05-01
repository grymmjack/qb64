' BOX BASH BY ALLAN PEADEN
' peadenaw@gmail.com
' ALL ANGLES ARE BACKWARDS. THIS IS BECAUSE Y POINTS DOWN.
' STATED ANOTHER WAY, ACCORDING TO THE RIGHT HAND RULE,THE Z AXIS POINTS INTO THE SCREEN, NOT OUT OF IT
Screen _NewImage(640, 360, 32)
_FullScreen
_MouseHide
Rem $Dynamic 'Allows for resizeable arrays
Open "Errata.txt" For Output As #5
'Open "Errata2.txt" For Output As #6
Dim Shared write1%, write2%
write1% = 0
'write2% = 0
Const touchcondition% = 1 '1=ON 0=OFF
Const springconst# = 4000
Const framelimit = 60
Const gravity# = 9.8
Const springboundary# = .2
Const velocityangletransition# = 10
Const rotationalangletransition# = 10
Const damptype% = 1 '1=unidirectional, 0=traditional
Const collisionperobjectlimit% = 31
Dim Shared physicslimit#
physicslimit# = 180
Dim looptimer#
Dim Shared landscape(960, 720) As Integer 'value dictates which type each cell is
Dim Shared landscapehealth(960, 720) As Single
Dim Archivelandscape(960, 720) As Integer 'value dictates which type each cell is
Dim Archivelandscapehealth(960, 720) As Single
Dim Shared forces(1) As Double
Dim Shared corners#(90, 7)
Dim Shared springcorners#(90, 7)
Dim Shared collisioncounter%, permanentobjectsused%
collisioncounter% = 0
Dim Shared soundtimer#, gametimer#, scoretimer#
Dim physicstimer#, pausetimer#, warningtimer#, healthreductiontimer#, lowfreqtimer#
Dim clickdown`, clickdownR` 'a bit, either -1 or 0
clickdown` = 0
clickdownR` = 0
Dim Shared scale#
Dim oldscale#, scalefactor%
scale# = 3
scalefactor% = 1
Dim cursorstyle%
Dim mousewheelvalue%, mousexpos%, mouseypos%, mousexmatrix%, mouseymatrix%
mousexpos% = 160 'Integer
mouseypos% = 100
cursorstyle% = 2
permanentobjectsused% = 0
Dim Shared screenx%, screeny%
Dim pwarning%
screenx% = 0 'These values go negative as you scroll down and accross
screeny% = 0 'They are the screen offset values
Dim Shared boxonboxsound% '1= On, 0 = Off
Dim Shared boxonenvironsound%
Dim Shared gameobjectsound%
Dim Shared moneyrate%
Dim Shared cutoffvelocity#, boxhitpoint#, decayrate#
Dim Shared displayfps`
Dim Shared adv$, prev$
Dim Shared moneyboxlist%(10)
Dim Shared highpointboxlist%(10)
boxonboxsound% = 1
boxonenvironsound% = 1
gameobjectsound% = 1
cutoffvelocity# = 15
displayfps` = 0
boxhitpoint# = 100
decayrate# = 2.5
adv$ = "F"
prev$ = "D"
moneyrate% = 3
Randomize (Timer)

'Physics Engine variables
Type physicsobj
    otype As Integer 'Type 1 is fixed permanent, 2 is moveable and has gravity, 3 is movable with no gravity
    stype As Integer '1=Regular Box 2=Money Box that gives negative points in goal 3=Delicate high point box
    health As Double
    size As Double
    mass As Double
    xpos As Double
    ypos As Double
    xvel As Double
    yvel As Double
    xacc As Double
    yacc As Double
    environ As Integer '# of environmental objects touching, was spot 10
    friction As Double 'Friction Coef
    forcereturn As Double 'how much the objects rebounds after a collision.  Forcereturn of 1 means a full rebound (no energy loss)
    rotInert As Double 'was spot 13
    angle As Double 'angular position
    anglevel As Double 'angular velocity
    angleaccel As Double 'angular acceleration
    touching As Integer '# regular other objects touching, was spot 17
    damping As Double 'Damping Coef
    healthtime As Integer 'health time, was 19
End Type
Dim Shared physobjarray(110) As physicsobj
Dim Archivephysobjarray(110) As physicsobj
Dim Archivepermanentobjectsused%

'Game specific variables
Type gameobject
    otype As Integer
    xpos As Double
    ypos As Double
    radius As Double
    time As Double
    angle As Double
    other As Double
    targetlock As Integer 'FOR MISSILES
    lockdist As Double 'FOR MISSILES
    islocked As Integer '0= unlocked, 1=locked, 2=temp locked FOR MISSILES
End Type
Dim Shared gameobjectarray(150) As gameobject
Dim nextobject#, totalobjects%
Dim Shared money%
Dim Shared boxsaved%, boxdestroyed%, penalty%
Dim Shared costarray%(12)
costarray%(2) = 4 'DRAW HARD
costarray%(3) = 5 'ERASE
costarray%(4) = 25 'AWAY MAGNET
costarray%(5) = 30 'PULL MAGNET
costarray%(6) = 35 'MAGNET BOMB
costarray%(7) = 10 'BUILD BOX
costarray%(8) = 40 'SMALL BOMB
costarray%(9) = 75 'LARGE BOMB
costarray%(10) = 110 'FORCE WALL
costarray%(11) = 45 'ROCKETS
costarray%(12) = 45 'MISSILE
Dim drawpoints#(16, 2)
Dim xx%, yy%, xpos%, ypos%
Dim temp#
level% = 1
Makelandscape 'requires there to be money; run menu after this in case a new file is loaded
LoadSettings

'Title Screen
Cls
Color _RGB(44, 177, 227)
Locate 2, 36
Print "BOX BASH"
'80 Characters across
Color _RGB(94, 205, 28)
Locate 11, 32
Print "Press M for Menu"
Locate 12, 28
Print "Press I for Instructions"
Locate 14, 25
Color _RGB(104, 215, 38)
Print "Press Any Other Key To Continue"
Dim inputchar$
_Display
gametimer# = Timer(.0001)
scoretimer# = gametimer# + 10
Do: K$ = InKey$: Loop Until K$ = ""
While inputchar$ = "" And scoretimer# - gametimer# > 0
    inputchar$ = InKey$
    If UCase$(inputchar$) = "M" Then menuoptions
    If UCase$(inputchar$) = "I" Then
        instructions
        menuoptions
    End If
    gametimer# = Timer(.0001)
Wend
money% = 500
'Archive level matrix here, and physics objects for the level
' Create memory blocks for the arrays
Dim ma As _MEM: ma = _Mem(landscape())
Dim mb As _MEM: mb = _Mem(Archivelandscape())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb

' Create memory blocks for the arrays
ma = _Mem(landscapehealth())
mb = _Mem(Archivelandscapehealth())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb

Archivepermanentobjectsused% = permanentobjectsused%
' Create memory blocks for the arrays
ma = _Mem(physobjarray())
mb = _Mem(Archivephysobjarray())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb



Color _RGB(255, 255, 255)

start:
Do: K$ = InKey$: Loop Until K$ = ""
Cls
Locate 10, 36
Color _RGB(255, 255, 255)
Print "LEVEL: "
Locate 10, 43
Print level%
_Display
Sleep 5

boxsaved% = 0
boxdestroyed% = 0
penalty% = 0
money% = money% + 500
totalobjects% = 50 'Number of boxes that will be dropped
For x = 0 To UBound(gameobjectarray) 'ERASES ALL GAME OBJECTS
    gameobjectarray(x).otype = 0
Next x
For x = 0 To UBound(physobjarray) 'ERASES ALL PHYSICS OBJECTS
    physobjarray(x).otype = 0
Next x
'Retrieve Archive level matrix here
' Create memory blocks for the arrays
ma = _Mem(Archivelandscape())
mb = _Mem(landscape())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb

' Create memory blocks for the arrays
ma = _Mem(Archivelandscapehealth())
mb = _Mem(landscapehealth())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb

permanentobjectsused% = Archivepermanentobjectsused%
' Create memory blocks for the arrays
ma = _Mem(Archivephysobjarray())
mb = _Mem(physobjarray())

' Copy the entire content of sourceArray to destArray
_MemCopy ma, ma.OFFSET, ma.SIZE To mb, mb.OFFSET

' Free the memory blocks when done
_MemFree ma
_MemFree mb


Makelevel (level%)

'Time dependent variables
gametimer# = Timer(.0001)
physicstimer# = Timer(.0001)
nextobject# = gametimer# + 2
scoretimer# = gametimer# + 180
moneytimer# = gametimer# + 1
warningtimer# = gametimer#
soundtimer# = gametimer#
healthreductiontimer# = gametimer# + 6
lowfreqtimer# = gametimer# + 1 / 60

'Main loop exits on ESC or game end
While inputchar$ <> Chr$(27) And scoretimer# - gametimer# > 0
    'Cls 'temporary clear screen to see troubleshooting input steps
    inputchar$ = InKey$
    oldscale# = scale#
    If inputchar$ = "." Then scale# = scale# + 0.2
    If inputchar$ = "," Then scale# = scale# - 0.2
    If inputchar$ = "s" Then Savefile
    If inputchar$ = "l" Then Loadfile
    If inputchar$ = "/" Then scale# = 1
    If inputchar$ = "o" Then outputobjects
    If inputchar$ = "1" Then cursorstyle% = 2
    If inputchar$ = "2" Then cursorstyle% = 3
    If inputchar$ = "3" Then cursorstyle% = 4
    If inputchar$ = "4" Then cursorstyle% = 5
    If inputchar$ = "5" Then cursorstyle% = 6
    If inputchar$ = "6" Then cursorstyle% = 7
    If inputchar$ = "7" Then cursorstyle% = 8
    If inputchar$ = "8" Then cursorstyle% = 9
    If inputchar$ = "9" Then cursorstyle% = 10
    If inputchar$ = "0" Then cursorstyle% = 11
    If inputchar$ = "-" Then cursorstyle% = 12
    If UCase$(inputchar$) = prev$ Then cursorstyle% = cursorstyle% + 1
    If UCase$(inputchar$) = adv$ Then cursorstyle% = cursorstyle% - 1
    If UCase$(inputchar$) = "P" Then
        Locate 10, 30
        Color (_RGB(78, 17, 255))
        Print "*PAUSE*"
        Locate 12, 21
        Color (_RGB(205, 50, 55))
        Print "PRESS ANY KEY TO CONTINUE"
        _Display
        Color (_RGB(255, 255, 255))
        Sleep
    End If
    If inputchar$ = "r" Then
        scoretimer# = gametimer#
        boxsaved% = 1000
    End If
    If _KeyDown(20480) Then screeny% = screeny% - 1 'up arrow
    If _KeyDown(18432) Then screeny% = screeny% + 1 'down arrow
    If _KeyDown(19200) Then screenx% = screenx% + 1 'left arrow
    If _KeyDown(19712) Then screenx% = screenx% - 1 'right arrow
    If _MouseInput Then
        mousewheelvalue% = _MouseWheel
        If mousewheelvalue% Then
            scale# = scale# - mousewheelvalue% * scale# * 0.2
        End If
        mousexpos% = mousexpos% + _MouseMovementX
        mouseypos% = mouseypos% + _MouseMovementY
    End If
    If _MouseButton(2) And clickdownR` = 0 Then
        cursorstyle% = cursorstyle% + 1
        clickdownR` = -1
    End If
    If cursorstyle% > 12 Then cursorstyle% = 2
    If cursorstyle% < 2 Then cursorstyle% = 12
    If scale# < 0.25 Then scale# = 0.25
    If scale# > 30 Then scale# = 30
    If oldscale# <> scale# Then 'adjust screen offsets is scaling changes
        screenx% = Int(-scale# * (mousexpos% - screenx%) / (oldscale#) + mousexpos%)
        screeny% = Int(-scale# * (mouseypos% - screeny%) / (oldscale#) + mouseypos%)
    End If
    mousexmatrix% = Round((mousexpos% - screenx%) / scale#)
    mouseymatrix% = Round((mouseypos% - screeny%) / scale#)
    'Print mousexmatrix%
    'Print mouseymatrix%
    'If _MouseButton(1) And mousexmatrix% > 0 And mousexmatrix% <= 960 And mouseymatrix% > 0 And mouseymatrix% <= 720 Then
    'landscape(mousexmatrix%, mouseymatrix%) = 1
    'End If
    If pwarning% <> 0 And gametimer# - warningtimer# > 0 Then pwarning% = 0 'warning code if trying to place block in illegal location

    ' 4 PLACES TO ADDRESS USER INTERACTIONS.  HERE, BEFORE GRAPHICS, IN GRAPHICS & IN PHYSICS
    If _MouseButton(1) And cursorstyle% = 1 And clickdown` = 0 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then '-1=True
        If landscape(mousexmatrix%, mouseymatrix%) < 2 Then
            pausetimer# = Timer(.0001)
            ' with this method individual clicks are required for each action.  No hold and drag.
            clickdown` = -1 'clickdown`=-1 when mouse button is down
            placeobject ((mousexpos% - screenx%) / scale#), ((mouseypos% - screeny%) / scale#)
            nextobject# = nextobject# + Timer(.0001) - pausetimer#
            physicstimer# = physicstimer# + Timer(.0001) - pausetimer#
            scoretimer# = scoretimer# + Timer(.0001) - pausetimer#
        Else
            pwarning% = 1
            warningtimer# = gametimer# + .5
        End If
    ElseIf _MouseButton(1) And cursorstyle% = 1 And clickdown` = 0 And Inbounds(mousexmatrix%, mouseymatrix%) = 0 Then
        pwarning% = 2
        warningtimer# = gametimer# + .5
    End If
    If _MouseButton(1) And cursorstyle% = 2 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(2) Then 'Paint Hard Surface
        brushfillweapon mousexmatrix%, mouseymatrix%, 8, 4, costarray%(2)
    End If
    If _MouseButton(1) And cursorstyle% = 3 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(3) Then 'Erase
        brushfillweapon mousexmatrix%, mouseymatrix%, 11, 0, costarray%(3)
    End If
    If _MouseButton(1) And cursorstyle% = 4 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(4) And clickdown` = 0 Then 'Magnet Away
        NewGameObject 3, mousexmatrix%, mouseymatrix%, 1, 0, gametimer# + 1.5, 0
        If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
            Play "mbL64@3o2bao3gfedcbao4gfedcbao5gfedcba"
            soundtimer# = gametimer# + .12
        End If
        money% = money% - costarray%(4)
        clickdown` = -1
    End If
    If _MouseButton(1) And cursorstyle% = 5 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(5) And clickdown` = 0 Then 'Pull Magnet
        NewGameObject 4, mousexmatrix%, mouseymatrix%, 1, 0, gametimer# + 2.0, 0
        If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
            Play "mbL64@3o4abcdefgo3abcdefgo2abcdefg"
            soundtimer# = gametimer# + .12
        End If
        money% = money% - costarray%(5)
        clickdown` = -1
    End If
    If _MouseButton(1) And cursorstyle% = 6 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(6) And clickdown` = 0 Then 'Magnet Bomb
        NewGameObject 5, mousexmatrix%, mouseymatrix%, 1, 0, gametimer# + 1.5, 0
        If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
            Play "mbL64@2o3bo1bo3co1co3bo1bo3do1do3go1go3eo1eo3fo1f"
            soundtimer# = gametimer# + .09
        End If
        money% = money% - costarray%(6)
        clickdown` = -1
    End If
    If _MouseButton(1) And cursorstyle% = 7 And money% > costarray%(7) And clickdown` = 0 Then 'Build Box
        If Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then
            If landscape(mousexmatrix%, mouseymatrix%) < 2 Then
                NewGameObject 6, (mousexpos% - screenx%) / scale#, (mouseypos% - screeny%) / scale#, 1, 0, 0, 0
                money% = money% - costarray%(7)
                clickdown` = -1
            Else
                pwarning% = 1
                warningtimer# = gametimer# + .5
            End If
        Else
            pwarning% = 2
            warningtimer# = gametimer# + .5
        End If
    End If
    If _MouseButton(1) And cursorstyle% = 8 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(8) And clickdown` = 0 Then 'Small Bomb
        NewGameObject 7, mousexmatrix%, mouseymatrix%, 1, 0, gametimer# + 0.7, 0
        If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
            Play "mbL64@1o0gfdecabdegfcabo1gfdecabdegfcab"
            soundtimer# = gametimer# + .15
        End If
        money% = money% - costarray%(8)
        clickdown` = -1
    End If
    If _MouseButton(1) And cursorstyle% = 9 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 And money% > costarray%(9) And clickdown` = 0 Then 'Large Bomb
        NewGameObject 8, mousexmatrix%, mouseymatrix%, 1, 0, gametimer# + 1.2, 0
        If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
            Play "mbL64@1o0gfedcdbabedcabagefcbadgfabdefa@2o1bababa"
            soundtimer# = gametimer# + .19
        End If
        money% = money% - costarray%(9)
        clickdown` = -1
    End If
    If _MouseButton(1) And cursorstyle% = 10 And money% > costarray%(10) And clickdown` = 0 Then 'Force Wall VECTORS
        If Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then
            If landscape(mousexmatrix%, mouseymatrix%) < 2 Then
                NewGameObject 9, (mousexpos% - screenx%) / scale#, (mouseypos% - screeny%) / scale#, 1, 0, 0, 16 'type, xpos, ypos, radius, angle, gtime, other   Other in this case is for what type of object the vector will create
                money% = money% - costarray%(12)
                clickdown` = -1
            Else
                pwarning% = 1
                warningtimer# = gametimer# + .5
            End If
        Else
            pwarning% = 2
            warningtimer# = gametimer# + .5
        End If
    End If
    If _MouseButton(1) And cursorstyle% = 11 And money% > costarray%(11) And clickdown` = 0 Then 'Rocket Vectors
        If Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then
            If landscape(mousexmatrix%, mouseymatrix%) < 2 Then
                NewGameObject 9, (mousexpos% - screenx%) / scale#, (mouseypos% - screeny%) / scale#, 1, 0, 0, 10 'type, xpos, ypos, radius, angle, gtime, other  Other in this case is for what type of object the vector will create
                money% = money% - costarray%(11)
                clickdown` = -1
            Else
                pwarning% = 1
                warningtimer# = gametimer# + .5
            End If
        Else
            pwarning% = 2
            warningtimer# = gametimer# + .5
        End If
    End If
    If _MouseButton(1) And cursorstyle% = 12 And money% > costarray%(12) And clickdown` = 0 Then 'MISSILE Vectors
        If Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then
            If landscape(mousexmatrix%, mouseymatrix%) < 2 Then
                NewGameObject 9, (mousexpos% - screenx%) / scale#, (mouseypos% - screeny%) / scale#, 1, 0, 0, 12 'type, xpos, ypos, radius, angle, gtime, other   Other in this case is for what type of object the vector will create
                money% = money% - costarray%(12)
                clickdown` = -1
            Else
                pwarning% = 1
                warningtimer# = gametimer# + .5
            End If
        Else
            pwarning% = 2
            warningtimer# = gametimer# + .5
        End If
    End If


    If mousexpos% < 1 Then mousexpos% = 1
    If mousexpos% > 480 Then mousexpos% = 480
    If mouseypos% < 1 Then mouseypos% = 1
    If mouseypos% > 360 Then mouseypos% = 360
    If mousexpos% = 1 Then screenx% = screenx% + scrollspeed%
    If mousexpos% = 480 Then screenx% = screenx% - scrollspeed%
    If mouseypos% = 1 Then screeny% = screeny% + scrollspeed%
    If mouseypos% = 360 Then screeny% = screeny% - scrollspeed%
    'LIMIT SCREEN OFFSETS
    If -screenx% < -40 / scale# Then screenx% = 40 / scale#
    If -screeny% < -30 / scale# Then screeny% = 30 / scale#
    If -screenx% > 960 * scale# - 480 + 40 / scale# Then screenx% = -960 * scale# + 480 - 40 / scale#
    If -screeny% > 720 * scale# - 320 + 20 / scale# Then screeny% = -720 * scale# + 320 - 20 / scale#

    Do While _MouseInput 'Clear Mouse Buffer
    Loop
    scrollspeed% = Int(scale# / 10) + 3

    'Game Logic
    'BOXES IN GOAL OR DESTROYED HANDLED IN PHSYCIS OBJECTS
    If gametimer# - moneytimer# > 0 Then
        money% = money% + moneyrate%
        moneytimer# = gametimer# + 0.5
    End If
    If gametimer# - healthreductiontimer# > 0 Then
        For x = 0 To UBound(physobjarray)
            If physobjarray(x).stype = 1 Then physobjarray(x).healthtime = physobjarray(x).healthtime - 0.5 * decayrate#
            'Green boxes stype=2 don't decay
            If physobjarray(x).stype = 3 Then physobjarray(x).healthtime = physobjarray(x).healthtime - 0.5 * decayrate# - 0.5
        Next x
        healthreductiontimer# = gametimer# + 0.5
    End If

    'Game Objects
    'Create Falling Boxes:
    If nextobject# - gametimer# < 0 And totalobjects% > 0 Then
        NewGameObject 1, 11 + Rnd * 949, 10, 1, 0, gametimer# + 2, 1 'last input is .other and designates the eventual box sub-type
        nextobject# = gametimer# + 3.0
        totalobjects% = totalobjects% - 1
    End If
    For x = 1 To 10
        If moneyboxlist%(x) <> 0 Then
            If Int(scoretimer# - gametimer#) = moneyboxlist%(x) Then
                NewGameObject 1, 11 + Rnd * 949, 10, 1, 0, gametimer# + 2, 2 'last input is .other and designates the eventual box sub-type
                moneyboxlist%(x) = 0
            End If
        End If
    Next x
    For x = 1 To 10
        If highpointboxlist%(x) <> 0 Then
            If Int(scoretimer# - gametimer#) = highpointboxlist%(x) Then
                NewGameObject 1, 11 + Rnd * 949, 10, 1, 0, gametimer# + 2, 3 'last input is .other and designates the eventual box sub-type
                highpointboxlist%(x) = 0
            End If
        End If
    Next x


    'Cycle Through Game Objects For Non-Graphical Effects
    For x = 0 To UBound(gameobjectarray)
        Select Case gameobjectarray(x).otype
            Case -1 'Box Destruction
                Select Case gameobjectarray(x).other
                    Case 1
                        gameobjectarray(x).radius = 20 * (0.52 - (gameobjectarray(x).time - gametimer#)) + 5
                    Case 2
                        gameobjectarray(x).radius = 24 * (0.52 - (gameobjectarray(x).time - gametimer#)) + 5
                    Case 3
                        gameobjectarray(x).radius = 18 * (0.52 - (gameobjectarray(x).time - gametimer#)) + 5
                End Select
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 1 'Appearing Box
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    If gameobjectarray(x).other = 1 Then
                        NewObject 2, gameobjectarray(x).other, boxhitpoint#, 10, 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, 0, 0, 0, 0, 1, 0, 0, .1, 0.05 '(otype%, subtype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction, damping)
                    ElseIf gameobjectarray(x).other = 2 Then
                        NewObject 2, gameobjectarray(x).other, 3 * boxhitpoint#, 12, 20, gameobjectarray(x).xpos, gameobjectarray(x).ypos, 0, 0, 0, 0, 1, 0, 0, .1, 0.05 '(otype%, subtype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction, damping)
                    ElseIf gameobjectarray(x).other = 3 Then
                        NewObject 2, gameobjectarray(x).other, 0.5 * boxhitpoint#, 9, 8, gameobjectarray(x).xpos, gameobjectarray(x).ypos, 0, 0, 0, 0, 1, 0, 0, .1, 0.05 '(otype%, subtype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction, damping)
                    End If
                    gameobjectarray(x).otype = 0
                End If
            Case 2 'Disappearing Box
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
                Select Case gameobjectarray(x).other
                    Case 1
                        gameobjectarray(x).radius = 7.07 * ((gameobjectarray(x).time - gametimer#) / 0.6)
                    Case 2
                        gameobjectarray(x).radius = 8.48 * ((gameobjectarray(x).time - gametimer#) / 0.6)
                    Case 3
                        gameobjectarray(x).radius = 6.37 * ((gameobjectarray(x).time - gametimer#) / 0.6)
                End Select
            Case 3 'Outward magnet
                gameobjectarray(x).radius = 60 + 10 * Sin(4 * _Pi * (gametimer# - Int(gametimer#)))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 4 'Pull magnet
                gameobjectarray(x).radius = 70 + 10 * Sin(4 * _Pi * (gametimer# - Int(gametimer#)))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 5 'Magnet Bomb
                gameobjectarray(x).radius = 60 * (1.52 - (gameobjectarray(x).time - gametimer#))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 6 'Box Build
                If _MouseButton(1) = -1 And clickdown` = -1 Then
                    gameobjectarray(x).radius = 1.4 * Sqr((((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos) ^ 2 + (((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos) ^ 2)
                    gameobjectarray(x).angle = _Atan2(((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos, ((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos)
                    If gameobjectarray(x).radius > 70 Then gameobjectarray(x).radius = 70
                End If
                If _MouseButton(1) = 0 And clickdown` = -1 Then
                    xx% = 0 'Check if box violates placement conditions
                    yy% = 0
                    While yy% = 0 And xx% < UBound(physobjarray)
                        If physobjarray(xx%).otype = 2 Then
                            drawpoints#(1, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (Cos(physobjarray(xx%).angle) - Sin(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=1
                            drawpoints#(1, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (Sin(physobjarray(xx%).angle) + Cos(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=1
                            drawpoints#(2, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (-Cos(physobjarray(xx%).angle) - Sin(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=1
                            drawpoints#(2, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (-Sin(physobjarray(xx%).angle) + Cos(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=1
                            drawpoints#(3, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (-Cos(physobjarray(xx%).angle) + Sin(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=-1
                            drawpoints#(3, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (-Sin(physobjarray(xx%).angle) - Cos(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=-1
                            drawpoints#(4, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (Cos(physobjarray(xx%).angle) + Sin(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=-1
                            drawpoints#(4, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (Sin(physobjarray(xx%).angle) - Cos(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=-1
                            If In4Points(gameobjectarray(x).xpos, gameobjectarray(x).ypos, drawpoints#(1, 1), drawpoints#(1, 2), drawpoints#(2, 1), drawpoints#(2, 2), drawpoints#(3, 1), drawpoints#(3, 2), drawpoints#(4, 1), drawpoints#(4, 2)) = 1 Then
                                yy% = 1
                            End If
                        End If
                        xx% = xx% + 1
                    Wend
                    If yy% = 0 And permanentobjectsused% < 50 Then
                        NewObject 1, 0, 10, gameobjectarray(x).radius, 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, 0, 0, 0, 0, 1, gameobjectarray(x).angle, 0, .1, 0.05 '(otype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction, damping)
                        permanentobjectsused% = permanentobjectsused% + 1
                    Else
                        If yy% = 0 Then
                            pwarning% = 3
                        Else
                            pwarning% = 1
                        End If
                        money% = money% + costarray%(7)
                        warningtimer# = gametimer# + .5
                    End If
                    gameobjectarray(x).otype = 0
                End If
            Case 7 'Small Bomb
                gameobjectarray(x).radius = 50 * (.72 - (gameobjectarray(x).time - gametimer#))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 8 'Large Bomb
                gameobjectarray(x).radius = 60 * (1.22 - (gameobjectarray(x).time - gametimer#))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 9 'Rocket or Missile Vectors
                If _MouseButton(1) = -1 And clickdown` = -1 Then
                    gameobjectarray(x).radius = Sqr((((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos) ^ 2 + (((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos) ^ 2)
                    gameobjectarray(x).angle = _Atan2(((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos, ((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos)
                    If gameobjectarray(x).radius > 100 Then gameobjectarray(x).radius = 100
                End If
                If _MouseButton(1) = 0 And clickdown` = -1 Then
                    If gameobjectarray(x).radius > 1.0 Then
                        xx% = 0 'Check if box violates placement conditions
                        yy% = 0
                        While yy% = 0 And xx% < UBound(physobjarray)
                            If physobjarray(xx%).otype = 2 Then
                                drawpoints#(1, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (Cos(physobjarray(xx%).angle) - Sin(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=1
                                drawpoints#(1, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (Sin(physobjarray(xx%).angle) + Cos(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=1
                                drawpoints#(2, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (-Cos(physobjarray(xx%).angle) - Sin(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=1
                                drawpoints#(2, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (-Sin(physobjarray(xx%).angle) + Cos(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=1
                                drawpoints#(3, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (-Cos(physobjarray(xx%).angle) + Sin(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=-1
                                drawpoints#(3, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (-Sin(physobjarray(xx%).angle) - Cos(physobjarray(xx%).angle)) 'angles are in radians X=-1 Y=-1
                                drawpoints#(4, 1) = physobjarray(xx%).xpos + physobjarray(xx%).size / 2 * (Cos(physobjarray(xx%).angle) + Sin(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=-1
                                drawpoints#(4, 2) = physobjarray(xx%).ypos + physobjarray(xx%).size / 2 * (Sin(physobjarray(xx%).angle) - Cos(physobjarray(xx%).angle)) 'angles are in radians X=1 Y=-1
                                If In4Points(gameobjectarray(x).xpos, gameobjectarray(x).ypos, drawpoints#(1, 1), drawpoints#(1, 2), drawpoints#(2, 1), drawpoints#(2, 2), drawpoints#(3, 1), drawpoints#(3, 2), drawpoints#(4, 1), drawpoints#(4, 2)) = 1 Then
                                    yy% = 1
                                End If
                            End If
                            xx% = xx% + 1
                        Wend
                        Select Case gameobjectarray(x).other
                            Case 10
                                If yy% = 0 Then
                                    NewGameObject 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, gameobjectarray(x).radius * 1.5, gameobjectarray(x).angle, gametimer#, gameobjectarray(x).angle
                                    NewGameObject 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, gameobjectarray(x).radius * 1.5, gameobjectarray(x).angle + _Pi / 3, gametimer#, gameobjectarray(x).angle
                                    NewGameObject 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, gameobjectarray(x).radius * 1.5, gameobjectarray(x).angle - _Pi / 3, gametimer#, gameobjectarray(x).angle
                                Else
                                    pwarning% = 1
                                    money% = money% + costarray%(11)
                                    warningtimer# = gametimer# + .5
                                End If
                            Case 12
                                If yy% = 0 Then
                                    NewGameObject 12, gameobjectarray(x).xpos, gameobjectarray(x).ypos, gameobjectarray(x).radius * 1.5, gameobjectarray(x).angle, gametimer#, gameobjectarray(x).angle
                                Else
                                    pwarning% = 1
                                    money% = money% + costarray%(12)
                                    warningtimer# = gametimer# + .5
                                End If
                            Case 16
                                NewGameObject 16, gameobjectarray(x).xpos, gameobjectarray(x).ypos, gameobjectarray(x).radius * .25, gameobjectarray(x).angle, gametimer# + 11, Rnd * 40
                                Play "MBL32@2O1E,GD,FC,ED,FL8C,E"
                                soundtimer# = gametimer# + .19
                        End Select
                    End If
                    gameobjectarray(x).otype = 0
                End If
                'Case 10 'Rockets, do this in physics objects
                'Case 12 'Missiles, same thing
            Case 11 'Rocket Explosion
                gameobjectarray(x).radius = 80 * (.27 - (gameobjectarray(x).time - gametimer#))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 13 'Missile Explosion
                gameobjectarray(x).radius = 85 * (.32 - (gameobjectarray(x).time - gametimer#))
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If
            Case 14 'Wormholes
                'interactions with boxes handled in physics
            Case 15 'DeathSpirals
                'interactions with boxes handled in physics
            Case 16 'Force Wall
                'interactions with boxes handled in physics
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 17
                    gameobjectarray(x).time = gametimer# + 1
                End If
            Case 17 'Collapsing Wall
                If gameobjectarray(x).time - gametimer# <= 0 Then
                    gameobjectarray(x).otype = 0
                End If

        End Select
    Next x

    If _MouseButton(1) = 0 And clickdown` = -1 Then clickdown` = 0 'mouse button unclicked
    If _MouseButton(2) = 0 And clickdownR` = -1 Then clickdownR` = 0 'Right mouse button unclicked

    gametimer# = Timer(.0001)
    If gametimer# - physicstimer# > 2 Then physicstimer# = gametimer#

    While physicstimer# < gametimer#
        PhysicsCollisions 'loop this sub while Gametime-Physicstime > physicstimedelta. Increment physicstime each loop
        physicstimer# = physicstimer# + 1 / physicslimit# 'limit of 200 iterations a second
    Wend

    While lowfreqtimer# < gametimer#
        'Do Explosion Math
        For z = 0 To UBound(gameobjectarray)
            Select Case gameobjectarray(z).otype
                Case -1 'Self Explosion
                    xpos% = Int(gameobjectarray(z).xpos)
                    ypos% = Int(gameobjectarray(z).ypos)
                    For x% = xpos% - Int(gameobjectarray(z).radius) - 1 To xpos% + Int(gameobjectarray(z).radius) + 1 Step 1
                        For y% = ypos% - Int(gameobjectarray(z).radius) - 1 To ypos% + Int(gameobjectarray(z).radius) + 1 Step 1
                            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < gameobjectarray(z).radius And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                                If landscape(x%, y%) = 2 Or landscape(x%, y%) = 4 Then
                                    landscapehealth(x%, y%) = landscapehealth(x%, y%) - 3
                                    If landscapehealth(x%, y%) <= 0 Then
                                        If Rnd < .005 Then
                                            landscape(x%, y%) = 1
                                        Else
                                            landscape(x%, y%) = 0
                                        End If
                                    End If
                                End If
                            End If
                        Next y%
                    Next x%
                Case 7 'Small Bomb
                    xpos% = Int(gameobjectarray(z).xpos)
                    ypos% = Int(gameobjectarray(z).ypos)
                    For x% = xpos% - Int(gameobjectarray(z).radius) - 1 To xpos% + Int(gameobjectarray(z).radius) + 1 Step 1
                        For y% = ypos% - Int(gameobjectarray(z).radius) - 1 To ypos% + Int(gameobjectarray(z).radius) + 1 Step 1
                            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < gameobjectarray(z).radius And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                                If landscape(x%, y%) = 2 Or landscape(x%, y%) = 4 Then
                                    landscapehealth(x%, y%) = landscapehealth(x%, y%) - 4
                                    If landscapehealth(x%, y%) <= 0 Then
                                        If Rnd < .005 Then
                                            landscape(x%, y%) = 1
                                        Else
                                            landscape(x%, y%) = 0
                                        End If
                                    End If
                                End If
                            End If
                        Next y%
                    Next x%
                Case 8 'Large Bomb
                    xpos% = Int(gameobjectarray(z).xpos)
                    ypos% = Int(gameobjectarray(z).ypos)
                    For x% = xpos% - Int(gameobjectarray(z).radius) - 1 To xpos% + Int(gameobjectarray(z).radius) + 1 Step 1
                        For y% = ypos% - Int(gameobjectarray(z).radius) - 1 To ypos% + Int(gameobjectarray(z).radius) + 1 Step 1
                            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < gameobjectarray(z).radius And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                                If landscape(x%, y%) = 2 Or landscape(x%, y%) = 4 Then
                                    landscapehealth(x%, y%) = landscapehealth(x%, y%) - 5
                                    If landscapehealth(x%, y%) <= 0 Then
                                        If Rnd < .005 Then
                                            landscape(x%, y%) = 1
                                        Else
                                            landscape(x%, y%) = 0
                                        End If
                                    End If
                                End If
                            End If
                        Next y%
                    Next x%
                Case 10 'Rocket Movement
                    'Move rocket in physicsobjects
                    'Collisions also handled in physics
                    'termination
                    If Inbounds(gameobjectarray(z).xpos, gameobjectarray(z).ypos) = 0 Then
                        gameobjectarray(z).otype = 0
                    End If
                Case 11 'Rocket Explosion
                    xpos% = Int(gameobjectarray(z).xpos)
                    ypos% = Int(gameobjectarray(z).ypos)
                    For x% = xpos% - Int(gameobjectarray(z).radius) - 1 To xpos% + Int(gameobjectarray(z).radius) + 1 Step 1
                        For y% = ypos% - Int(gameobjectarray(z).radius) - 1 To ypos% + Int(gameobjectarray(z).radius) + 1 Step 1
                            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < gameobjectarray(z).radius And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                                If landscape(x%, y%) = 2 Or landscape(x%, y%) = 4 Then
                                    landscapehealth(x%, y%) = landscapehealth(x%, y%) - 6
                                    If landscapehealth(x%, y%) <= 0 Then
                                        If Rnd < .005 Then
                                            landscape(x%, y%) = 1
                                        Else
                                            landscape(x%, y%) = 0
                                        End If
                                    End If
                                End If
                            End If
                        Next y%
                    Next x%
                Case 12 'Missile Movement
                    'Move rocket in physicsobjects
                    'Collisions also handled in physics
                    'termination
                    If Inbounds(gameobjectarray(z).xpos, gameobjectarray(z).ypos) = 0 Then
                        gameobjectarray(z).otype = 0
                    End If
                Case 13 ' Missile Explosion
                    xpos% = Int(gameobjectarray(z).xpos)
                    ypos% = Int(gameobjectarray(z).ypos)
                    For x% = xpos% - Int(gameobjectarray(z).radius) - 1 To xpos% + Int(gameobjectarray(z).radius) + 1 Step 1
                        For y% = ypos% - Int(gameobjectarray(z).radius) - 1 To ypos% + Int(gameobjectarray(z).radius) + 1 Step 1
                            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < gameobjectarray(z).radius And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                                If landscape(x%, y%) = 2 Or landscape(x%, y%) = 4 Then
                                    landscapehealth(x%, y%) = landscapehealth(x%, y%) - 6
                                    If landscapehealth(x%, y%) <= 0 Then
                                        If Rnd < .005 Then
                                            landscape(x%, y%) = 1
                                        Else
                                            landscape(x%, y%) = 0
                                        End If
                                    End If
                                End If
                            End If
                        Next y%
                    Next x%
                Case 14 'Wormholes
                    'interactions with boxes handled in physics
                Case 15 'DeathSpirals
                    'interactions with boxes handled in physics
                    'Add deathspiral movement logic here.  It can be done here because it moves so slowly
                    gameobjectarray(z).xpos = gameobjectarray(z).xpos + gameobjectarray(z).angle
                    gameobjectarray(z).ypos = gameobjectarray(z).ypos + gameobjectarray(z).other
                    If gameobjectarray(z).xpos < 60 Or gameobjectarray(z).xpos > 900 Then
                        gameobjectarray(z).angle = -gameobjectarray(z).angle
                        gameobjectarray(z).other = gameobjectarray(z).other * (Rnd * .2 + 0.9)
                    End If
                    If gameobjectarray(z).ypos < 60 Or gameobjectarray(z).ypos > 660 Then
                        gameobjectarray(z).other = -gameobjectarray(z).other
                        gameobjectarray(z).angle = gameobjectarray(z).angle * (Rnd * .2 + 0.9)
                    End If
                Case 16 ' Force Wall
                    'interactions handled in physics
            End Select
        Next z
        lowfreqtimer# = lowfreqtimer# + 1 / 60
    Wend

    'DRAW EVERYTHING

    Cls
    'Draw visible portion of screen
    DrawGrid screenx%, screeny%, scale#
    DrawObjects screenx%, screeny%, scale#
    'Cycle Through Game Objects for Graphical Effects
    For x = 0 To UBound(gameobjectarray)
        Select Case gameobjectarray(x).otype
            Case -1 'BOX DESTRUCTION
                Select Case gameobjectarray(x).other
                    Case 1
                        temp# = 5
                    Case 2
                        temp# = 6
                    Case 3
                        temp# = 4.5
                End Select
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle) - temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle) - temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 2 * _Pi / 4) - temp# * Sin(gameobjectarray(x).angle + 2 * _Pi / 4)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 2 * _Pi / 4) + temp# * Cos(gameobjectarray(x).angle + 2 * _Pi / 4)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 2 * _Pi / 4) + temp# * Sin(gameobjectarray(x).angle + 2 * _Pi / 4)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 2 * _Pi / 4) - temp# * Cos(gameobjectarray(x).angle + 2 * _Pi / 4)) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 4 * _Pi / 4) - temp# * Sin(gameobjectarray(x).angle + 4 * _Pi / 4)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 4 * _Pi / 4) + temp# * Cos(gameobjectarray(x).angle + 4 * _Pi / 4)) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 4 * _Pi / 4) + temp# * Sin(gameobjectarray(x).angle + 4 * _Pi / 4)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 4 * _Pi / 4) - temp# * Cos(gameobjectarray(x).angle + 4 * _Pi / 4)) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 6 * _Pi / 4) - temp# * Sin(gameobjectarray(x).angle + 6 * _Pi / 4)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 6 * _Pi / 4) + temp# * Cos(gameobjectarray(x).angle + 6 * _Pi / 4)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 6 * _Pi / 4) + temp# * Sin(gameobjectarray(x).angle + 6 * _Pi / 4)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 6 * _Pi / 4) - temp# * Cos(gameobjectarray(x).angle + 6 * _Pi / 4)) * scale#
                Select Case gameobjectarray(x).other
                    Case 1
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 0, 0)
                    Case 2
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(0, 200, 0)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(0, 200, 0)
                        Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(0, 200, 0)
                        Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(0, 200, 0)
                    Case 3
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(128, 0, 200)
                End Select
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 50, 12)
            Case 1 'Appearing Box
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), scale# * (7 * (2 - (gameobjectarray(x).time - gametimer#))), _RGB(0, 39, 255)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), scale# * (6 * (2 - (gameobjectarray(x).time - gametimer#))), _RGB(0, 122, 255)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), scale# * (5 * (2 - (gameobjectarray(x).time - gametimer#))), _RGB(0, 168, 255)
                If gameobjectarray(x).other = 1 Then
                    Line (screenx% + (gameobjectarray(x).xpos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#)-(screenx% + (gameobjectarray(x).xpos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#), _RGB(255, 0, 0), B
                ElseIf gameobjectarray(x).other = 2 Then
                    Line (screenx% + (gameobjectarray(x).xpos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#)-(screenx% + (gameobjectarray(x).xpos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#), _RGB(0, 250, 0), B
                ElseIf gameobjectarray(x).other = 3 Then
                    Line (screenx% + (gameobjectarray(x).xpos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos - (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#)-(screenx% + (gameobjectarray(x).xpos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos + (3 * (2 - (gameobjectarray(x).time - gametimer#)))) * scale#), _RGB(128, 0, 200), B
                End If
            Case 2 'Disappearing Box
                'Line (screenx% + (gameobjectarray(x).xpos - (9 * ((gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos - (9 * ((gameobjectarray(x).time - gametimer#)))) * scale#)-(screenx% + (gameobjectarray(x).xpos + (9 * ((gameobjectarray(x).time - gametimer#)))) * scale#, screeny% + (gameobjectarray(x).ypos + (9 * ((gameobjectarray(x).time - gametimer#)))) * scale#), _RGB(255, 0, 0), B
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + _Pi / 4)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + _Pi / 4)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                Select Case gameobjectarray(x).other
                    Case 1
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 0, 0)
                        Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, 0, 0)
                    Case 2
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(0, 250, 0)
                        Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(0, 250, 0)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(0, 250, 0)
                        Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(0, 250, 0)
                    Case 3
                        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(128, 0, 200)
                        Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(128, 0, 200)
                End Select
            Case 3 'Away Magnet
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(0, 122, 255)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale# * .92, _RGB(0, 100, 255)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale# * (4 * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) - Int(4 * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5))), _RGB(6, 205, 255)
            Case 4 'Pull Magnet
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(122, 5, 255)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale# * .92, _RGB(105, 55, 161)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale# * (4 * ((gameobjectarray(x).time - gametimer#) / 2.0) - Int(4 * (gameobjectarray(x).time - gametimer#) / 2.0)), _RGB(172, 133, 216)
            Case 5 'MAGNET BOMB
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + _Pi / 4)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + _Pi / 4)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 3 * _Pi / 4)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 3 * _Pi / 4)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 5 * _Pi / 4)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 5 * _Pi / 4)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 7 * _Pi / 4)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * (1.5 - (gameobjectarray(x).time - gametimer#) / 1.5) + 7 * _Pi / 4)) * scale#
                drawpoints#(5, 1) = screenx% + gameobjectarray(x).xpos * scale#
                drawpoints#(5, 2) = screeny% + gameobjectarray(x).ypos * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + _Pi / 4)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + _Pi / 4)) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 3 * _Pi / 4)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 3 * _Pi / 4)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 5 * _Pi / 4)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 5 * _Pi / 4)) * scale#
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 7 * _Pi / 4)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * ((gameobjectarray(x).time - gametimer#) / 1.5) + 7 * _Pi / 4)) * scale#
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 0, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(9, 1), drawpoints#(9, 2)), _RGB(255, 0, 0)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 11, 12)
            Case 6 'BUILD BOX
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + _Pi / 4)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + _Pi / 4)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, 255, 255)
            Case 7 'SMALL BOMB
                temp# = Rnd * .125
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .125
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .25
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .375
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + 0.5
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .625
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .75
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .875
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 50, 12)
            Case 8 'LARGE BOMB
                temp# = Rnd * .125
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .125
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .25
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .375
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + 0.5
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .625
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .75
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .875
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .125
                drawpoints#(10, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(10, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .25
                drawpoints#(11, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(11, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .375
                drawpoints#(12, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(12, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + 0.5
                drawpoints#(13, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(13, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .625
                drawpoints#(14, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(14, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .75
                drawpoints#(15, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(15, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .875
                drawpoints#(16, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(16, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(10, 1), drawpoints#(10, 2))-(drawpoints#(11, 1), drawpoints#(11, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(12, 1), drawpoints#(12, 2))-(drawpoints#(13, 1), drawpoints#(13, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(13, 1), drawpoints#(13, 2))-(drawpoints#(14, 1), drawpoints#(14, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(14, 1), drawpoints#(14, 2))-(drawpoints#(15, 1), drawpoints#(15, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(15, 1), drawpoints#(15, 2))-(drawpoints#(16, 1), drawpoints#(16, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Line (drawpoints#(16, 1), drawpoints#(16, 2))-(drawpoints#(9, 1), drawpoints#(9, 2)), _RGB(255, Int(Rnd * 40), Int(Rnd * 40))
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(233, 28, 0)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 50, 12)
            Case 9 'ROCKET VECTOR
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + .8 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + _Pi / 6)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + .8 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + _Pi / 6)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + .8 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle - _Pi / 6)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + .8 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle - _Pi / 6)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 255, 255)
            Case 10 'ROCKET
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos - 3 * Cos(gameobjectarray(x).angle + _Pi / 7)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos - 3 * Sin(gameobjectarray(x).angle + _Pi / 7)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos - 3 * Cos(gameobjectarray(x).angle - _Pi / 7)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos - 3 * Sin(gameobjectarray(x).angle - _Pi / 7)) * scale#
                drawpoints#(4, 1) = drawpoints#(2, 1) - 6 * Cos(gameobjectarray(x).angle) * scale#
                drawpoints#(4, 2) = drawpoints#(2, 2) - 6 * Sin(gameobjectarray(x).angle) * scale#
                drawpoints#(5, 1) = drawpoints#(3, 1) - 6 * Cos(gameobjectarray(x).angle) * scale#
                drawpoints#(5, 2) = drawpoints#(3, 2) - 6 * Sin(gameobjectarray(x).angle) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(6, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(6, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(7, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(7, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(8, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(8, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Rnd * 140, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Rnd * 140, 0)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, 200 + Int(Rnd * 20), 255)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, 200 + Int(Rnd * 20), 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 127 + Int(Rnd * 128), Int(Rnd * 100))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 127 + Int(Rnd * 128), Int(Rnd * 100))
            Case 11 'ROCKET EXPLOSIONS
                temp# = Rnd * .125
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .125
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .25
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .375
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + 0.5
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .625
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .75
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .875
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 50, 12)
            Case 12 'MISSILE
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos - 3 * Cos(gameobjectarray(x).angle + _Pi / 7)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos - 3 * Sin(gameobjectarray(x).angle + _Pi / 7)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos - 3 * Cos(gameobjectarray(x).angle - _Pi / 7)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos - 3 * Sin(gameobjectarray(x).angle - _Pi / 7)) * scale#
                drawpoints#(4, 1) = drawpoints#(2, 1) - 6 * Cos(gameobjectarray(x).angle) * scale#
                drawpoints#(4, 2) = drawpoints#(2, 2) - 6 * Sin(gameobjectarray(x).angle) * scale#
                drawpoints#(5, 1) = drawpoints#(3, 1) - 6 * Cos(gameobjectarray(x).angle) * scale#
                drawpoints#(5, 2) = drawpoints#(3, 2) - 6 * Sin(gameobjectarray(x).angle) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(6, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(6, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(7, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(7, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                temp# = Rnd * 2 - 1
                drawpoints#(8, 1) = drawpoints#(1, 1) - (9 + Rnd * 5) * Cos(gameobjectarray(x).angle) * scale# - (temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(8, 2) = drawpoints#(1, 2) - (9 + Rnd * 5) * Sin(gameobjectarray(x).angle) * scale# + (temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(9, 1) = (drawpoints#(2, 1) + drawpoints#(3, 1)) / 2
                drawpoints#(9, 2) = (drawpoints#(2, 2) + drawpoints#(3, 2)) / 2
                If Int(gametimer# * 2) Mod 2 = 1 Then
                    Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(9, 1), drawpoints#(9, 2)), _RGB(255, 0, 0)
                End If
                If gameobjectarray(x).islocked = 1 And Int(gametimer# * 4) Mod 2 = 1 Then
                    drawpoints#(10, 1) = screenx% + physobjarray(gameobjectarray(x).targetlock).xpos * scale#
                    drawpoints#(10, 2) = screeny% + physobjarray(gameobjectarray(x).targetlock).ypos * scale#
                    Circle (drawpoints#(10, 1), drawpoints#(10, 2)), 8 * scale#, _RGB(255, 0, 0)
                End If
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, 255, 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Rnd * 140, 0)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Rnd * 140, 0)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, 200 + Int(Rnd * 20), 255)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, 200 + Int(Rnd * 20), 255)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 127 + Int(Rnd * 128), Int(Rnd * 100))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 127 + Int(Rnd * 128), Int(Rnd * 100))
            Case 13 'MISSILE EXPLOSIONS
                temp# = Rnd * .125
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .125
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .25
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .375
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + 0.5
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .625
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .75
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                temp# = Rnd * .125 + .875
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * (Rnd * .4 + 0.8) * Sin(2 * _Pi * temp#)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, Int(Rnd * 20), Int(Rnd * 60) + 40)
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(5, 1), drawpoints#(5, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(7, 1), drawpoints#(7, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(6, 1), drawpoints#(6, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Line (drawpoints#(8, 1), drawpoints#(8, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(Int(Rnd * 128), 120 + Int(Rnd * 100), 225 + Int(Rnd * 30))
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 50, 12)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * .9 * scale#, _RGB(0, 205, 255)
            Case 14 'wormholes
                'Wormhole 1 IN
                temp# = (((gametimer# + 4 * gameobjectarray(x).time) * 36) Mod 180) / 180
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius))) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius))) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp# - 1.047)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp# - 1.047)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 1.047)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 1.047)) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp# - 2.094)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp# - 2.094)) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 2.094)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 2.094)) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp# - _Pi)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp# - _Pi)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - _Pi)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - _Pi)) * scale#
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp# - 4.189)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp# - 4.189)) * scale#
                drawpoints#(10, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 4.189)) * scale#
                drawpoints#(10, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 4.189)) * scale#
                drawpoints#(11, 1) = screenx% + (gameobjectarray(x).xpos + 10 * Cos(2 * _Pi * temp# - 5.236)) * scale#
                drawpoints#(11, 2) = screeny% + (gameobjectarray(x).ypos + 10 * Sin(2 * _Pi * temp# - 5.236)) * scale#
                drawpoints#(12, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 5.236)) * scale#
                drawpoints#(12, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - _Acos(10 / gameobjectarray(x).radius) - 5.236)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 250, 12)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), 10 * scale#, _RGB(255, 250, 12)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), gameobjectarray(x).radius * scale# * (1 - ((gametimer# + gameobjectarray(x).time) * 100 Mod 100) / 100), _RGB(255, 255, 255)
                'Wormhole 2 OUT
                temp# = 1 - (((gametimer# + 4 * gameobjectarray(x).time) * 36) Mod 180) / 180
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp#)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp#)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius))) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius))) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp# + 1.047)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp# + 1.047)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 1.047)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 1.047)) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp# + 2.094)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp# + 2.094)) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 2.094)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 2.094)) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp# + _Pi)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp# + _Pi)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + _Pi)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + _Pi)) * scale#
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp# + 4.189)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp# + 4.189)) * scale#
                drawpoints#(10, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 4.189)) * scale#
                drawpoints#(10, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 4.189)) * scale#
                drawpoints#(11, 1) = screenx% + (gameobjectarray(x).angle + 10 * Cos(2 * _Pi * temp# + 5.236)) * scale#
                drawpoints#(11, 2) = screeny% + (gameobjectarray(x).other + 10 * Sin(2 * _Pi * temp# + 5.236)) * scale#
                drawpoints#(12, 1) = screenx% + (gameobjectarray(x).angle + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 5.236)) * scale#
                drawpoints#(12, 2) = screeny% + (gameobjectarray(x).other + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + _Acos(10 / gameobjectarray(x).radius) + 5.236)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
                Circle (screenx% + gameobjectarray(x).angle * scale#, screeny% + gameobjectarray(x).other * scale#), gameobjectarray(x).radius * scale#, _RGB(255, 250, 12)
                Circle (screenx% + gameobjectarray(x).angle * scale#, screeny% + gameobjectarray(x).other * scale#), 10 * scale#, _RGB(255, 250, 12)
                Circle (screenx% + gameobjectarray(x).angle * scale#, screeny% + gameobjectarray(x).other * scale#), gameobjectarray(x).radius * scale# * (((gametimer# + gameobjectarray(x).time) * 100 Mod 100) / 100), _RGB(255, 255, 255)
            Case 15 'Deathspirals
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), (gameobjectarray(x).radius - .25) * scale#, _RGB(100, 100, 100)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), (gameobjectarray(x).radius) * scale#, _RGB(100, 100, 100)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), (gameobjectarray(x).radius - .5) * scale#, _RGB(100, 100, 100)
                Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), (gameobjectarray(x).radius - .75) * scale#, _RGB(100, 100, 100)
                If Int(gametimer# * 2) Mod 2 <> 1 Then
                    Circle (screenx% + gameobjectarray(x).xpos * scale#, screeny% + gameobjectarray(x).ypos * scale#), (gameobjectarray(x).radius + .25) * scale#, _RGB(255, 1, 1)
                End If
                temp# = (((gametimer# + 2 * gameobjectarray(x).time) * 18) Mod 180) / 180
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + .722 + Rnd * .05)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + .722 + Rnd * .05)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - .722 + Rnd * .05)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - .722 + Rnd * .05)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 1.047 + Rnd * .05)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 1.047 + Rnd * .05)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 1.047 + Rnd * .05)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 1.047 + Rnd * .05)) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 1.318 + Rnd * .05)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 1.318 + Rnd * .05)) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 1.318 + Rnd * .05)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 1.318 + Rnd * .05)) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 1.571 + Rnd * .05)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 1.571 + Rnd * .05)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 1.571 + Rnd * .05)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 1.571 + Rnd * .05)) * scale#
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 1.823 + Rnd * .05)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 1.823 + Rnd * .05)) * scale#
                drawpoints#(10, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 1.823 + Rnd * .05)) * scale#
                drawpoints#(10, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 1.823 + Rnd * .05)) * scale#
                drawpoints#(11, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 2.094 + Rnd * .05)) * scale#
                drawpoints#(11, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 2.094 + Rnd * .05)) * scale#
                drawpoints#(12, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 2.094 + Rnd * .05)) * scale#
                drawpoints#(12, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 2.094 + Rnd * .05)) * scale#
                drawpoints#(13, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# + 2.419 + Rnd * .05)) * scale#
                drawpoints#(13, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# + 2.419 + Rnd * .05)) * scale#
                drawpoints#(14, 1) = screenx% + (gameobjectarray(x).xpos + gameobjectarray(x).radius * Cos(2 * _Pi * temp# - 2.419 + Rnd * .05)) * scale#
                drawpoints#(14, 2) = screeny% + (gameobjectarray(x).ypos + gameobjectarray(x).radius * Sin(2 * _Pi * temp# - 2.419 + Rnd * .05)) * scale#
                If Int((gametimer# + gameobjectarray(x).time / 2) * 6) Mod 6 <> 1 Then
                    Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(13, 1), drawpoints#(13, 2))-(drawpoints#(14, 1), drawpoints#(14, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 0, 0)
                    Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(255, 0, 0)
                End If
            Case 16 'Force Wall   20x50 each
                temp# = ((((gametimer# + gameobjectarray(x).other) * 60) Mod 180) * 40) / 180
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.19)) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.19)) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.951)) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.951)) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.19)) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.19)) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.951)) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.951)) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.951) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.951) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                temp# = ((((gametimer# + gameobjectarray(x).other) * 60 + 45) Mod 180) * 40) / 180
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.951) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.951) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                temp# = ((((gametimer# + gameobjectarray(x).other) * 60 + 90) Mod 180) * 40) / 180
                drawpoints#(9, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.951) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(9, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.951) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(10, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(10, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(11, 1) = screenx% + (gameobjectarray(x).xpos + 55.71 * Cos(gameobjectarray(x).angle + 1.203)) * scale#
                drawpoints#(11, 2) = screeny% + (gameobjectarray(x).ypos + 55.71 * Sin(gameobjectarray(x).angle + 1.203)) * scale#
                drawpoints#(12, 1) = screenx% + (gameobjectarray(x).xpos + 55.71 * Cos(gameobjectarray(x).angle + 1.937)) * scale#
                drawpoints#(12, 2) = screeny% + (gameobjectarray(x).ypos + 55.71 * Sin(gameobjectarray(x).angle + 1.937)) * scale#
                drawpoints#(13, 1) = screenx% + (gameobjectarray(x).xpos + 55.71 * Cos(gameobjectarray(x).angle + _Pi + 1.203)) * scale#
                drawpoints#(13, 2) = screeny% + (gameobjectarray(x).ypos + 55.71 * Sin(gameobjectarray(x).angle + _Pi + 1.203)) * scale#
                drawpoints#(14, 1) = screenx% + (gameobjectarray(x).xpos + 55.71 * Cos(gameobjectarray(x).angle + _Pi + 1.937)) * scale#
                drawpoints#(14, 2) = screeny% + (gameobjectarray(x).ypos + 55.71 * Sin(gameobjectarray(x).angle + _Pi + 1.937)) * scale#
                temp# = ((((gametimer# + gameobjectarray(x).other) * 60 + 135) Mod 180) * 40) / 180
                drawpoints#(15, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + 1.951) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(15, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + 1.951) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                drawpoints#(16, 1) = screenx% + (gameobjectarray(x).xpos + 53.85 * Cos(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Cos(gameobjectarray(x).angle)) * scale#
                drawpoints#(16, 2) = screeny% + (gameobjectarray(x).ypos + 53.85 * Sin(gameobjectarray(x).angle + _Pi + 1.19) + temp# * Sin(gameobjectarray(x).angle)) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(249, 177, 94)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(249, 177, 94)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(188, 11, 255)
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(188, 11, 255)
                Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(188, 11, 255)
                Line (drawpoints#(15, 1), drawpoints#(15, 2))-(drawpoints#(16, 1), drawpoints#(16, 2)), _RGB(188, 11, 255)
                Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(13, 1), drawpoints#(13, 2))-(drawpoints#(14, 1), drawpoints#(14, 2)), _RGB(95, 95, 95)
            Case 17 'Collapsing Wall
                temp# = ((((gameobjectarray(x).time - gametimer#) * 180) Mod 180) / 180) * 20 'Starts at 20 and gets smaller
                drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 50 * 50) * Cos(gameobjectarray(x).angle + _Atan2(50, temp#))) * scale#
                drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 50 * 50) * Sin(gameobjectarray(x).angle + _Atan2(50, temp#))) * scale#
                drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 50 * 50) * Cos(gameobjectarray(x).angle + _Pi - _Atan2(50, temp#))) * scale#
                drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 50 * 50) * Sin(gameobjectarray(x).angle + _Pi - _Atan2(50, temp#))) * scale#
                drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 50 * 50) * Cos(gameobjectarray(x).angle + _Pi + _Atan2(50, temp#))) * scale#
                drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 50 * 50) * Sin(gameobjectarray(x).angle + _Pi + _Atan2(50, temp#))) * scale#
                drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 50 * 50) * Cos(gameobjectarray(x).angle + 2 * _Pi - _Atan2(50, temp#))) * scale#
                drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 50 * 50) * Sin(gameobjectarray(x).angle + 2 * _Pi - _Atan2(50, temp#))) * scale#
                drawpoints#(5, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 52 * 52) * Cos(gameobjectarray(x).angle + _Atan2(52, temp#))) * scale#
                drawpoints#(5, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 52 * 52) * Sin(gameobjectarray(x).angle + _Atan2(52, temp#))) * scale#
                drawpoints#(6, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 52 * 52) * Cos(gameobjectarray(x).angle + _Pi - _Atan2(52, temp#))) * scale#
                drawpoints#(6, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 52 * 52) * Sin(gameobjectarray(x).angle + _Pi - _Atan2(52, temp#))) * scale#
                drawpoints#(7, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 52 * 52) * Cos(gameobjectarray(x).angle + _Pi + _Atan2(52, temp#))) * scale#
                drawpoints#(7, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 52 * 52) * Sin(gameobjectarray(x).angle + _Pi + _Atan2(52, temp#))) * scale#
                drawpoints#(8, 1) = screenx% + (gameobjectarray(x).xpos + Sqr(temp# * temp# + 52 * 52) * Cos(gameobjectarray(x).angle + 2 * _Pi - _Atan2(52, temp#))) * scale#
                drawpoints#(8, 2) = screeny% + (gameobjectarray(x).ypos + Sqr(temp# * temp# + 52 * 52) * Sin(gameobjectarray(x).angle + 2 * _Pi - _Atan2(52, temp#))) * scale#
                Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(249, 177, 94)
                Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(249, 177, 94)
                Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(95, 95, 95)
                Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(95, 95, 95)
        End Select
    Next x

    If displayfps` = -1 Then
        Locate 1, 1
        Print Left$(Str$(1 / (Timer(.0001) - looptimer#)), 5) 'Prints Framrate
    End If
    'Print collisioncounter%
    'Print mouseymatrix%
    'Draw Screen Features
    Line (0, 0)-(479, 359), _RGB(0, 255, 0), B
    Line (480, 0)-(719, 359), _RGB(0, 0, 0), BF 'blacks out part of screen on the right, because limits aren't perfect
    'Draw Text/etc on right hand panel
    'Print screenx%
    'Print screeny%
    Locate 2, 62
    Color _RGB(0, 255, 72)
    Select Case cursorstyle%
        Case 1
            Print "PLACE OBJECTS"
        Case 2
            Print "DRAW"
        Case 3
            Print "ERASE"
        Case 4
            Print "PUSH MAGNET"
        Case 5
            Print "PULL MAGNET"
        Case 6
            Print "MAGNET BOMB"
        Case 7
            Print "BUILD BOX"
        Case 8
            Print "SMALL BOMB"
        Case 9
            Print "LARGE BOMB"
        Case 10
            Print "FORCE WALL"
        Case 11
            Print "ROCKETS"
        Case 12
            Print "MISSILE"
    End Select
    Locate 3, 62
    Color _RGB(255, 255, 255)
    Print "COST:"
    Locate 3, 68
    Print costarray%(cursorstyle%)
    If cursorstyle% = 2 Or cursorstyle% = 3 Then
        Locate 4, 62
        Print "PER SPOT"
    End If
    Select Case pwarning%
        Case 1
            Locate 4, 62
            Print "ILLEGAL LOCATION"
        Case 2
            Locate 4, 62
            Print "OUT OF BOUNDS"
        Case 3
            Locate 4, 62
            Print "OBJECT LIMIT"
    End Select
    Locate 1, 62
    Color _RGB(255, 255, 255)
    Print "TIME:"
    Locate 1, 68
    Print Int(scoretimer# - gametimer#)
    Locate 5, 62
    Color _RGB(0, 139, 0)
    Print "MONEY:"
    Locate 5, 68
    Print money%
    Locate 6, 62
    Color _RGB(55, 78, 227)
    Print "BOXES SAVED:"
    Locate 6, 74
    Print boxsaved%
    Locate 7, 62
    Color _RGB(255, 55, 55)
    Print "BOXES LOST:"
    Locate 7, 74
    Print boxdestroyed%
    Color _RGB(183, 183, 183)
    Locate 8, 62
    Print "OBJECTS USED:"
    Locate 9, 62
    Print Str$(permanentobjectsused%)
    Locate 9, 67
    Print "/50"
    Color _RGB(255, 255, 255)
    Locate 10, 62
    Print "1 DRAW"
    Locate 10, 75
    Print costarray%(2)
    Locate 11, 62
    Print "2 ERASE"
    Locate 11, 75
    Print costarray%(3)
    Locate 12, 62
    Print "3 PUSH MAGNET"
    Locate 12, 75
    Print costarray%(4)
    Locate 13, 62
    Print "4 PULL MAGNET"
    Locate 13, 75
    Print costarray%(5)
    Locate 14, 62
    Print "5 MAGNET BOMB"
    Locate 14, 75
    Print costarray%(6)
    Locate 15, 62
    Print "6 BUILD BOX"
    Locate 15, 75
    Print costarray%(7)
    Locate 16, 62
    Print "7 SMALL BOMB"
    Locate 16, 75
    Print costarray%(8)
    Locate 17, 62
    Print "8 LARGE BOMB"
    Locate 17, 75
    Print costarray%(9)
    Locate 18, 62
    Print "9 FORCE WALL"
    Locate 18, 75
    Print costarray%(10)
    Locate 19, 62
    Print "0 ROCKETS"
    Locate 19, 75
    Print costarray%(11)
    Locate 20, 62
    Print "- MISSILE"
    Locate 20, 75
    Print costarray%(12)
    Line (481, (cursorstyle% - 1) * 16 + 126)-(639, (cursorstyle% - 1) * 16 + 126 + 16), _RGB(255, 0, 0), B
    'Draw Mouse Last
    Line (mousexpos%, mouseypos%)-(mousexpos% + 3, mouseypos%), _RGB(255, 255, 255)
    Line (mousexpos%, mouseypos%)-(mousexpos%, mouseypos% + 3), _RGB(255, 255, 255)
    Line (mousexpos%, mouseypos%)-(mousexpos% + 4, mouseypos% + 4), _RGB(255, 255, 255)
    _Display
    looptimer# = Timer(.0001)
    _Limit framelimit
Wend
Close #5
'Close #6
outputobjects

'End Screen
Cls
boxdestroyed% = 50 - boxsaved%
Color _RGB(44, 177, 227)
Locate 2, 36
Print "BOX BASH"
'80 Characters across
Locate 4, 32
Color _RGB(211, 72, 127)
Print "BOXES SAVED:"
Locate 6, 38
Print boxsaved%
Locate 8, 32
Color _RGB(39, 188, 133)
Print "BOXES LOST:"
Locate 10, 38
Print boxdestroyed%
Locate 12, 32
Color _RGB(139, 0, 255)
Print "PENALTY"
Locate 14, 38
Print penalty% * 300
Locate 16, 36
Color _RGB(238, 83, 200)
Print "FINAL SCORE:"
Locate 18, 38
Print boxsaved% * 100 - boxdestroyed% * 24 - penalty% * 300
Locate 20, 28
Color _RGB(94, 205, 28)
Print "Press Any Key To Continue"
_Display
Sleep 10

Cls
Color _RGB(255, 255, 255)
If (boxsaved% * 100 - boxdestroyed% * 24 - penalty% * 300) > 0 Then
    Locate 14, 25
    If level% <= 9 Then
        inputchar$ = ""
        gametimer# = Timer(.0001)
        scoretimer# = gametimer# + 5 'WAIT 5 SECONDS
        Do: K$ = InKey$: Loop Until K$ = ""
        While inputchar$ = "" And scoretimer# - gametimer# > 0
            inputchar$ = InKey$
            gametimer# = Timer(.0001)
            If Int(gametimer# * 240) Mod 60 = 1 Then 'CHANGING COLOR BORDER 4 Hz
                Cls
                Line (2, 2)-(638, 358), _RGB(Int(Rnd * 255), Int(Rnd * 255), Int(Rnd * 255)), B
                Locate 12, 25
                Print "You Advance to the next level!"
                _Display
            End If
        Wend
        level% = level% + 1
        GoTo start
    Else
        victory
    End If
Else
    Locate 10, 35
    Print "GAME OVER"
End If


Sub Paintmap
    Dim cursorstyle%, brushsize%
    Dim looptimer#, fillpercent#
    Dim clickdown`, clickdownR` 'a bit, either -1 or 0
    Dim oldscale#, scalefactor%
    Dim mousewheelvalue%, mousexpos%, mouseypos%, mousexmatrix%, mouseymatrix%
    Dim pwarning%
    Dim drawpoints#(16, 2)
    Dim redcolor#, bluecolor#, greencolor#
    scale# = 3
    scalefactor% = 1
    mousexpos% = 160 'Integer
    mouseypos% = 100
    cursorstyle% = 2
    screenx% = 0 'These values go negative as you scroll down and accross
    screeny% = 0 'They are the screen offset values
    fillpercent# = 1
    brushsize% = 8
    While inputchar$ <> Chr$(27)
        'Cls 'temporary clear screen to see troubleshooting input steps
        inputchar$ = InKey$
        oldscale# = scale#
        If inputchar$ = "." Then scale# = scale# + 0.2
        If inputchar$ = "," Then scale# = scale# - 0.2
        If UCase$(inputchar$) = "S" Then Savefile
        If UCase$(inputchar$) = "L" Then Loadfile
        If inputchar$ = "/" Then scale# = 1
        If UCase$(inputchar$) = "O" Then
            Cls
            Color _RGB(233, 255, 222)
            Print "Options"
            Input "Brush size: ", brushsize%
            Input "Fill Percent: ", fillpercent#
            If brushsize% < 1 Then brushsize% = 1
            If brushsize% > 200 Then brushsize% = 200
            If fillpercent# < 1 Then fillpercent# = 1
            If fillpercent# > 200 Then fillpercent# = 200
            fillpercent# = fillpercent# / 200 'to artificially reduce the number entered, since it fills in fast
        End If
        If UCase$(inputchar$) = prev$ Then cursorstyle% = cursorstyle% + 1
        If UCase$(inputchar$) = adv$ Then cursorstyle% = cursorstyle% - 1
        If _KeyDown(20480) Then screeny% = screeny% - 1 'up arrow
        If _KeyDown(18432) Then screeny% = screeny% + 1 'down arrow
        If _KeyDown(19200) Then screenx% = screenx% + 1 'left arrow
        If _KeyDown(19712) Then screenx% = screenx% - 1 'right arrow
        If cursorstyle% > 10 Then cursorstyle% = 1
        If cursorstyle% < 1 Then cursorstyle% = 10
        If _MouseInput Then
            mousewheelvalue% = _MouseWheel
            If mousewheelvalue% Then
                scale# = scale# - mousewheelvalue% * scale# * 0.2
            End If
            mousexpos% = mousexpos% + _MouseMovementX
            mouseypos% = mouseypos% + _MouseMovementY
        End If
        If _MouseButton(2) And clickdownR` = 0 Then
            cursorstyle% = cursorstyle% + 1
            clickdownR` = -1
        End If
        If scale# < 0.25 Then scale# = 0.25
        If scale# > 30 Then scale# = 30
        If oldscale# <> scale# Then 'adjust screen offsets is scaling changes
            screenx% = Int(-scale# * (mousexpos% - screenx%) / (oldscale#) + mousexpos%)
            screeny% = Int(-scale# * (mouseypos% - screeny%) / (oldscale#) + mouseypos%)
        End If
        mousexmatrix% = Round((mousexpos% - screenx%) / scale#)
        mouseymatrix% = Round((mouseypos% - screeny%) / scale#)
        'Print mousexmatrix%
        'Print mouseymatrix%

        ' 4 PLACES TO ADDRESS USER INTERACTIONS.  HERE, BEFORE GRAPHICS, IN GRAPHICS & IN PHYSICS
        If _MouseButton(1) And cursorstyle% = 1 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'Paint Soft Surface
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, 2, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 2 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'Erase
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, 0, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 3 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'Durable Surface
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, 4, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 4 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'Invincible Surface
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, 3, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 5 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'Blinking
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, 1, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 6 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'EXIT DOOR
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, -1, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 7 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'PINK PASS-THRU
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, -2, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 8 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then 'YELLOW PASS-THRU BACKGROUND
            brushfill mousexmatrix%, mouseymatrix%, brushsize%, -3, fillpercent#
        End If
        If _MouseButton(1) And cursorstyle% = 9 And clickdown` = 0 Then 'Build Box
            If Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then
                If landscape(mousexmatrix%, mouseymatrix%) = 0 Or landscape(mousexmatrix%, mouseymatrix%) = 1 Then
                    NewGameObject 6, (mousexpos% - screenx%) / scale#, (mouseypos% - screeny%) / scale#, 1, 0, 0, 0
                    clickdown` = -1
                Else
                    pwarning% = 1
                    warningtimer# = gametimer# + .5
                End If
            Else
                pwarning% = 2
                warningtimer# = gametimer# + .5
            End If
        End If
        If _MouseButton(1) And cursorstyle% = 10 And clickdown` = 0 And Inbounds(mousexmatrix%, mouseymatrix%) = 1 Then '-1=True
            If landscape(mousexmatrix%, mouseymatrix%) = 0 Or landscape(mousexmatrix%, mouseymatrix%) = 1 Then
                clickdown` = -1 'clickdown`=-1 when mouse button is down
                placeobject ((mousexpos% - screenx%) / scale#), ((mouseypos% - screeny%) / scale#)
            Else
                pwarning% = 1
                warningtimer# = gametimer# + .5
            End If
        ElseIf _MouseButton(1) And cursorstyle% = 1 And clickdown` = 0 And Inbounds(mousexmatrix%, mouseymatrix%) = 0 Then
            pwarning% = 2
            warningtimer# = gametimer# + .5
        End If

        If mousexpos% < 1 Then mousexpos% = 1
        If mousexpos% > 480 Then mousexpos% = 480
        If mouseypos% < 1 Then mouseypos% = 1
        If mouseypos% > 360 Then mouseypos% = 360
        If mousexpos% = 1 Then screenx% = screenx% + scrollspeed%
        If mousexpos% = 480 Then screenx% = screenx% - scrollspeed%
        If mouseypos% = 1 Then screeny% = screeny% + scrollspeed%
        If mouseypos% = 360 Then screeny% = screeny% - scrollspeed%
        'LIMIT SCREEN OFFSETS
        If -screenx% < -40 / scale# Then screenx% = 40 / scale#
        If -screeny% < -30 / scale# Then screeny% = 30 / scale#
        If -screenx% > 960 * scale# - 480 + 40 / scale# Then screenx% = -960 * scale# + 480 - 40 / scale#
        If -screeny% > 720 * scale# - 320 + 20 / scale# Then screeny% = -720 * scale# + 320 - 20 / scale#

        Do While _MouseInput 'Clear Mouse Buffer
        Loop
        scrollspeed% = Int(scale# / 10) + 3

        'Game Logic
        If gametimer# - healthreductiontimer# > 0 Then
            For x = 0 To UBound(physobjarray)
                If physobjarray(x).otype = 2 Then physobjarray(x).healthtime = physobjarray(x).healthtime - decayrate#
            Next x
            healthreductiontimer# = gametimer# + 1
        End If

        'Cycle Through Game Objects For Non-Graphical Effects
        For x = 0 To UBound(gameobjectarray)
            Select Case gameobjectarray(x).otype
                Case 6 'Box Build
                    If _MouseButton(1) = -1 And clickdown` = -1 Then
                        gameobjectarray(x).radius = 1.4 * Sqr((((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos) ^ 2 + (((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos) ^ 2)
                        gameobjectarray(x).angle = _Atan2(((mouseypos% - screeny%) / scale#) - gameobjectarray(x).ypos, ((mousexpos% - screenx%) / scale#) - gameobjectarray(x).xpos)
                        If gameobjectarray(x).radius > 60 Then gameobjectarray(x).radius = 60
                    End If
                    If _MouseButton(1) = 0 And clickdown` = -1 Then
                        drawpoints#(1, 1) = gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + _Pi / 4)
                        drawpoints#(1, 2) = gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + _Pi / 4)
                        drawpoints#(2, 1) = gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 3 * _Pi / 4)
                        drawpoints#(2, 2) = gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 3 * _Pi / 4)
                        drawpoints#(3, 1) = gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 5 * _Pi / 4)
                        drawpoints#(3, 2) = gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 5 * _Pi / 4)
                        drawpoints#(4, 1) = gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 7 * _Pi / 4)
                        drawpoints#(4, 2) = gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 7 * _Pi / 4)
                        xx% = 0
                        While (physobjarray(xx%).otype <> 2 And xx% < UBound(physobjarray)) Or ((physobjarray(xx%).otype = 2 And In4Points(physobjarray(xx%).xpos, physobjarray(xx%).ypos, drawpoints#(1, 1), drawpoints#(1, 2), drawpoints#(2, 1), drawpoints#(2, 2), drawpoints#(3, 1), drawpoints#(3, 2), drawpoints#(4, 1), drawpoints#(4, 2)) = -1) And xx% < UBound(physobjarray))
                            xx% = xx% + 1
                        Wend
                        If xx% = UBound(physobjarray) And permanentobjectsused% < 20 Then
                            NewObject 1, 0, 10, gameobjectarray(x).radius, 10, gameobjectarray(x).xpos, gameobjectarray(x).ypos, 0, 0, 0, 0, 1, gameobjectarray(x).angle, 0, .1, 0.05 '(otype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction, damping)
                            permanentobjectsused% = permanentobjectsused% + 1
                        Else
                            If xx% = UBound(physobjarray) Then
                                pwarning% = 3
                            Else
                                pwarning% = 1
                            End If
                            warningtimer# = gametimer# + .5
                        End If
                        gameobjectarray(x).otype = 0
                    End If
            End Select
        Next x

        If _MouseButton(1) = 0 And clickdown` = -1 Then clickdown` = 0 'mouse button unclicked
        If _MouseButton(2) = 0 And clickdownR` = -1 Then clickdownR` = 0 'Right mouse button unclicked

        gametimer# = Timer(.0001)
        If gametimer# - physicstimer# > 2 Then physicstimer# = gametimer#

        While physicstimer# < gametimer#
            physicstimer# = physicstimer# + 1 / 60 'not actually using physics limit here
        Wend

        'DRAW EVERYTHING
        Cls
        'Draw visible portion of screen
        DrawGrid screenx%, screeny%, scale#
        DrawObjects screenx%, screeny%, scale#
        'Cycle Through Game Objects for Graphical Effects
        For x = 0 To UBound(gameobjectarray)
            Select Case gameobjectarray(x).otype
                Case 6 'BUILD BOX
                    drawpoints#(1, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + _Pi / 4)) * scale#
                    drawpoints#(1, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + _Pi / 4)) * scale#
                    drawpoints#(2, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                    drawpoints#(2, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 3 * _Pi / 4)) * scale#
                    drawpoints#(3, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                    drawpoints#(3, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 5 * _Pi / 4)) * scale#
                    drawpoints#(4, 1) = screenx% + (gameobjectarray(x).xpos + .707 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                    drawpoints#(4, 2) = screeny% + (gameobjectarray(x).ypos + .707 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle + 7 * _Pi / 4)) * scale#
                    Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 255, 255)
                    Line (drawpoints#(2, 1), drawpoints#(2, 2))-(drawpoints#(3, 1), drawpoints#(3, 2)), _RGB(255, 255, 255)
                    Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 255, 255)
                    Line (drawpoints#(4, 1), drawpoints#(4, 2))-(drawpoints#(1, 1), drawpoints#(1, 2)), _RGB(255, 255, 255)
            End Select
        Next x

        'Print mouseymatrix%
        'Draw Screen Features
        Line (0, 0)-(479, 359), _RGB(0, 255, 0), B
        Line (480, 0)-(719, 359), _RGB(0, 0, 0), BF 'blacks out part of screen on the right, because limits aren't perfect
        'Draw Text/etc on right hand panel
        'Print screenx%
        'Print screeny%
        Locate 1, 62
        If Rnd < .01 Then
            redcolor# = Int(Rnd * 255)
            bluecolor# = Int(Rnd * 255)
            greencolor# = Int(Rnd * 255)
        End If
        Color _RGB(redcolor#, bluecolor#, greencolor#)
        Print "MAP EDITOR"
        Locate 2, 62
        Color _RGB(0, 255, 72)
        Select Case cursorstyle%
            Case 1
                Print "SOFT SURFACE"
            Case 2
                Print "ERASE"
            Case 3
                Print "DURABLE SURF"
            Case 4
                Print "INDESTRUCTIBLE"
            Case 5
                Print "BLINKING"
            Case 6
                Print "EXIT DOOR"
            Case 7
                Print "PINK BACKGROUND"
            Case 8
                Print "YWL BACKGROUND"
            Case 9
                Print "BUILD BOX"
            Case 10
                Print "ADV PLACE OBJ"
        End Select
        Select Case pwarning%
            Case 1
                Locate 4, 62
                Print "ILLEGAL LOCATION"
            Case 2
                Locate 4, 62
                Print "OUT OF BOUNDS"
            Case 3
                Locate 4, 62
                Print "OBJECT LIMIT"
        End Select
        Locate 12, 62
        Print "OBJECTS USED:"
        Locate 13, 62
        Print Str$(permanentobjectsused%)
        Locate 13, 67
        Print "/20"
        Locate 15, 62
        Print "ESQ TO QUIT"
        'Draw Mouse Last
        Line (mousexpos%, mouseypos%)-(mousexpos% + 3, mouseypos%), _RGB(255, 255, 255)
        Line (mousexpos%, mouseypos%)-(mousexpos%, mouseypos% + 3), _RGB(255, 255, 255)
        Line (mousexpos%, mouseypos%)-(mousexpos% + 4, mouseypos% + 4), _RGB(255, 255, 255)
        _Display
        looptimer# = Timer(.0001)
        _Limit framelimit
    Wend
End Sub


Sub PhysicsCollisions
    Dim numobjects%, initialimpact%, initialimpactenvironment%
    numobjects% = UBound(physobjarray)
    ReDim corners#(numobjects%, 7) 'without _PRESERVE all values become 0
    Dim drawpoints#(4, 2)
    Dim forcelist#(collisionperobjectlimit%, 2)
    Dim finalforcelist#(collisionperobjectlimit%, 2)
    Dim normx#, normy#, tx#, ty#, ttorque#, sum#, temp#
    Dim distance#, dot#, dist#, angle1#, angle2#, dist1#, dist2#, correction#, pangle#, vangle#, fangle#
    Dim playsound1%, playsound2%
    Dim tvx#, tvy#, cpx#, cpy# 'Total Velocity & collision Point
    Dim textstring$
    playsound1% = 0 'triggers if touching a new physics objects
    playsound2% = 0 'triggers if touching a new environment object
    'Compute Physics
    update_non_screen_corners

    'Update accelerations based off of force in splots 8 and 9, and angular acceleration based off of Torque and I in 16
    Dim totalforcecounter%, tcheck%
    Dim rotperc#, transperc#
    Dim xmincorner%, ymincorner%, xmaxcorner%, ymaxcorner%
    For i% = 0 To numobjects%
        'PHYSICS
        'GRAVITY
        If physobjarray(i%).otype > 1 Then
            physobjarray(i%).xacc = 0 'x accel
            physobjarray(i%).angleaccel = 0 'angular accel
            If physobjarray(i%).otype = 2 Then
                physobjarray(i%).yacc = gravity#
            Else
                physobjarray(i%).yacc = 0
            End If
        End If
        initialimpact% = physobjarray(i%).touching
        initialimpactenvironment% = physobjarray(i%).environ
        tx# = 0
        ty# = 0
        ttorque# = 0
        physobjarray(i%).touching = 0 'reset number of objects hitting each round
        physobjarray(i%).environ = 0 'Same for environment boxes
        totalforcecounter% = 0
        ReDim forcelist#(collisionperobjectlimit%, 2) 'also clears all values
        ReDim finalforcelist#(collisionperobjectlimit%, 2)
        'FIND COLLISIONS
        If physobjarray(i%).otype <> 0 And physobjarray(i%).otype <> 1 Then 'Force Calculations not needed for things that don't exist or are fixed
            For j% = 0 To numobjects%
                If j% <> i% And physobjarray(j%).otype <> 0 Then 'don't include self intersections or j items that don't exists
                    'Weed out things that are too far apart
                    distance# = Sqr((physobjarray(i%).xpos - physobjarray(j%).xpos) ^ 2 + (physobjarray(i%).ypos - physobjarray(j%).ypos) ^ 2)
                    If distance# < (1.42 * physobjarray(i%).size + 1.42 * physobjarray(j%).size) Then
                        If write1% = 1 Then Print #5, ""
                        If write1% = 1 Then Print #5, "CALCULATING OBJECT ", i%, " AGAINST OBJECT ", j%

                        'touching forces: the idea is each objects acts a little bit like a weak spring
                        tcheck% = totalforcecounter%
                        If touchcondition% = 1 Then
                            If In4Points%(springcorners#(i%, 0), springcorners#(i%, 1), springcorners#(j%, 0), springcorners#(j%, 1), springcorners#(j%, 2), springcorners#(j%, 3), springcorners#(j%, 4), springcorners#(j%, 5), springcorners#(j%, 6), springcorners#(j%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 1"
                                inner_collision springcorners#(i%, 0), springcorners#(i%, 1), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(i%, 2), springcorners#(i%, 3), springcorners#(j%, 0), springcorners#(j%, 1), springcorners#(j%, 2), springcorners#(j%, 3), springcorners#(j%, 4), springcorners#(j%, 5), springcorners#(j%, 6), springcorners#(j%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 2"
                                inner_collision springcorners#(i%, 2), springcorners#(i%, 3), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(i%, 4), springcorners#(i%, 5), springcorners#(j%, 0), springcorners#(j%, 1), springcorners#(j%, 2), springcorners#(j%, 3), springcorners#(j%, 4), springcorners#(j%, 5), springcorners#(j%, 6), springcorners#(j%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 3"
                                inner_collision springcorners#(i%, 4), springcorners#(i%, 5), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(i%, 6), springcorners#(i%, 7), springcorners#(j%, 0), springcorners#(j%, 1), springcorners#(j%, 2), springcorners#(j%, 3), springcorners#(j%, 4), springcorners#(j%, 5), springcorners#(j%, 6), springcorners#(j%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 4"
                                inner_collision springcorners#(i%, 6), springcorners#(i%, 7), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(j%, 0), springcorners#(j%, 1), springcorners#(i%, 0), springcorners#(i%, 1), springcorners#(i%, 2), springcorners#(i%, 3), springcorners#(i%, 4), springcorners#(i%, 5), springcorners#(i%, 6), springcorners#(i%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 5"
                                inner_collision springcorners#(j%, 0), springcorners#(j%, 1), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(j%, 2), springcorners#(j%, 3), springcorners#(i%, 0), springcorners#(i%, 1), springcorners#(i%, 2), springcorners#(i%, 3), springcorners#(i%, 4), springcorners#(i%, 5), springcorners#(i%, 6), springcorners#(i%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 6"
                                inner_collision springcorners#(j%, 2), springcorners#(j%, 3), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(j%, 4), springcorners#(j%, 5), springcorners#(i%, 0), springcorners#(i%, 1), springcorners#(i%, 2), springcorners#(i%, 3), springcorners#(i%, 4), springcorners#(i%, 5), springcorners#(i%, 6), springcorners#(i%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 7"
                                inner_collision springcorners#(j%, 4), springcorners#(j%, 5), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                            If In4Points%(springcorners#(j%, 6), springcorners#(j%, 7), springcorners#(i%, 0), springcorners#(i%, 1), springcorners#(i%, 2), springcorners#(i%, 3), springcorners#(i%, 4), springcorners#(i%, 5), springcorners#(i%, 6), springcorners#(i%, 7)) = 1 Then
                                'If write1%=1 Then Print #5, "TCORNER 8"
                                inner_collision springcorners#(j%, 6), springcorners#(j%, 7), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                            End If
                        End If
                        'If write1%=1 Then Print #5, "DISTANCE: ", distance#
                        '                        physobjarray(i%).xvel * physobjarray(j%).xvel + physobjarray(i%).yvel * physobjarray(j%).yvel 'dot product of vel vectors.  useful?
                        '                        Dynamic forces
                        If In4Points%(corners#(i%, 0), corners#(i%, 1), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 1"
                            outer_collision corners#(i%, 0), corners#(i%, 1), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(i%, 2), corners#(i%, 3), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 2"
                            outer_collision corners#(i%, 2), corners#(i%, 3), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(i%, 4), corners#(i%, 5), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 3"
                            outer_collision corners#(i%, 4), corners#(i%, 5), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(i%, 6), corners#(i%, 7), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 4"
                            outer_collision corners#(i%, 6), corners#(i%, 7), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(j%, 0), corners#(j%, 1), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 5"
                            outer_collision corners#(j%, 0), corners#(j%, 1), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(j%, 2), corners#(j%, 3), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 6"
                            outer_collision corners#(j%, 2), corners#(j%, 3), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(j%, 4), corners#(j%, 5), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 7"
                            outer_collision corners#(j%, 4), corners#(j%, 5), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If In4Points%(corners#(j%, 6), corners#(j%, 7), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
                            'If write1%=1 Then Print #5, "CORNER 8"
                            outer_collision corners#(j%, 6), corners#(j%, 7), i%, j%, totalforcecounter%, forcelist#() 'This sub updates forcelist# at index totalforcecounter%
                        End If
                        If tcheck% <> totalforcecounter% Then physobjarray(i%).touching = physobjarray(i%).touching + 1
                        If write1% = 1 Then Print #5, "TOUCH CHECK AND TOUCHFORCECOUNTER : ", tcheck%, totalforcecounter%, physobjarray(i%).touching
                    End If
                End If
            Next j%

            'Add environment collisions here
            xmincorner% = Int(physobjarray(i%).xpos - physobjarray(i%).size * .7072) - 1
            ymincorner% = Int(physobjarray(i%).ypos - physobjarray(i%).size * .7072) - 1
            xmaxcorner% = Int(physobjarray(i%).xpos + physobjarray(i%).size * .7072) + 2
            ymaxcorner% = Int(physobjarray(i%).ypos + physobjarray(i%).size * .7072) + 2
            If xmincorner% < 0 Then xmincorner% = 0
            If xmincorner% > 960 Then xmincorner% = 960
            If ymincorner% < 0 Then ymincorner% = 0
            If ymincorner% > 720 Then ymincorner% = 720
            If xmaxcorner% < 0 Then xmaxcorner% = 0
            If xmaxcorner% > 960 Then xmaxcorner% = 960
            If ymaxcorner% < 0 Then ymaxcorner% = 0
            If ymaxcorner% > 720 Then ymaxcorner% = 720
            'Print scalefactor%
            'Dim valuex1#, valuex2#, valuey1#, valuey2#
            If write1% = 1 Then
                Print #5, ""
                Print #5, "Environmental Collision START!"
            End If
            For down% = ymincorner% To ymaxcorner% Step 1
                For across% = xmincorner% To xmaxcorner% Step 1
                    If landscape(across%, down%) >= 2 Then
                        dist# = Sqr((physobjarray(i%).xpos - across%) ^ 2 + (physobjarray(i%).ypos - down%) ^ 2)
                        angle1# = _Atan2(physobjarray(i%).ypos - down%, physobjarray(i%).xpos - across%) - 0 'from environment box to cursor box, relative to fixed box
                        angle2# = _Atan2(down% - physobjarray(i%).ypos, across% - physobjarray(i%).xpos) - physobjarray(i%).angle 'from cursor box to environment box relative to cursor box
                        'dist1# = 1 / 2 * (1.12412487 - 0.158465548 * Cos(4 * angle1#) + 0.04980645 * Cos(8 * angle1#) - 0.023735474 * Cos(12 * angle1#) + 0.0136513 * Cos(16 * angle1#) - 0.0088865545 * Cos(20 * angle1#))
                        dist1# = 1 / 2 * radialsquare(angle1#)
                        'dist2# = physobjarray(i%).size / 2 * (1.12412487 - 0.158465548 * Cos(4 * angle2#) + 0.04980645 * Cos(8 * angle2#) - 0.023735474 * Cos(12 * angle2#) + 0.0136513 * Cos(16 * angle2#) - 0.0088865545 * Cos(20 * angle2#))
                        dist2# = physobjarray(i%).size / 2 * radialsquare(angle2#)
                        'OLD CORRECTION METHOD, less accurate
                        'correction# = (0.5 * Cos(4 * ((physobjarray(i%).angle - 0) - _Pi / 4)) + 0.5) * (0.5 * Cos(4 * ((angle1# - 0) - _Pi / 4)) + 0.5) * (0.5 * (Sqr(2) - 1) * (physobjarray(i%).size / 2 + 1 / 2))
                        'NEW CORRECTION METHOD
                        correction# = boxcollisioncorrection(0, physobjarray(i%).angle, _Atan2(physobjarray(i%).ypos - down%, physobjarray(i%).xpos - across%), 1, physobjarray(i%).size)
                        If correction# < 0 Then correction# = 0 'almost never happens, and is only very small values when it does
                        'boxcollisioncorrection(angle#, cangle#, _Atan2(py# - centery#, px# - centerx#), size#, csize#)
                        'use law of cosines to calculate max distance
                        'If dist# > Sqr((Sqr(2) * (1 / 2)) ^ 2 + (Sqr(2) * (physobjarray(i%).size / 2)) ^ 2 - 2 * (1 / 2) * 1 * physobjarray(i%).size * Cos(.75 * _Pi)) Then correction# = 0 'probably an un-needed precaution, but just in case
                        'This simplifies down to:
                        If dist# > Sqr(0.5 + 0.5 * physobjarray(i%).size ^ 2 - physobjarray(i%).size * Cos(.75 * _Pi)) + 1 Then correction# = 0 'Add 1 to avoid rounding error, and because the maximum distance is actually a little past this angle (size dependant)
                        'collision point approximation
                        cpx# = across% + 0.5 * Cos(angle1#) 'perhaps I can develop a better formula here later
                        cpy# = down% + 0.5 * Sin(angle1#)
                        'total velocity of cursor box approximation
                        tvx# = physobjarray(i%).xvel - physobjarray(i%).anglevel * physobjarray(i%).size / 2 * Sin(angle1# + _Pi)
                        tvy# = physobjarray(i%).yvel + physobjarray(i%).anglevel * physobjarray(i%).size / 2 * Cos(angle1# + _Pi)
                        dot# = tvx# * Cos(angle1# + _Pi) + tvy# * Sin(angle1# + _Pi) 'is the collision point coming or going?  positive means it's coming
                        If dist# < (dist1# + dist2# + correction#) Then 'if there is a collision
                            If totalforcecounter% <= collisionperobjectlimit% Then
                                If tvx# ^ 2 + tvy# ^ 2 > .001 Then 'if the colliding object is moving
                                    vangle# = _Atan2(tvy#, tvx#) + _Pi 'velocity angle
                                    'vangle# = avgangle#(_Atan2(tvy#, tvx#) + _Pi, _Atan2(physobjarray(i%).yvel, physobjarray(i%).xvel) + _Pi) 'average of point velocity and object velocity  angle
                                Else
                                    vangle# = angle1# 'else the angle is the opposite of the away vector
                                End If
                                fixangle (angle1#) 'output will be between 0 and 2Pi
                                'force angle average of velocity/away vector and face angle
                                If angle1# > 0.25 * _Pi And angle1# < _Pi * .75 Then
                                    pangle# = _Pi / 2
                                ElseIf angle1# >= 0.75 * _Pi And angle1# <= 1.25 * _Pi Then
                                    pangle# = _Pi
                                ElseIf angle1# > 1.25 * _Pi And angle1# < 1.75 * _Pi Then
                                    pangle# = -_Pi / 2
                                Else
                                    pangle# = 0
                                End If
                                fangle# = avgangle#(pangle#, vangle#)
                                forcelist#(totalforcecounter%, 0) = ((dist1# + dist2# + correction#) - dist#) * 1000 * Cos(fangle#)
                                forcelist#(totalforcecounter%, 1) = ((dist1# + dist2# + correction#) - dist#) * 1000 * Sin(fangle#)
                                'Add damping if the points are moving away from each other
                                If dot# < 0 Then 'if the points are moving away from each other, then there is DAMPING
                                    forcelist#(totalforcecounter%, 0) = forcelist#(totalforcecounter%, 0) * 0.90
                                    forcelist#(totalforcecounter%, 1) = forcelist#(totalforcecounter%, 1) * 0.90
                                ElseIf Sqr(tvx# ^ 2 + tvy# ^ 2) > 3.0 Then
                                    physobjarray(i%).environ = physobjarray(i%).environ + 1
                                    'playsound2% = 1 'only play the sound if they are getting closer
                                End If
                                If (-Sin(angle1#) * forcelist#(totalforcecounter%, 0) + Cos(angle1#) * forcelist#(totalforcecounter%, 1)) < 0 Then 'inequality reversed because angle is reversed
                                    '         dot product of negative recirprocal of normalized angle vector (from sin/cos) with force vector then the rotation is positive
                                    forcelist#(totalforcecounter%, 2) = Sqr(forcelist#(totalforcecounter%, 0) ^ 2 + forcelist#(totalforcecounter%, 1) ^ 2) * perpvector(cpx#, cpy#, forcelist#(totalforcecounter%, 0), forcelist#(totalforcecounter%, 1), physobjarray(i%).xpos, physobjarray(i%).ypos) '+F*R
                                Else
                                    forcelist#(totalforcecounter%, 2) = -Sqr(forcelist#(totalforcecounter%, 0) ^ 2 + forcelist#(totalforcecounter%, 1) ^ 2) * perpvector(cpx#, cpy#, forcelist#(totalforcecounter%, 0), forcelist#(totalforcecounter%, 1), physobjarray(i%).xpos, physobjarray(i%).ypos) '+F*R
                                End If
                                If write1% = 1 Then
                                    Print #5, "Environmental Collision COLLISION", across%, down%
                                    Print #5, "ANGLE: ", fangle#
                                    Print #5, "ANGLES: ", vangle#, pangle#, angle1#, angle2#
                                    Print #5, "DOT: ", dot#
                                    Print #5, "Perp Vector: ", perpvector(across%, down%, forcelist#(totalforcecounter%, 0), forcelist#(totalforcecounter%, 1), physobjarray(i%).xpos, physobjarray(i%).ypos)
                                    Print #5, "Collision Point: ", cpx#, cpy#
                                    Print #5, "Total Velocity: ", tvx#, tvy#
                                    Print #5, "TOTAL FORCE: ", totalforcecounter%
                                    Print #5, "X, Y, Torque ", forcelist#(totalforcecounter%, 0), forcelist#(totalforcecounter%, 1), forcelist#(totalforcecounter%, 2)
                                End If
                                totalforcecounter% = totalforcecounter% + 1
                            End If
                        End If
                    End If
                Next across%
            Next down%
            'Once the number of colliding objects has been determined, environmental damage can be determined
            For down% = ymincorner% To ymaxcorner% Step 1
                For across% = xmincorner% To xmaxcorner% Step 1
                    If landscape(across%, down%) >= 2 Then
                        dist# = Sqr((physobjarray(i%).xpos - across%) ^ 2 + (physobjarray(i%).ypos - down%) ^ 2)
                        angle1# = _Atan2(physobjarray(i%).ypos - down%, physobjarray(i%).xpos - across%) - 0 'from environment box to cursor box, relative to fixed box
                        angle2# = _Atan2(down% - physobjarray(i%).ypos, across% - physobjarray(i%).xpos) - physobjarray(i%).angle 'from cursor box to environment box relative to cursor box
                        dist1# = 1 / 2 * radialsquare(angle1#)
                        dist2# = physobjarray(i%).size / 2 * radialsquare(angle2#)
                        'NEW CORRECTION METHOD
                        correction# = boxcollisioncorrection(0, physobjarray(i%).angle, _Atan2(physobjarray(i%).ypos - down%, physobjarray(i%).xpos - across%), 1, physobjarray(i%).size)
                        If correction# < 0 Then correction# = 0 'almost never happens, and is only very small values when it does
                        If dist# > Sqr(0.5 + 0.5 * physobjarray(i%).size ^ 2 - physobjarray(i%).size * Cos(.75 * _Pi)) + 1 Then correction# = 0 'Add 1 to avoid rounding error, and because the maximum distance is actually a little past this angle (size dependant)
                        'total velocity of cursor box approximation
                        tvx# = physobjarray(i%).xvel - physobjarray(i%).anglevel * physobjarray(i%).size / 2 * Sin(angle1# + _Pi)
                        tvy# = physobjarray(i%).yvel + physobjarray(i%).anglevel * physobjarray(i%).size / 2 * Cos(angle1# + _Pi)
                        'The collision does damage to the environment if the total velocity is fast enough
                        If dist# < (dist1# + dist2# + correction#) Then 'if there is a collision
                            If tvx# ^ 2 + tvy# ^ 2 > 10 And (landscape(across%, down%) = 2 Or landscape(across%, down%) = 4) Then 'Keep this as a velocity limit, since energy depends on mass, and I don't want a heavy object with lots of mass to still trigger collisions at low velocities
                                If write1% = 1 Then
                                    Print #5, "BOX DAMAGE: lin, rot :", .05 * 0.5 * physobjarray(i%).mass * (physobjarray(i%).xvel ^ 2 + physobjarray(i%).yvel ^ 2), .05 * 0.5 * physobjarray(i%).rotInert * physobjarray(i%).anglevel ^ 2
                                End If
                                landscapehealth(across%, down%) = landscapehealth(across%, down%) - .05 / (physobjarray(i%).environ) * (0.5 * physobjarray(i%).mass * (physobjarray(i%).xvel ^ 2 + physobjarray(i%).yvel ^ 2) + 0.5 * physobjarray(i%).rotInert * physobjarray(i%).anglevel ^ 2) 'should velocity be total velocity, or object velocity?
                                'Box Damage handled in final force/acceleration, not here
                                If landscapehealth(across%, down%) <= 0 Then
                                    'If write1% = 1 Then
                                    '    Print #5, "BOX KILLED"
                                    'End If
                                    If Rnd < .005 Then
                                        landscape(across%, down%) = 1
                                    Else
                                        landscape(across%, down%) = 0
                                    End If
                                End If
                            End If
                        End If
                    End If
                Next across%
            Next down%
        End If

        If physobjarray(i%).otype <> 0 Then 'Force Calculations not needed for things that don't exist or are fixed
            'Cycle Through Game Objects For Physics Effects
            For x = 0 To UBound(gameobjectarray)
                distance# = Sqr((gameobjectarray(x).ypos - physobjarray(i%).ypos) ^ 2 + (gameobjectarray(x).xpos - physobjarray(i%).xpos) ^ 2)
                Select Case gameobjectarray(x).otype
                    Case -1 'Box Explosion
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 80 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 80 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 3 'Outward magnet
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 90 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 90 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 4 'Inward magnet
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc * (1 - .01 / physicslimit#) - (250 - 250 * distance# ^ 4 / (distance# + 100) ^ 4 + 40) * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc * (1 - .01 / physicslimit#) - (250 - 250 * distance# ^ 4 / (distance# + 100) ^ 4 + 40) * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 5 'MAGNET BOMB
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 180 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 180 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 7 'Small Bomb
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 120 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 120 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 8 'Large Bomb
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 205 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 205 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 10 'Rockets
                        'Guidance and movement system done after this loop in movement section so that it's not repeated
                        'collision
                        yy% = 0
                        'WITH OBJECT:
                        If physobjarray(i%).otype <> 0 Then
                            angle2# = _Atan2(gameobjectarray(x).ypos - physobjarray(i%).ypos, gameobjectarray(x).xpos - physobjarray(i%).xpos) - physobjarray(i%).angle 'from cursor box to collision point relative to cursor box
                            dist2# = physobjarray(i%).size / 2 * radialsquare(angle2#)
                            If Sqr((physobjarray(i%).xpos - gameobjectarray(x).xpos) ^ 2 + (physobjarray(i%).ypos - gameobjectarray(x).ypos) ^ 2) <= (dist2# + 2) Then 'compare distance to collision radius
                                yy% = 1
                                If physobjarray(i%).otype >= 2 Then
                                    physobjarray(i%).xacc = physobjarray(i%).xacc + 200 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle) * 180 / physicslimit#
                                    physobjarray(i%).yacc = physobjarray(i%).yacc + 200 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle) * 180 / physicslimit#
                                End If
                            End If
                        End If
                        'If physobjarray(i%).otype <> 0 Then
                        '    drawpoints#(1, 1) = physobjarray(i%).xpos + .707 * physobjarray(i%).size * Cos(physobjarray(i%).angle + _Pi / 4)
                        '    drawpoints#(1, 2) = physobjarray(i%).ypos + .707 * physobjarray(i%).size * Sin(physobjarray(i%).angle + _Pi / 4)
                        '    drawpoints#(2, 1) = physobjarray(i%).xpos + .707 * physobjarray(i%).size * Cos(physobjarray(i%).angle + 3 * _Pi / 4)
                        '    drawpoints#(2, 2) = physobjarray(i%).ypos + .707 * physobjarray(i%).size * Sin(physobjarray(i%).angle + 3 * _Pi / 4)
                        '    drawpoints#(3, 1) = physobjarray(i%).xpos + .707 * physobjarray(i%).size * Cos(physobjarray(i%).angle + 5 * _Pi / 4)
                        '    drawpoints#(3, 2) = physobjarray(i%).ypos + .707 * physobjarray(i%).size * Sin(physobjarray(i%).angle + 5 * _Pi / 4)
                        '    drawpoints#(4, 1) = physobjarray(i%).xpos + .707 * physobjarray(i%).size * Cos(physobjarray(i%).angle + 7 * _Pi / 4)
                        '    drawpoints#(4, 2) = physobjarray(i%).ypos + .707 * physobjarray(i%).size * Sin(physobjarray(i%).angle + 7 * _Pi / 4)
                        '    If In4Points(gameobjectarray(x).xpos, gameobjectarray(x).ypos, drawpoints#(1, 1), drawpoints#(1, 2), drawpoints#(2, 1), drawpoints#(2, 2), drawpoints#(3, 1), drawpoints#(3, 2), drawpoints#(4, 1), drawpoints#(4, 2)) = 1 Then
                        '        yy% = 1
                        '        If physobjarray(i%).otype >= 2 Then
                        '            physobjarray(i%).xacc = physobjarray(i%).xacc + 300 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle)
                        '            physobjarray(i%).yacc = physobjarray(i%).yacc + 300 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle)
                        '        End If
                        '    End If
                        'End If
                        'WITH LANDSCAPE moved to movement section
                        If yy% = 1 Then
                            gameobjectarray(x).otype = 11
                            gameobjectarray(x).time = gametimer# + .25
                            gameobjectarray(x).radius = 1.0
                            If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
                                Play "MBL64@2O1E,GD,FC,EB,DA,CO0E,GD,FC,EA,C"
                                soundtimer# = gametimer# + .15
                            End If
                        End If
                    Case 11 'ROCKET EXPLOSION
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc + 150 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc + 150 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 12 'MISSILE
                        'guidance and movement system done after this loop in movement section so that it's not repeated
                        'Lock on handled here (targetlock)
                        If (gameobjectarray(x).islocked = 0 Or gameobjectarray(x).islocked = 2) And distance# < 500 Then
                            'ANGLE is the direction the rocket is actually moving; OTHER is the reference direction
                            'Difference in angle starts at _Pi/3.  Difference in time is (31-16)/gameobjectarray(i%).radius
                            If physobjarray(i%).otype > 1 Then
                                If targetangle(gameobjectarray(x).xpos, gameobjectarray(x).ypos, physobjarray(i%).xpos, physobjarray(i%).ypos, gameobjectarray(x).radius, gameobjectarray(x).other, physobjarray(i%).xvel, physobjarray(i%).yvel) > 0 Then
                                    If distance# < gameobjectarray(x).lockdist Then
                                        gameobjectarray(x).lockdist = distance#
                                        gameobjectarray(x).targetlock = i%
                                        gameobjectarray(x).islocked = 2
                                    End If
                                End If
                            End If
                            If write1% = 1 Then
                                Print #5, "Target Parameters", gameobjectarray(x).xpos, gameobjectarray(x).ypos, physobjarray(i%).xpos, physobjarray(i%).ypos, gameobjectarray(x).radius, gameobjectarray(x).other, physobjarray(i%).xvel, physobjarray(i%).yvel
                                Print #5, "OUTPUT TARGETANGLE: ", targetangle(gameobjectarray(x).xpos, gameobjectarray(x).ypos, physobjarray(i%).xpos, physobjarray(i%).ypos, gameobjectarray(x).radius, gameobjectarray(x).other, physobjarray(i%).xvel, physobjarray(i%).yvel)
                                Print #5, "NOW LOCKED ON TO: ", gameobjectarray(x).targetlock
                            End If
                        End If
                        'collision
                        yy% = 0
                        'WITH OBJECT:
                        If physobjarray(i%).otype <> 0 Then
                            angle2# = _Atan2(gameobjectarray(x).ypos - physobjarray(i%).ypos, gameobjectarray(x).xpos - physobjarray(i%).xpos) - physobjarray(i%).angle 'from cursor box to collision point relative to cursor box
                            dist2# = physobjarray(i%).size / 2 * radialsquare(angle2#)
                            If Sqr((physobjarray(i%).xpos - gameobjectarray(x).xpos) ^ 2 + (physobjarray(i%).ypos - gameobjectarray(x).ypos) ^ 2) <= (dist2# + 2) Then 'compare distance to collision radius
                                yy% = 1
                                If physobjarray(i%).otype >= 2 Then
                                    physobjarray(i%).xacc = physobjarray(i%).xacc + 200 * gameobjectarray(x).radius * Cos(gameobjectarray(x).angle) * 180 / physicslimit#
                                    physobjarray(i%).yacc = physobjarray(i%).yacc + 200 * gameobjectarray(x).radius * Sin(gameobjectarray(x).angle) * 180 / physicslimit#
                                End If
                            End If
                        End If
                        'WITH LANDSCAPE moved to movement section
                        If yy% = 1 Then
                            gameobjectarray(x).otype = 13
                            gameobjectarray(x).time = gametimer# + .30
                            gameobjectarray(x).radius = 1.0
                            If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
                                Play "MBL64@2O1E,GD,FC,EB,DA,CO0E,GD,FC,EA,FC,EA,C"
                                soundtimer# = gametimer# + .19
                            End If
                        End If
                    Case 13 'MISSILE EXPLOSION
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            'Also slow it down so it doesn't just orbit
                            physobjarray(i%).xacc = physobjarray(i%).xacc * (1 - .01 / physicslimit#) + 160 * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc * (1 - .01 / physicslimit#) + 160 * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                    Case 14 'wormhole
                        'Suck in Blocks
                        If physobjarray(i%).otype >= 2 And distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            physobjarray(i%).xacc = physobjarray(i%).xacc - (250 - 250 * distance# ^ 4 / (distance# + 15000) ^ 4 + 60) * Cos(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                            physobjarray(i%).yacc = physobjarray(i%).yacc - (250 - 250 * distance# ^ 4 / (distance# + 15000) ^ 4 + 60) * Sin(_Atan2(physobjarray(i%).ypos - gameobjectarray(x).ypos, physobjarray(i%).xpos - gameobjectarray(x).xpos)) * 180 / physicslimit#
                        End If
                        'Swap Locations
                        If physobjarray(i%).otype >= 2 And distance# < 5 + 0.5 * physobjarray(i%).size Then
                            If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
                                If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                                    Play "mbL64@1o3beo4ao3cfo4bo3dgo4c"
                                    soundtimer# = soundtimer# + .141
                                End If
                            End If
                            physobjarray(i%).xpos = gameobjectarray(x).angle
                            physobjarray(i%).ypos = gameobjectarray(x).other
                            physobjarray(i%).xvel = 0 'Rnd 'slight movement
                            physobjarray(i%).yvel = 0 'Rnd 'slight movement
                            physobjarray(i%).xacc = 0 'Rnd 'slight movement
                            physobjarray(i%).yacc = 0 'Rnd 'slight movement
                        End If
                    Case 15 'deathtrap
                        If distance# < gameobjectarray(x).radius + 0.5 * physobjarray(i%).size Then
                            If physobjarray(i%).stype = 1 Or physobjarray(i%).stype = 3 Then
                                physobjarray(i%).health = physobjarray(i%).health - 75 / 180 * 180 / physicslimit# '75 damage/second
                            End If
                        End If
                    Case 16 'Force Wall
                        temp# = 53.85 + 0.5 * physobjarray(i%).size
                        If physobjarray(i%).otype >= 2 And distance# < temp# Then
                            drawpoints#(1, 1) = (gameobjectarray(x).xpos + temp# * Cos(gameobjectarray(x).angle + 1.19))
                            drawpoints#(1, 2) = (gameobjectarray(x).ypos + temp# * Sin(gameobjectarray(x).angle + 1.19))
                            drawpoints#(2, 1) = (gameobjectarray(x).xpos + temp# * Cos(gameobjectarray(x).angle + 1.951))
                            drawpoints#(2, 2) = (gameobjectarray(x).ypos + temp# * Sin(gameobjectarray(x).angle + 1.951))
                            drawpoints#(3, 1) = (gameobjectarray(x).xpos + temp# * Cos(gameobjectarray(x).angle + _Pi + 1.19))
                            drawpoints#(3, 2) = (gameobjectarray(x).ypos + temp# * Sin(gameobjectarray(x).angle + _Pi + 1.19))
                            drawpoints#(4, 1) = (gameobjectarray(x).xpos + temp# * Cos(gameobjectarray(x).angle + _Pi + 1.951))
                            drawpoints#(4, 2) = (gameobjectarray(x).ypos + temp# * Sin(gameobjectarray(x).angle + _Pi + 1.951))
                            If In4Points(gameobjectarray(x).xpos, gameobjectarray(x).ypos, drawpoints#(1, 1), drawpoints#(1, 2), drawpoints#(2, 1), drawpoints#(2, 2), drawpoints#(3, 1), drawpoints#(3, 2), drawpoints#(4, 1), drawpoints#(4, 2)) = 1 Then
                                temp# = -((physobjarray(i%).xpos - gameobjectarray(x).xpos) * Cos(gameobjectarray(x).angle) + (physobjarray(i%).ypos - gameobjectarray(x).ypos) * Sin(gameobjectarray(x).angle) - 30)
                                physobjarray(i%).xacc = 5 * temp# * Cos(gameobjectarray(x).angle)
                                physobjarray(i%).yacc = 5 * temp# * Sin(gameobjectarray(x).angle)
                            End If
                        End If
                End Select
            Next x
        End If

        'Calculate finalforcelist#
        If totalforcecounter% > collisionperobjectlimit% Then
            totalforcecounter% = collisionperobjectlimit%
        End If
        If totalforcecounter% > 0 Then
            For k% = 0 To totalforcecounter%
                If forcelist#(k%, 0) <> 0 Or forcelist#(k%, 1) <> 0 Then
                    'Find weighted sum to divide against, based on dot products of vector angles
                    normx# = Cos(_Atan2(forcelist#(k%, 1), forcelist#(k%, 0)))
                    normy# = Sin(_Atan2(forcelist#(k%, 1), forcelist#(k%, 0)))
                    sum# = 0 'sum of all the dot products in the direction of the original force (k)
                    For m% = 0 To totalforcecounter%
                        If forcelist#(m%, 0) <> 0 Or forcelist#(m%, 1) <> 0 Then
                            'dot# = normx# * Cos(Atan2(forcelist#(m%, 0), forcelist#(m%, 1))) + normy# * Sin(Atan2(forcelist#(m%, 0), forcelist#(m%, 1)))
                            dot# = normx# * Cos(_Atan2(forcelist#(m%, 1), forcelist#(m%, 0))) + normy# * Sin(_Atan2(forcelist#(m%, 1), forcelist#(m%, 0)))
                            If dot# > 0 Then 'only use vectors pointing somewhat in the same direction
                                'sum# = sum# + normx# * Cos(Atan2(forcelist#(m%, 0), forcelist#(m%, 1))) + normy# * Sin(Atan2(forcelist#(m%, 0), forcelist#(m%, 1)))
                                sum# = sum# + normx# * Cos(_Atan2(forcelist#(m%, 1), forcelist#(m%, 0))) + normy# * Sin(_Atan2(forcelist#(m%, 1), forcelist#(m%, 0)))
                            End If
                        End If
                    Next m%
                    finalforcelist#(k%, 0) = forcelist#(k%, 0) / sum#
                    finalforcelist#(k%, 1) = forcelist#(k%, 1) / sum#
                    finalforcelist#(k%, 2) = forcelist#(k%, 2) / sum# 'the torque is reduced proportionally with the force, the radius is constant
                    If write1% = 1 Then Print #5, "SUM: ", sum#, normx#, normy#
                Else
                    finalforcelist#(k%, 2) = 0 'should already be zero, this is just in case
                End If
            Next k%
            'Calculate final forces/accelerations
            For k% = 0 To totalforcecounter%
                If Sqr(forcelist#(k%, 0) ^ 2 + forcelist#(k%, 1) ^ 2) > 0.0000000001 Then
                    If write1% = 1 Then
                        Print #5, "INDEX, Forces: ", k%, forcelist#(k%, 0), forcelist#(k%, 1), forcelist#(k%, 2)
                        Print #5, "INDEX, FinalForces: ", k%, finalforcelist#(k%, 0), finalforcelist#(k%, 1), finalforcelist#(k%, 2)
                    End If
                    tx# = tx# + finalforcelist#(k%, 0)
                    ty# = ty# + finalforcelist#(k%, 1)
                    ttorque# = ttorque# + finalforcelist#(k%, 2)
                End If
            Next k%

            If tx# <> 0 Or ty# <> 0 Or ttorque# <> 0 Then
                rotperc# = Abs(ttorque# / physobjarray(i%).size) / (Abs(ttorque# / physobjarray(i%).size) + Sqr(tx# ^ 2 + ty# ^ 2)) ' could also try using the values squared
                transperc# = 1 - rotperc#
            Else
                rotperc# = 0.5
                transperc# = 0.5
            End If

            If tx# <> 0 Or ty# <> 0 Or ttorque# <> 0 Then
                physobjarray(i%).xacc = physobjarray(i%).xacc + (transperc# * tx# / physobjarray(i%).mass) * physicslimit# 'F=MA, so A=F/M
                physobjarray(i%).yacc = physobjarray(i%).yacc + (transperc# * ty# / physobjarray(i%).mass) * physicslimit# 'F=MA, so A=F/M
                physobjarray(i%).angleaccel = physobjarray(i%).angleaccel + (rotperc# * ttorque#) / physobjarray(i%).rotInert * physicslimit# 'Torque=F*R=I*Alpha  Alpha=Torque/I
                If Abs(physobjarray(i%).angleaccel) < .00000001 Then physobjarray(i%).angleaccel = 0 'reduce drift
            End If

            'DAMAGE to Box itself
            'To simplify this, ignore torque
            If Sqr(tx# ^ 2 + ty# ^ 2) > 200 Then
                physobjarray(i%).health = physobjarray(i%).health - Sqr(tx# ^ 2 + ty# ^ 2) / 200
            End If
            If physobjarray(i%).touching > initialimpact% And (Sqr(physobjarray(i%).xvel ^ 2 + physobjarray(i%).yvel ^ 2) + Abs(physobjarray(i%).anglevel * 0.5 * physobjarray(i%).size) > cutoffvelocity#) Then
                If write1% = 1 Then Print #5, "INITIAL IMPACT"
                If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                    playsound1% = 1
                End If
            End If

            If physobjarray(i%).environ > initialimpactenvironment% And (Sqr(physobjarray(i%).xvel ^ 2 + physobjarray(i%).yvel ^ 2) + Abs(physobjarray(i%).anglevel * 0.5 * physobjarray(i%).size) > cutoffvelocity#) Then
                If write1% = 1 Then Print #5, "INITIAL ENVIRONMENT IMPACT"
                If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                    playsound2% = 1
                End If
            End If
            If write1% = 1 Then
                Print #5, "BLOCK-END"
                Print #5, "AVERAGED FORCES X, Y, torque ", tx#, ty#, ttorque#
                Print #5, "COUNTER ", totalforcecounter%
                Print #5, "POS: ", physobjarray(i%).xpos, physobjarray(i%).ypos
                Print #5, "ANGLE pos, vel, accel: ", physobjarray(i%).angle, physobjarray(i%).anglevel, physobjarray(i%).angleaccel
                Print #5, "VEL: ", physobjarray(i%).xvel, physobjarray(i%).yvel
                Print #5, "ACCEL: ", physobjarray(i%).xacc, physobjarray(i%).yacc
                Print #5, "Colliding Objects (environ, obj): ", physobjarray(i%).environ, physobjarray(i%).touching
                Print #5, "ROT PERC; TRANS PERC: ", rotperc#, transperc#
                textstring$ = "Newobject 1, 0, 10, " + Str$(physobjarray(i%).size) + ", 10, " + Str$(physobjarray(i%).xpos) + ", " + Str$(physobjarray(i%).ypos) + ", 0, 0, 0, 0, 0, " + Str$(physobjarray(i%).angle) + ", 0, 0, 0"
                Print #5, textstring$ '(otype%, stype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#)"
            End If
        End If
    Next i%

    'Play Sounds, if applicable

    If playsound1% = 1 And boxonboxsound% = 1 And gametimer# - soundtimer# > 0 Then
        'Sound 78, 1, .8, 0, 2
        Play "mbL64@3o1V20g"
        soundtimer# = gametimer# + .01
    End If
    If playsound2% = 1 And boxonenvironsound% = 1 And gametimer# - soundtimer# > 0 Then
        'Sound 62, 1, .8, 0, 4
        Play "mbL64@3o1v25d"
        soundtimer# = gametimer# + .01
    End If


    'Update Positions after all collisions have been computed
    For i% = 0 To numobjects%
        If physobjarray(i%).otype > 1 And physobjarray(i%).health > 0 Then 'object must be the right type, and have positive health
            'Update Velocity
            physobjarray(i%).xvel = physobjarray(i%).xvel + physobjarray(i%).xacc * 1 / physicslimit#
            physobjarray(i%).yvel = physobjarray(i%).yvel + physobjarray(i%).yacc * 1 / physicslimit#
            If Abs(physobjarray(i%).xvel) < .000001 Then physobjarray(i%).xvel = 0 'reduce drift
            If Abs(physobjarray(i%).yvel) < .000001 Then physobjarray(i%).yvel = 0 'reduce drift
            physobjarray(i%).xpos = physobjarray(i%).xpos + physobjarray(i%).xvel * 1 / physicslimit#
            physobjarray(i%).ypos = physobjarray(i%).ypos + physobjarray(i%).yvel * 1 / physicslimit#

            'Update Angular Velocity
            physobjarray(i%).anglevel = physobjarray(i%).anglevel + physobjarray(i%).angleaccel * 1 / physicslimit#
            'Update Angle
            physobjarray(i%).angle = physobjarray(i%).angle + physobjarray(i%).anglevel * 1 / physicslimit#
        End If
    Next i%

    'Game Object movement
    For i% = 0 To UBound(gameobjectarray)
        Select Case gameobjectarray(i%).otype
            Case 10 'Rockets
                If gametimer# < gameobjectarray(i%).time + 16 / gameobjectarray(i%).radius Then
                    gameobjectarray(i%).xpos = gameobjectarray(i%).xpos + 1 / physicslimit# * gameobjectarray(i%).radius * Cos(gameobjectarray(i%).angle)
                    gameobjectarray(i%).ypos = gameobjectarray(i%).ypos + 1 / physicslimit# * gameobjectarray(i%).radius * Sin(gameobjectarray(i%).angle)
                ElseIf gametimer# >= gameobjectarray(i%).time + 16 / gameobjectarray(i%).radius And gametimer# <= gameobjectarray(i%).time + 31 / gameobjectarray(i%).radius Then
                    'ANGLE is the direction the rocket is actually moving; OTHER is the reference direction
                    'Difference in angle starts at _Pi/3.  Difference in time is (31-16)/gameobjectarray(i%).radius
                    If gameobjectarray(i%).angle < gameobjectarray(i%).other Then gameobjectarray(i%).angle = gameobjectarray(i%).angle + _Pi / 3 / (15 * physicslimit# / gameobjectarray(i%).radius)
                    If gameobjectarray(i%).angle > gameobjectarray(i%).other Then gameobjectarray(i%).angle = gameobjectarray(i%).angle - _Pi / 3 / (15 * physicslimit# / gameobjectarray(i%).radius)
                    gameobjectarray(i%).xpos = gameobjectarray(i%).xpos + 1 / physicslimit# * gameobjectarray(i%).radius * Cos(gameobjectarray(i%).angle)
                    gameobjectarray(i%).ypos = gameobjectarray(i%).ypos + 1 / physicslimit# * gameobjectarray(i%).radius * Sin(gameobjectarray(i%).angle)
                ElseIf gametimer# >= gameobjectarray(i%).time + 31 / gameobjectarray(i%).radius Then
                    gameobjectarray(i%).angle = gameobjectarray(i%).other
                    gameobjectarray(i%).xpos = gameobjectarray(i%).xpos + 1 / physicslimit# * gameobjectarray(i%).radius * Cos(gameobjectarray(i%).angle)
                    gameobjectarray(i%).ypos = gameobjectarray(i%).ypos + 1 / physicslimit# * gameobjectarray(i%).radius * Sin(gameobjectarray(i%).angle)
                End If
                yy% = 0
                xpos% = Int(gameobjectarray(i%).xpos)
                ypos% = Int(gameobjectarray(i%).ypos)
                If xpos% < 1 Then xpos% = 1
                If ypos% < 1 Then ypos% = 1
                If xpos% > 959 Then xpos% = 959
                If ypos% > 719 Then ypos% = 719
                If landscape(xpos%, ypos%) >= 2 Or landscape(xpos% + 1, ypos%) >= 2 Or landscape(xpos% - 1, ypos%) >= 2 Or landscape(xpos%, ypos% - 1) >= 2 Or landscape(xpos%, ypos% + 1) >= 2 Or landscape(xpos% + 1, ypos% + 1) >= 2 Or landscape(xpos% + 1, ypos% - 1) >= 2 Or landscape(xpos% - 1, ypos% + 1) >= 2 Or landscape(xpos% - 1, ypos% - 1) >= 2 Then
                    yy% = 1
                End If
                If yy% = 1 Then 'collision with landscape
                    gameobjectarray(i%).otype = 11
                    gameobjectarray(i%).time = gametimer# + .27
                    gameobjectarray(i%).radius = 1.0
                    If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
                        Play "MBL64@2O1E,GD,FC,EB,DA,CO0E,GD,FC,EA,C"
                        soundtimer# = gametimer# + .15
                    End If
                End If
            Case 12 'Missiles
                'ANGLE is the direction the rocket is actually moving; OTHER is the reference direction
                'Difference in angle starts at _Pi/3.  Difference in time is (31-16)/gameobjectarray(i%).radius
                If gameobjectarray(i%).islocked = 2 Then gameobjectarray(i%).islocked = 1
                If gameobjectarray(i%).islocked = 1 Then
                    temp# = targetangle(gameobjectarray(i%).xpos, gameobjectarray(i%).ypos, physobjarray(gameobjectarray(i%).targetlock).xpos, physobjarray(gameobjectarray(i%).targetlock).ypos, gameobjectarray(i%).radius, gameobjectarray(i%).other, physobjarray(gameobjectarray(i%).targetlock).xvel, physobjarray(gameobjectarray(i%).targetlock).yvel)
                    If temp# < 0 Then
                        gameobjectarray(i%).islocked = 0
                        gameobjectarray(i%).angle = gameobjectarray(i%).other
                    Else
                        gameobjectarray(i%).angle = temp#
                        If write1% = 1 Then
                            Print #5, "LOCK LOST"
                        End If
                    End If
                End If
                gameobjectarray(i%).xpos = gameobjectarray(i%).xpos + 1 / physicslimit# * gameobjectarray(i%).radius * Cos(gameobjectarray(i%).angle)
                gameobjectarray(i%).ypos = gameobjectarray(i%).ypos + 1 / physicslimit# * gameobjectarray(i%).radius * Sin(gameobjectarray(i%).angle)
                yy% = 0
                xpos% = Int(gameobjectarray(i%).xpos)
                ypos% = Int(gameobjectarray(i%).ypos)
                If xpos% < 1 Then xpos% = 1
                If ypos% < 1 Then ypos% = 1
                If xpos% > 959 Then xpos% = 959
                If ypos% > 719 Then ypos% = 719
                If landscape(xpos%, ypos%) >= 2 Or landscape(xpos% + 1, ypos%) >= 2 Or landscape(xpos% - 1, ypos%) >= 2 Or landscape(xpos%, ypos% - 1) >= 2 Or landscape(xpos%, ypos% + 1) >= 2 Or landscape(xpos% + 1, ypos% + 1) >= 2 Or landscape(xpos% + 1, ypos% - 1) >= 2 Or landscape(xpos% - 1, ypos% + 1) >= 2 Or landscape(xpos% - 1, ypos% - 1) >= 2 Then
                    yy% = 1
                End If
                If yy% = 1 Then 'collision with landscape
                    gameobjectarray(i%).otype = 13
                    gameobjectarray(i%).time = gametimer# + .32
                    gameobjectarray(i%).radius = 1.0
                    If gametimer# - soundtimer# > 0 And gameobjectsound% = 1 Then
                        Play "MBL64@2O1E,GD,FC,EB,DA,CO0E,GD,FC,EA,FC,EA,C"
                        soundtimer# = gametimer# + .19
                    End If
                End If
            Case 16 'Force wall
                gameobjectarray(i%).xpos = gameobjectarray(i%).xpos + 1 / physicslimit# * gameobjectarray(i%).radius * Cos(gameobjectarray(i%).angle)
                gameobjectarray(i%).ypos = gameobjectarray(i%).ypos + 1 / physicslimit# * gameobjectarray(i%).radius * Sin(gameobjectarray(i%).angle)
        End Select
    Next i%

    'Objects out of bounds and with no health  or in the goal
    For i% = 0 To numobjects%
        If (physobjarray(i%).health <= 0 Or physobjarray(i%).healthtime <= 0) And physobjarray(i%).otype > 0 Then 'no health
            Select Case physobjarray(i%).stype
                Case 1
                    physobjarray(i%).otype = 0 'remove object
                    NewGameObject -1, physobjarray(i%).xpos, physobjarray(i%).ypos, 6, physobjarray(i%).angle, gametimer# + 0.5, 1
                    If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                        If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                            Play "mbL64@1o0dbbdcaca"
                            'soundtimer# = gametimer# + .1
                        End If
                    End If
                    boxdestroyed% = boxdestroyed% + 1
                Case 2
                    physobjarray(i%).otype = 0 'remove object
                    NewGameObject -1, physobjarray(i%).xpos, physobjarray(i%).ypos, 8, physobjarray(i%).angle, gametimer# + 0.5, 2
                    If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                        If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                            Play "mb@1o2L64cL32GL64CL32GL64CL32G"
                            'soundtimer# = gametimer# + .1
                        End If
                    End If
                    money% = money% + 600
                Case 3
                    physobjarray(i%).otype = 0 'remove object
                    NewGameObject -1, physobjarray(i%).xpos, physobjarray(i%).ypos, 5, physobjarray(i%).angle, gametimer# + 0.5, 3
                    If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                        If physobjarray(i%).xpos >= (-screenx% / scale# - 30) And physobjarray(i%).xpos <= ((-screenx% + 480) / scale# + 30) And physobjarray(i%).ypos >= (-screeny% / scale# - 30) And physobjarray(i%).ypos <= ((-screeny% + 360) / scale# + 30) Then 'if on screen
                            Play "mbL64@1o0eccfdbdb"
                            'soundtimer# = gametimer# + .1
                        End If
                    End If
            End Select
        End If
        If physobjarray(i%).xpos < -2880 Or physobjarray(i%).xpos > 3840 Or physobjarray(i%).ypos < -2160 Or physobjarray(i%).ypos > 2880 Then physobjarray(i%).otype = 0 'out of bounds
        If physobjarray(i%).otype > 0 And physobjarray(i%).xpos > 1 And physobjarray(i%).xpos < 959 And physobjarray(i%).ypos > 1 And physobjarray(i%).ypos < 719 Then 'if object exist and is in bounds
            If landscape(Round(physobjarray(i%).xpos), Round(physobjarray(i%).ypos)) = -1 Then ' in goal
                Select Case physobjarray(i%).stype
                    Case 1
                        physobjarray(i%).otype = 0
                        boxsaved% = boxsaved% + 1
                        NewGameObject 2, physobjarray(i%).xpos, physobjarray(i%).ypos, 6, physobjarray(i%).angle, gametimer# + 0.6, 1
                        If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                            Play "mbL32@1o2bL16o3b"
                            'soundtimer# = gametimer# + .1
                        End If
                        money% = money% + 100
                    Case 2
                        physobjarray(i%).otype = 0
                        penalty% = penalty% + 1
                        NewGameObject 2, physobjarray(i%).xpos, physobjarray(i%).ypos, 8, physobjarray(i%).angle, gametimer# + 0.6, 2
                        If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                            Play "mbL32@1o1baL16g"
                            'soundtimer# = gametimer# + .1
                        End If
                    Case 3
                        physobjarray(i%).otype = 0
                        boxsaved% = boxsaved% + 5
                        NewGameObject 2, physobjarray(i%).xpos, physobjarray(i%).ypos, 5, physobjarray(i%).angle, gametimer# + 0.6, 3
                        If gameobjectsound% = 1 Then 'And gametimer# - soundtimer# Then
                            Play "mbL32@1o3cegp64fl8g"
                            'soundtimer# = gametimer# + .1
                        End If
                        money% = money% + 200
                End Select
            End If
        End If
        'Makes output angles easier to understand when troubleshooting
        fixangle (physobjarray(i%).angle)

    Next i%

End Sub

Sub DrawObjects (scrx%, scry%, scale#)
    Dim size#, xx#, yy#
    Dim lowerx#, lowery#, upperx#, uppery#
    Dim dcorners#(7)
    Dim drawpoints#(3, 1)
    Dim boxcolor%(3)
    Dim percent#
    lowerx# = -scrx% / scale# - 60
    upperx# = (-scrx% + 480) / scale# + 60
    lowery# = -scry% / scale# - 60
    uppery# = (-scry% + 360) / scale# + 60
    'Print "Lower ", lowerx#
    'Print "Upper ", upperx#

    For i% = 0 To UBound(physobjarray)
        size# = physobjarray(i%).size
        xx# = physobjarray(i%).xpos
        yy# = physobjarray(i%).ypos
        Select Case physobjarray(i%).stype
            Case 0
                boxcolor%(1) = 255
                boxcolor%(2) = 255
                boxcolor%(3) = 255
            Case 1
                boxcolor%(1) = 255
                boxcolor%(2) = 0
                boxcolor%(3) = 0
                percent# = physobjarray(i%).health / 100
            Case 2
                boxcolor%(1) = 0
                boxcolor%(2) = 200
                boxcolor%(3) = 0
                percent# = physobjarray(i%).health / (3 * boxhitpoint#)
            Case 3
                boxcolor%(1) = 128
                boxcolor%(2) = 0
                boxcolor%(3) = 200
                percent# = physobjarray(i%).health / (0.5 * boxhitpoint#)
        End Select
        If percent# > physobjarray(i%).healthtime / 100 Then percent# = physobjarray(i%).healthtime / 100
        dcorners#(0) = scrx% + (xx# + size# / 2 * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
        dcorners#(1) = scry% + (yy# + size# / 2 * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
        dcorners#(2) = scrx% + (xx# + size# / 2 * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
        dcorners#(3) = scry% + (yy# + size# / 2 * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
        dcorners#(4) = scrx% + (xx# + size# / 2 * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
        dcorners#(5) = scry% + (yy# + size# / 2 * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
        dcorners#(6) = scrx% + (xx# + size# / 2 * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
        dcorners#(7) = scry% + (yy# + size# / 2 * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
        'drawpoints#(0, 0) = scrx% + (xx# + 0.9 * size# / 2 * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
        'drawpoints#(0, 1) = scry% + (yy# + 0.9 * size# / 2 * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
        'drawpoints#(1, 0) = scrx% + (xx# + 0.9 * size# / 2 * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
        'drawpoints#(1, 1) = scry% + (yy# + 0.9 * size# / 2 * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
        'drawpoints#(2, 0) = scrx% + (xx# + 0.9 * size# / 2 * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
        'drawpoints#(2, 1) = scry% + (yy# + 0.9 * size# / 2 * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
        'drawpoints#(3, 0) = scrx% + (xx# + 0.9 * size# / 2 * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
        'drawpoints#(3, 1) = scry% + (yy# + 0.9 * size# / 2 * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1


        'FIXED OBJECTS
        If physobjarray(i%).otype = 1 And xx# >= lowerx# And xx# <= upperx# And yy# >= lowery# And yy# <= uppery# Then
            Line (dcorners#(0), dcorners#(1))-(dcorners#(2), dcorners#(3)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(2), dcorners#(3))-(dcorners#(4), dcorners#(5)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(4), dcorners#(5))-(dcorners#(6), dcorners#(7)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(6), dcorners#(7))-(dcorners#(0), dcorners#(1)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))

            'Line (scrx% + (xx# - 0.5 * size#) * scale#, scry% + (yy# - 0.5 * size#) * scale#)-(scrx% + ((xx# + 0.5 * size#) * scale#) - scalefactor%, scry% + ((yy# + 0.5 * size#) * scale#) - scalefactor%), _RGB(255, 255, 255), BF
            'Line (physobjarray(i%).size - 1, physobjarray(i%).mass - 1)-(physobjarray(i%).size + 1, physobjarray(i%).mass + 1), _RGB(255, 255, 255), BF
        End If
        'FREE OBJECTS
        If physobjarray(i%).otype = 2 And xx# >= lowerx# And xx# <= upperx# And yy# >= lowery# And yy# <= uppery# Then
            drawpoints#(0, 0) = scrx% + (xx# + 0.9 * size# / 2 * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
            drawpoints#(0, 1) = scry% + (yy# + 0.9 * size# / 2 * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
            drawpoints#(1, 0) = scrx% + (xx# + 0.9 * size# / 2 * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
            drawpoints#(1, 1) = scry% + (yy# + 0.9 * size# / 2 * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
            drawpoints#(2, 0) = scrx% + (xx# + 0.9 * size# / 2 * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
            drawpoints#(2, 1) = scry% + (yy# + 0.9 * size# / 2 * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
            drawpoints#(3, 0) = scrx% + (xx# + 0.9 * size# / 2 * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
            drawpoints#(3, 1) = scry% + (yy# + 0.9 * size# / 2 * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
            Line (drawpoints#(0, 0), drawpoints#(0, 1))-(drawpoints#(1, 0), drawpoints#(1, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(1, 0), drawpoints#(1, 1))-(drawpoints#(2, 0), drawpoints#(2, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(2, 0), drawpoints#(2, 1))-(drawpoints#(3, 0), drawpoints#(3, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(3, 0), drawpoints#(3, 1))-(drawpoints#(0, 0), drawpoints#(0, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            drawpoints#(0, 0) = scrx% + (xx# + 0.8 * size# / 2 * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
            drawpoints#(0, 1) = scry% + (yy# + 0.8 * size# / 2 * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=1
            drawpoints#(1, 0) = scrx% + (xx# + 0.8 * size# / 2 * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
            drawpoints#(1, 1) = scry% + (yy# + 0.8 * size# / 2 * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=1
            drawpoints#(2, 0) = scrx% + (xx# + 0.8 * size# / 2 * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
            drawpoints#(2, 1) = scry% + (yy# + 0.8 * size# / 2 * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=-1 Y=-1
            drawpoints#(3, 0) = scrx% + (xx# + 0.8 * size# / 2 * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
            drawpoints#(3, 1) = scry% + (yy# + 0.8 * size# / 2 * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle))) * scale# 'angles are in radians X=1 Y=-1
            Line (drawpoints#(0, 0), drawpoints#(0, 1))-(drawpoints#(1, 0), drawpoints#(1, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(1, 0), drawpoints#(1, 1))-(drawpoints#(2, 0), drawpoints#(2, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(2, 0), drawpoints#(2, 1))-(drawpoints#(3, 0), drawpoints#(3, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))
            Line (drawpoints#(3, 0), drawpoints#(3, 1))-(drawpoints#(0, 0), drawpoints#(0, 1)), _RGB(boxcolor%(1) + Int((255 - boxcolor%(1)) * percent#), boxcolor%(2) + Int((255 - boxcolor%(2)) * percent#), boxcolor%(3) + Int((255 - boxcolor%(3)) * percent#))

            Line (dcorners#(0), dcorners#(1))-(dcorners#(2), dcorners#(3)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(2), dcorners#(3))-(dcorners#(4), dcorners#(5)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(4), dcorners#(5))-(dcorners#(6), dcorners#(7)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            Line (dcorners#(6), dcorners#(7))-(dcorners#(0), dcorners#(1)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            If percent# <= .25 Then
                Line (dcorners#(0), dcorners#(1))-(dcorners#(4), dcorners#(5)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
                Line (dcorners#(2), dcorners#(3))-(dcorners#(6), dcorners#(7)), _RGB(boxcolor%(1), boxcolor%(2), boxcolor%(3))
            End If
        End If
        If physobjarray(i%).otype = 3 And xx# >= lowerx# And xx# <= upperx# And yy# >= lowery# And yy# <= uppery# Then
            Line (dcorners#(0), dcorners#(1))-(dcorners#(2), dcorners#(3)), _RGB(0, 63, 0)
            Line (dcorners#(2), dcorners#(3))-(dcorners#(4), dcorners#(5)), _RGB(255, 63, 0)
            Line (dcorners#(4), dcorners#(5))-(dcorners#(6), dcorners#(7)), _RGB(255, 63, 0)
            Line (dcorners#(6), dcorners#(7))-(dcorners#(0), dcorners#(1)), _RGB(255, 63, 0)
        End If
    Next i%
End Sub


Sub NewObject (otype%, stype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction#, damping#)
    Dim i%
    i% = 0
    'While objects(i%, 0) <> 0 And i% < UBound(objects)
    ''    Print objects(i%, 0)
    '    i% = i% + 1
    'Wend
    While physobjarray(i%).otype <> 0 And i% < UBound(physobjarray)
        'Print physicsobj.otype
        i% = i% + 1
    Wend
    physobjarray(i%).otype = otype% 'Type 1 is fixed permanent, 2 is moveable and has gravity, 3 is movable with no gravity
    physobjarray(i%).stype = stype% 'Type 0 is invincible white box, 1 is regular box, 2 is a money box, 3 is a purple box
    physobjarray(i%).health = health#
    physobjarray(i%).size = size#
    physobjarray(i%).mass = mass#
    physobjarray(i%).xpos = xpos#
    physobjarray(i%).ypos = ypos#
    physobjarray(i%).xvel = xvel#
    physobjarray(i%).yvel = yvel#
    physobjarray(i%).xacc = xacc#
    physobjarray(i%).yacc = yacc#
    physobjarray(i%).environ = 0 '# of environmental objects touching
    physobjarray(i%).friction = friction# 'Friction Coef
    physobjarray(i%).forcereturn = forcereturn# 'how much the objects rebounds after a collision.  Forcereturn of 1 means a full rebound (no energy loss)
    If otype% >= 1 Then
        physobjarray(i%).rotInert = mass# * size# ^ 2 / 6 'I
    End If
    physobjarray(i%).angle = angle# 'angular position
    physobjarray(i%).anglevel = anglevel# 'angular velocity
    physobjarray(i%).angleaccel = 0 'angular acceleration
    physobjarray(i%).touching = 0 '# regular other objects touching
    physobjarray(i%).damping = damping# 'Damping Coef
    physobjarray(i%).healthtime = 100 'health time
End Sub

Sub NewGameObject (otype%, xpos#, ypos#, radius#, angle#, gtime#, other#)
    Dim i%
    i% = 0
    While gameobjectarray(i%).otype <> 0 And i% < UBound(gameobjectarray)
        'Print physobjarray(i%).otype
        i% = i% + 1
    Wend
    gameobjectarray(i%).otype = otype%
    gameobjectarray(i%).xpos = xpos#
    gameobjectarray(i%).ypos = ypos#
    gameobjectarray(i%).radius = radius#
    gameobjectarray(i%).angle = angle#
    gameobjectarray(i%).time = gtime#
    gameobjectarray(i%).other = other#
    gameobjectarray(i%).targetlock = -1 ' -1 is unlocked
    gameobjectarray(i%).lockdist = 1000
    gameobjectarray(i%).islocked = 0 '0= unlocked, 1=locked, 2=temp locked FOR MISSILES
End Sub

Sub DrawGrid (scrx%, scry%, scale#)
    'All values are passed by reference
    'You can create local variables to mimic the effect of pass by value
    'Draw visible portion of screen
    'Static variables retain their value between function calls  (define with STATIC)
    Dim DrawXcorner%, DrawYcorner%, xmaxcorner%, ymaxcorner%
    DrawXcorner% = -scrx% / scale# - 1
    DrawYcorner% = -scry% / scale# - 1
    xmaxcorner% = DrawXcorner% + 480 / scale# + 2
    ymaxcorner% = DrawYcorner% + 360 / scale# + 2
    If DrawXcorner% < 0 Then DrawXcorner% = 0
    If DrawXcorner% > 960 Then DrawXcorner% = 960
    If DrawYcorner% < 0 Then DrawYcorner% = 0
    If DrawYcorner% > 720 Then DrawYcorner% = 720
    If xmaxcorner% < 0 Then xmaxcorner% = 0
    If xmaxcorner% > 960 Then xmaxcorner% = 960
    If ymaxcorner% < 0 Then ymaxcorner% = 0
    If ymaxcorner% > 720 Then ymaxcorner% = 720
    If scale# >= 1 Then scalefactor% = 1 Else scalefactor% = 0
    'Print scalefactor%
    'Dim valuex1#, valuex2#, valuey1#, valuey2#
    For down% = DrawXcorner% To xmaxcorner% Step 1
        For across% = DrawYcorner% To ymaxcorner% Step 1
            Select Case landscape(down%, across%)
                Case -3
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(233, 233, 50), BF
                Case -2
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(238, 61, 150), BF
                Case -1 'Exit Door
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(0, 180, 0), BF
                Case 1
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(Int(Rnd * 255) + 1, Int(Rnd * 255) + 1, Int(Rnd * 255) + 1), BF
                Case 2
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(200, 200, 200), BF
                Case 3
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(60, 160, 255), BF
                Case 4
                    Line (scrx% + down% * scale# - 0.5 * scale# * scalefactor%, scry% + across% * scale# - 0.5 * scale# * scalefactor%)-(scrx% + down% * scale# + 0.5 * scale# * scalefactor% - scalefactor%, scry% + across% * scale# + 0.5 * scale# * scalefactor% - scalefactor%), _RGB(150, 180, 230), BF
            End Select
        Next across%
    Next down%
End Sub

Sub Savefile
    Cls
    scansaves
    Print "11 CUSTOM FILE NAME"
    Print "12 CANCEL"
    Dim ss#
    Dim name$, filename$
    Input "Please select a save slot: ", ss#
    If ss# = 12 Then Exit Sub
    Input "Please add the title for your save ", name$
    If ss# > 0 And ss# <= 10 Then
        filename$ = "savefile" + Str$(ss#) + ".txt"
    Else
        Input "Please enter your file name: ", filename$
    End If
    Open filename$ For Output As #1
    Print #1, name$
    Print #1, Date$ + " " + Time$
    Dim Linestring$
    Dim l, w As Integer
    l = UBound(landscape, 1)
    w = UBound(landscape, 2)
    Print #1, l
    Print #1, w
    For x = 0 To l
        Linestring$ = ""
        For y = 0 To w
            Linestring$ = Linestring$ + Str$(landscape(x, y)) + ","
        Next y
        Linestring$ = Left$(Linestring$, Len(Linestring$) - 1)
        Print #1, Linestring$
    Next x
    For x = 0 To l
        Linestring$ = ""
        For y = 0 To w
            Linestring$ = Linestring$ + Str$(landscapehealth(x, y)) + ","
        Next y
        Linestring$ = Left$(Linestring$, Len(Linestring$) - 1)
        Print #1, Linestring$
    Next x
    l = UBound(physobjarray)
    Print #1, l
    For x = 0 To l
        Linestring$ = Str$(physobjarray(x).otype) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).stype) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).health) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).size) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).mass) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xpos) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).ypos) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xvel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).yvel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xacc) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).yacc) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).environ) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).friction) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).forcereturn) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).rotInert) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).angle) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).anglevel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).angleaccel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).touching) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).damping) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).healthtime)
        Print #1, Linestring$
    Next x

    Close #1
End Sub

Sub SaveSettings
    Open "BOX_BASH_SETTINGS.txt" For Output As #7
    Print #7, physicslimit#
    Print #7, boxonboxsound%
    Print #7, boxonenvironsound%
    Print #7, gameobjectsound%
    Print #7, cutoffvelocity#
    Print #7, decayrate#
    Print #7, boxhitpoint#
    Print #7, displayfps`
    Print #7, adv$
    Print #7, prev$
    Print #7, moneyrate%
    Close #7
End Sub

Sub LoadSettings
    If _FileExists("BOX_BASH_SETTINGS.txt") Then
        Open "BOX_BASH_SETTINGS.txt" For Input As #8
        Line Input #8, textline$
        physicslimit# = Val(textline$)
        Line Input #8, textline$
        boxonboxsound% = Val(textline$)
        Line Input #8, textline$
        boxonenvironsound% = Val(textline$)
        Line Input #8, textline$
        gameobjectsound% = Val(textline$)
        Line Input #8, textline$
        cutoffvelocity# = Val(textline$)
        Line Input #8, textline$
        decayrate# = Val(textline$)
        Line Input #8, textline$
        boxhitpoint# = Val(textline$)
        Line Input #8, textline$
        displayfps` = Val(textline$)
        Line Input #8, textline$
        adv$ = textline$
        Line Input #8, textline$
        prev$ = textline$
        Line Input #8, textline$
        moneyrate% = Val(textline$)
        Close #8
    End If
End Sub


Sub Loadfile
    Dim textline$, filename$
    Dim position%
    Dim lastposition%
    Dim l, w As Integer
    Dim ans#
    Cls
    scansaves
    Print "11 CUSTOM FILE NAME"
    Print "12 CANCEL"
    Input "Please select the file you would like to open: ", ans#
    If ans# > 0 And ans# <= 10 Then
        filename$ = "savefile" + Str$(ans#) + ".txt"
    Else
        Input "Please enter your file name: ", filename$
    End If
    Print filename$
    If _FileExists(filename$) Then
        Open filename$ For Input As #2
        Line Input #2, textline$
        Line Input #2, textline$
        Line Input #2, textline$
        l = Val(textline$)
        Line Input #2, textline$
        w = Val(textline$)
        For xx = 0 To l
            Line Input #2, textline$
            position% = 0
            For yy = 0 To w - 1
                lastposition% = position%
                position% = InStr(position% + 1, textline$, ",")
                landscape(xx, yy) = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            Next yy
            Locate 14, 1
            Print "LOADING...", Int(xx * 50 / Int(l))
            Locate 14, 20
            Print "%"
            landscape(xx, w) = Val(Mid$(textline$, position% + 1, Len(textline$) - position%))
            _Display
        Next xx
        For xx = 0 To l
            Line Input #2, textline$
            position% = 0
            For yy = 0 To w - 1
                lastposition% = position%
                position% = InStr(position% + 1, textline$, ",")
                landscapehealth(xx, yy) = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            Next yy
            Locate 14, 1
            Print "LOADING...", 50 + Int(xx * 50 / Int(l))
            Locate 14, 20
            Print "%"
            landscapehealth(xx, w) = Val(Mid$(textline$, position% + 1, Len(textline$) - position%))
            _Display
        Next xx

        Line Input #2, textline$
        l = Val(textline$)
        'ReDim physobjarray(l)
        For xx = 0 To l
            Line Input #2, textline$
            lastposition% = 0
            position% = InStr(1, textline$, ",")
            physobjarray(xx).otype = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).stype = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).health = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).size = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).mass = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).xpos = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).ypos = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).xvel = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).yvel = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).xacc = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).yacc = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).environ = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).friction = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).forcereturn = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).rotInert = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).angle = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).anglevel = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).angleaccel = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).touching = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            lastposition% = position%
            position% = InStr(position% + 1, textline$, ",")
            physobjarray(xx).damping = Val(Mid$(textline$, lastposition% + 1, position% - lastposition% - 1))
            physobjarray(xx).healthtime = Val(Mid$(textline$, position% + 1, Len(textline$) - position%))
            Locate 15, 1
            Print "LOADING...", Int(xx * 100 / Int(l))
            Locate 15, 20
            Print "%"
            _Display
        Next xx
        permanentobjectsused% = 0
        For xx = 0 To l
            If physobjarray(xx).otype = 1 Then permanentobjectsused% = permanentobjectsused% + 1
        Next
        Close #2
    Else
        Input "FILE NOT FOUND", ans#
    End If
End Sub

Sub scansaves
    Dim filename$
    Dim firstline$
    Dim secondline$
    Color _RGB(255, 255, 255)
    For x = 1 To 10
        filename$ = "savefile" + Str$(x) + ".txt"
        'Print filename$
        firstline$ = ""
        secondline$ = ""
        If _FileExists(filename$) Then
            Open filename$ For Input As #3
            If Not EOF(3) Then
                Line Input #3, firstline$
            End If
            If Not EOF(3) Then
                Line Input #3, secondline$
            End If
            Close #3
        End If
        Print Str$(x) + " " + firstline$ + "  " + secondline$
    Next x
End Sub

Sub outputobjects
    Open "objectlist.txt" For Output As #4
    Print #4, Date$ + " " + Time$
    Dim Linestring$
    Dim l As Integer
    l = UBound(physobjarray)
    For x = 0 To l
        Linestring$ = Str$(physobjarray(x).otype) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).stype) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).health) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).size) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).mass) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xpos) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).ypos) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xvel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).yvel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).xacc) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).yacc) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).environ) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).friction) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).forcereturn) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).rotInert) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).angle) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).anglevel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).angleaccel) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).touching) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).damping) + ","
        Linestring$ = Linestring$ + Str$(physobjarray(x).healthtime)
        Print #4, Linestring$
        Print #4, "TOTAL ENERGY: ", 0.5 * physobjarray(x).mass * (physobjarray(x).xvel ^ 2 + physobjarray(x).yvel ^ 2) + 0.5 * physobjarray(x).rotInert * physobjarray(x).anglevel ^ 2 + physobjarray(x).mass * gravity# * (720 - physobjarray(x).ypos)
    Next x
    Print #4, " "
    l = UBound(gameobjectarray)
    For x = 0 To l
        Linestring$ = Str$(gameobjectarray(x).otype) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).xpos) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).ypos) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).radius) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).time) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).angle) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).other) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).targetlock) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).lockdist) + ","
        Linestring$ = Linestring$ + Str$(gameobjectarray(x).islocked) + ","
        Print #4, Linestring$
    Next x

    Close #4
    Print "Objects Outputed"
End Sub


Function Round% (value#)
    If (value# - Int(value#)) >= 0.5 Then Round% = Int(value#) + 1 Else Round% = Int(value#)
End Function


Function In4Points% (testx#, testy#, p1x#, p1y#, p2x#, p2y#, p3x#, p3y#, p4x#, p4y#) 'returns 1 if in 4 points, -1 if not
    Dim centerx#, centery#
    centerx# = (p1x# + p2x# + p3x# + p4x#) / 4 'could possibly pass these variables over to save CPU cycles if this becomes an issue
    centery# = (p1y# + p2y# + p3y# + p4y#) / 4 'calculating them here eliminates the possibility of a bad value if this is used elsewhere
    Dim hc#, ht#
    Dim vx#, vy#
    'If write1%=1 Then Print #5, "POINT VALUES: ", testx#, testy#, p1x#, p1y#, p2x#, p2y#, p3x#, p3y#, p4x#, p4y#
    'Points 1 and Points 2, point 1 is fulcrum
    vx# = p2x# - p1x#
    vy# = p2y# - p1y#
    'Calculating distance in both X and Y directions shouldn't be required because it is impossible to have the test pass in one direction but fail in the other.  It does however help us avoid singularities
    If Abs(vx#) > 0.00001 Then 'Use Y direction first   or vx#<>0
        hc# = centery# - p1y# - vy# * (centerx# - p1x#) / vx#
        ht# = testy# - p1y# - vy# * (testx# - p1x#) / vx#
    Else 'use X direction
        hc# = centerx# - p1x# '-0, since vx#=0
        ht# = testx# - p1x#
    End If
    Dim test%
    test% = Abs(hc# * ht#) / (hc# * ht#) 'passes if both hc and ht are positive or negative, fails if they are opposites
    If test% = -1 Then
        In4Points% = test%
        Exit Function
    End If
    'Points 2 and Points 3, point 2 is fulcrum
    vx# = p3x# - p2x#
    vy# = p3y# - p2y#
    If Abs(vx#) > 0.00001 Then 'Use Y direction first
        hc# = centery# - p2y# - vy# * (centerx# - p2x#) / vx#
        ht# = testy# - p2y# - vy# * (testx# - p2x#) / vx#
    Else 'use X direction
        hc# = centerx# - p2x# '-0, since vx#=0
        ht# = testx# - p2x#
    End If
    test% = Abs(hc# * ht#) / (hc# * ht#) 'passes if both hc and ht are positive or negative, fails if they are opposites
    If test% = -1 Then
        In4Points% = test%
        Exit Function
    End If
    'Points 3 and Points 4, point 3 is fulcrum
    vx# = p4x# - p3x#
    vy# = p4y# - p3y#
    If Abs(vx#) > 0.00001 Then 'Use Y direction first
        hc# = centery# - p3y# - vy# * (centerx# - p3x#) / vx#
        ht# = testy# - p3y# - vy# * (testx# - p3x#) / vx#
    Else 'use X direction
        hc# = centerx# - p3x# '-0, since vx#=0
        ht# = testx# - p3x#
    End If
    test% = Abs(hc# * ht#) / (hc# * ht#) 'passes if both hc and ht are positive or negative, fails if they are opposites
    If test% = -1 Then
        In4Points% = test%
        Exit Function
    End If
    'Points 4 and Points 1, point 4 is fulcrum
    vx# = p1x# - p4x#
    vy# = p1y# - p4y#
    If Abs(vx#) > 0.00001 Then 'Use Y direction first
        hc# = centery# - p4y# - vy# * (centerx# - p4x#) / vx#
        ht# = testy# - p4y# - vy# * (testx# - p4x#) / vx#
    Else 'use X direction
        hc# = centerx# - p4x# '-0, since vx#=0
        ht# = testx# - p4x#
    End If
    test% = Abs(hc# * ht#) / (hc# * ht#) 'passes if both hc and ht are positive or negative, fails if they are opposite
    'If test% = 1 Then
    'If write1%=1 Then Print #5, "POINT VALUES: ", testx#, testy#, p1x#, p1y#, p2x#, p2y#, p3x#, p3y#, p4x#, p4y#
    'End If
    In4Points% = test%
End Function

Function perpvector# (px#, py#, vx#, vy#, centerx#, centery#)
    'p is the starting point, v is the vector from p, center is the point offset from the vector you are finding the distance to.
    'If write1%=1 Then Print #5, "PERP VEC PARAM: ", px#, py#, vx#, vy#, centerx#, centery#
    perpvector# = Abs(vx# * (centery# - py#) + vy# * (px# - centerx#)) / Sqr(vx# ^ 2 + vy# ^ 2) 'SQR is for square root
End Function

Sub collisionforceobjects (px#, py#, obj1%, obj2%)
    'Forces applied to object1 at px, py
    'Sub updates forces 0 and 1
    'THIS IS AN APPROXIMATION (HOPEFULLY) THAT PRODUCES BELIEVABLE RESULTS.  I haven't yet solved the 4 DOF equation

    'Force is:
    '2*m1*m2*(v1-v2)/(m1+m2)  Linear movement solution. Sign depends on directions. Use COM velocity for linear components, velocity of point impact for rotational.
    '2*I1*I2*(w1-w2)/(I1+I2)  Torque only solution is similar.  Divide by radius of impacting object to get force
    'Forces applied to object1 at px, py
    If write1% = 1 Then Print #5, ""
    If write1% = 1 Then Print #5, "COLLISION COUNTER: ", collisioncounter%
    'If write2% = 1 Then Print #6, "COLLISION COUNTER: ", collisioncounter%
    collisioncounter% = collisioncounter% + 1
    Dim vel1#, vel2#, vel1f#, vel2f#, torquemag#, force2mag#, force1mag#, transangle#, angle1#, angle2#, angle3#, angle4#, angle5#, finalangle#
    Dim finalforce#, radius#, tempangle1#
    Dim tvx1#, tvx2#, tvy1#, tvy2#, tv1tot#, tv2tot# 'Total Velocity
    Dim obj1topangle#, obj2topangle#, rot_to_rot#, rot_to_trans#, trans_to_trans#, trans_to_rot#, tempforce1#, tempforce2#, temptorque#
    Dim cornerflag%, nulvel%, nulrot%
    nulvel% = 0
    nulrot% = 0
    cornerflag% = 0
    forces(0) = 0
    forces(1) = 0
    vel1# = Sqr(physobjarray(obj1%).xvel ^ 2 + physobjarray(obj1%).yvel ^ 2)
    vel2# = Sqr(physobjarray(obj2%).xvel ^ 2 + physobjarray(obj2%).yvel ^ 2)
    'Maybe useful? If perpvector of obj1 COM's velocity is greater than it's size/2 the the COM is out of line with the collision
    'ROTATIONAL ALIGNMENT
    'obj1topangle# = Atan2(px# - physobjarray(obj1%).xpos, py# - physobjarray(obj1%).ypos)
    'obj2topangle# = Atan2(px# - physobjarray(obj2%).xpos, py# - physobjarray(obj2%).ypos)
    obj1topangle# = _Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos)
    obj2topangle# = _Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos)
    'This effort finished later on after finalangle is determined
    'If write1%=1 Then Print #5, "Rot Angles: ", obj1topangle#, obj2topangle#
    'THIS CODE REMOVED
    'rot_to_rot# = Abs(Cos(obj1topangle#) * Cos(obj2topangle#) + Sin(obj1topangle#) * Sin(obj2topangle#))
    'If physobjarray(obj2%).otype = 1 Then rot_to_rot# = 1 'perhaps a good assumption, gives better results
    'rot_to_trans# = 1 - rot_to_rot#
    'TRANSLATIONAL ALIGNMENT
    Dim sizelimit#, maxsize#, perpoffset#
    If vel1# < 0.00000000001 And vel2# < 0.00000000001 Then
        trans_to_trans# = 1
        trans_to_rot# = 0
        angle2# = 0 'This is OK since the force will also be zero
    Else
        maxsize# = 1.414214 * (physobjarray(obj1%).size + physobjarray(obj2%).size)
        'angle2# = Atan2(physobjarray(obj2%).xvel - physobjarray(obj1%).xvel, physobjarray(obj2%).yvel - physobjarray(obj1%).yvel) 'angle of relative velocity of obj2 with respect to obj1
        angle2# = _Atan2(physobjarray(obj2%).yvel - physobjarray(obj1%).yvel, physobjarray(obj2%).xvel - physobjarray(obj1%).xvel) 'angle of relative velocity of obj2 with respect to obj1
        If physobjarray(obj2%).otype = 1 Then
            sizelimit# = 0.51 * physobjarray(obj2%).size 'use immovable box as limit, else use smaller size
        ElseIf physobjarray(obj1%).size < physobjarray(obj2%).size Then
            sizelimit# = Abs(Sin(angle2#) * 0.51 * physobjarray(obj1%).size)
            If sizelimit# < 0.51 * physobjarray(obj1%).size Then sizelimit# = 0.51 * physobjarray(obj1%).size 'make 0.51 the min for some extra grace
        Else
            sizelimit# = Abs(Sin(angle2#) * 0.51 * physobjarray(obj2%).size)
            If sizelimit# < 0.51 * physobjarray(obj2%).size Then sizelimit# = 0.51 * physobjarray(obj2%).size
        End If
        perpoffset# = perpvector#(physobjarray(obj1%).xpos, physobjarray(obj1%).ypos, Cos(angle2#), Sin(angle2#), physobjarray(obj2%).xpos, physobjarray(obj2%).ypos)
        If perpoffset# < sizelimit# Then
            trans_to_trans# = 1
            trans_to_rot# = 0
        Else
            trans_to_rot# = (perpoffset# - sizelimit#) / (maxsize# - sizelimit#)
            If trans_to_rot# > 1 Then trans_to_rot# = 1 'just a safety precaution
            trans_to_trans# = 1 - trans_to_rot#
        End If
    End If

    'Find Face Angle more efficiently
    If Abs(Abs(_Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos) - physobjarray(obj2%).angle - _Pi / 4) / (_Pi / 2) - _Round(Abs(_Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos) - physobjarray(obj2%).angle - _Pi / 4) / (_Pi / 2))) < .01 Then 'If collision point is on corner of other box
        'Then check this box
        If Abs(Abs(_Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos) - physobjarray(obj1%).angle - _Pi / 4) / (_Pi / 2) - _Round(Abs(_Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos) - physobjarray(obj1%).angle - _Pi / 4) / (_Pi / 2))) < .01 Then 'If collision point is on corner of this box
            'Corner of both boxes
            'faceangle# = _Round((_Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos) - physobjarray(obj1%).angle - _Pi / 4) / (_Pi / 2)) * (_Pi / 2) + physobjarray(obj1%).angle + 5 * _Pi / 4 'corner angle of this box, reversed, so it points to the center
            angle1# = _Atan2(physobjarray(obj1%).ypos - py#, physobjarray(obj1%).xpos - px#) 'points directly to center
            tempangle1# = _Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos) 'points away from center of obj2
            If Cos(angle1#) * Cos(tempangle1#) + Sin(angle1#) * Sin(tempangle1#) < .707 Then 'if the dot product of the two vectors is <.707 =  ABcos(theta) = cos(theta) (since vectors length=1) so if the collision angle is less than 45 degrees...
                angle1# = _Round((_Atan2(physobjarray(obj1%).ypos - physobjarray(obj2%).ypos, physobjarray(obj1%).xpos - physobjarray(obj2%).xpos) - physobjarray(obj2%).angle) / (_Pi / 2)) * (_Pi / 2) + physobjarray(obj2%).angle 'face of other box that points to center of this box
                If write1% = 1 Then Print #5, "ALTERED CORNER "
            End If
            angle4# = angle1#
            cornerflag% = 1
            If write1% = 1 Then Print #5, "E CORNER COLLISION: ", angle1#
        Else
            'face of this box, reversed
            angle1# = _Round((_Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos) - physobjarray(obj1%).angle) / (_Pi / 2)) * (_Pi / 2) + physobjarray(obj1%).angle + _Pi 'face of this box, reversed
            If write1% = 1 Then Print #5, "E FIRST OBJECT FACE COLLISION: ", angle1#
        End If
    Else
        'face of other box
        angle1# = _Round((_Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos) - physobjarray(obj2%).angle) / (_Pi / 2)) * (_Pi / 2) + physobjarray(obj2%).angle 'face angle of the box that is being hit
        If write1% = 1 Then Print #5, "E SECOND OBJECT FACE COLLISION: ", angle1#
    End If


    'COLLISION ANGLE:
    'Translation Portion
    If vel1# > 0.00000000001 Or vel2# > 0.00000000001 Then 'if something is moving
        If (Cos(angle1#) * physobjarray(obj1%).xvel + Sin(angle1#) * physobjarray(obj1%).yvel) > (Cos(angle1#) * physobjarray(obj2%).xvel + Sin(angle1#) * physobjarray(obj2%).yvel) Then 'if objects are moving away from each other
            'Rem  nullify force if the objects are moving away from each other
            nulvel% = 1
            transangle# = angle1#
        Else
            'transangle# = avgangle(angle1#, angle2#)
            transangle# = anglemeld#(angle1#, angle2#, 1 - 0.5 * Abs(vel1# - vel2#) ^ 2 / (Abs(vel1# - vel2#) ^ 2 + velocityangletransition#))
        End If
    Else
        transangle# = angle1#
        nulvel% = 1
    End If


    'Rotation Portion
    Rem    Total Velocity of collision point on object 1
    tvx1# = physobjarray(obj1%).xvel - physobjarray(obj1%).anglevel * Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) * Sin(obj1topangle#)
    tvy1# = physobjarray(obj1%).yvel + physobjarray(obj1%).anglevel * Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) * Cos(obj1topangle#)
    tvx2# = physobjarray(obj2%).xvel - physobjarray(obj2%).anglevel * Sqr((px# - physobjarray(obj2%).xpos) ^ 2 + (py# - physobjarray(obj2%).ypos) ^ 2) * Sin(obj2topangle#)
    tvy2# = physobjarray(obj2%).yvel + physobjarray(obj2%).anglevel * Sqr((px# - physobjarray(obj2%).xpos) ^ 2 + (py# - physobjarray(obj2%).ypos) ^ 2) * Cos(obj2topangle#)
    tv1tot# = Sqr(tvx1# ^ 2 + tvy1# ^ 2)
    tv2tot# = Sqr(tvx2# ^ 2 + tvy2# ^ 2)
    If write1% = 1 Then Print #5, "TVs: ", tvx1#, tvy1#, tvx2#, tvy2#
    If (Cos(angle1#) * tvx1# + Sin(angle1#) * tvy1#) < (Cos(angle1#) * tvx2# + Sin(angle1#) * tvy2#) Then 'if the collision points are moving towards each other
        'If write1%=1 Then Print #5, "VEL of point on 1 in impact direction: ", Cos(angle1#) * tvx1# + Sin(angle1#) * tvy1#
        'If write1%=1 Then Print #5, "VEL of point on 2 in impact direction: ", Cos(angle1#) * tvx2# + Sin(angle1#) * tvy2#
        If tv1tot# > .0001 Or tv2tot# > .0001 Then 'if at least one point is moving
            If cornerflag% = 0 Then 'If it's not a corner collision, if it's a corner collision then angle4# is already defined
                Rem    Vectors should be pointing the same direction
                If tv1tot# < .0001 Then 'if point 1 is stationary (and point 2 is not)
                    'angle4# = Atan2(tvx2#, tvy2#)
                    angle4# = _Atan2(tvy2#, tvx2#)
                ElseIf tv2tot# < .0001 Then 'if point 2 is stationary (and point 1 is not)
                    'angle4# = Atan2(tvx1#, tvy1#)
                    angle4# = _Atan2(tvy1#, tvx1#)
                ElseIf tvx1# * tvx2# + tvy1# * tvy2# < 0 Then
                    'angle4# = avgangle(Atan2(tvx1#, tvy1#) + _Pi, Atan2(tvx2#, tvy2#)) 'since the vectors are pointing opposite directions, one must be reversed
                    angle4# = avgangle(_Atan2(tvy1#, tvx1#) + _Pi, _Atan2(tvy2#, tvx2#)) 'since the vectors are pointing opposite directions, one must be reversed
                ElseIf tvx1# * tvx2# + tvy1# * tvy2# > 0 Then
                    'angle4# = avgangle(Atan2(tvx1#, tvy1#), Atan2(tvx2#, tvy2#)) 'since the vectors are pointing the same direction, they can be averaged
                    angle4# = avgangle(_Atan2(tvy1#, tvx1#), _Atan2(tvy2#, tvx2#)) 'since the vectors are pointing the same direction, they can be averaged
                Else
                    angle4# = angle1#
                End If
                Rem    Vector must be pointing towards the collision face, or away from 1.  angle1# already accounts for this, so the two must be aligned.
                If Cos(angle1#) * Cos(angle4#) + Sin(angle1#) * Sin(angle4#) <= 0 Then angle4# = angle4# + _Pi 'This checks for alignment
                fixangle (angle4#)
                fixangle (angle1#)
            End If
        Else
            angle4# = angle1#
            nulrot% = 1
        End If
        If physobjarray(obj1%).anglevel <> 0 Or physobjarray(obj2%).anglevel <> 0 Then 'Rotation Portion
            'angle5# = avgangle(angle1#, angle4#)
            angle5# = anglemeld#(angle1#, angle4#, 1 - 0.5 * Abs(tv1tot# - tv2tot#) ^ 2 / (Abs(tv1tot# - tv2tot#) ^ 2 + rotationalangletransition#))
        Else
            angle5# = angle1#
        End If
    Else
        angle5# = angle1#
        nulrot% = 1
    End If

    'Average
    'finalangle# = avgangle(transangle#, angle5#)

    If (Abs(tv1tot# - tv2tot#) + Abs(vel1# - vel2#)) <> 0 Then
        finalangle# = anglemeld#(angle5#, transangle#, (Abs(tv1tot# - tv2tot#) / (Abs(tv1tot# - tv2tot#) + Abs(vel1# - vel2#))))
    Else
        finalangle# = avgangle(transangle#, angle5#)
    End If

    'FINISH ROTATIONAL ALIGNMENT
    radius# = perpvector(px#, py#, Cos(finalangle#), Sin(finalangle#), physobjarray(obj1%).xpos, physobjarray(obj1%).ypos)
    rot_to_rot# = radius# / (physobjarray(obj1%).size * Sqr(2))
    rot_to_trans# = 1 - rot_to_rot#

    If write1% = 1 Then
        Print #5, "Rot To Rot: ", rot_to_rot#, rot_to_trans#
        Print #5, "Trans to Trans: ", trans_to_trans#, trans_to_rot#
        Print #5, "Sizelimit#: ", sizelimit#
    End If


    'ROTATIONAL COLLISION PORTION
    'These equations are for the conservation of angular momentum and energy between two colliding rotating bodies
    'This becomes less true as this vector points closer to the center of object 1
    'In the final extreme final case the rotation smacks the point like a paddle producing pure translation
    'A new solution is needed to handle this case, then transition between situations
    'For the extreme cases, all translational transfer to rotational energy: 0.5mv^2=0.5Iw^2  w=sqrt(mv^2/I) Torque=I(w-w0)  w0=0 to Torque=sqrt(Imv^2)
    'A better approximation is all rotational energy from both bodies is transferred to translational energy for both
    'In this case, Force = sqrt((I1*w1^2 + I2*w2^2)*m1*m2/(m1+m2)).  In the other case Torque=sqrt((m1*v1^2+m2*v2^2)*I1*I2/(I1+I2))
    'Similarly for the opposite case, rotaional to translational Torque=sqrt(Imw^2) 'square root of square eliminates sign
    If nulrot% = 0 Then 'if the collision points are moving towards each other
        If physobjarray(obj2%).otype = 1 Then 'when the object it's hitting is fixed
            torquemag# = Abs(2 * physobjarray(obj1%).rotInert * physobjarray(obj1%).anglevel) 'limit should be 2*I1*w1
            tempforce2# = Sqr(physobjarray(obj1%).rotInert * physobjarray(obj1%).anglevel ^ 2 * physobjarray(obj1%).mass) 'Force =sqrt(Iw^2*m)
        Else
            torquemag# = Abs(2 * physobjarray(obj1%).rotInert * physobjarray(obj2%).rotInert * (physobjarray(obj1%).anglevel - physobjarray(obj2%).anglevel) / (physobjarray(obj1%).rotInert + physobjarray(obj2%).rotInert)) '2*I1*I2*(w1-w2)/(I1+I2)
            tempforce2# = Sqr((physobjarray(obj1%).rotInert * physobjarray(obj1%).anglevel ^ 2 + physobjarray(obj2%).rotInert * physobjarray(obj2%).anglevel ^ 2) * physobjarray(obj1%).mass * physobjarray(obj2%).mass / (physobjarray(obj1%).mass + physobjarray(obj2%).mass)) 'Force = sqrt((I1*w1^2 + I2*w2^2)*m1*m2/(m1+m2))
        End If
        'radius# = Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) 'maximum value
        If Abs(radius#) < .000000001 Then
            tempforce1# = 1 * tempforce2#
        Else
            tempforce1# = (torquemag# / radius#) 'These values don't depend on knowing the colliding face
        End If
        If tempforce1# > 1 * tempforce2# Then
            If write1% = 1 Then Print #5, "Rotation Force REDUCED from ", tempforce1#
            tempforce1# = 1 * tempforce2# 'this ratio is a complete guess, but we can't have a singularity
        End If
        force2mag# = rot_to_rot# * tempforce1# + rot_to_trans# * tempforce2#
        'SUBSTITUTE rot_to_tot* tempforce1# with: radius# / (physobjarray(obj1%).size * Sqr(2))* (torquemag# / radius#)=  torquemag#/(physobjarray(obj1%).size * Sqr(2))
        'tempforce1# = (torquemag# / radius#) 'this doesn't work for some reason?
        'force2mag# = torquemag# / (physobjarray(obj1%).size * Sqr(2)) + rot_to_trans# * tempforce2#
        If write1% = 1 Then Print #5, "ROTATION TEMPFORCE 1 & 2 & radius: ", tempforce1#, tempforce2#, radius#
    Else
        force2mag# = 0 'nullify force if the objects are moving away from each other
        If write1% = 1 Then Print #5, "Rotation Force Nullified"
    End If


    'TRANSLATION PORTION
    If nulvel% = 0 Then
        If physobjarray(obj2%).otype = 1 Then 'when the object it's hitting is fixed
            tempforce1# = Abs(2 * physobjarray(obj1%).mass * (Cos(finalangle#) * physobjarray(obj1%).xvel + Sin(finalangle#) * physobjarray(obj1%).yvel)) ''limit should be 2*m1*v1, velocity component in line with force (used to use component in-line with face, but this works better)
            temptorque# = Sqr(physobjarray(obj1%).mass * vel1# ^ 2 * physobjarray(obj1%).rotInert) 'sqr(m*v1^2*I)
        Else
            '2*m1*m2*(v1-v2)/(m1+m2)  Sign depends on directions linear movement solution. Use COM velocity for linear components, velocity of point impact for rotational.
            'tempforce1# = Abs(2 * physobjarray(obj1%).mass * physobjarray(obj2%).mass * (vel1# - vel2#) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass)) '2*m1*m2*(v1-v2)/(m1+m2)  force direction agnostic equation
            vel1f# = Sqr((Cos(finalangle#) * physobjarray(obj1%).xvel) ^ 2 + (Sin(finalangle#) * physobjarray(obj1%).yvel) ^ 2)
            vel2f# = Sqr((Cos(finalangle#) * physobjarray(obj2%).xvel) ^ 2 + (Sin(finalangle#) * physobjarray(obj2%).yvel) ^ 2)
            tempforce1# = Abs(2 * physobjarray(obj1%).mass * physobjarray(obj2%).mass * (vel1f# - vel2f#) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass)) 'These equations use the force direction
            temptorque# = Sqr((physobjarray(obj1%).mass * vel1# ^ 2 + physobjarray(obj2%).mass * vel2# ^ 2) * physobjarray(obj1%).rotInert * physobjarray(obj2%).rotInert / (physobjarray(obj1%).rotInert + physobjarray(obj2%).rotInert)) 'Torque=sqrt((m1*v1^2+m2*v2^2)*I1*I2/(I1+I2))
        End If
        'radius# = Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) 'maximum value
        If Abs(radius#) < .0000000001 Then
            tempforce2# = 1 * tempforce1#
        Else
            tempforce2# = (temptorque# / radius#) 'These values don't depend on knowing the colliding face
        End If
        If tempforce2# > 1 * tempforce1# Then tempforce2# = 1 * tempforce1# 'this ratio is a complete guess, but we can't have a singularity
        force1mag# = trans_to_trans# * tempforce1# + trans_to_rot# * tempforce2#
        If write1% = 1 Then Print #5, "TRANSLATION TEMPFORCE 1 & 2 & Radius: ", tempforce1#, tempforce2#, radius#
    Else
        force1mag# = 0 'nullify force is the objects are moving away from each other
        If write1% = 1 Then Print #5, "Velocity Force Nullified"
    End If

    'FORCES
    finalforce# = force1mag# + force2mag#
    forces(0) = forces(0) + physobjarray(obj1%).forcereturn * physobjarray(obj2%).forcereturn * (finalforce# * Cos(finalangle#)) 'reduce by force return
    forces(1) = forces(1) + physobjarray(obj1%).forcereturn * physobjarray(obj2%).forcereturn * (finalforce# * Sin(finalangle#)) 'reduce by force return


    If write1% = 1 Then Print #5, "REDUCED STATIC SUB FORCES"
    If write1% = 1 Then Print #5, forces(0), forces(1)
    If write1% = 1 Then Print #5, "ANGLE1, ANGLE2, TRANS_ANGLE AND FORCE1MAG"
    If write1% = 1 Then Print #5, angle1#, angle2#, transangle#, force1mag#
    If write1% = 1 Then Print #5, "ANGLE 3 and ANGLE 4, and ANGLE 5 ", angle3#, angle4#, angle5#
    If write1% = 1 Then Print #5, "TRANS FORCE, ROT FORCE, TORQUE ", force1mag#, force2mag#, torquemag#
    If write1% = 1 Then Print #5, "FINAL ANGLE AND FINAL FORCE AND FINAL FORCE REDUCED: ", finalangle#, finalforce#, physobjarray(obj1%).forcereturn * physobjarray(obj2%).forcereturn * finalforce#
    If write1% = 1 Then Print #5, "VELOCITY", vel1#, physobjarray(obj1%).xvel, physobjarray(obj1%).yvel
End Sub

Sub springforceobjects (px#, py#, obj1%, obj2%)
    If write1% = 1 Then Print #5, ""
    If write1% = 1 Then Print #5, "TOUCH COLLISION "
    Dim springforce#, angle1#, tempangle1#, reflectangle#, altspringboundary#
    springforce# = 0
    forces(0) = 0
    forces(1) = 0
    Dim corner%% 'a byte, between -128 amd 127
    corner%% = 0
    Dim dampingcoef#
    dampingcoef# = 0.5 * physobjarray(obj1%).damping + 0.5 * physobjarray(obj2%).damping

    Rem    FIND FACE ANGLE:
    'Approach: find dot product of obj2 vector to collision point (stepped back by one velocity increment) and obj2 angle vectors (incremented by 90 deg increments)
    Dim dotproducts#(3, 1)
    reflectangle# = physobjarray(obj2%).angle
    For i% = 0 To 3
        'dotproducts#(i%, 0) = Cos(reflectangle#) * ((px# - physobjarray(obj1%).xvel / physicslimit#) - physobjarray(obj2%).xpos) + Sin(reflectangle#) * ((py# - physobjarray(obj1%).yvel / physicslimit#) - physobjarray(obj2%).ypos)
        dotproducts#(i%, 0) = Cos(reflectangle#) * (px# - physobjarray(obj2%).xpos) + Sin(reflectangle#) * (py# - physobjarray(obj2%).ypos) 'Not sure that stepping back position always helps
        'If write1%=1 Then Print #5, reflectangle#, (px# - physobjarray(obj2%).xpos), (py# - physobjarray(obj2%).ypos)
        dotproducts#(i%, 1) = reflectangle#
        reflectangle# = reflectangle# + _Pi / 2
    Next i%
    'the largest positive value will indicate which face of obj2 was hit by obj1, and the angle that points to it.
    sortdouble2D dotproducts#(), 0
    'If write1%=1 Then Print #5, "SECOND OBJECT DOT PRODUCTS"
    'If two dot products are the same length then you have a corner collision, handled separately
    'in all other cases the force is applied in the direction of the angle of obj2 that points to the face, found before
    If Abs(dotproducts#(0, 0) - dotproducts#(1, 0)) < .02 * physobjarray(obj2%).size Or Abs(dotproducts#(0, 0) - dotproducts#(1, 0)) < .1 Then
        'For corner collisions first look at the other object to determine the angle
        reflectangle# = physobjarray(obj1%).angle
        For i% = 0 To 3
            dotproducts#(i%, 0) = Cos(reflectangle#) * (px# - physobjarray(obj1%).xpos) + Sin(reflectangle#) * (py# - physobjarray(obj1%).ypos)
            dotproducts#(i%, 1) = reflectangle#
            reflectangle# = reflectangle# + _Pi / 2
        Next i%
        sortdouble2D dotproducts#(), 0
        'If write1%=1 Then Print #5, "FIRST OBJECT DOT PRODUCTS"
        If Abs(dotproducts#(0, 0) - dotproducts#(1, 0)) < .02 * physobjarray(obj1%).size Or Abs(dotproducts#(0, 0) - dotproducts#(1, 0)) < .1 Then
            'angle1# = Atan2(physobjarray(obj1%).xpos - px#, physobjarray(obj1%).ypos - py#) 'points directly to center of obj1
            angle1# = _Atan2(physobjarray(obj1%).ypos - py#, physobjarray(obj1%).xpos - px#) 'points directly to center of obj1
            'tempangle1# = Atan2(px# - physobjarray(obj2%).xpos, py# - physobjarray(obj2%).ypos) 'points away from center of obj2
            tempangle1# = _Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos) 'points away from center of obj2
            If Cos(angle1#) * Cos(tempangle1#) + Sin(angle1#) * Sin(tempangle1#) < .707 Then 'if the dot product of the two vectors is <.707 =  ABcos(theta) = cos(theta) (since vectors length=1) so if the collision angle is less than 45 degrees...
                reflectangle# = physobjarray(obj2%).angle
                For i% = 0 To 3
                    dotproducts#(i%, 0) = Cos(reflectangle#) * (physobjarray(obj1%).xpos - physobjarray(obj2%).xpos) + Sin(reflectangle#) * (physobjarray(obj1%).ypos - physobjarray(obj2%).ypos)
                    dotproducts#(i%, 1) = reflectangle#
                    reflectangle# = reflectangle# + _Pi / 2
                Next i%
                sortdouble2D dotproducts#(), 0
                angle1# = dotproducts#(0, 1)
            End If 'else angle1# remains unchanged
            corner%% = 2
            'If write1% = 1 Then Print #5, "TOUCH CORNER COLLISION"
        Else
            angle1# = dotproducts#(0, 1) + _Pi 'reversed because for object 1 the vectors point away from the center of object 1 (for object 2 they point towards object 1)
            corner%% = 1 'Because this means it's hitting the corner of the second object
            'If write1% = 1 Then Print #5, "TOUCH FIRST OBJECT FACE COLLISION"
        End If
    Else
        angle1# = dotproducts#(0, 1) 'references the old dot products due to conditional else statement, points towards object 1 face
        'If write1% = 1 Then Print #5, "TOUCH SECOND OBJECT FACE COLLISION"
    End If

    'velocity parameters
    Dim tvx1#, tvx2#, tvy1#, tvy2#
    Dim obj1topangle#, obj2topangle#
    'obj1topangle# = Atan2(px# - physobjarray(obj1%).xpos, py# - physobjarray(obj1%).ypos)
    'obj2topangle# = Atan2(px# - physobjarray(obj2%).xpos, py# - physobjarray(obj2%).ypos)
    obj1topangle# = _Atan2(py# - physobjarray(obj1%).ypos, px# - physobjarray(obj1%).xpos)
    obj2topangle# = _Atan2(py# - physobjarray(obj2%).ypos, px# - physobjarray(obj2%).xpos)
    tvx1# = physobjarray(obj1%).xvel - physobjarray(obj1%).anglevel * Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) * Sin(obj1topangle#)
    tvy1# = physobjarray(obj1%).yvel + physobjarray(obj1%).anglevel * Sqr((px# - physobjarray(obj1%).xpos) ^ 2 + (py# - physobjarray(obj1%).ypos) ^ 2) * Cos(obj1topangle#)
    tvx2# = physobjarray(obj2%).xvel - physobjarray(obj2%).anglevel * Sqr((px# - physobjarray(obj2%).xpos) ^ 2 + (py# - physobjarray(obj2%).ypos) ^ 2) * Sin(obj2topangle#)
    tvy2# = physobjarray(obj2%).yvel + physobjarray(obj2%).anglevel * Sqr((px# - physobjarray(obj2%).xpos) ^ 2 + (py# - physobjarray(obj2%).ypos) ^ 2) * Cos(obj2topangle#)


    altspringboundary# = springboundary#
    'If the relative velocity of the two objects is high enough, then the boundary must get larger so that this will return a 0 value, which will get omitted in the final analysis
    'otherwise this will return a low value that will get averaged out with the other force value calculated, making the impact forces severely reduced
    If Sqr((tvx1# - tvx2#) ^ 2 + (tvy1# - tvy2#) ^ 2) > 10 Then
        If write1% = 1 Then Print #5, "INCREASED SPRING BOUNDARY"
        altspringboundary# = altspringboundary# * 2.5
    End If

    'compression Distance
    Dim compdist#, fulldist#
    If corner%% = 0 Then
        fulldist# = perpvector(px#, py#, -Sin(angle1#), Cos(angle1#), physobjarray(obj2%).xpos, physobjarray(obj2%).ypos) 'Distance from center is perpvector of negative reciprocal of angle1# with COM of other object and collision point.
        compdist# = physobjarray(obj2%).size / 2 - fulldist# - altspringboundary#
        If compdist# < 0 Then compdist# = 0
        springforce# = compdist# * springconst#
    ElseIf corner%% = 1 Then
        fulldist# = perpvector(px#, py#, -Sin(angle1#), Cos(angle1#), physobjarray(obj1%).xpos, physobjarray(obj1%).ypos) 'Distance from center is perpvector of negative reciprocal of angle1# with COM of this object and collision point.
        compdist# = physobjarray(obj1%).size / 2 - fulldist# - altspringboundary#
        If compdist# < 0 Then compdist# = 0
        springforce# = compdist# * springconst#
    Else
        fulldist# = Sqr((physobjarray(obj1%).xpos - physobjarray(obj2%).xpos) ^ 2 + (physobjarray(obj1%).ypos - physobjarray(obj2%).ypos) ^ 2)
        compdist# = (physobjarray(obj1%).size + physobjarray(obj2%).size) * Sqr(2) / 2 - fulldist# - altspringboundary#
        If compdist# < 0 Then compdist# = 0
        springforce# = compdist# * springconst#
    End If

    'Reduce springforce by damping coef if object is moving away
    If damptype% = 1 Then 'if unidirectional damping
        If (Cos(angle1#) * tvx1# + Sin(angle1#) * tvy1#) <= (Cos(angle1#) * tvx2# + Sin(angle1#) * tvy2#) Then 'if the collision points are moving towards each other
            forces(0) = springforce# * Cos(angle1#)
            forces(1) = springforce# * Sin(angle1#)
        Else
            'Rem   FORCES
            If write1% = 1 Then Print #5, "Spring Points Moving Away"
            forces(0) = (1 - dampingcoef#) * springforce# * Cos(angle1#)
            forces(1) = (1 - dampingcoef#) * springforce# * Sin(angle1#)
        End If
    Else 'permanent damping
        'What was I doing here?
        'forces(0) = Cos(angle1#) * (springforce# - dampingcoef# * physobjarray(obj1%).mass * physobjarray(obj2%).mass * (Cos(angle1#) * (tvx1# - tvx2#) + Sin(angle1#) * (tvy1# - tvy2#)) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass))
        'forces(1) = Sin(angle1#) * (springforce# - dampingcoef# * physobjarray(obj1%).mass * physobjarray(obj2%).mass * (Cos(angle1#) * (tvx1# - tvx2#) + Sin(angle1#) * (tvy1# - tvy2#)) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass))
        forces(0) = (1 - dampingcoef#) * springforce# * Cos(angle1#)
        forces(1) = (1 - dampingcoef#) * springforce# * Sin(angle1#)
    End If

    If write1% = 1 Then
        Print #5, "SPRING STATIC SUB FORCES"
        Print #5, forces(0), forces(1)
    End If


    'Add friction here, and in collisionforceobjects also? Probably best to just leave them here only
    'Normal Force
    Dim normalforce#, forceangle#, frictionforce#
    If Abs((tvx1# - tvx2#) * Cos(forceangle#) + (tvy1# - tvy2#) * Sin(forceangle#)) > 0.001 Then ' skip this whole thing if there is no tangent velocity or force, use relative velocity
        '(tvx1# - tvx2#) * Cos(forceangle#) + (tvy1# - tvy2#) * Sin(forceangle#)
        '(physobjarray(obj1%).xvel - physobjarray(obj2%).xvel) * Cos(forceangle#) + (physobjarray(obj1%).yvel - physobjarray(obj2%).yvel) * Sin(forceangle#)
        'Use of total velocity and object velocity is different and intentional, but I'm still experimenting with this
        forceangle# = angle1# + _Pi / 2
        If (tvx1# - tvx2#) * Cos(forceangle#) + (tvy1# - tvy2#) * Sin(forceangle#) > 0 Then forceangle# = forceangle# - _Pi
        'friction force should be opposite in direction to the tangent velocity, if no velocity then should be opposite to tangent force.  No tangent force here
        normalforce# = Sqr(forces(0) ^ 2 + forces(1) ^ 2) 'already in direction for angle1, so no correction needed there
        frictionforce# = (0.5 * physobjarray(obj1%).friction + 0.5 * physobjarray(obj2%).friction) * normalforce#
        If frictionforce# > Abs(physobjarray(obj1%).mass * physobjarray(obj2%).mass * (Cos(forceangle#) * (physobjarray(obj1%).xvel - physobjarray(obj2%).xvel) + Sin(forceangle#) * (physobjarray(obj1%).yvel - physobjarray(obj2%).yvel)) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass)) Then
            frictionforce# = Abs(physobjarray(obj1%).mass * physobjarray(obj2%).mass * (Cos(forceangle#) * (physobjarray(obj1%).xvel - physobjarray(obj2%).xvel) + Sin(forceangle#) * (physobjarray(obj1%).yvel - physobjarray(obj2%).yvel)) / (physobjarray(obj1%).mass + physobjarray(obj2%).mass))
            If write1% = 1 Then Print #5, "FRICTION FORCES CAPPED"
            'Friction force should not exceed stopping force
        End If
        forces(0) = forces(0) + Cos(forceangle#) * frictionforce#
        forces(1) = forces(1) + Sin(forceangle#) * frictionforce#
        If write1% = 1 Then
            Print #5, "FRICTION  SUB FORCES"
            Print #5, Cos(forceangle#) * frictionforce#, Sin(forceangle#) * frictionforce#
            Print #5, "NORMAL FORCE, FRICTION FORCE, FORCE ANGLE: ", normalforce#, frictionforce#, forceangle#
        End If
    End If


    If write1% = 1 Then
        Print #5, "TOTAL REACTION SUB FORCES"
        Print #5, forces(0), forces(1)
        Print #5, "ANGLE1 ", angle1#
        Print #5, "compdist, fulldist: ", compdist#, fulldist#
        Print #5, "VELOCITY", physobjarray(obj1%).xvel, physobjarray(obj1%).yvel
    End If

End Sub

Function Atan2# (x#, y#)
    If x# >= 0 Then
        Atan2# = Atn(y# / x#)
    Else
        Atan2# = Atn(y# / x#) + _Pi
    End If 'output ranges from -Pi/2 to 3Pi/2
End Function

Sub outer_collision (px#, py#, obji%, objj%, forcecounter%, forcelist#()) 'updates forcelist# with new forces
    Dim angle#
    'This sub could probably be included in collisionforceobjects in a future update, unless it becomes more complex
    collisionforceobjects px#, py#, obji%, objj% 'This sub updates the forces vectors used below
    If Sqr(forces(0) ^ 2 + forces(1) ^ 2) > 0.000001 And forcecounter% <= collisionperobjectlimit% Then
        forcelist#(forcecounter%, 0) = forces(0)
        forcelist#(forcecounter%, 1) = forces(1)
        'angle# = Atan2(px# - physobjarray(obji%).xpos, py# - physobjarray(obji%).ypos) 'angle from object center to point p
        angle# = _Atan2(py# - physobjarray(obji%).ypos, px# - physobjarray(obji%).xpos) 'angle from object center to point p
        If (-Sin(angle#) * forces(0) + Cos(angle#) * forces(1)) > 0 Then
            '         dot product of negative recirprocal of normalized angle vector (from sin/cos) with force vector then the rotation is positive
            forcelist#(forcecounter%, 2) = Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos) '+F*R
            'If write1% = 1 Then Print #5, "THIS TORQUE 1: ", Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), objects(obji%, 4), objects(obji%, 5))
        Else
            forcelist#(forcecounter%, 2) = -Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos) '+F*R
            'If write1% = 1 Then Print #5, "THIS TORQUE 2: ", -Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), objects(obji%, 4), objects(obji%, 5))
        End If
        If write1% = 1 Then Print #5, "O-TORQUE ", forcelist#(forcecounter%, 2), perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos)
        If write1% = 1 Then Print #5, "angle ", angle#, px#, py#
        forcecounter% = forcecounter% + 1
    Else
        If write1% = 1 Then Print #5, "TOUCHED, NO TOUCH FORCE"
    End If
End Sub

Sub inner_collision (px#, py#, obji%, objj%, forcecounter%, forcelist#()) 'updates forcelist# with new forces
    Dim angle#
    springforceobjects px#, py#, obji%, objj% 'This sub updates the forces vectors used below (I could have made it pass them but instead I made these global)
    If Sqr(forces(0) ^ 2 + forces(1) ^ 2) > 0.000001 And forcecounter% <= collisionperobjectlimit% Then
        forcelist#(forcecounter%, 0) = forces(0)
        forcelist#(forcecounter%, 1) = forces(1)
        'angle# = Atan2(px# - physobjarray(obji%).xpos, py# - physobjarray(obji%).ypos) 'angle from object center to point p
        angle# = _Atan2(py# - physobjarray(obji%).ypos, px# - physobjarray(obji%).xpos) 'angle from object center to point p
        If (-Sin(angle#) * forces(0) + Cos(angle#) * forces(1)) > 0 Then
            '         dot product of negative recirprocal of normalized angle vector (from sin/cos) with force vector then the rotation is positive
            forcelist#(forcecounter%, 2) = Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos) '+F*R
            'If write1% = 1 Then Print #5, "THIS TORQUE 1: ", Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), objects(obji%, 4), objects(obji%, 5))
        Else
            forcelist#(forcecounter%, 2) = -Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos) '+F*R
            'If write1% = 1 Then Print #5, "THIS TORQUE 2: ", -Sqr(forces(0) ^ 2 + forces(1) ^ 2) * perpvector(px#, py#, forces(0), forces(1), objects(obji%, 4), objects(obji%, 5))
        End If
        If write1% = 1 Then Print #5, "I-TORQUE ", forcelist#(forcecounter%, 2), perpvector(px#, py#, forces(0), forces(1), physobjarray(obji%).xpos, physobjarray(obji%).ypos)
        If write1% = 1 Then Print #5, "angle ", angle#
        forcecounter% = forcecounter% + 1
    Else
        If write1% = 1 Then Print #5, "TOUCHED, NO TOUCH FORCE"
    End If
End Sub


Function anycollision% (i%, j%)
    Dim test%
    test% = 0
    If In4Points%(corners#(i%, 0), corners#(i%, 1), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(i%, 2), corners#(i%, 3), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(i%, 4), corners#(i%, 5), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(i%, 6), corners#(i%, 7), corners#(j%, 0), corners#(j%, 1), corners#(j%, 2), corners#(j%, 3), corners#(j%, 4), corners#(j%, 5), corners#(j%, 6), corners#(j%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(j%, 0), corners#(j%, 1), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(j%, 2), corners#(j%, 3), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(j%, 4), corners#(j%, 5), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
        test% = 1
    End If
    If In4Points%(corners#(j%, 6), corners#(j%, 7), corners#(i%, 0), corners#(i%, 1), corners#(i%, 2), corners#(i%, 3), corners#(i%, 4), corners#(i%, 5), corners#(i%, 6), corners#(i%, 7)) = 1 Then
        test% = 1
    End If
    anycollision% = test%

End Function

Sub update_non_screen_corners
    Dim numobjects%
    numobjects% = UBound(physobjarray)
    'Make a temporary list of all corners of all objects
    ReDim corners#(numobjects%, 7) 'Redim also sets everything to zero                                                                                                                                                      If write1%=1 Then Print #5, "FIRST OBJECT FACE COLLISION"
    ReDim springcorners#(numobjects%, 7) 'Redim also sets everything to zero                                                                                                                                                      If write1%=1 Then Print #5, "FIRST OBJECT FACE COLLISION"
    For i% = 0 To numobjects%
        '        corners#(i%, 0) = physobjarray(i%).xpos - physobjarray(i%).size / 2 * Cos(physobjarray(i%).angle) - physobjarray(i%).size / 2 * Sin(physobjarray(i%).angle) 'angles are in radians
        '        corners#(i%, 1) = physobjarray(i%).ypos - physobjarray(i%).size / 2 * Sin(physobjarray(i%).angle) + physobjarray(i%).size / 2 * Cos(physobjarray(i%).angle) 'angles are in radians
        'Side lengths are the same, so this can be further simplified:

        corners#(i%, 0) = physobjarray(i%).xpos + physobjarray(i%).size / 2 * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle)) 'angles are in radians   X=1 Y=1
        corners#(i%, 1) = physobjarray(i%).ypos + physobjarray(i%).size / 2 * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle)) 'angles are in radians X=1 Y=1
        corners#(i%, 2) = physobjarray(i%).xpos + physobjarray(i%).size / 2 * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=1
        corners#(i%, 3) = physobjarray(i%).ypos + physobjarray(i%).size / 2 * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=1
        corners#(i%, 4) = physobjarray(i%).xpos + physobjarray(i%).size / 2 * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=-1
        corners#(i%, 5) = physobjarray(i%).ypos + physobjarray(i%).size / 2 * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=-1
        corners#(i%, 6) = physobjarray(i%).xpos + physobjarray(i%).size / 2 * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle)) 'angles are in radians  X=1 Y=-1
        corners#(i%, 7) = physobjarray(i%).ypos + physobjarray(i%).size / 2 * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle)) 'angles are in radians   X=1 Y=-1

        springcorners#(i%, 0) = physobjarray(i%).xpos + (physobjarray(i%).size / 2 - springboundary#) * (Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle)) 'angles are in radians   X=1 Y=1
        springcorners#(i%, 1) = physobjarray(i%).ypos + (physobjarray(i%).size / 2 - springboundary#) * (Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle)) 'angles are in radians X=1 Y=1
        springcorners#(i%, 2) = physobjarray(i%).xpos + (physobjarray(i%).size / 2 - springboundary#) * (-Cos(physobjarray(i%).angle) - Sin(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=1
        springcorners#(i%, 3) = physobjarray(i%).ypos + (physobjarray(i%).size / 2 - springboundary#) * (-Sin(physobjarray(i%).angle) + Cos(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=1
        springcorners#(i%, 4) = physobjarray(i%).xpos + (physobjarray(i%).size / 2 - springboundary#) * (-Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=-1
        springcorners#(i%, 5) = physobjarray(i%).ypos + (physobjarray(i%).size / 2 - springboundary#) * (-Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle)) 'angles are in radians  X=-1 Y=-1
        springcorners#(i%, 6) = physobjarray(i%).xpos + (physobjarray(i%).size / 2 - springboundary#) * (Cos(physobjarray(i%).angle) + Sin(physobjarray(i%).angle)) 'angles are in radians  X=1 Y=-1
        springcorners#(i%, 7) = physobjarray(i%).ypos + (physobjarray(i%).size / 2 - springboundary#) * (Sin(physobjarray(i%).angle) - Cos(physobjarray(i%).angle)) 'angles are in radians   X=1 Y=-1

    Next i%
End Sub
Sub placeobject (xpos#, ypos#)
    Dim temp%, tempsize#, temptype%, tempreturnforce#, tempmass#, tempangle#, tempxvel#, tempyvel#, tempanglevel#, tempfriction#, tempdamping#
    Cls
    Print "PLACE OBJECT"
    Print "1 - Size 50 Stationary Square "
    Print "2 - Size 10 Free Square Mass 10"
    Print "3 - Size 2 Free Square Mass 2"
    Print "4 - Size 10 Free Square Mass 10 No Gravity"
    Print "5 - Size 4 Free Square Mass 4 No Gravity"
    Print "6 - Size 2 Stationary Square "
    Print "7 - Custom"
    Input "SELECTION: ", temp%
    If temp% = 1 Then
        tempsize# = 50
        temptype% = 1
        tempmass# = 10
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 2 Then
        tempsize# = 10
        temptype% = 2
        tempmass# = 10
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 3 Then
        tempsize# = 2
        temptype% = 2
        tempmass# = 2
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 4 Then
        tempsize# = 10
        temptype% = 3
        tempmass# = 10
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 5 Then
        tempsize# = 4
        temptype% = 3
        tempmass# = 4
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 6 Then
        tempsize# = 2
        temptype% = 1
        tempmass# = 4
        tempreturnforce# = 1
        tempfriction# = 0.1
        tempdamping# = 0.05
    End If
    If temp% = 7 Then
        Input "Size?: ", tempsize#
        Input "Type? (1=Fixed 2=Free 3=Free No Gravity): ", temptype%
        Input "Mass? ", tempmass#
        Input "Force Return? (1 is nominal) ", tempreturnforce#
        Input "Friction? (0.1 is nominal) ", tempfriction#
        Input "Damping? (.05 is nominal) ", tempdamping#
    End If
    Input "Angle: ", tempangle#
    If temp% <> 1 And temp% <> 6 Then
        Input "X-Velocity: ", tempxvel#
        Input "Y-Velocity: ", tempyvel#
        Input "Angular Velocity: ", tempanglevel#
    End If
    NewObject temptype%, 0, 100, tempsize#, tempmass#, xpos#, ypos#, tempxvel#, tempyvel#, 0, 0, tempreturnforce#, tempangle#, tempanglevel#, tempfriction#, tempdamping# '(otype%, health#, size#, mass#, xpos#, ypos#, xvel#, yvel#, xacc#, yacc#, forcereturn#, angle#, anglevel#, friction#, damping#)
End Sub
Sub sortdouble (array#())
    Dim size%
    size% = UBound(array#)
    Dim newarray#(size%)
    Dim tagged%(size%)
    Dim taggedindex%
    For i = 0 To size%
        newarray#(i) = -1.797693134862310 * 10 ^ 308
    Next i
    For i = 0 To size%
        For j = 0 To size%
            If array#(j) > newarray#(i) And tagged%(j) = 0 Then
                newarray#(i) = array#(j)
                taggedindex% = j
            End If
        Next j
        tagged%(taggedindex%) = 1
    Next i

    For i = 0 To size%
        'Print newarray#(i)
        array#(i) = newarray#(i)
    Next i


End Sub

Sub sortdouble2D (array#(), col%)
    Dim size%, numcols%
    size% = UBound(array#, 1) 'UBOUND command is 1 indexed
    numcols% = UBound(array#, 2)
    If col% > numcols% Then Exit Sub
    Dim newarray#(size%, numcols%)
    Dim tagged%(size%)
    Dim taggedindex%
    For i = 0 To size%
        newarray#(i, col%) = -1.797693134862310 * 10 ^ 308
    Next i
    For i = 0 To size%
        For j = 0 To size%
            If array#(j, col%) > newarray#(i, col%) And tagged%(j) = 0 Then
                For k = 0 To numcols%
                    newarray#(i, k) = array#(j, k)
                Next k
                taggedindex% = j
            End If
        Next j
        tagged%(taggedindex%) = 1
    Next i

    For i = 0 To size%
        For j = 0 To numcols%
            array#(i, j) = newarray#(i, j)
        Next j
    Next i

End Sub
Function avgangle# (angle1#, angle2#)
    avgangle# = 0
    fixangle (angle1#)
    fixangle (angle2#)
    If angle1# < angle2# Then
        While angle2# - angle1# > _Pi
            angle1# = angle1# + 2 * _Pi
        Wend
    End If
    If angle2# < angle1# Then
        While angle1# - angle2# > _Pi
            angle2# = angle2# + 2 * _Pi
        Wend
    End If
    avgangle# = (angle1# + angle2#) / 2
End Function
Function anglemeld# (angle1#, angle2#, angle1percent#)
    anglemeld# = 0
    fixangle (angle1#)
    fixangle (angle2#)
    If angle1# < angle2# Then
        While angle2# - angle1# > _Pi
            angle1# = angle1# + 2 * _Pi
        Wend
    End If
    If angle2# < angle1# Then
        While angle1# - angle2# > _Pi
            angle2# = angle2# + 2 * _Pi
        Wend
    End If
    anglemeld# = angle1# * angle1percent# + angle2# * (1 - angle1percent#)
End Function
Sub fixangle (angle#) 'all angles will be between 0 and 2Pi
    While angle# > 2 * _Pi
        angle# = angle# - 2 * _Pi
    Wend
    While angle# < 0
        angle# = angle# + 2 * _Pi
    Wend

End Sub
Function fixangle# (angle#) 'all angles will be between 0 and 2Pi
    While angle# > 2 * _Pi
        angle# = angle# - 2 * _Pi
    Wend
    While angle# < 0
        angle# = angle# + 2 * _Pi
    Wend
    fixangle# = angle#
End Function

Sub Makelandscape ()
    Dim downint%, acrossint%, cursorx%, cursory%, brush%
    '-3=ANOTHER BORDER COLOR
    '-2=DOOR BORDER
    '-1=EXIT DOOR
    '0=NOTHING
    '1=BLINKING STAR
    '2=DESTRUCTABLE BLOCK
    '3=INVINCIBLE BLOCK
    '4=DURABLE BLOCK
    For x = 1 To 3000
        downint% = Int(Rnd * 960) + 1
        acrossint% = Int(Rnd * 720) + 1
        landscape(downint%, acrossint%) = 1
    Next x
    For x = 0 To 720
        landscape(0, x) = 3
        landscape(960, x) = 3
    Next x
    For x = 0 To 960
        landscape(x, 0) = 3
        landscape(x, 720) = 3
    Next x
    brush% = 2
    For x = 1 To 130 'Fill in Less Durable Areas
        cursorx% = Int(Rnd * 959) + 1
        cursory% = Int(Rnd * 699) + 20
        While Rnd > .003
            If Rnd < .05 Then brush% = Int(Rnd * 6) + 3
            brushfill cursorx%, cursory%, brush%, 2, 1
            cursorx% = cursorx% + Int(Rnd * 5) - 2
            cursory% = cursory% + Int(Rnd * 5) - 2
            If cursorx% < 1 Then cursorx% = 1
            If cursory% < 21 Then cursory% = 21
            If cursorx% > 959 Then cursorx% = 959
            If cursory% > 719 Then cursory% = 719
        Wend
    Next x
    For x = 1 To 20 'Fill in More Durable Areas
        cursorx% = Int(Rnd * 959) + 1
        cursory% = Int(Rnd * 699) + 20
        While Rnd > .003
            If Rnd < .05 Then brush% = Int(Rnd * 6) + 3
            brushfill cursorx%, cursory%, brush%, 4, 1
            cursorx% = cursorx% + Int(Rnd * 5) - 2
            cursory% = cursory% + Int(Rnd * 5) - 2
            If cursorx% < 1 Then cursorx% = 1
            If cursory% < 21 Then cursory% = 21
            If cursorx% > 959 Then cursorx% = 959
            If cursory% > 719 Then cursory% = 719
        Wend
    Next x

    'For x = 1 To 959
    '    For y = 1 To 719
    '        If Rnd < .5 Then landscape(x, y) = 1
    '    Next y
    'Next x

    'Make larger holes
    Dim holecounter%
    Dim fill_list%(6)

    'Fill in holes
    fill_list%(0) = 5
    fill_list%(1) = 5
    fill_list%(2) = 6
    fill_list%(3) = 6
    fill_list%(4) = 7
    fill_list%(5) = 7
    fill_list%(6) = 8
    For z = 0 To UBound(fill_list%)
        For x = 1 To 959
            For y = 1 To 719
                holecounter% = 0
                If landscape(x + 1, y) = 2 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y) = 2 Then holecounter% = holecounter% + 1
                If landscape(x, y + 1) = 2 Then holecounter% = holecounter% + 1
                If landscape(x, y - 1) = 2 Then holecounter% = holecounter% + 1
                If landscape(x + 1, y + 1) = 2 Then holecounter% = holecounter% + 1
                If landscape(x + 1, y - 1) = 2 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y + 1) = 2 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y - 1) = 2 Then holecounter% = holecounter% + 1
                If holecounter% >= fill_list%(z) Then landscape(x, y) = 2
            Next y
        Next x
    Next z
    For z = 0 To UBound(fill_list%)
        For x = 1 To 959
            For y = 1 To 719
                holecounter% = 0
                If landscape(x + 1, y) = 4 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y) = 4 Then holecounter% = holecounter% + 1
                If landscape(x, y + 1) = 4 Then holecounter% = holecounter% + 1
                If landscape(x, y - 1) = 4 Then holecounter% = holecounter% + 1
                If landscape(x + 1, y + 1) = 4 Then holecounter% = holecounter% + 1
                If landscape(x + 1, y - 1) = 4 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y + 1) = 4 Then holecounter% = holecounter% + 1
                If landscape(x - 1, y - 1) = 4 Then holecounter% = holecounter% + 1
                If holecounter% >= fill_list%(z) Then landscape(x, y) = 4
            Next y
        Next x
    Next z


    For x = 1 To 959
        For y = 1 To 719
            If landscape(x, y) = 2 Then landscapehealth(x, y) = 12
        Next y
    Next x

    'Make Door
    For x = 446 To 514
        For y = 675 To 719
            If x < 450 Or x > 510 Or y < 680 Then
                landscape(x, y) = -2
                landscapehealth(x, y) = 0
            Else
                landscape(x, y) = -1
                landscapehealth(x, y) = 0
            End If
        Next y
    Next x

End Sub

Sub Makelevel (level%)
    If level% < 1 Then level% = 1
    If level% > 10 Then level% = 10
    Dim wormholes%(10)
    Dim deathspirals%(10)
    Dim angle#
    Dim velocity#(10)
    Dim spiralsize#(10)
    Dim wormholesize#(10)
    Dim moneyboxes%(10)
    Dim highpointboxes%(10)
    Dim tempx#, tempy#
    wormholesize#(1) = 30
    wormholesize#(2) = 30
    wormholesize#(3) = 30
    wormholesize#(4) = 40
    wormholesize#(5) = 40
    wormholesize#(6) = 50
    wormholesize#(7) = 50
    wormholesize#(8) = 55
    wormholesize#(9) = 55
    wormholesize#(10) = 60
    spiralsize#(1) = 35
    spiralsize#(2) = 35
    spiralsize#(3) = 40
    spiralsize#(4) = 40
    spiralsize#(5) = 50
    spiralsize#(6) = 50
    spiralsize#(7) = 55
    spiralsize#(8) = 55
    spiralsize#(9) = 60
    spiralsize#(10) = 65
    wormholes%(1) = 0
    wormholes%(2) = 0
    wormholes%(3) = 1
    wormholes%(4) = 1
    wormholes%(5) = 1
    wormholes%(6) = 2
    wormholes%(7) = 2
    wormholes%(8) = 2
    wormholes%(9) = 3
    wormholes%(10) = 3
    deathspirals%(1) = 0
    deathspirals%(2) = 2
    deathspirals%(3) = 2
    deathspirals%(4) = 3
    deathspirals%(5) = 4
    deathspirals%(6) = 4
    deathspirals%(7) = 5
    deathspirals%(8) = 6
    deathspirals%(9) = 7
    deathspirals%(10) = 8
    velocity#(1) = .25
    velocity#(2) = .25
    velocity#(3) = .35
    velocity#(4) = .35
    velocity#(5) = .35
    velocity#(6) = .45
    velocity#(7) = .45
    velocity#(8) = .45
    velocity#(9) = .55
    velocity#(10) = .65
    moneyboxes%(1) = 0
    moneyboxes%(2) = 0
    moneyboxes%(3) = 2
    moneyboxes%(4) = 2
    moneyboxes%(5) = 4
    moneyboxes%(6) = 4
    moneyboxes%(7) = 5
    moneyboxes%(8) = 7
    moneyboxes%(9) = 9
    moneyboxes%(10) = 10
    highpointboxes%(1) = 0
    highpointboxes%(2) = 1
    highpointboxes%(3) = 2
    highpointboxes%(4) = 3
    highpointboxes%(5) = 4
    highpointboxes%(6) = 5
    highpointboxes%(7) = 6
    highpointboxes%(8) = 7
    highpointboxes%(9) = 8
    highpointboxes%(10) = 10
    wormholesize#(1) = 1
    For x = 0 To wormholes%(level%) - 1
        'A single game object contains two wormholes
        tempx# = Int(Rnd * (960 - 2 * wormholesize#(level%) - 20)) + Int(wormholesize#(level%)) + 10
        tempy# = Int(Rnd * (720 - 2 * wormholesize#(level%) - 30)) + Int(wormholesize#(level%)) + 20
        While landscape(Int(tempx#), Int(tempy#)) < 0 Or landscape(Int(tempx#), Int(tempy#)) > 1
            tempx# = Int(Rnd * (960 - 2 * wormholesize#(level%) - 20)) + Int(wormholesize#(level%)) + 10
            tempy# = Int(Rnd * (720 - 2 * wormholesize#(level%) - 30)) + Int(wormholesize#(level%)) + 20
        Wend
        NewGameObject 14, tempx#, tempy#, wormholesize#(level%), Int(Rnd * 860) + 50, Int(Rnd * 20), Int(Rnd * 640) + 50
    Next x
    For x = 0 To deathspirals%(level%) - 1
        'For simplicity, angle is xvelocity, other is yvelocity, which are both doubles (both wormholes in same game object)
        tempx# = Int(Rnd * (960 - 2 * spiralsize#(level%) - 20)) + Int(spiralsize#(level%)) + 10
        tempy# = Int(Rnd * (720 - 2 * spiralsize#(level%) - 30)) + Int(spiralsize#(level%)) + 20
        While landscape(Int(tempx#), Int(tempy#)) < 0 Or landscape(Int(tempx#), Int(tempy#)) > 1
            tempx# = Int(Rnd * (960 - 2 * spiralsize#(level%) - 20)) + Int(spiralsize#(level%)) + 10
            tempy# = Int(Rnd * (720 - 2 * spiralsize#(level%) - 30)) + Int(spiralsize#(level%)) + 20
        Wend
        angle# = Rnd * 2 * _Pi
        NewGameObject 15, tempx#, tempy#, spiralsize#(level%), velocity#(level%) * Cos(angle#), Int(Rnd * 20), velocity#(level%) * Sin(angle#)
    Next x
    'populate variables not used in creator
    'For x = 0 To UBound(gameobjectarray)
    '    If gameobjectarray(x).otype = 14 Or gameobjectarray(x).otype = 15 Then
    '        gameobjectarray(x).targetlock = Int(Rnd * 20)
    '    End If
    'Next x
    For x = 1 To moneyboxes%(level%)
        moneyboxlist%(x) = Int(Rnd * 120) + 38 '179 - (x * 2 + 1)
    Next x
    For x = 1 To highpointboxes%(level%)
        highpointboxlist%(x) = Int(Rnd * 120) + 38 ' 179 - (x * 2 + 2)
    Next x
End Sub

Sub brushfill (xpos%, ypos%, size%, value%, fillpercent#)
    Dim x%, y%
    For x% = xpos% - Int(size% / 2) - 1 To xpos% + Int(size% / 2) + 1 Step 1
        For y% = ypos% - Int(size% / 2) - 1 To ypos% + Int(size% / 2) + 1 Step 1
            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < .5 * size% And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                If Rnd < fillpercent# Then
                    landscape(x%, y%) = value%
                    If value% = 2 Then
                        landscapehealth(x%, y%) = 12
                    ElseIf value% = 4 Then
                        landscapehealth(x%, y%) = 48
                    Else
                        landscapehealth(x%, y%) = 0
                    End If
                End If
            End If
        Next y%
    Next x%

End Sub

Sub brushfillweapon (xpos%, ypos%, size%, value%, cost%)
    Dim x%, y%, tempcost%
    For x% = xpos% - Int(size% / 2) - 1 To xpos% + Int(size% / 2) + 1 Step 1
        For y% = ypos% - Int(size% / 2) - 1 To ypos% + Int(size% / 2) + 1 Step 1
            If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < .5 * size% And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                If landscape(x%, y%) <> value% Then
                    tempcost% = tempcost% + 1
                End If
            End If
        Next y%
    Next x%
    If money% > Int(CDbl(tempcost%) / 57 * cost%) Then
        For x% = xpos% - Int(size% / 2) - 1 To xpos% + Int(size% / 2) + 1 Step 1
            For y% = ypos% - Int(size% / 2) - 1 To ypos% + Int(size% / 2) + 1 Step 1
                If Sqr((x% - xpos%) ^ 2 + (y% - ypos%) ^ 2) < .5 * size% And x% > 0 And y% > 0 And x% < 960 And y% < 720 Then
                    landscape(x%, y%) = value%
                    If value% = 2 Then
                        landscapehealth(x%, y%) = 12
                    ElseIf value% = 4 Then
                        landscapehealth(x%, y%) = 72
                    Else
                        landscapehealth(x%, y%) = 0
                    End If
                End If
            Next y%
        Next x%
        money% = money% - Int(CDbl(tempcost%) / 57 * cost%)
    End If

End Sub

Sub instructions
    Cls
    '16 pixels per row, 8 per character
    Color _RGB(0, 188, 0)
    Locate 1, 30
    Print "BOX BASH"
    Color _RGB(255, 255, 255)
    Print "The object of this game is to get the falling squares into"
    Print "the exit location, which is this color:"
    Line (320, 33)-(350, 45), _RGB(0, 180, 0), BF
    Print ""
    Print "To do this you can use various tools to push, pull"
    Print "or create obstacles to guide your boxes to their goal"
    Print "The number you get in before the time runs out determines your score."
    Print ""
    Print "Each tool has a cost associated to it, without money you cannot"
    Print "use that tool. You acrue money over time, but also get a 100 credit bonus"
    Print "when a box gets into the exit."
    Print ""
    Print "Boxes have a limited life. They also are not indestructible"
    Print "Hard hits will reduce their life. Their life will also timeout"
    Print "Regardless of damage. As a box nears death its inner color will darken"
    Print "from white to red. Imediately before expiration a red X will "
    Print "appear inside the box:"
    Print ""
    Print "The off-white and light blue environment blocks are also destructible."
    Print "Only blue blocks are indestructible."
    Line (190, 258)-(220, 288), _RGB(255, 0, 0), B
    Line (192, 260)-(218, 286), _RGB(255, 0, 0), B
    Line (190, 258)-(220, 288), _RGB(255, 0, 0)
    Line (190, 288)-(220, 258), _RGB(255, 0, 0)
    _Display
    Sleep
    Cls
    Color _RGB(0, 188, 0)
    Print "                                 SCORING"
    Color _RGB(255, 255, 255)
    Print "To advance to the next level you must have a positive score"
    Print "The player is awarded 100 points for a box that reaches the exit"
    Print "All boxes that do not make it to the exit before the timer expires"
    Print "will be counted as lost. The player is punished with -24 points"
    Print "for each box that does not make it into an exit."
    Color _RGB(255, 10, 10)
    Print "This means that during a round you need to save at least 10 boxes."
    Color _RGB(255, 255, 255)
    Print "The BOXES DESTROYED counter during gameplay only serves as a status"
    Print "update and not a final count."
    Print ""
    Print "In the base levels the exit is always a rectangle at the bottom"
    Print "In the level editor, you can create levels with multiple exits"
    Print "of different shapes and sizes."

    _Display
    Sleep
    Cls
    Color _RGB(0, 188, 0)
    Locate 1, 30
    Print "CONTROLS"
    Color _RGB(255, 255, 255)
    Print "Mouse: pan and zoom (mouse wheel)"
    Print "Left click: use tool"
    Print "Right click: change tool"
    Print "Advance tool (keyboard): " + adv$
    Print "Previous tool (keyboard): " + prev$
    Print "Zoom in slightly: ."
    Print "Zoom out slightly: ,"
    Print "Reset zoom: /"
    Print "Pan slightly: arrow keys"
    Print "Skip level (cheat): R"
    Print ""
    Print "If you beat the game you come to a screen with falling boxes"
    Print "You click and drag to select these boxes, then right click"
    Print "To boost them towards your mouse cursor."
    Print "No objective here, but you can play around with it."
    _Display
    Sleep
    Cls
    Color _RGB(0, 188, 0)
    Locate 1, 30
    Print "TOOLS\WEAPONS"
    Color _RGB(255, 255, 255)
    Print "KEY   COST  FUNCTION"
    Print "1    " + Str$(costarray%(2))
    Locate 3, 13
    Print "DRAW SEMI-DURABLE CLOUDS, COST IS PER PIXEL"
    Locate 4, 1
    Print "2    " + Str$(costarray%(3))
    Locate 4, 13
    Print "ERASER, COST IS PER PIXEL"
    Locate 5, 1
    Print "3    " + Str$(costarray%(4))
    Locate 5, 13
    Print "PUSHES BOXES AWAY FROM THE REGION"
    Locate 6, 1
    Print "4    " + Str$(costarray%(5))
    Locate 6, 13
    Print "PULLS BOXES INTO THE REGION"
    Locate 7, 1
    Print "5    " + Str$(costarray%(6))
    Locate 7, 13
    Print "PULLS BOXES INTO THE REGION, AND GROWS IN SIZE"
    Locate 8, 1
    Print "6    " + Str$(costarray%(7))
    Locate 8, 13
    Print "BUILDS AN INDESTRUCTABLE BOX THAT OTHER BOXES BOUND OFF OF"
    Locate 9, 1
    Print "7    " + Str$(costarray%(8))
    Locate 9, 13
    Print "SMALL BOMB"
    Locate 10, 1
    Print "8    " + Str$(costarray%(9))
    Locate 10, 13
    Print "LARGE BOMB"
    Locate 11, 1
    Print "9    " + Str$(costarray%(10))
    Locate 11, 13
    Print "PLACES A FORCE WALL. Draw an arrow to guide the wall's path"
    Locate 12, 1
    Print "10   " + Str$(costarray%(11))
    Locate 12, 13
    Print "FIRES A SALVO OF 3 ROCKETS.  Draw an arrow to direct them"
    Locate 13, 1
    Print "-    " + Str$(costarray%(12))
    Locate 13, 13
    Print "FIRES A GUIDED MISSILE. WILL TARGET A NEARBY BOX."
    Locate 14, 13
    Print "COLLISION IS NOT GUARANTEED"
    _Display
    Sleep
    Cls
    'Sleep
    Dim drawpoints#(16, 2)
    Dim xpos#, ypos#, radius#
    gametimer# = Timer(.0001)
    Do: K$ = InKey$: Loop Until K$ = ""
    While inputchar$ = ""
        inputchar$ = InKey$
        gametimer# = Timer(.001)
        Cls
        'WRITE TEXT
        Color _RGB(0, 188, 0)
        Print "                  TYPES OF BOXES"
        Color _RGB(255, 255, 255)
        Print "      Green boxes are a 300 point penalty if they enter an exit"
        Print "      But they give you 600 credits if you destroy them"
        Print "      Green boxes are not affected by laser grids"
        Print "      Purple boxes are extra fragile, but count as 5 boxes if they reach an"
        Print "      exit, and they are worth double the credits also"
        Print "      They do not count against you if they don't reach the exit"
        Color _RGB(0, 188, 0)
        Print ""
        Print "                  OTHER GAME ELEMENTS"
        Color _RGB(255, 255, 255)
        Print "Starting in level 2 the following game elements will start to appear"
        Print "         LASER GRID.  If a box enters a laser grid it will loose health"
        Print "         very quickly!"
        Print ""
        Print ""
        Print "         WORMHOLE.  One will suck boxes in.  If a box gets sucked in, it will"
        Print "         exit through the other one"
        'DRAW DEATH LASER GRID
        xpos# = 40
        ypos# = 185
        radius# = 25
        Circle (xpos#, ypos#), (radius# - .25), _RGB(100, 100, 100)
        Circle (xpos#, ypos#), (radius#), _RGB(100, 100, 100)
        Circle (xpos#, ypos#), (radius# - .5), _RGB(100, 100, 100)
        Circle (xpos#, ypos#), (radius# - .75), _RGB(100, 100, 100)
        If Int(gametimer# * 2) Mod 2 <> 1 Then
            Circle (xpos#, ypos#), (radius# + .25), _RGB(255, 1, 1)
        End If
        temp# = (((gametimer#) * 18) Mod 180) / 180
        drawpoints#(1, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + .722 + Rnd * .05))
        drawpoints#(1, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + .722 + Rnd * .05))
        drawpoints#(2, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - .722 + Rnd * .05))
        drawpoints#(2, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - .722 + Rnd * .05))
        drawpoints#(3, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 1.047 + Rnd * .05))
        drawpoints#(3, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 1.047 + Rnd * .05))
        drawpoints#(4, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 1.047 + Rnd * .05))
        drawpoints#(4, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 1.047 + Rnd * .05))
        drawpoints#(5, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 1.318 + Rnd * .05))
        drawpoints#(5, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 1.318 + Rnd * .05))
        drawpoints#(6, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 1.318 + Rnd * .05))
        drawpoints#(6, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 1.318 + Rnd * .05))
        drawpoints#(7, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 1.571 + Rnd * .05))
        drawpoints#(7, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 1.571 + Rnd * .05))
        drawpoints#(8, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 1.571 + Rnd * .05))
        drawpoints#(8, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 1.571 + Rnd * .05))
        drawpoints#(9, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 1.823 + Rnd * .05))
        drawpoints#(9, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 1.823 + Rnd * .05))
        drawpoints#(10, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 1.823 + Rnd * .05))
        drawpoints#(10, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 1.823 + Rnd * .05))
        drawpoints#(11, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 2.094 + Rnd * .05))
        drawpoints#(11, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 2.094 + Rnd * .05))
        drawpoints#(12, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 2.094 + Rnd * .05))
        drawpoints#(12, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 2.094 + Rnd * .05))
        drawpoints#(13, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + 2.419 + Rnd * .05))
        drawpoints#(13, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + 2.419 + Rnd * .05))
        drawpoints#(14, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - 2.419 + Rnd * .05))
        drawpoints#(14, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - 2.419 + Rnd * .05))
        If Int((gametimer#) * 6) Mod 6 <> 1 Then
            Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(13, 1), drawpoints#(13, 2))-(drawpoints#(14, 1), drawpoints#(14, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(255, 0, 0)
            Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(255, 0, 0)
        End If
        'DRAW WORMHOLE
        'Wormhole 1 IN
        xpos# = 40
        ypos# = 240
        radius# = 25

        temp# = (((gametimer#) * 36) Mod 180) / 180
        drawpoints#(1, 1) = (xpos# + 10 * Cos(2 * _Pi * temp#))
        drawpoints#(1, 2) = (ypos# + 10 * Sin(2 * _Pi * temp#))
        drawpoints#(2, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#)))
        drawpoints#(2, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#)))
        drawpoints#(3, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# - 1.047))
        drawpoints#(3, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# - 1.047))
        drawpoints#(4, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#) - 1.047))
        drawpoints#(4, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#) - 1.047))
        drawpoints#(5, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# - 2.094))
        drawpoints#(5, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# - 2.094))
        drawpoints#(6, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#) - 2.094))
        drawpoints#(6, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#) - 2.094))
        drawpoints#(7, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# - _Pi))
        drawpoints#(7, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# - _Pi))
        drawpoints#(8, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#) - _Pi))
        drawpoints#(8, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#) - _Pi))
        drawpoints#(9, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# - 4.189))
        drawpoints#(9, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# - 4.189))
        drawpoints#(10, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#) - 4.189))
        drawpoints#(10, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#) - 4.189))
        drawpoints#(11, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# - 5.236))
        drawpoints#(11, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# - 5.236))
        drawpoints#(12, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# - _Acos(10 / radius#) - 5.236))
        drawpoints#(12, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# - _Acos(10 / radius#) - 5.236))
        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Circle (xpos#, ypos#), radius#, _RGB(255, 250, 12)
        Circle (xpos#, ypos#), 10, _RGB(255, 250, 12)
        Circle (xpos#, ypos#), radius# * (1 - ((gametimer# + time) * 100 Mod 100) / 100), _RGB(255, 255, 255)
        'Wormhole 2 OUT
        xpos# = 40
        ypos# = 295
        radius# = 25

        temp# = 1 - (((gametimer#) * 36) Mod 180) / 180
        drawpoints#(1, 1) = (xpos# + 10 * Cos(2 * _Pi * temp#))
        drawpoints#(1, 2) = (ypos# + 10 * Sin(2 * _Pi * temp#))
        drawpoints#(2, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#)))
        drawpoints#(2, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#)))
        drawpoints#(3, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# + 1.047))
        drawpoints#(3, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# + 1.047))
        drawpoints#(4, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#) + 1.047))
        drawpoints#(4, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#) + 1.047))
        drawpoints#(5, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# + 2.094))
        drawpoints#(5, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# + 2.094))
        drawpoints#(6, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#) + 2.094))
        drawpoints#(6, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#) + 2.094))
        drawpoints#(7, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# + _Pi))
        drawpoints#(7, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# + _Pi))
        drawpoints#(8, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#) + _Pi))
        drawpoints#(8, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#) + _Pi))
        drawpoints#(9, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# + 4.189))
        drawpoints#(9, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# + 4.189))
        drawpoints#(10, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#) + 4.189))
        drawpoints#(10, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#) + 4.189))
        drawpoints#(11, 1) = (xpos# + 10 * Cos(2 * _Pi * temp# + 5.236))
        drawpoints#(11, 2) = (ypos# + 10 * Sin(2 * _Pi * temp# + 5.236))
        drawpoints#(12, 1) = (xpos# + radius# * Cos(2 * _Pi * temp# + _Acos(10 / radius#) + 5.236))
        drawpoints#(12, 2) = (ypos# + radius# * Sin(2 * _Pi * temp# + _Acos(10 / radius#) + 5.236))
        Line (drawpoints#(1, 1), drawpoints#(1, 2))-(drawpoints#(2, 1), drawpoints#(2, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(3, 1), drawpoints#(3, 2))-(drawpoints#(4, 1), drawpoints#(4, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(5, 1), drawpoints#(5, 2))-(drawpoints#(6, 1), drawpoints#(6, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(7, 1), drawpoints#(7, 2))-(drawpoints#(8, 1), drawpoints#(8, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(9, 1), drawpoints#(9, 2))-(drawpoints#(10, 1), drawpoints#(10, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Line (drawpoints#(11, 1), drawpoints#(11, 2))-(drawpoints#(12, 1), drawpoints#(12, 2)), _RGB(100, 100 + Int(Rnd * 150), 150 + Int(Rnd * 100))
        Circle (xpos#, ypos#), radius#, _RGB(255, 250, 12)
        Circle (xpos#, ypos#), 10, _RGB(255, 250, 12)
        Circle (xpos#, ypos#), radius# * (((gametimer# + time) * 100 Mod 100) / 100), _RGB(255, 255, 255)

        'Green Box
        Line (5, 17)-(5 + 24, 17 + 24), _RGB(0, 200, 0), B
        Line (7, 19)-(7 + 20, 19 + 20), _RGB(0, 200, 0), B
        'Purple Box
        Line (5, 65)-(5 + 24, 65 + 24), _RGB(128, 0, 200), B
        Line (7, 67)-(7 + 20, 67 + 20), _RGB(128, 0, 200), B
        _Display
    Wend
    Cls
End Sub

Sub menuoptions
    Dim menulocation%
    Dim temp#
    Dim temp$
    menulocation% = 3
    While inputchar$ <> Chr$(27)
        inputchar$ = InKey$
        If UCase$(inputchar$) = "M" Then menuoptions
        gametimer# = Timer(.0001)
        If inputchar$ = Chr$(0) + Chr$(72) Then menulocation% = menulocation% - 1
        If inputchar$ = Chr$(0) + Chr$(80) Then menulocation% = menulocation% + 1
        If menulocation% < 3 Then menulocation% = 3
        If menulocation% > 20 Then menulocation% = 20
        If inputchar$ = Chr$(13) Then 'User hits ENTER
            Select Case menulocation%
                Case 3
                    Cls
                    Print "Lowering this number improves performance, but reduces accuracy"
                    Input "NEW PHYSICS FREQUENCY: ", physicslimit#
                Case 4
                    If boxonboxsound% = 1 Then
                        boxonboxsound% = 0
                    Else
                        boxonboxsound% = 1
                    End If
                Case 5
                    If boxonenvironsound% = 1 Then
                        boxonenvironsound% = 0
                    Else
                        boxonenvironsound% = 1
                    End If
                Case 6
                    If gameobjectsound% = 1 Then
                        gameobjectsound% = 0
                    Else
                        gameobjectsound% = 1
                    End If
                Case 7
                    Cls
                    Print "Below this velocity, collisions will be silent"
                    Input "NEW CUTOFF FREQUENCY: ", cutoffvelocity#
                Case 8
                    Cls
                    Print "After this much time, boxes will die, regardless of remaining hit points"
                    Input "BOX DECAY TIME: ", temp#
                    decayrate# = 100 / temp#
                Case 9
                    Cls
                    Print "How many hit points boxes start out with"
                    Input "HIT POINTS: ", boxhitpoint#
                Case 10
                    If displayfps` = -1 Then
                        displayfps` = 0
                    Else
                        displayfps` = -1
                    End If
                Case 11
                    Cls
                    Print "Select key to advance the tool"
                    Print "Non-alpha characters will not display correctly in menu"
                    Print "(Right clicking also does this)"
                    Print "Selection: "
                    _Display
                    adv$ = ""
                    While adv$ = ""
                        adv$ = InKey$
                    Wend
                    adv$ = UCase$(adv$)
                Case 12
                    Cls
                    Print "Select key to return to the previous tool"
                    Print "Non-alpha characters will not display correctly in menu"
                    Print "Selection: "
                    _Display
                    prev$ = ""
                    While prev$ = ""
                        prev$ = InKey$
                    Wend
                    prev$ = UCase$(prev$)
                Case 13
                    Cls
                    Print "How much money is added every 1/2 second:"
                    Input "Money Rate: ", moneyrate%
                Case 14
                    Cls
                    Color _RGB(0, 255, 0)
                    Print " Instructions:"
                    Color _RGB(255, 255, 255)
                    Print "HIT S TO SAVE"
                    Print "HIT L TO LOAD"
                    Print "HIT O FOR OPTIONS"
                    Print "RIGHT CLICK TO CHANGE TOOL, LEFT CLICK TO USE IT"
                    Input "Add Stary background (y/n): ", temp$
                    For x = 1 To 959
                        For y = 1 To 719
                            landscape(x, y) = 0
                        Next y
                    Next x
                    If UCase$(temp$) = "Y" Then
                        For x = 1 To 3000
                            downint% = Int(Rnd * 960) + 1
                            acrossint% = Int(Rnd * 720) + 1
                            landscape(downint%, acrossint%) = 1
                        Next x
                    End If
                    For x = 0 To 720
                        landscape(0, x) = 3
                        landscape(960, x) = 3
                    Next x
                    For x = 0 To 960
                        landscape(x, 0) = 3
                        landscape(x, 720) = 3
                    Next x
                    Paintmap
                    temp# = 0
                    For x = 1 To 959
                        For y = 1 To 719
                            If landscape(x, y) = -1 Then temp# = 1
                        Next y
                    Next x
                    Cls
                    If temp# = 0 Then
                        Print "No exit was detected."
                        Input "Would you like to add the default exit? (y/n): ", temp$
                        If UCase$(temp$) = "Y" Then
                            'Make Door
                            For x = 446 To 514
                                For y = 675 To 719
                                    If x < 450 Or x > 510 Or y < 680 Then
                                        landscape(x, y) = -2
                                        landscapehealth(x, y) = 0
                                    Else
                                        landscape(x, y) = -1
                                        landscapehealth(x, y) = 0
                                    End If
                                Next y
                            Next x
                        End If
                    End If
                    Print ""
                    Input "Would you like to save? (y/n): ", temp$
                    If UCase$(temp$) = "Y" Then Savefile
                    'CHECK FOR EXIT SQUARES
                Case 15
                    Loadfile
                Case 16
                    instructions
                    While InKey$ <> ""
                        'InKey$ = ""
                    Wend
                Case 17
                    Locate 16, 16
                    SaveSettings
                    Print "SAVED"
                    _Display
                    Sleep 4
                Case 18
                    Locate 17, 17
                    physicslimit# = 180
                    boxonboxsound% = 1
                    boxonenvironsound% = 1
                    gameobjectsound% = 1
                    cutoffvelocity# = 15
                    decayrate# = 2.5
                    boxhitpoint# = 100
                    displayfps` = 0
                    adv$ = "F"
                    prev$ = "D"
                    moneyrate% = 3
                    Print "RESET"
                    _Display
                    Sleep 4
                Case 20
                    inputchar$ = Chr$(27)
            End Select
        End If
        Cls
        Locate menulocation%, 1
        Color _RGB(194, 72, 122)
        Print ">"
        Color _RGB(255, 255, 255)
        Locate 1, 38
        Color _RGB(0, 188, 0)
        Print "MENU "
        Locate 2, 1 'Locate to the TOP again after the cursor to prevent the screen from scrolling.  22 line max.  22 useable due to scrolling issues still messing things up
        Color _RGB(255, 255, 255)
        Color _RGB(245, 245, 245)
        Print "Use the arrow keys to navigate, ENTER to select"
        Locate 3, 2
        Print "PHYSICS FREQUENCY: " + Str$(physicslimit#)
        Locate 4, 2
        Print "BOX ON BOX SOUNDS: " '
        Locate 4, 21
        If boxonboxsound% = 1 Then
            Print "ON"
        Else
            Print "OFF"
        End If
        Locate 5, 2
        Print "BOX ON ENVIRONMENT SOUNDS: " '
        Locate 5, 29
        If boxonenvironsound% = 1 Then
            Print "ON"
        Else
            Print "OFF"
        End If
        Locate 6, 2
        Print "OTHER SOUNDS: " '
        Locate 6, 16
        If gameobjectsound% = 1 Then
            Print "ON"
        Else
            Print "OFF"
        End If
        Locate 7, 2
        Print "Sound threshold velocity: " + Str$(cutoffvelocity#)
        Locate 8, 2
        Print "Box Decay Time: " + Str$(100 / decayrate#) 'be sure to update associated graphics cutoffs as well (dependent variables)
        Locate 9, 2
        Print "Starting Standard Box Hit Points: " + Str$(boxhitpoint#)
        Locate 10, 2
        Print "Display Framerate: " 'display ON or OFF  displayfps`
        Locate 10, 21
        If displayfps` = -1 Then
            Print "ON"
        Else
            Print "OFF"
        End If
        Locate 11, 2
        Print "Advance Weapon Button: " + adv$
        Locate 12, 2
        Print "Previous Weapon Button: " + prev$
        Locate 13, 2
        Print "Money Growth Rate: " + Str$(moneyrate%)
        Locate 14, 2
        Print "Map Editor"
        Locate 15, 2
        Print "LOAD custom map"
        Locate 16, 2
        Print "Instructions"
        Locate 17, 2
        Print "Save Settings"
        Locate 18, 2
        Print "Reset Settings"
        Locate 20, 2
        Print "Exit Menu & PLAY GAME!"
        _Limit 30
        _Display
    Wend
End Sub

Sub victory
    Cls
    'Assume all collisions happen one at a time to keep things simple
    Play "MBW3O3L8CDL8EGR32FL2GR8O4L8CDL8EGR32FL2G"
    Dim inputchar$, gametimer#, scoretimer#, physfreq#, phystimer#, tempangle#, tempangle2#, cornerx#, cornery#, topx#, topy#, bottomx#, bottomy#, leftx#, lefty#, rightx#, righty#, forceangle#, forceangle2#
    Dim rotperc#, forcemag#, maxrotperc#, centerweight#
    Dim outerred%, outergreen%, outerblue%, boxcount%, r%, g%, b%, flagdown%
    Dim boxenergy#, maxdist#, dist#, correction#, xspot#, yspot#, angle1#, angle2#, angle3#, dist1#, dist2#, dist3#, tvx#, tvy#, faceangle#
    Dim drawpoints#(4, 2)
    Dim forceconst#, newgravity#
    Dim select1x%, select1y%, select2x%, select2y%, selectRx%, selectRy%, selecting`, selectingR`, tempint%, carryoverx#(101), carryovery#(101)
    newgravity# = 9.8 * 2
    maxrotperc# = 0.20
    centerweight# = 0.0
    forceconst# = 400000
    Randomize Timer
    gametimer# = Timer(.0001)
    scoretimer# = gametimer# + 300
    physfreq# = 180
    flagdown% = 0
    Dim fallingboxes(101) As physicsobj
    Cls
    Do: K$ = InKey$: Loop Until K$ = ""
    phystimer# = Timer(.0001)

    While inputchar$ = "" And scoretimer# - gametimer# > 0
        inputchar$ = InKey$
        If Int(gametimer#) Mod 2 = 0 And flagdown% = 0 And boxcount% < 100 Then 'every 2 seconds   'Int(gametimer#) Mod 2 = 0 And
            fallingboxes(boxcount%).otype = 1
            fallingboxes(boxcount%).xpos = Rnd * 600 + 20 '320 'Rnd * 600 + 20
            fallingboxes(boxcount%).ypos = 16
            fallingboxes(boxcount%).size = 15
            fallingboxes(boxcount%).mass = 100
            fallingboxes(boxcount%).rotInert = (100 * 15 ^ 2 / 6) '* 10 'I  mass*size^2/6
            fallingboxes(boxcount%).xvel = Rnd * 20 - 10
            fallingboxes(boxcount%).yvel = Rnd * 20 - 10 '3
            fallingboxes(boxcount%).xacc = 0
            fallingboxes(boxcount%).yacc = 0
            fallingboxes(boxcount%).angle = 0
            fallingboxes(boxcount%).anglevel = Rnd * 3 - 1.5
            fallingboxes(boxcount%).angleaccel = 0
            r% = Int(Rnd * 255)
            g% = Int(Rnd * 255)
            b% = Int(Rnd * 255)
            While r% + g% + b% < 127
                r% = Int(Rnd * 255)
                g% = Int(Rnd * 255)
                b% = Int(Rnd * 255)
            Wend
            fallingboxes(boxcount%).environ = r% 'red color
            fallingboxes(boxcount%).touching = g% 'green color
            fallingboxes(boxcount%).healthtime = b% 'blue color
            fallingboxes(boxcount%).forcereturn = fallingboxes(boxcount%).mass * newgravity# * (400 - fallingboxes(boxcount%).ypos) 'potential energy
            fallingboxes(boxcount%).forcereturn = fallingboxes(boxcount%).forcereturn + 0.5 * fallingboxes(boxcount%).mass * (fallingboxes(boxcount%).xvel ^ 2 + fallingboxes(boxcount%).yvel ^ 2) 'translational energy
            fallingboxes(boxcount%).forcereturn = fallingboxes(boxcount%).forcereturn + 0.5 * fallingboxes(boxcount%).rotInert * fallingboxes(boxcount%).anglevel ^ 2 'rotational energy
            fallingboxes(boxcount%).damping = 0 ' 0 is keep energy limit, 1 is limited reset, 2 is less limited reset
            fallingboxes(boxcount%).friction = 0 ' 0 is not selected, 1 is selected
            boxcount% = boxcount% + 1
            flagdown% = 1
        End If
        If Int(gametimer#) Mod 2 = 1 Then
            flagdown% = 0 ' change back to 0, 1 stops new boxes after the first for troubleshooting
        End If

        'I/O
        If _MouseInput Then
            mousewheelvalue% = _MouseWheel
            mousexpos% = mousexpos% + _MouseMovementX
            mouseypos% = mouseypos% + _MouseMovementY
        End If

        If mousexpos% < 1 Then mousexpos% = 1
        If mousexpos% > 640 Then mousexpos% = 640
        If mouseypos% < 1 Then mouseypos% = 1
        If mouseypos% > 360 Then mouseypos% = 360

        If _MouseButton(1) And clickdown` = 0 Then 'MOUSE CLICKED DOWN
            select1x% = mousexpos%
            select1y% = mouseypos%
            clickdown` = -1
            selecting` = -1
        End If

        If _MouseButton(1) And clickdown` = -1 Then 'MOUSE STILL DOWN
            select2x% = mousexpos%
            select2y% = mouseypos%
            selecting` = -1
        End If

        If _MouseButton(1) = 0 And clickdown` = -1 Then 'mouse button unclicked
            clickdown` = 0
            select2x% = mousexpos%
            select2y% = mouseypos%
            selecting` = 0
            'Find lower upper selection limits
            If select1x% > select2x% Then
                tempint% = select1x%
                select1x% = select2x%
                select2x% = tempint%
            End If
            If select1y% > select2y% Then
                tempint% = select1y%
                select1y% = select2y%
                select2y% = tempint%
            End If
            'Mark selected boxes
            For i% = 0 To 100 'Reset accelerations
                If fallingboxes(i%).xpos > select1x% And fallingboxes(i%).xpos < select2x% And fallingboxes(i%).ypos > select1y% And fallingboxes(i%).ypos < select2y% Then fallingboxes(i%).friction = 1
            Next i%
        End If
        If _MouseButton(2) And clickdownR` = 0 Then 'R MOUSE CLICKED DOWN
            selectRx% = mousexpos%
            selectRy% = mouseypos%
            clickdownR` = -1
            selectingR` = -1
        End If
        If _MouseButton(2) And clickdownR` = -1 Then 'R MOUSE STILL DOWN
            selectRx% = mousexpos%
            selectRy% = mouseypos%
            selectingR` = -1
        End If
        If _MouseButton(2) = 0 And clickdownR` = -1 Then 'mouse button unclicked
            clickdownR` = 0
            selectRx% = mousexpos%
            selectRy% = mouseypos%
            selectingR` = 0
            '  Unselect all boxes and Apply Force to selected boxes
            For i% = 0 To 100 'Reset accelerations
                If fallingboxes(i%).friction = 1 Then
                    carryovery#(i%) = fallingboxes(i%).yacc + 500000 * Sin(_Atan2(selectRy% - fallingboxes(i%).ypos, selectRx% - fallingboxes(i%).xpos))
                    carryoverx#(i%) = fallingboxes(i%).xacc + 500000 * Cos(_Atan2(selectRy% - fallingboxes(i%).ypos, selectRx% - fallingboxes(i%).xpos))
                    'fallingboxes(i%).friction = 0
                End If
            Next i%
        End If

        Do While _MouseInput 'Clear Mouse Buffer
        Loop


        'PHYSICS LOOP
        gametimer# = Timer(.0001)
        While phystimer# < gametimer#
            'DO STUFF
            'Gravity acceleration
            For i% = 0 To 100 'Reset accelerations
                If fallingboxes(i%).otype = 1 Then
                    fallingboxes(i%).yacc = newgravity#
                    fallingboxes(i%).xacc = 0
                    fallingboxes(i%).angleaccel = 0
                    If fallingboxes(i%).friction = 1 And (carryoverx#(i%) <> 0 Or carryovery#(i%) <> 0) Then
                        fallingboxes(i%).yacc = fallingboxes(i%).yacc + carryovery#(i%)
                        fallingboxes(i%).xacc = carryoverx#(i%)
                        fallingboxes(i%).friction = 0 'unselects
                        fallingboxes(i%).damping = 2 'resets energy limit
                        carryovery#(i%) = 0
                        carryoverx#(i%) = 0
                    End If
                End If
            Next i%


            'Ground and Wall collisions
            For i% = 0 To 100
                If fallingboxes(i%).otype = 1 Then 'object must be the right type, and have positive health
                    'Ground collision
                    If Abs(fallingboxes(i%).angle) / (_Pi / 2) - Int(Abs(fallingboxes(i%).angle) / (_Pi / 2)) < .01 Then 'within ~0.5 degrees
                        If fallingboxes(i%).ypos + fallingboxes(i%).size / 2 > 359 Then
                            fallingboxes(i%).yacc = -(fallingboxes(i%).ypos + fallingboxes(i%).size / 2 - 359) * forceconst#
                        End If
                        If fallingboxes(i%).ypos - fallingboxes(i%).size / 2 < 1 Then
                            fallingboxes(i%).yacc = -(fallingboxes(i%).ypos - fallingboxes(i%).size / 2 - 1) * forceconst#
                        End If
                        If fallingboxes(i%).xpos - fallingboxes(i%).size / 2 < 1 Then
                            fallingboxes(i%).xacc = -(fallingboxes(i%).xpos - fallingboxes(i%).size / 2 - 1) * forceconst#
                        End If
                        If fallingboxes(i%).xpos + fallingboxes(i%).size / 2 > 639 Then
                            fallingboxes(i%).xacc = -(fallingboxes(i%).xpos + fallingboxes(i%).size / 2 - 639) * forceconst#
                        End If
                    Else
                        fixangle fallingboxes(i%).angle ' to keep things clean
                        topx# = fallingboxes(i%).xpos
                        topy# = fallingboxes(i%).ypos
                        bottomx# = fallingboxes(i%).xpos
                        bottomy# = fallingboxes(i%).ypos
                        leftx# = fallingboxes(i%).xpos
                        lefty# = fallingboxes(i%).ypos
                        rightx# = fallingboxes(i%).xpos
                        righty# = fallingboxes(i%).ypos
                        tempangle# = _Pi / 4
                        While tempangle# < 2.5 * _Pi
                            cornerx# = fallingboxes(i%).xpos + Cos(fallingboxes(i%).angle + tempangle#) * fallingboxes(i%).size * Sqr(2) / 2
                            cornery# = fallingboxes(i%).ypos + Sin(fallingboxes(i%).angle + tempangle#) * fallingboxes(i%).size * Sqr(2) / 2
                            If cornery# < topy# Then
                                topy# = cornery#
                                topx# = cornerx#
                            End If
                            If cornery# > bottomy# Then
                                bottomy# = cornery#
                                bottomx# = cornerx#
                            End If
                            If cornerx# < leftx# Then
                                leftx# = cornerx#
                                lefty# = cornery#
                            End If
                            If cornerx# > rightx# Then
                                rightx# = cornerx#
                                righty# = cornery#
                            End If
                            tempangle# = tempangle# + _Pi / 2
                        Wend
                        If bottomy# > 359 Then 'Bottom of the screen
                            tempangle# = _Atan2(bottomy# - fallingboxes(i%).ypos, bottomx# - fallingboxes(i%).xpos) ' tempangle to be angle to collision point from box center
                            If fallingboxes(i%).anglevel <> 0 And Abs((fallingboxes(i%).angle) / (_Pi / 2) - _Round((fallingboxes(i%).angle) / (_Pi / 2))) > .08 Then ' reaction angle to corner point velocity
                                tempangle2# = tempangle# - fallingboxes(i%).anglevel / Abs(fallingboxes(i%).anglevel) * _Pi / 2
                            Else
                                tempangle2# = tempangle# + _Pi
                            End If
                            If Sin(tempangle2#) > 0 Then tempangle2# = 3 * _Pi / 2 'if collision point is moving away from collision surface, then don't use the reaction angle, use the surface vector instead
                            'in this case this criteria is derived from the angelvel, since this can be simplified for the bottom floor
                            'Dot product not needed here because we can check with cardinal directions
                            If fallingboxes(i%).yvel > 0 Then 'if object is moving towards the bottom floor
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel) + _Pi, tempangle2#) 'average of reaction to object velocity vector and reaction angle to collision point
                            Else
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel), tempangle2#) 'average of object vector and reaction to object velocity vector
                            End If
                            forceangle# = avgangle(3 * _Pi / 2, forceangle2#) 'average of surface vector and previous answer
                            rotperc# = maxrotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / (fallingboxes(i%).size * Sqr(2) / 2)
                            'Acceleration = Force/Mass
                            forcemag# = (bottomy# - 359) * forceconst#
                            fallingboxes(i%).yacc = fallingboxes(i%).yacc + forcemag# * (1 - rotperc#) * Sin(forceangle#) / fallingboxes(i%).mass
                            fallingboxes(i%).xacc = fallingboxes(i%).xacc + forcemag# * (1 - rotperc#) * Cos(forceangle#) / fallingboxes(i%).mass
                            If (Cos(tempangle# + _Pi / 2) * Cos(forceangle#) + Sin(tempangle# + _Pi / 2) * Sin(forceangle#)) > 0 Then 'use dot product to determine if torque change is positive or negative
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel + forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            Else
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel - forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            End If
                        End If
                        If topy# < 1 Then 'Top of the screen
                            tempangle# = _Atan2(topy# - fallingboxes(i%).ypos, topx# - fallingboxes(i%).xpos) ' tempangle to be angle to collision point from box center
                            If fallingboxes(i%).anglevel <> 0 And Abs((fallingboxes(i%).angle) / (_Pi / 2) - _Round((fallingboxes(i%).angle) / (_Pi / 2))) > .08 Then ' reaction angle to corner point velocity
                                tempangle2# = tempangle# - fallingboxes(i%).anglevel / Abs(fallingboxes(i%).anglevel) * _Pi / 2
                            Else
                                tempangle2# = tempangle# + _Pi
                            End If
                            If Sin(tempangle2#) < 0 Then tempangle2# = _Pi / 2 'if collision point is moving away from collision surface, then don't use the reaction angle, use the surface vector instead
                            '    in this case this criteria is derived from the angelvel, since this can be simplified for the top floor
                            '        Dot product not needed here because we can check with cardinal directions
                            If fallingboxes(i%).yvel < 0 Then 'if object is moving towards the top
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel) + _Pi, tempangle2#) 'average of object vector and reaction to object velocity vector
                            Else
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel), tempangle2#) 'average of object vector and reaction to object velocity vector
                            End If
                            forceangle# = avgangle(_Pi / 2, forceangle2#) 'average of surface vector and previous answer
                            rotperc# = maxrotperc# * perpvector(topx#, topy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / (fallingboxes(i%).size * Sqr(2) / 2)
                            'rotperc# = rotperc# ^ 2
                            'Acceleration = Force / Mass
                            forcemag# = (1 - topy#) * forceconst#
                            fallingboxes(i%).yacc = fallingboxes(i%).yacc + forcemag# * (1 - rotperc#) * Sin(forceangle#) / fallingboxes(i%).mass
                            fallingboxes(i%).xacc = fallingboxes(i%).xacc + forcemag# * (1 - rotperc#) * Cos(forceangle#) / fallingboxes(i%).mass
                            If (Cos(tempangle# + _Pi / 2) * Cos(forceangle#) + Sin(tempangle# + _Pi / 2) * Sin(forceangle#)) > 0 Then 'use dot product to determine if torque change is positive or negative
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel + forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            Else
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel - forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            End If
                        End If
                        If rightx# > 639 Then 'Right of the screen
                            tempangle# = _Atan2(righty# - fallingboxes(i%).ypos, rightx# - fallingboxes(i%).xpos) ' tempangle to be angle to collision point from box center
                            If fallingboxes(i%).anglevel <> 0 And Abs((fallingboxes(i%).angle) / (_Pi / 2) - _Round((fallingboxes(i%).angle) / (_Pi / 2))) > .08 Then ' reaction angle to corner point velocity
                                tempangle2# = tempangle# - fallingboxes(i%).anglevel / Abs(fallingboxes(i%).anglevel) * _Pi / 2
                            Else
                                tempangle2# = tempangle# + _Pi
                            End If
                            If Cos(tempangle2#) < 0 Then tempangle2# = _Pi 'if collision point is moving away from collision surface, then don't use the reaction angle, use the surface vector instead
                            'in this case this criteria is derived from the angelvel, since this can be simplified for the right wall
                            'Dot product not needed here because we can check with cardinal directions
                            If fallingboxes(i%).xvel > 0 Then 'if object is moving towards the right wall
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).xvel, fallingboxes(i%).xvel) + _Pi, tempangle2#) 'average of object vector and reaction to object velocity vector
                            Else
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).xvel, fallingboxes(i%).xvel), tempangle2#) 'average of object vector and reaction to object velocity vector
                            End If
                            forceangle# = avgangle(_Pi, forceangle2#) 'average of surface vector and previous answer
                            rotperc# = maxrotperc# * perpvector(rightx#, righty#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / (fallingboxes(i%).size * Sqr(2) / 2)
                            'rotperc# = rotperc# ^ 2
                            'Acceleration = Force/Mass
                            forcemag# = (rightx# - 639) * forceconst#
                            fallingboxes(i%).yacc = fallingboxes(i%).yacc + forcemag# * (1 - rotperc#) * Sin(forceangle#) / fallingboxes(i%).mass
                            fallingboxes(i%).xacc = fallingboxes(i%).xacc + forcemag# * (1 - rotperc#) * Cos(forceangle#) / fallingboxes(i%).mass
                            If (Cos(tempangle# + _Pi / 2) * Cos(forceangle#) + Sin(tempangle# + _Pi / 2) * Sin(forceangle#)) > 0 Then 'use dot product to determine if torque change is positive or negative
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel + forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            Else
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel - forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            End If
                        End If
                        If leftx# < 1 Then 'Left of the screen
                            tempangle# = _Atan2(lefty# - fallingboxes(i%).ypos, leftx# - fallingboxes(i%).xpos) ' tempangle to be angle to collision point from box center
                            If fallingboxes(i%).anglevel <> 0 And Abs((fallingboxes(i%).angle) / (_Pi / 2) - _Round((fallingboxes(i%).angle) / (_Pi / 2))) > .08 Then ' reaction angle to corner point velocity
                                tempangle2# = tempangle# - fallingboxes(i%).anglevel / Abs(fallingboxes(i%).anglevel) * _Pi / 2
                            Else
                                tempangle2# = tempangle# + _Pi
                            End If
                            If Cos(tempangle2#) > 0 Then tempangle2# = 0 'if collision point is moving away from collision surface, then don't use the reaction angle, use the surface vector instead
                            '    in this case this criteria is derived from the angelvel, since this can be simplified for the top floor
                            '        Dot product not needed here because we can check with cardinal directions
                            If fallingboxes(i%).xvel < 0 Then 'if object is moving towards the left wall
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel) + _Pi, tempangle2#) 'average of object vector and reaction to object velocity vector
                            Else
                                forceangle2# = avgangle(_Atan2(fallingboxes(i%).yvel, fallingboxes(i%).xvel), tempangle2#) 'average of object vector and reaction to object velocity vector
                            End If
                            forceangle# = avgangle(0, forceangle2#) 'average of surface vector and previous answer
                            rotperc# = maxrotperc# * perpvector(leftx#, lefty#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / (fallingboxes(i%).size * Sqr(2) / 2)
                            'rotperc# = rotperc# ^ 2
                            'Acceleration = Force / Mass
                            forcemag# = (1 - leftx#) * forceconst#
                            fallingboxes(i%).yacc = fallingboxes(i%).yacc + forcemag# * (1 - rotperc#) * Sin(forceangle#) / fallingboxes(i%).mass
                            fallingboxes(i%).xacc = fallingboxes(i%).xacc + forcemag# * (1 - rotperc#) * Cos(forceangle#) / fallingboxes(i%).mass
                            fallingboxes(i%).angleaccel = forcemag# * rotperc# * perpvector(leftx#, lefty#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            If (Cos(tempangle# + _Pi / 2) * Cos(forceangle#) + Sin(tempangle# + _Pi / 2) * Sin(forceangle#)) > 0 Then 'use dot product to determine if torque change is positive or negative
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel + forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            Else
                                fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel - forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                            End If
                        End If
                    End If
                    'Box to Box collisions
                    For j% = 0 To 100
                        maxdist# = Sqr(0.5 * fallingboxes(i%).size ^ 2 + 0.5 * fallingboxes(j%).size ^ 2) + 1 '(1/2 * size * sqr(2))^2=0.5*size^2
                        dist# = Sqr((fallingboxes(i%).xpos - fallingboxes(j%).xpos) ^ 2 + (fallingboxes(i%).ypos - fallingboxes(j%).ypos) ^ 2)
                        If dist# < maxdist# And i% <> j% Then 'filter out objects not close to each other, and make sure object isn't checking against itself
                            angle1# = _Atan2(fallingboxes(i%).ypos - fallingboxes(j%).ypos, fallingboxes(i%).xpos - fallingboxes(j%).xpos) - fallingboxes(j%).angle 'from other box to this box, relative to other box
                            angle2# = _Atan2(fallingboxes(j%).ypos - fallingboxes(i%).ypos, fallingboxes(j%).xpos - fallingboxes(i%).xpos) - fallingboxes(i%).angle 'from this box to other box, relative to this box
                            dist1# = fallingboxes(j%).size / 2 * radialsquare(angle1#)
                            dist2# = fallingboxes(i%).size / 2 * radialsquare(angle2#)
                            boxcollisioncorrection2 correction#, xspot#, yspot#, fallingboxes(i%).angle, fallingboxes(j%).angle, fallingboxes(i%).size, fallingboxes(j%).size, fallingboxes(i%).xpos, fallingboxes(i%).ypos, fallingboxes(j%).xpos, fallingboxes(j%).ypos
                            'Print #1, "POSSIBLE COLLISION ", dist1#, dist2#, correction#, dist#
                            If dist# < (dist1# + dist2# + correction#) Then 'IF COLLISION
                                'Print #1, " COLLISION! "
                                angle3# = _Atan2(yspot# - fallingboxes(i%).ypos, xspot# - fallingboxes(i%).xpos) 'from this box to collision point, relative to screen
                                dist3# = Sqr((yspot# - fallingboxes(i%).ypos) ^ 2 + (xspot# - fallingboxes(i%).xpos) ^ 2) 'distance from this box to collision point
                                tvx# = fallingboxes(i%).xvel - dist3# * fallingboxes(i%).anglevel * Sin(angle3#) 'total velocity x
                                tvy# = fallingboxes(i%).yvel + dist3# * fallingboxes(i%).anglevel * Cos(angle3#) 'total velocity y
                                'Find Face Angle
                                If Abs(Abs(_Atan2(yspot# - fallingboxes(j%).ypos, xspot# - fallingboxes(j%).xpos) - fallingboxes(j%).angle - _Pi / 4) / (_Pi / 2) - _Round(Abs(_Atan2(yspot# - fallingboxes(j%).ypos, xspot# - fallingboxes(j%).xpos) - fallingboxes(j%).angle - _Pi / 4) / (_Pi / 2))) < .03 Then 'If collision point is on corner of other box
                                    'Then check this box
                                    If Abs(Abs(_Atan2(yspot# - fallingboxes(i%).ypos, xspot# - fallingboxes(i%).xpos) - fallingboxes(i%).angle - _Pi / 4) / (_Pi / 2) - _Round(Abs(_Atan2(yspot# - fallingboxes(i%).ypos, xspot# - fallingboxes(i%).xpos) - fallingboxes(i%).angle - _Pi / 4) / (_Pi / 2))) < .03 Then 'If collision point is on corner of this box
                                        'Corner of both boxes
                                        faceangle# = _Atan2(fallingboxes(i%).ypos - yspot#, fallingboxes(i%).xpos - xspot#) 'points directly to center
                                        tempangle# = _Atan2(yspot# - fallingboxes(i%).ypos, xspot# - fallingboxes(i%).xpos) 'points away from center of obj2
                                        If Cos(angle1#) * Cos(tempangle1#) + Sin(angle1#) * Sin(tempangle1#) < .707 Then 'if the dot product of the two vectors is <.707 =  ABcos(theta) = cos(theta) (since vectors length=1) so if the collision angle is less than 45 degrees...
                                            'alternate solution if the inner angle is low
                                            faceangle# = _Round((_Atan2(fallingboxes(i%).ypos - fallingboxes(j%).ypos, fallingboxes(i%).xpos - fallingboxes(j%).xpos) - fallingboxes(j%).angle) / (_Pi / 2)) * (_Pi / 2) + fallingboxes(j%).angle 'face of other box that points to center of this box
                                        End If
                                    Else
                                        'face of this box, reversed
                                        faceangle# = _Round((_Atan2(yspot# - fallingboxes(i%).ypos, xspot# - fallingboxes(i%).xpos) - fallingboxes(i%).angle) / (_Pi / 2)) * (_Pi / 2) + fallingboxes(i%).angle + _Pi 'face of this box, reversed
                                    End If
                                Else
                                    'face of other box
                                    faceangle# = _Round((_Atan2(yspot# - fallingboxes(j%).ypos, xspot# - fallingboxes(j%).xpos) - fallingboxes(j%).angle) / (_Pi / 2)) * (_Pi / 2) + fallingboxes(j%).angle 'face angle of the box that is being hit
                                End If
                                'new tempangle
                                'angle3# replaces tempangle# to be angle to collision point from box center
                                ' reaction angle to corner point velocity
                                If fallingboxes(i%).anglevel <> 0 And Abs((fallingboxes(i%).angle - fallingboxes(j%).angle) / (_Pi / 2) - _Round((fallingboxes(i%).angle - fallingboxes(j%).angle) / (_Pi / 2))) > .08 Then
                                    tempangle2# = angle3# - fallingboxes(i%).anglevel / Abs(fallingboxes(i%).anglevel) * _Pi / 2
                                Else
                                    tempangle2# = angle3# + _Pi
                                End If
                                If (Cos(tempangle2#) * Cos(faceangle#) + Sin(tempangle2#) * Sin(faceangle#)) < 0 Then
                                    tempangle2# = faceangle# 'if collision point is moving away from collision surface, then don't use the reaction angle, use the surface vector instead
                                End If
                                'START HERE
                                If tvx# * Cos(faceangle#) + tvy# * Sin(faceangle#) < 0 Then 'if total collision point velocity is towards faceangle
                                    forceangle2# = avgangle(_Atan2(tvy#, tvx#) + _Pi, tempangle2#) 'average of total point velocity vector and reaction vector
                                Else
                                    forceangle2# = avgangle(_Atan2(tvy#, tvx#), tempangle2#) 'average of total point velocity vector and reaction vector
                                End If
                                forceangle# = avgangle(faceangle#, forceangle2#) 'average of surface vector and previous answer
                                rotperc# = maxrotperc# * perpvector(xspot#, yspot#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / (fallingboxes(i%).size * Sqr(2) / 2)
                                'Acceleration = Force / Mass
                                forcemag# = (dist1# + dist2# + correction# - dist#) * forceconst#
                                fallingboxes(i%).yacc = fallingboxes(i%).yacc + forcemag# * (1 - rotperc#) * Sin(forceangle#) / fallingboxes(i%).mass
                                fallingboxes(i%).xacc = fallingboxes(i%).xacc + forcemag# * (1 - rotperc#) * Cos(forceangle#) / fallingboxes(i%).mass
                                fallingboxes(i%).angleaccel = forcemag# * rotperc# * perpvector(xspot#, yspot#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                                If (Cos(angle3# + _Pi / 2) * Cos(forceangle#) + Sin(angle3# + _Pi / 2) * Sin(forceangle#)) > 0 Then 'use dot product to determine if torque change is positive or negative
                                    fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel + forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                                Else
                                    fallingboxes(i%).angleaccel = fallingboxes(i%).angleaccel - forcemag# * rotperc# * perpvector(bottomx#, bottomy#, Cos(forceangle#), Sin(forceangle#), fallingboxes(i%).xpos, fallingboxes(i%).ypos) / fallingboxes(i%).rotInert
                                End If
                                fallingboxes(i%).damping = 1 'recompute energy limit
                                fallingboxes(j%).damping = 1 'recompute energy limit
                            End If
                        End If
                    Next j%
                End If
            Next i%


            'Update Positions after all collisions have been computed
            'Update Kinematics first
            For i% = 0 To 100
                If fallingboxes(i%).otype = 1 Then 'object must be the right type, and have positive health
                    'Update Velocity
                    fallingboxes(i%).xvel = fallingboxes(i%).xvel + fallingboxes(i%).xacc * 1 / physfreq#
                    fallingboxes(i%).yvel = fallingboxes(i%).yvel + fallingboxes(i%).yacc * 1 / physfreq#
                    'Update Angular Velocity
                    fallingboxes(i%).anglevel = fallingboxes(i%).anglevel + fallingboxes(i%).angleaccel * 1 / physfreq#
                End If
            Next i%

            'Total box energy check
            For i% = 0 To 100
                boxenergy# = fallingboxes(i%).mass * newgravity# * (400 - fallingboxes(i%).ypos) 'potential energy
                boxenergy# = boxenergy# + 0.5 * fallingboxes(i%).mass * (fallingboxes(i%).xvel ^ 2 + fallingboxes(i%).yvel ^ 2) 'translational energy
                boxenergy# = boxenergy# + 0.5 * fallingboxes(i%).rotInert * fallingboxes(i%).anglevel ^ 2 'rotational energy
                If fallingboxes(i%).damping = 1 Then 'Flag object i% with damping= 1 anytime its total energy state may have changed
                    'Print #1, "BOX ENERGY LIMIT ", fallingboxes(i%).forcereturn
                    'These limits control the energy balance of the whole system
                    'The simple idea is that if in a collision one box gains energy, another must lose some
                    'Trying to control this more precisely than this has been frustrating a futile
                    'Spring force energy has a random element to it based on how the collision occurs
                    'A box may not exceed its peak energy, but it may not be at this limit (at later times)
                    'The lower limit prevents the system from having an eventual energy death compared to using only the final .forcereturn=boxenergy#
                    If boxenergy# > 1.05 * fallingboxes(i%).forcereturn Then
                        fallingboxes(i%).forcereturn = 1.05 * fallingboxes(i%).forcereturn
                    ElseIf boxenergy# < 0.95 * fallingboxes(i%).forcereturn Then
                        fallingboxes(i%).forcereturn = 0.95 * fallingboxes(i%).forcereturn
                    Else
                        fallingboxes(i%).forcereturn = boxenergy#
                    End If
                    fallingboxes(i%).damping = 0
                End If
                If fallingboxes(i%).damping = 2 Then 'More generous energy change limits for manual selection
                    If boxenergy# > 1.1 * fallingboxes(i%).forcereturn Then
                        fallingboxes(i%).forcereturn = 1.1 * fallingboxes(i%).forcereturn
                    ElseIf boxenergy# < 0.9 * fallingboxes(i%).forcereturn Then
                        fallingboxes(i%).forcereturn = 0.9 * fallingboxes(i%).forcereturn
                    Else
                        fallingboxes(i%).forcereturn = boxenergy#
                    End If
                    fallingboxes(i%).damping = 0
                End If

                If boxenergy# > fallingboxes(i%).forcereturn Then
                    tempangle# = .999 * Sqr((fallingboxes(i%).forcereturn) / (boxenergy#))
                    fallingboxes(i%).xvel = tempangle# * fallingboxes(i%).xvel
                    fallingboxes(i%).yvel = tempangle# * fallingboxes(i%).yvel
                    fallingboxes(i%).anglevel = tempangle# * fallingboxes(i%).anglevel
                End If
            Next i%


            'Update position
            For i% = 0 To 100
                If fallingboxes(i%).otype = 1 Then 'object must be the right type, and have positive health
                    If Abs(fallingboxes(i%).xvel) < .000001 Then fallingboxes(i%).xvel = 0 'reduce drift
                    If Abs(fallingboxes(i%).yvel) < .000001 Then fallingboxes(i%).yvel = 0 'reduce drift
                    tempangle# = Sqr(fallingboxes(i%).xvel ^ 2 + fallingboxes(i%).yvel ^ 2)
                    'peak velocity
                    If tempangle# > 1.5 * physfreq# Then
                        fallingboxes(i%).xvel = (1.5 * physfreq#) / tempangle# * fallingboxes(i%).xvel
                        fallingboxes(i%).yvel = (1.5 * physfreq#) / tempangle# * fallingboxes(i%).yvel
                    End If
                    If fallingboxes(i%).anglevel * Sqr(2) * fallingboxes(i%).size / 2 > 1.5 * physfreq# Then fallingboxes(i%).anglevel = 1.2 * physfreq# * 2 / (Sqr(2) * fallingboxes(i%).size)
                    'Update positions
                    fallingboxes(i%).xpos = fallingboxes(i%).xpos + fallingboxes(i%).xvel * 1 / physfreq#
                    fallingboxes(i%).ypos = fallingboxes(i%).ypos + fallingboxes(i%).yvel * 1 / physfreq#
                    'Update Angle
                    fallingboxes(i%).angle = fallingboxes(i%).angle + fallingboxes(i%).anglevel * 1 / physfreq#
                End If
            Next i%

            'UPDATE TIMER
            phystimer# = phystimer# + 1 / physfreq#
        Wend 'End PHYSICS LOOP

        If Int(gametimer# * 24) Mod 8 = 1 Then '24/8=3 changes a second
            outerred% = Int(Rnd * 200) + 55
            outergreen% = Int(Rnd * 250) + 5
            outerblue% = Int(Rnd * 250) + 5
        End If

        'DISPLAY STUFF
        Cls
        'Draw Boxes
        For i% = 0 To 100
            If fallingboxes(i%).otype = 1 Then 'object must be the right type
                drawpoints#(0, 0) = (fallingboxes(i%).xpos + fallingboxes(i%).size / 2 * (Cos(fallingboxes(i%).angle) - Sin(fallingboxes(i%).angle))) 'angles are in radians X=1 Y=1
                drawpoints#(0, 1) = (fallingboxes(i%).ypos + fallingboxes(i%).size / 2 * (Sin(fallingboxes(i%).angle) + Cos(fallingboxes(i%).angle))) 'angles are in radians X=1 Y=1
                drawpoints#(1, 0) = (fallingboxes(i%).xpos + fallingboxes(i%).size / 2 * (-Cos(fallingboxes(i%).angle) - Sin(fallingboxes(i%).angle))) 'angles are in radians X=-1 Y=1
                drawpoints#(1, 1) = (fallingboxes(i%).ypos + fallingboxes(i%).size / 2 * (-Sin(fallingboxes(i%).angle) + Cos(fallingboxes(i%).angle))) 'angles are in radians X=-1 Y=1
                drawpoints#(2, 0) = (fallingboxes(i%).xpos + fallingboxes(i%).size / 2 * (-Cos(fallingboxes(i%).angle) + Sin(fallingboxes(i%).angle))) 'angles are in radians X=-1 Y=-1
                drawpoints#(2, 1) = (fallingboxes(i%).ypos + fallingboxes(i%).size / 2 * (-Sin(fallingboxes(i%).angle) - Cos(fallingboxes(i%).angle))) 'angles are in radians X=-1 Y=-1
                drawpoints#(3, 0) = (fallingboxes(i%).xpos + fallingboxes(i%).size / 2 * (Cos(fallingboxes(i%).angle) + Sin(fallingboxes(i%).angle))) 'angles are in radians X=1 Y=-1
                drawpoints#(3, 1) = (fallingboxes(i%).ypos + fallingboxes(i%).size / 2 * (Sin(fallingboxes(i%).angle) - Cos(fallingboxes(i%).angle))) 'angles are in radians X=1 Y=-1
                Line (drawpoints#(0, 0), drawpoints#(0, 1))-(drawpoints#(1, 0), drawpoints#(1, 1)), _RGB(fallingboxes(i%).environ, fallingboxes(i%).touching, fallingboxes(i%).healthtime)
                Line (drawpoints#(1, 0), drawpoints#(1, 1))-(drawpoints#(2, 0), drawpoints#(2, 1)), _RGB(fallingboxes(i%).environ, fallingboxes(i%).touching, fallingboxes(i%).healthtime)
                Line (drawpoints#(2, 0), drawpoints#(2, 1))-(drawpoints#(3, 0), drawpoints#(3, 1)), _RGB(fallingboxes(i%).environ, fallingboxes(i%).touching, fallingboxes(i%).healthtime)
                Line (drawpoints#(3, 0), drawpoints#(3, 1))-(drawpoints#(0, 0), drawpoints#(0, 1)), _RGB(fallingboxes(i%).environ, fallingboxes(i%).touching, fallingboxes(i%).healthtime)
                If fallingboxes(i%).friction = 1 Then
                    Circle (fallingboxes(i%).xpos, fallingboxes(i%).ypos), 11, _RGB(252, 252, 252)
                End If

            End If
        Next i%

        Line (2, 2)-(638, 358), _RGB(outerred%, outergreen%, outerblue%), B
        'Line (2, 2)-(638, 358), _RGB(127, 128, 129), B
        Locate 12, 35
        Print "You Won!"
        'Draw selection box
        If selecting` = -1 Then
            Line (select1x%, select1y%)-(select2x%, select2y%), _RGB(250, 250, 250), B
        End If
        If selectingR` = -1 Then
            Line (selectRx% - 4, selectRy% - 4)-(selectRx% + 4, selectRy% + 4), _RGB(255, 0, 0)
            Line (selectRx% + 4, selectRy% - 4)-(selectRx% - 4, selectRy% + 4), _RGB(255, 0, 0)
        End If
        'Draw Mouse Last
        Line (mousexpos%, mouseypos%)-(mousexpos% + 3, mouseypos%), _RGB(255, 255, 255)
        Line (mousexpos%, mouseypos%)-(mousexpos%, mouseypos% + 3), _RGB(255, 255, 255)
        Line (mousexpos%, mouseypos%)-(mousexpos% + 4, mouseypos% + 4), _RGB(255, 255, 255)
        _Display

        _Limit 60
    Wend

End Sub


Function radialsquare (angle#)
    fixangle angle#
    Select Case angle#
        Case 0 To _Pi / 4
            radialsquare = Sqr(1 + Tan(angle#) ^ 2)
        Case _Pi / 4 To 3 * _Pi / 4
            radialsquare = Sqr(1 + (1 / Tan(angle#)) ^ 2)
        Case 3 * _Pi / 4 To 5 * _Pi / 4
            radialsquare = Sqr(1 + Tan(angle#) ^ 2)
        Case 5 * _Pi / 4 To 7 * _Pi / 4
            radialsquare = Sqr(1 + (1 / Tan(angle#)) ^ 2)
        Case 7 * _Pi / 4 To 2 * _Pi
            radialsquare = Sqr(1 + Tan(angle#) ^ 2)
    End Select
End Function
Function Inbounds (xpos%, ypos%)
    If xpos% > 0 And xpos% <= 960 And ypos% > 0 And ypos% <= 720 Then
        Inbounds = 1
    Else
        Inbounds = 0
    End If
End Function


Function betweenangles (lowerangle#, upperangle#, inputangle#)
    While upperangle# - lowerangle# > _Pi
        lowerangle# = lowerangle# + 2 * _Pi
    Wend
    While lowerangle# - upperangle# > _Pi
        upperangle# = upperangle# + 2 * _Pi
    Wend
    While inputangle# < lowerangle#
        inputangle# = inputangle# + 2 * _Pi
    Wend
    While lowerangle# < 0 Or upperangle# < 0 Or inputangle# < 0
        lowerangle# = lowerangle# + 2 * _Pi
        upperangle# = upperangle# + 2 * _Pi
        inputangle# = inputangle# + 2 * _Pi
    Wend
    If inputangle# <= upperangle# And inputangle# >= lowerangle# Then
        betweenangles = -1
    Else
        betweenangles = 0
    End If
End Function

Function intersectiontime (xmpos#, ympos#, xbpos#, ybpos#, Mv#, missileangle#, xboxv#, yboxv#)
    Dim xint#, xint1#, xmissilev#, ymissilev#, tm#, tb#, tm1#, tb1#, ftimediff1#, ftimediff2#, radical#
    xmissilev# = Mv# * Cos(missileangle#)
    ymissilev# = Mv# * Sin(missileangle#)
    If Abs(xboxv#) > 0.1 Then
        radical# = 2 * (gravity#) * xmissilev# * (ymissilev# * (xbpos# - xmpos#) - xmissilev# * (ybpos# - ympos#)) + (xboxv# * ymissilev# - xmissilev# * yboxv#) ^ 2
    Else
        radical# = 2 * (gravity#) * xmissilev# * (ymissilev# * (xbpos# - xmpos#) - xmissilev# * (ybpos# - ympos#)) + xmissilev# ^ 2 * yboxv# ^ 2
    End If
    If radical# > 0 Then
        If Abs(xboxv#) > 0.1 Then
            xint# = (Sqr(radical#) * xboxv# + (gravity#) * xbpos# * xmissilev# + xboxv# * (xboxv# * ymissilev# - xmissilev# * yboxv#)) / ((gravity#) * xmissilev#)
            tm# = (xint# - xmpos#) / xmissilev#
            tb# = (xint# - xbpos#) / xboxv#
            xint1# = (-Sqr(radical#) * xboxv# + (gravity#) * xbpos# * xmissilev# + xboxv# * (xboxv# * ymissilev# - xmissilev# * yboxv#)) / ((gravity#) * xmissilev#)
            tm1# = (xint1# - xmpos#) / xmissilev#
            tb1# = (xint1# - xbpos#) / xboxv#
            'ftimediff1=(sqrt(radical#)*(xboxv#-xmissilev#)+(gravity#)*xmissilev#*(xbpos#-xmpos#)+(xboxv#-xmissilev#)*(xboxv#*ymissilev#-xmissilev#*yboxv#))/((gravity#)*xmissilev#^2)
            ' ftimediff2=(-sqrt(radical#)*(xboxv#-xmissilev#)+(gravity#)*xmissilev#*(xbpos#-xmpos#)+(xboxv#-xmissilev#)*(xboxv#*ymissilev#-xmissilev#*yboxv#))/((gravity#)*xmissilev#^2)
        Else
            tm# = (xbpos# - xmpos#) / xmissilev#
            tm1# = tm#
            tb# = (Sqr(radical#) - xmissilev# * yboxv#) / (gravity# * xmissilev#)
            tb1# = (-Sqr(radical#) - xmissilev# * yboxv#) / (gravity# * xmissilev#)
        End If
        If tm# >= 0 And tb# >= 0 Then
            ftimediff1# = tm# - tb#
        Else
            ftimediff1# = 100
        End If
        If tm1# >= 0 And tb1# >= 0 Then
            ftimediff2# = tm1# - tb1#
        Else
            ftimediff2# = 100
        End If
        If Abs(ftimediff1#) < Abs(ftimediff2#) Then
            intersectiontime = ftimediff1#
        Else
            intersectiontime = ftimediff2#
        End If
        'positive time difference means the box arrives there first, negative means the missile arrives first
        'unreal answers means there is no collision
    Else
        intersectiontime = 100
    End If

End Function
Function targetangle (xmt#, ymt#, xbt#, ybt#, Mv#, mangle#, xbv#, ybv#)
    'Returns target angle, a negative value means it will not hit, a positive value is the angle in radians
    xmv# = Mv# * Cos(mangle#)
    ymv# = Mv# * Sin(mangle#)
    Dim timeoffset#, timediff#, timediffold#, dist#, increment#, adjustment#, tangle#
    tangle# = mangle#
    dist# = Sqr((xmt# - xbt#) ^ 2 + (ymt# - ybt#) ^ 2)
    increment# = _Pi / 24
    timeoffset# = -0.4 'negative means the missile gets there first
    If Abs(xmv#) > 0.1 And Sqr(ybv# ^ 2 + xbv# ^ 2) > 0.5 Then
        If dist# < Mv# * Abs(timeoffset#) Then
            timeoffset# = 0.0
        End If
        tangle# = mangle# - _Pi / 6 - increment# 'temp angle, missile angle
        timediffold# = intersectiontime(xmt# + Mv# * Cos(mangle#) * Abs(timeoffset#), ymt# + Mv# * Sin(mangle#) * Abs(timeoffset#), xbt#, ybt#, Mv#, tangle#, xbv#, ybv#)
        timediff# = timediffold#
        While tangle# <= mangle# + _Pi / 6 + increment# And (((timediff# >= timeoffset# And timediffold# > timeoffset#) Or (timediff# <= timeoffset# And timediffold# < timeoffset#)) Or timediff# >= 50 Or timediffold# >= 50) 'while x<limit and abort=false (abort can have various conditions separated with 'or'), shifting the graph with timeoffset# will change the zero point
            tangle# = tangle# + increment#
            timediffold# = timediff#
            timediff# = intersectiontime(xmt# + Mv# * Cos(mangle#) * Abs(timeoffset#), ymt# + Mv# * Sin(mangle#) * Abs(timeoffset#), xbt#, ybt#, Mv#, tangle#, xbv#, ybv#)
            If timediff# >= 50 Then
                timediff# = intersectiontime(xmt# + Mv# * Cos(mangle#) * Abs(timeoffset#), ymt# + Mv# * Sin(mangle#) * Abs(timeoffset#), xbt#, ybt#, Mv#, tangle# - increment#, xbv#, ybv#)
                If timediff# >= 50 Then
                    timediff# = intersectiontime(xmt# + Mv# * Cos(mangle#) * Abs(timeoffset#), ymt# + Mv# * Sin(mangle#) * Abs(timeoffset#), xbt#, ybt#, Mv#, tangle# + increment#, xbv#, ybv#)
                End If
            End If
        Wend
        'interpolate between timediff# and timediffold#
        If timediff# <> timediffold# And timediff# < 50 Then
            tangle# = tangle# - increment# + increment# * Abs(timeoffset# - timediffold#) / Abs((timediff# - timediffold#))
        End If
        If tangle# >= (mangle# + _Pi / 6 + increment#) And timeoffset# <> 0 Then
            tangle# = mangle# - _Pi / 6 - increment#
            timediffold# = intersectiontime(xmt#, ymt#, xbt#, ybt#, Mv#, tangle#, xbv#, ybv#)
            timediff# = timediffold#
            While tangle# <= mangle# + _Pi / 6 + increment# And (Abs(timediff#) / (timediff#) = Abs(timediffold#) / (timediffold#) Or timediff# >= 50 Or timediffold# >= 50)
                tangle# = tangle# + increment#
                timediffold# = timediff#
                timediff# = intersectiontime(xmt#, ymt#, xbt#, ybt#, Mv#, tangle#, xbv#, ybv#)
                If timediff# >= 50 Then
                    timediff# = intersectiontime(xmt#, ymt#, xbt#, ybt#, Mv#, tangle# + increment#, xbv#, ybv#)
                    If timediff# >= 50 Then
                        timediff# = intersectiontime(xmt#, ymt#, xbt#, ybt#, Mv#, tangle# - increment#, xbv#, ybv#)
                    End If
                End If
            Wend
            'interpolate between timediff# and timediffold#
            tangle# = tangle# - increment# + increment# * Abs(timediffold#) / Abs((timediff# - timediffold#))
        End If
        If tangle# >= (mangle# + _Pi / 6 + increment# - .01) Then
            tangle# = -1 'NO COLLISION; negative score
        Else
            While tangle# < 0
                tangle# = tangle# + 2 * _Pi
            Wend
        End If
        'SIMPLE APPROACH
    Else
        adjustment# = 0.8
        If dist# < Mv# * Abs(timeoffset# * adjustment#) Or dist# < 10 Then
            tangle# = _Atan2((ybt# - ymt#), (xbt# - xmt#))
        Else
            tangle# = _Atan2((ybt# - Mv# * Sin(mangle#) * Abs(timeoffset# * adjustment#) - ymt#), (xbt# - Mv# * Cos(mangle#) * Abs(timeoffset# * adjustment#) - xmt#))
        End If
        If betweenangles(mangle# - _Pi / 5, mangle# + _Pi / 5, tangle#) = 0 Then '0=false
            tangle# = -1 'NO COLLISION; negative score
        Else
            While tangle# < 0
                tangle# = tangle# + 2 * _Pi
            Wend
        End If
    End If
    'Block targetting items behind the missile
    If Cos(mangle#) * Cos(_Atan2((ybt# - ymt#), (xbt# - xmt#))) + Sin(mangle#) * Sin(_Atan2((ybt# - ymt#), (xbt# - xmt#))) < 0 Then
        tangle# = -1
    End If
    'Problems seem to be caused by missiles targeting boxes behind them, targetting offscreen boxes, targeting boxes with collision times far in the future or collision points offscreen
    'Also boxes changing state while the missile is in course (stationary vs. moving) or changing trajectory.
    'there may possiby be some other bugs as well.  This works well enough that addressing this problems may not be worth the cost in time
    'and the fact that addressing them sometimes has other unintended consequences also.
    targetangle = tangle#
End Function

Function boxcollisioncorrection (box1angle#, box2angle#, box1tobox2angle#, box1size#, box2size#)
    Dim boxrelativeangle#, boxlinerelative#, beta1#, beta2#, b1corner#, b2corner#
    b1corner# = (box1size# / 2) * Sqr(2)
    b2corner# = (box2size# / 2) * Sqr(2)
    boxrelativeangle# = box2angle# - box1angle#
    boxlinerelative# = box1tobox2angle# - box1angle# 'box1tobox2angle# is absolute, make it relative
    While boxrelativeangle# < 0
        boxrelativeangle# = boxrelativeangle# + _Pi / 2 'Corrected THIS #1
    Wend
    While boxrelativeangle# > _Pi / 2
        boxrelativeangle# = boxrelativeangle# - _Pi / 2
    Wend
    While boxlinerelative# < _Pi / 4
        boxlinerelative# = boxlinerelative# + _Pi / 2
    Wend
    While boxlinerelative# > 3 * _Pi / 4
        boxlinerelative# = boxlinerelative# - _Pi / 2
    Wend
    'Calculate beta1 and beta2 (opposite from drawing, beta1 is less than beta2)
    beta1# = _Pi / 4 + _Asin((b2corner# * Sin(_Pi - boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)))
    beta2# = 3 * _Pi / 4 - _Asin((b2corner# * Sin(_Pi / 2 + boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)))
    If boxlinerelative# >= beta1# And boxlinerelative# <= beta2# Then
        'Minimum at _Pi/4+boxrelativeangle#=0
        If boxlinerelative# < _Pi / 4 + boxrelativeangle# Then
            'interpolate
            boxcollisioncorrection = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta1# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)) - box1size# / 2 * radialsquare(beta1#) - box2size# / 2 * radialsquare(beta1# + box1angle# - box2angle#))
        Else
            boxcollisioncorrection = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta2# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)) - box1size# / 2 * radialsquare(beta2#) - box2size# / 2 * radialsquare(beta2# + box1angle# - box2angle#))
        End If
    Else
        'Switch to other box's perspective
        boxrelativeangle# = box1angle# - box2angle#
        boxlinerelative# = box1tobox2angle# + _Pi - box2angle# 'box1tobox2angle# is absolute, make it relative
        While boxrelativeangle# < 0 'CORRECT THIS #4
            boxrelativeangle# = boxrelativeangle# + _Pi / 2
        Wend
        While boxrelativeangle# > _Pi / 2
            boxrelativeangle# = boxrelativeangle# - _Pi / 2
        Wend
        While boxlinerelative# < _Pi / 4
            boxlinerelative# = boxlinerelative# + _Pi / 2
        Wend
        While boxlinerelative# > 3 * _Pi / 4
            boxlinerelative# = boxlinerelative# - _Pi / 2
        Wend
        beta1# = _Pi / 4 + _Asin((b1corner# * Sin(_Pi - boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)))
        beta2# = 3 * _Pi / 4 - _Asin((b1corner# * Sin(_Pi / 2 + boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)))
        If boxlinerelative# >= beta1# And boxlinerelative# <= beta2# Then
            'Minimum at _Pi/4+boxrelativeangle#=0
            If boxlinerelative# < _Pi / 4 + boxrelativeangle# Then
                'interpolate
                boxcollisioncorrection = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta1# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)) - box2size# / 2 * radialsquare(beta1#) - box1size# / 2 * radialsquare(beta1# + box2angle# - box1angle#))
            Else
                boxcollisioncorrection = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta2# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)) - box2size# / 2 * radialsquare(beta2#) - box1size# / 2 * radialsquare(beta2# + box2angle# - box1angle#))
            End If
        Else
            boxcollisioncorrection = 0
        End If
    End If
End Function

Sub boxcollisioncorrection2 (returnvalue#, returnx#, returny#, box1angle#, box2angle#, box1size#, box2size#, b1x#, b1y#, b2x#, b2y#)
    Dim boxrelativeangle#, boxlinerelative#, boxlinerelative2#, beta1#, beta2#, b1corner#, b2corner#, box1tobox2angle#
    Dim g#, d1#, d2#, d3#, gamma#
    b1corner# = (box1size# / 2) * Sqr(2)
    b2corner# = (box2size# / 2) * Sqr(2)
    boxrelativeangle# = box2angle# - box1angle#
    box1tobox2angle# = _Atan2(b2y# - b1y#, b2x# - b1x#)
    boxlinerelative# = box1tobox2angle# - box1angle# 'box1tobox2angle# is absolute, make it relative
    boxlinerelative2# = box1tobox2angle# + _Pi - box2angle# 'box1tobox2angle# is absolute, make it relative
    If Abs(box1angle# - box2angle#) < .009 Then 'about 0.5 degree
        returnvalue# = 0
        returnx# = b1x# + box1size# / 2 * radialsquare(box1tobox2angle# - box1angle#) * Cos(box1tobox2angle#)
        returny# = b1y# + box1size# / 2 * radialsquare(box1tobox2angle# - box1angle#) * Sin(box1tobox2angle#)
        Exit Sub
    End If
    While boxrelativeangle# < 0
        boxrelativeangle# = boxrelativeangle# + _Pi / 2
    Wend
    While boxrelativeangle# > _Pi / 2
        boxrelativeangle# = boxrelativeangle# - _Pi / 2
    Wend
    While boxlinerelative# < _Pi / 4
        boxlinerelative# = boxlinerelative# + _Pi / 2
    Wend
    While boxlinerelative# > 3 * _Pi / 4
        boxlinerelative# = boxlinerelative# - _Pi / 2
    Wend
    While boxlinerelative2# < _Pi / 4
        boxlinerelative2# = boxlinerelative2# + _Pi / 2
    Wend
    While boxlinerelative2# > 3 * _Pi / 4
        boxlinerelative2# = boxlinerelative2# - _Pi / 2
    Wend
    d1# = box1size# / 2 * radialsquare(boxlinerelative#)
    d2# = box2size# / 2 * radialsquare(boxlinerelative2#)
    'Calculate beta1 and beta2 (opposite from drawing, beta1 is less than beta2)
    beta1# = _Pi / 4 + _Asin((b2corner# * Sin(_Pi - boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)))
    beta2# = 3 * _Pi / 4 - _Asin((b2corner# * Sin(_Pi / 2 + boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)))
    If boxlinerelative# >= beta1# And boxlinerelative# <= beta2# Then
        'Minimum at _Pi/4+boxrelativeangle#=0
        If boxlinerelative# < _Pi / 4 + boxrelativeangle# Then
            'interpolate
            returnvalue# = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta1# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)) - box1size# / 2 * radialsquare(beta1#) - box2size# / 2 * radialsquare(beta1# + box1angle# - box2angle#))
            g# = returnvalue# * Sin(_Pi / 2 + boxrelativeangle# - boxlinerelative#) / Sin(_Pi / 2 - boxrelativeangle#)
            d3# = Sqr(d1# ^ 2 + g# ^ 2 - 2 * d1# * g# * Cos(_Pi - boxlinerelative#))
            gamma# = -_Asin(g# * Sin(_Pi - boxlinerelative#) / d3#)
        Else
            returnvalue# = (boxlinerelative# - (_Pi / 4 + boxrelativeangle#)) / (beta2# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)) - box1size# / 2 * radialsquare(beta2#) - box2size# / 2 * radialsquare(beta2# + box1angle# - box2angle#))
            g# = returnvalue# * Sin(boxlinerelative# - boxrelativeangle#) / Sin(boxrelativeangle#)
            d3# = Sqr(d1# ^ 2 + g# ^ 2 - 2 * d1# * g# * Cos(boxlinerelative#))
            gamma# = _Asin(g# * Sin(boxlinerelative#) / d3#)
        End If
        'Now calculate returnx# and returny#
        returnx# = b1x# + d3# * Cos(box1tobox2angle# + gamma#)
        returny# = b1y# + d3# * Sin(box1tobox2angle# + gamma#)

    Else
        'Switch to other box's perspective
        boxrelativeangle# = box1angle# - box2angle#
        While boxrelativeangle# < 0
            boxrelativeangle# = boxrelativeangle# + _Pi / 2
        Wend
        While boxrelativeangle# > _Pi / 2
            boxrelativeangle# = boxrelativeangle# - _Pi / 2
        Wend
        beta1# = _Pi / 4 + _Asin((b1corner# * Sin(_Pi - boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)))
        beta2# = 3 * _Pi / 4 - _Asin((b1corner# * Sin(_Pi / 2 + boxrelativeangle#)) / Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)))
        If boxlinerelative2# >= beta1# And boxlinerelative2# <= beta2# Then
            'Minimum at _Pi/4+boxrelativeangle#=0
            If boxlinerelative2# < _Pi / 4 + boxrelativeangle# Then
                'interpolate
                returnvalue# = (boxlinerelative2# - (_Pi / 4 + boxrelativeangle#)) / (beta1# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi - boxrelativeangle#)) - box2size# / 2 * radialsquare(beta1#) - box1size# / 2 * radialsquare(beta1# + box2angle# - box1angle#))
                returnx# = b1x# + b1corner# * Cos(box1tobox2angle# + (_Pi * 3 / 4 - boxlinerelative#))
                returny# = b1y# + b1corner# * Sin(box1tobox2angle# + (_Pi * 3 / 4 - boxlinerelative#))
            Else
                returnvalue# = (boxlinerelative2# - (_Pi / 4 + boxrelativeangle#)) / (beta2# - (_Pi / 4 + boxrelativeangle#)) * (Sqr(b1corner# ^ 2 + b2corner# ^ 2 - 2 * b1corner# * b2corner# * Cos(_Pi / 2 + boxrelativeangle#)) - box2size# / 2 * radialsquare(beta2#) - box1size# / 2 * radialsquare(beta2# + box2angle# - box1angle#))
                returnx# = b1x# + b1corner# * Cos(box1tobox2angle# - (boxlinerelative# - _Pi / 4))
                returny# = b1y# + b1corner# * Sin(box1tobox2angle# - (boxlinerelative# - _Pi / 4))
            End If
        Else
            returnvalue# = 0
            returnx# = 0
            returny# = 0
        End If
    End If
End Sub