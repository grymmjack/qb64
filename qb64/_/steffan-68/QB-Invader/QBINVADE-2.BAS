'Program : QB Invaders
'Version : Ver 1.1 for Qbasic
'Type    : Shareware
'Revised : 4/29/97
'Author  : Tim Truman
'Address : NET -TimTruman@aol.com, AOL-TimTruman
'
'Copyright(c) 1997 Nocturnal Creations
'
'Feel free to use any routines or code found this program in your own
'as long as you credit Tim Truman as the contributer. Graphics and sounds
'are property of Tim Truman and may not be used.
'
'I just ask that you do not distribute this source code program or
'modify and recompile the program for reasons other than personal use.
'
'You are not obligated... however if you like QB Invaders, or plan to use
'code from it, please register by sending a small amount of money to :
'Tim Truman
'110 Homestead Ave.
'Springfield, MA 01151
'USA
'
'-------------------
'Info & Requirements
'-------------------
'Graphics for this program were made using SPRITE 2.0.
'Adlib sound effects were made using FX.
'Requires a VGA.
'Recommend 386 or higher processor, and a sound card.
'
'-------------------
'Running QBInvaders       * Important read this ! *
'-------------------
'Playing under DOS:
' Type qbasic /run qbinvade.
'
'Playing under WIN 3.1 and WIN 95 :
' Use the File Manager and double click on the MSDOS shortcut.
' Why?
' Some key combinations are reserved to windows like ALT-SPACE
' combo used by this program. Using the MSDOS shortcut realeases
' this key combo for Qbasic, preventing program errors.
'
'-------------------
' Program options
'-------------------
'  (1) Change the 'UseFX' variable to false for PC speaker sounds.
'  (2) Change the 'Hard' variable to true for harder gameplay.
'  (3) Two graphics set are available.


DefInt A-Z

Type hues ' define the type for hues
    red As Integer ' red component
    grn As Integer ' green component
    blu As Integer ' blue component
End Type

Type sprite
    x As Integer 'current alien location
    y As Integer '
    lx As Integer 'last alien location
    ly As Integer '
    w As Integer 'width of image
    h As Integer 'height of image
    dir As Integer 'referenced for movement
    health As Integer 'aliens well being
    sseg As Integer 'segment of alien char
    tile As Integer 'offset to frame
    ltile As Integer 'for erase
    hit As Integer 'check for a hit before moving
End Type

Type highscores 'type for highscores
    rank As String * 3 'rank
    dat As String * 8 'date
    nam As String * 25 'name
    lines As String * 4 'lines
    score As String * 6 'score
End Type

DECLARE SUB clearbuffer ()
DECLARE SUB DoAliens ()
DECLARE SUB DoAlienBombs ()
DECLARE SUB DoCollisions ()
DECLARE SUB DocommandShip ()
DECLARE SUB EndToDos ()

DECLARE SUB DoHighScores ()
DECLARE SUB Dolevel ()
DECLARE SUB DoScore (points)
DECLARE SUB DoGunShot ()
DECLARE SUB DoGunshot2 ()
DECLARE SUB DoGunner ()
DECLARE SUB DoGameEnd ()
DECLARE SUB FadePal (fc%, lc%, level%, mode%)
DECLARE SUB GetReady ()

DECLARE SUB InitGameStart ()
DECLARE SUB Initlevel ()
DECLARE SUB Intro ()
DECLARE SUB Mouse (argument)
DECLARE SUB p5x7font (x, y, text$, colour)
DECLARE SUB playsfx (fx$)
DECLARE SUB PalRegInfo (reg, red, grn, blu, mode)
DECLARE SUB Pfont (text$, x, y, colour)
DECLARE SUB ShowHighScores (score() AS highscores, mode)
DECLARE SUB soundfx (fx)
DECLARE SUB stay (Millisecs!)
DECLARE SUB TitleScreen ()

DECLARE FUNCTION CheckFiles ()
DECLARE FUNCTION DoExplode (x, y)
DECLARE FUNCTION DropFileList (filename$)
DECLARE FUNCTION Fileexists (filename$)
DECLARE FUNCTION GetFileName$ (filespec$)
DECLARE FUNCTION InputText$ (xcur%, ycur%, length%)
DECLARE FUNCTION returnevent ()
DECLARE FUNCTION TimeIsUp (n, tsecs!)

'mapped key values
Const up = -72
Const Down = -80
Const Left = -75
Const Right = -77
Const Eight = 56
Const Two = 50
Const Enter = 13
Const Esc = 27
Const space = 32
Const letterc = 99
'mouse
Const leftclick = 1
Const rightclick = 2
'other
Const true = 1
Const false = 0

Common Shared Maxx, Maxy, event, font(), pal() As hues
Common Shared sprites(), elmPerSpr, NewAlienFrame, spriteheight, spritewidth
Common Shared alien() As sprite, numberofaliens, AliensInPLay, movealiens
Common Shared AliensPerCol, AliensPerRow, alienvelx, AlienVely, TimeToStep!
Common Shared AlienStartX, AlienStartY, AlienStepX, AlienStepY
Common Shared abomb() As sprite, Numberofbombs, AbombInterval!, Abombvel
Common Shared gunner As sprite, gunnerlives
Common Shared gunner2 As sprite, gunnerlives2
Common Shared gunnerMaxx, GunnerMinx, numplayers, gunnervel

Common Shared gunshot As sprite, GunShotVel
Common Shared cship As sprite, headisup
Common Shared shield() As sprite, NumberofShields
Common Shared Barrier() As sprite
Common Shared level, gamescore&, UseFX, Hard

Cls

Dim Shared c$(8) 'FM register information for 9 channels
c$(0) = "&hB0&h20&h23&h40&h43&h60&h63&h80&h83&hA0&HBD&HC0&HE0&HE3&hB0"
c$(1) = "&hB1&h21&h24&h41&h44&h61&h64&h81&h84&hA1&HBD&HC1&HE1&HE4&hB1"
c$(2) = "&hB2&h22&h25&h42&h45&h62&h65&h82&h85&hA2&HBD&HC2&HE2&HE5&hB2"
c$(3) = "&hB3&h28&h2B&h48&h4B&h68&h6B&h88&h8B&hA3&HBD&HC3&HE8&HEB&hB3"
c$(4) = "&hB4&h29&h2C&h49&h4C&h69&h6C&h89&h8C&hA4&HBD&HC4&HE9&HEC&hB4"
c$(5) = "&hB5&h2A&h2D&h4A&h4D&h6A&h6D&h8A&h8D&hA5&HBD&HC5&HEA&HED&hB5"
c$(6) = "&hB6&h30&h33&h50&h53&h70&h73&h90&h93&hA6&HBD&HC6&HF0&HF3&hB6"
c$(7) = "&hB7&h31&h34&h51&h54&h71&h74&h91&h94&hA7&HBD&HC7&HF1&HF4&hB7"
c$(8) = "&hB8&h32&h35&h52&h55&h72&h75&h92&h95&hA8&HBD&HC8&HF2&HF5&hB8"

Dim Shared sfx$(25) 'dim array to hold 26 sounds
Open ".\qbinvade.sfx" For Input As #1 'open the .SFX file
For sfxnum% = 0 To 25 'first to last
    Input #1, sfx$(sfxnum%) 'load sound into string
Next 'next sound
Close #1 'close the file


Screen 13 'set video mode
_FullScreen
Maxx = 319 'store screen size
Maxy = 199 'ditto

Out &H60, &HF3 'inform keyboard port
stay (500) 'let hardware settle
Out &H60, 0 'fast typematic rate with min delay

bucket = TimeIsUp(7, -1) 'set up timers
stay (1) 'initilaize delay routine

ReDim pal(255) As hues 'array for palette
Def Seg = VarSeg(pal(0)) 'point to it
BLoad ".\default.pal", 0 'load it
Out &H3C8, 0 'inform VGA
For c = 0 To 255 'entire palette
    Out &H3C9, pal(c).red 'send red component
    Out &H3C9, pal(c).grn 'send green component
    Out &H3C9, pal(c).blu 'send blue component
Next 'next attribute

Dim font(127, 4, 6) 'DIM array for fonts
Def Seg = VarSeg(font(0, 0, 0)) 'Point to it
BLoad ".\qbinvade.fnt", 0 'Load 'em in

' Unremark image file to load. **********   Choose graphics. *************
'filename$ = "atari.spr"
filename$ = ".\qbinvade.spr"

Cls
Filesize& = 12877 'File size
bytes = (Filesize& - 7) \ 2 - 1 'BSAVE & BLOAD use 7 bytes
Dim sprites(bytes) 'dim the sprite array
Def Seg = VarSeg(sprites(0)) 'point to it
BLoad filename$, 0 'load the sprite file
spritewidth = sprites(0) \ 8 'get image width
spriteheight = sprites(1) 'get image height
elmPerSpr = ((spritewidth * spriteheight) \ 2) + 3 ' elements in one image


Randomize Timer 'seed randomizer
UseFX = false 'true 'set to false for PC speaker
Hard = false 'set to true for harder gameplay
TitleScreen 'start intro
InitGameStart 'init game varaibles/screen


Do 'level loop

    level = level + 1 'increment level
    Initlevel 'display graphics
    GetReady 'tell user game is ready

    Do 'game loop
        event = returnevent 'get events
        If event = Esc Then EndToDos 'user wants out
        DoAlienBombs
        DoAliens
        If TimeIsUp(3, 15) Then cship.health = true 'time appearance of command ship
        DocommandShip
        DoCollisions
        DoGunner
        DoGunShot
    Loop Until AliensInPLay = 0

Loop



'data to reconstruct qbinvader.scr in the event it is erased
Data 1,4/11/97,Timothy Truman,2000
Data 2,4/11/97,John Denesha,2000
Data 3,4/11/97,David Pastore,2000
Data 4,4/11/97,John Matias,2000
Data 5,4/11/97,Mike Eberts,1500
Data 6,4/11/97,Bonnie Soffan,1500
Data 7,4/11/97,Patty Effilo,1500
Data 8,4/11/97,Kelsi Donahue,1450
Data 9,4/11/97,Sabrina McIntosh,1450
Data 10,4/11/97,Colleen Wise,1450
Data 11,4/11/97,Michelle Poules,1300
Data 12,4/11/97,Dominic Amato,1300
Data 13,4/11/97,Bobby Barkett,1300
Data 14,4/11/97,Tracy Truman,1200
Data 15,4/11/97,Chris Hitas,1200


' Visit this FTP for my latest programs and utilities :
'   members.aol.com/TimTruman

Sub clearbuffer 'clear keyboard buffer
    Def Seg = &H40 'point to low memory
    Poke &H1A, Peek(&H1C) 'point head to tail
End Sub

Sub DoAlienBombs

    For ab = 1 To Numberofbombs 'do alien bombs
        If abomb(ab).health = false Then 'new one set up
            If TimeIsUp(2, AbombInterval!) Then 'time has passed
                For a = 1 To numberofaliens
                    If alien(a).health Then 'wide scan for gunner
                        If alien(a).x < gunner.x Or alien(a).x > gunner.x - gunner.w Then
                            AlienUnder = false 'assume alien under
                            For m = 1 To AliensPerCol 'next row down
                                lookunder = (a + (AliensPerRow * m)) 'calc down one
                                If lookunder <= numberofaliens Then 'Alien there ?
                                    If alien(lookunder).health = 1 Then AlienUnder = true 'This one can't fire
                                End If
                            Next
                            If AlienUnder = false Then
                                maybe = Rnd * 12 'this one is possible
                                If maybe > 1 And maybe < 6 Then 'use 'em
                                    abomb(ab).health = alien(a).health 'set up Bomp
                                    abomb(ab).x = alien(a).x + alien(a).w / 2 'ditto
                                    abomb(ab).y = alien(a).y + alien(a).h 'ditto
                                    abomb(ab).lx = abomb(ab).x 'ditto
                                    abomb(ab).ly = abomb(ab).y 'ditto
                                    Exit For 'Outa here
                                End If
                                'narrow scan
                                If alien(a).x >= gunner.x And alien(a).x < gunner.x + gunner.w Then
                                    If maybe <> 0 Then 'use 'em
                                        abomb(ab).health = alien(a).health 'set up Bomp
                                        abomb(ab).x = alien(a).x + alien(a).w / 2 'ditto
                                        abomb(ab).y = alien(a).y + alien(a).h 'ditto
                                        abomb(ab).lx = abomb(ab).x 'ditto
                                        abomb(ab).ly = abomb(ab).y 'ditto
                                        Exit For 'outa here
                                    End If
                                End If
                            End If
                        End If
                    End If
                Next 'check next alien
            End If

        ElseIf abomb(ab).health = true Then 'animate it
            Line (abomb(ab).lx, abomb(ab).ly)-(abomb(ab).lx, abomb(ab).ly + abomb(ab).h), 0
            abomb(ab).y = abomb(ab).y + Abombvel + Hard 'adjust bomb y
            If abomb(ab).y > Maxy Then 'it's off screen
                abomb(ab).health = 0 'Kill it
            Else 'still visible
                Line (abomb(ab).x, abomb(ab).y)-(abomb(ab).x, abomb(ab).y + abomb(ab).h), 138
                abomb(ab).lx = abomb(ab).x: abomb(ab).ly = abomb(ab).y 'for erase
                _Delay .005
            End If
        End If

    Next



End Sub

Sub DoAliens

    Static dir, ctr1



    If TimeIsUp(1, TimeToStep!) Then 'Move aliens ?
    
        For a = 1 To numberofaliens 'look for live aliens
            If alien(a).health Then 'got one
                CountEm = CountEm + 1 'count em in
                If dir = 1 Then 'going left
                    alien(a).x = alien(a).x - alienvelx 'adjust x position
                    If alien(a).x <= alienvelx Then dflag = true 'drop em ?
                    If dflag And CountEm = AliensInPLay Then 'wait for every x adjust
                        For b = 1 To numberofaliens 'drop em all at once
                            If alien(b).health Then alien(b).y = alien(b).y + AlienVely
                        Next 'next one
                        dflag = false: dir = 0 'did drop; change direction
                    End If
                ElseIf dir = 0 Then 'going right
                    alien(a).x = alien(a).x + alienvelx 'adjust x position
                    If alien(a).x > Maxx - alien(a).w - alienvelx Then dflag = true ' drop ?
                    If dflag And CountEm = AliensInPLay Then 'wait for every x adjust
                        For b = 1 To numberofaliens 'drop em all at once
                            If alien(b).health Then alien(b).y = alien(b).y + AlienVely
                        Next 'next
                        dflag = false: dir = 1 'did drop; change direction
                    End If
                End If
            End If
        Next
        CountEm = 0 'reset
        movealiens = true 'update screen
    End If

    Do: Loop Until (Inp(&H3DA) And 8) 'wait for VGA retrace
                                                             
    If movealiens = true Then
        For a = numberofaliens To 1 Step -1 'start at bot
            If alien(a).health And (alien(a).hit = false) Then 'got a live one
                Put (alien(a).lx, alien(a).ly), sprites(elmPerSpr * 20), PSet 'erase last
                alien(a).tile = (alien(a).tile + elmPerSpr) Mod NewAlienFrame 'calc ani frame
                alien(a).tile = alien(a).tile + alien(a).sseg 'calc alien
                Put (alien(a).x, alien(a).y), sprites(alien(a).tile), PSet 'Put it
                alien(a).lx = alien(a).x: alien(a).ly = alien(a).y 'for erase
                alien(a).ltile = alien(a).tile 'ditto
            End If
        Next

        If UseFX = 1 Then
            ctr1 = (ctr1 + 1) Mod 2
            If ctr1 Then playsfx (sfx$(2)) Else playsfx (sfx$(3))
        Else
            soundfx (1)
        End If
        movealiens = false 'done

    End If

End Sub

Sub DoCollisions

    '--* do collisions
    '--* check for collisions between aliens and gunshots using a bounding box

    For b = 1 To numberofaliens
        If alien(b).health = 1 And gunshot.health = 1 Then
            If gunshot.y >= alien(b).y And gunshot.y <= alien(b).y + alien(b).h Then
                If gunshot.x >= alien(b).x And gunshot.x <= alien(b).x + alien(b).w Then
                    Put (alien(b).lx, alien(b).ly), sprites(alien(b).ltile) 'erase old
                    Line (gunshot.lx, gunshot.ly)-(gunshot.lx, gunshot.ly + gunshot.h), 0
                    'soundfx (4)
                    If UseFX = 1 Then
                        playsfx (sfx$(1))
                    Else
                        soundfx (4)
                    End If

                    alien(b).health = 0
                    gunshot.health = 0
                    AliensInPLay = AliensInPLay - 1 'one less alien
                    row = ((b - 1) \ (AliensPerRow)) + 1
                    points = 5 * Abs(row - (AliensPerRow + 1))
                    DoScore (points)
                    Exit For
                End If
            End If
        End If
    Next


    '--* check for collisions between alien bombs and barriers

    For ab = 1 To Numberofbombs
        For b = 1 To 2
            If abomb(ab).health Then
                If abomb(ab).y > Barrier(b).y And abomb(ab).y < Barrier(b).y + spriteheight Then
                    If abomb(ab).x >= Barrier(b).x And abomb(ab).x <= Barrier(b).x + spritewidth Then
                        abomb(ab).health = 0
                        Line (abomb(ab).lx, abomb(ab).ly)-(abomb(ab).lx, abomb(ab).ly + abomb(ab).h), 0
                    End If
                End If
            End If
        Next
    Next

    '--* check for collisions between alien bombs and gunner

    For ab = 1 To Numberofbombs
        If abomb(ab).health = 1 Then
            If abomb(ab).x > (gunner.x + 4) And abomb(ab).x < (gunner.x + gunner.w - 4) Then
                If abomb(ab).y >= gunner.y And abomb(ab).y <= gunner.y Then
                    abomb(ab).health = 0
                    gunner.health = 0
                    Line (abomb(ab).lx, abomb(ab).ly)-(abomb(ab).lx, abomb(ab).ly + abomb(ab).h), 0
                End If
            End If
        End If
    Next



    '--* bombs against gunshots

    For ab = 1 To Numberofbombs
        If abomb(ab).health = 1 And gunshot.health Then
            If abomb(ab).x = gunshot.x Then
                If abomb(ab).y >= gunshot.y And abomb(ab).y <= gunshot.y + gunshot.h Then
                    abomb(ab).health = 0
                    gunshot.health = 0
                    Line (abomb(ab).lx, abomb(ab).ly)-(abomb(ab).lx, abomb(ab).ly + abomb(ab).h), 5
                    Line (gunshot.x, gunshot.y)-(gunshot.x, gunshot.y + gunshot.h), 0, BF 'ditto
                    '_Delay 1
                    If UseFX = true Then
                        playsfx (sfx$(4))
                    Else
                        soundfx (3)
                    End If
                End If
            End If
        End If
    Next

    '--* alienbombs against shields

    For s = 1 To NumberofShields
        For ab = 1 To Numberofbombs
            If abomb(ab).x > shield(s).x And abomb(ab).x < shield(s).x + shield(s).w Then
                If abomb(ab).y >= shield(s).y And abomb(ab).y <= shield(s).y + shield(s).h Then
                    If Point(abomb(ab).x, abomb(ab).y + abomb(ab).h + 1) > 0 Then
                        Line (abomb(ab).x, abomb(ab).y)-(abomb(ab).x, abomb(ab).y + abomb(ab).h + 1), 0
                        PSet (abomb(ab).x + (Rnd * -2), abomb(ab).y + abomb(ab).h + 1), 0
                        PSet (abomb(ab).x + (Rnd * 2), abomb(ab).y + abomb(ab).h + 1), 0
                        abomb(ab).health = 0
                    End If
                End If
            End If
        Next
    Next


    '--* gunshots against shields

    For s = 1 To NumberofShields
        If gunshot.x > shield(s).x And gunshot.x < shield(s).x + shield(s).w Then
            If gunshot.y >= shield(s).y And gunshot.y <= shield(s).y + shield(s).h Then
                If Point(gunshot.x, gunshot.y - 1) > 0 Then
                    Line (gunshot.x, gunshot.y - 1)-(gunshot.x, gunshot.y + gunshot.h), 0
                    gunshot.health = 0
                End If
            End If
        End If
    Next

    '--* gunshots against command ship

    If cship.health And gunshot.health Then
        If gunshot.y < cship.y + spriteheight Then
            If gunshot.x > cship.x And gunshot.x < cship.x + spritewidth Then

                If headisup Then
                    gunnerlives = gunnerlives + 1
                    If UseFX = true Then
                        playsfx (sfx$(7))
                    Else
                        soundfx (7)
                    End If
                Else
                    If UseFX = true Then
                        playsfx (sfx$(6))
                    Else
                        soundfx (6)
                    End If
                End If

                cship.health = 0
                gunshot.health = 0
                Line (gunshot.x, gunshot.y)-(gunshot.x, gunshot.y + gunshot.h), 0, BF 'ditto
                '_Delay 1
                DoScore (50)
            End If
        End If
    End If


    For a = 1 To numberofaliens
        If alien(a).y + alien(a).h >= gunner.y Then
            If UseFX = true Then
                playsfx (sfx$(9))
            Else
                soundfx (5)
            End If
            clearbuffer
            Do: Loop Until returnevent
            DoGameEnd
        End If
    Next

End Sub

Sub DocommandShip

    Static initialize, startframe, xstart, dir, frame, framedir, counter



    If cship.health Then

        If Not initialize Then
            startframe = (24 * elmPerSpr) 'calc start frame
            cship.x = 300 'set start coridinates
            cship.y = 1 'ditto
            For xerase = 1 To 300 Step 20 'clear top of screen
                Put (xerase, 1), sprites(20 * elmPerSpr), PSet
            Next
            ' soundfx (8)                        'make command ship noise
            If UseFX = true Then
                playsfx (sfx$(5))
            Else
                soundfx (8)
            End If

            initialize = Not initialize 'don't do this again
        End If
        _Delay .005
        If TimeIsUp(5, 3) Then 'soundfx (8)                   'time sound effect
            If UseFX = true Then
                playsfx (sfx$(5))
            Else
                soundfx (8)
            End If
        End If
        Put (cship.lx, cship.y), sprites(20 * elmPerSpr), PSet 'clear spot
        Put (cship.x, cship.y), sprites(startframe + (frame * elmPerSpr)), PSet

        If framedir = 0 Then 'add to last frame
            If TimeIsUp(4, 1.1) Then frame = (frame + 1) Mod 6 'time frames
            If frame = 5 Then 'extra life hitting this frame
                headisup = true 'raise flag
                framedir = 1 'reverse frame direction
            End If
        Else 'subtract from last frame
            If TimeIsUp(4, 1.1) Then
                frame = (frame - 1) 'time frames
                headisup = false 'drop flag
            End If
            If frame = 0 Then framedir = 0 'reverse frame direction
        End If

        cship.lx = cship.x 'save for erase

        counter = (counter + 1) Mod 3 'slow down ship movement
        If counter = 2 Then cship.x = cship.x - 1 'move ship

        If cship.x <= 1 Then cship.health = false 'ship reached left limit

    ElseIf cship.health = false Then 'ship has gone off screen

        If initialize Then
            Put (cship.x, 1), sprites(20 * elmPerSpr), PSet 'remove ship
            bitbucket = TimeIsUp(3, 0) 'reset timers
            bitbucket = TimeIsUp(4, 0) 'ditto
            bitbucket = TimeIsUp(5, 0) 'ditto
            initialize = Not initialize 'to re-initialize ship
            framedir = 0 'reset frame direction
            DoScore (0) 'redraw score and lives
        End If
    End If

End Sub

Function DoExplode (x, y)

    Static frame

    ExplodeFrame = elmPerSpr * 17 'point to Explosion frames

    DoExplode = false

    Put (x, y), sprites(ExplodeFrame + (frame * elmPerSpr)), PSet ' dislplay it

    If TimeIsUp(3, .4) Then 'time each frame
        Put (x, y), sprites(ExplodeFrame + ((frame + 1) * elmPerSpr)), PSet ' dislplay it
        frame = (frame + 1) Mod 3 'calc next frame
        If frame = 0 Then DoExplode = true 'Did all frames
    End If






End Function

Sub DoGameEnd


    Pfont "Game Over", 125, 90, 190
    playsfx (sfx$(10))
    _Delay .005
    Do: Loop Until returnevent

    DoHighScores


    'CHAIN "qbinvade.exe"

    End

End Sub

Sub DoGunner

    If gunner.health Then

        'kbyte3 = _KeyHit
        Def Seg = &H0 'point to low memory
        kbyte1 = Peek(&H417) 'get keyboard byte status
        kbyte2 = Peek(&H418) 'ditto

        'If kbyte3 = 19712 Then
        If _KeyDown(19712) Then
            gunner.x = gunner.x + gunnervel 'move gunner
        End If

        If (kbyte1 And &H4) Then 'left ctrl key
            gunner.x = gunner.x + gunnervel 'move gunner                                'check Ctrl key
        End If

        'If kbyte3 = 19200 Then
        If _KeyDown(19200) Then
            gunner.x = gunner.x - gunnervel 'move gunner
        End If

        If (kbyte1 And &H8) Then 'alt key
            gunner.x = gunner.x - gunnervel 'move gunner
        End If


        If gunner.x > gunnerMaxx Then gunner.x = gunnerMaxx 'keep gunner in bounds
        If gunner.x < GunnerMinx Then gunner.x = GunnerMinx 'ditto

        If gunner.x <> gunner.lx Then 'gunner moved ?
            Put (gunner.lx, gunner.ly), sprites(gunner.ltile) 'erase old
            gunner.tile = ((gunner.tile + elmPerSpr) Mod NewAlienFrame) + gunner.sseg
            Put (gunner.x, gunner.y), sprites(gunner.tile), PSet 'draw new
            gunner.lx = gunner.x: gunner.ly = gunner.y 'for erase
            gunner.ltile = gunner.tile 'ditto
        End If

    Else 'gunner got hit


        If UseFX = true Then 'make hit noise
            playsfx (sfx$(8))
        Else
            soundfx (2)
        End If

        Do
            clearbuffer 'clear key buffer
            If DoExplode(gunner.x, gunner.y) Then 'show all frames ?
                Do: clearbuffer: Loop Until TimeIsUp(3, .7) 'wait a bit so user can get ready
                gunnerlives = gunnerlives - 1 'less one gun
                DoScore (0) 'redraw gun count
                If gunnerlives = 0 Then DoGameEnd 'any more guns ?
                For ab = 1 To Numberofbombs 'yes, then reset alien bombs
                    abomb(ab).health = 0 'kill bomb and remove it from screen
                    Line (abomb(ab).x, abomb(ab).y)-(abomb(ab).x, abomb(ab).y + abomb(ab).h), 0
                Next 'next alien bomb
                gunner.health = 1 'reset gunner health
                Put (gunner.x, gunner.y), sprites(gunner.tile), PSet 'put on screen
            End If
        Loop Until gunner.health = 1 ' all done

    End If


End Sub

Sub DoGunShot

    Static colour

    If gunshot.health = false Then 'Do gun shot
        If event = space Then 'fire shot ?
            gunshot.x = gunner.x + (gunner.w / 2) 'calc pos
            gunshot.y = gunner.y - 1
            gunshot.health = 1 'give it life
            gunshot.lx = gunner.x 'for erase
            gunshot.ly = gunner.y 'ditto
            'IF usefx THEN playsfx (sfx$(0))
        End If
    ElseIf gunshot.health = true Then 'animate it
        PSet (gunshot.lx, gunshot.ly), 0 'erase last
        Line -(gunshot.lx, gunshot.ly + gunshot.h), 0, BF 'ditto
        gunshot.y = gunshot.y - GunShotVel 'move shot

        If cship.health Then
            If gunshot.y < 1 Then gunshot.health = 0 'it's off screen
        Else
            If gunshot.y < spriteheight + 1 Then gunshot.health = 0
        End If
        If gunshot.health Then
            colour = ((colour + 1) Mod 16) + 48
            PSet (gunshot.x, gunshot.y), 0 'draw new
            Line -(gunshot.x, gunshot.y + gunshot.h), colour 'ditto
            gunshot.lx = gunshot.x: gunshot.ly = gunshot.y 'for erase
            _Delay .005
        End If
    End If



End Sub

Sub DoHighScores

    fc = 199

    Dim score(1 To 16) As highscores

    filespec$ = "qbvaders.scr"

    Open filespec$ For Random As #1 Len = 46 'open high score file
    For n = 1 To 15 'first to last
        Get #1, n, score(n) 'load it in
    Next n 'next entry
    Close #1 'close the file

    If Val(score(1).score) = 0 Then 'did file exist
        Open filespec$ For Random As #1 Len = 46 'create file
        For n = 1 To 15 'first to last
            Read a$, b$, c$, d$ 'read in data
            score(n).rank = a$ 'store it
            score(n).dat = b$ 'ditto
            score(n).nam = c$ 'ditto
            score(n).score = d$ 'ditto
            Put #1, n, score(n) 'write it
        Next n 'next entry
        Close #1 'close file
    End If


    Temp$ = LTrim$(Str$(gamescore&)) 'convert to clean string
    addpad = 6 - Len(Temp$) 'calc padding
    gamescor$ = Temp$ + String$(addpad, 32) 'add it

    For rank = 1 To 15 'find players rank
                                
        If gamescore& > Val(score(rank).score) Then 'make the list ?
            madelist = true 'setflag

            For bump = 14 To rank Step -1 'sort it
                score(bump + 1).dat = score(bump).dat 'bump ahead
                score(bump + 1).nam = score(bump).nam 'ditto
                score(bump + 1).score = score(bump).score 'ditto
            Next 'bump next
            month$ = Mid$(Date$, 1, 2) 'get month
            day$ = Mid$(Date$, 4, 2) 'get day
            year$ = Mid$(Date$, 9, 2) 'get year
            format$ = month$ + "/" + day$ + "/" + year$ 'format the date
            score(rank).dat = format$ 'store it
            score(rank).nam = Space$(14) 'blank name
            score(rank).score = gamescor$ 'store gamescore
            ShowHighScores score(), 1 'print the list
            y = (rank * 10) + 26 'calc y
            score(rank).nam = InputText$(93 + 8, y, 199) 'enter name
            Open filespec$ For Random As #1 Len = 46 'open file to save
            For n = 1 To 15 'first to last
                Put #1, n, score(n) 'write entry
            Next 'next entry
            Close #1 'close file
            Exit For 'all done
        End If
    Next

    If madelist = false Then ShowHighScores score(), 0




End Sub

Sub Dolevel

 
    Select Case level

        Case 1 To 5
            AlienStartY = (level * 7) + 20
            alienvelx = 1
            TimeToStep! = .5

        Case 6 To 11
            AlienStartY = 18
            alienvelx = (level - 6) + 1
            TimeToStep! = .5

        Case 12
            AlienStartY = 21
            alienvelx = alienvelx - 2

        Case 13 To 17
            AlienStartY = ((level - 14) * 7) + 20
            alienvelx = ((level - 14) + 1)
            TimeToStep! = .5

        Case 18 To 24
            AlienStartY = ((level - 18) * 7) + 20
            alienvelx = ((level - 18) + 2)
            TimeToStep! = .5

        Case 25
            AlienStartY = ((level - 25) * 7) + 20
            alienvelx = 7

        Case 26
            AlienStartY = ((level - 26) * 7) + 20
            alienvelx = 1
            TimeToStep! = .5
            level = 1

    End Select


End Sub

Sub DoScore (points)

    Static lgunnerlives, lTimeToStep!

    Select Case AliensInPLay
        Case 1: TimeToStep! = .01: If level = 25 Then TimeToStep! = 0!
        Case 4: TimeToStep! = .09
        Case 5 To 8: TimeToStep! = .15
        Case 9 To 22: TimeToStep! = .25
        Case 23 To 42: TimeToStep! = .5
    End Select

    If lTimeToStep! <> TimeToStep! Then
        Select Case AliensInPLay
            Case 1: alienvelx = alienvelx + 4
            Case 4: alienvelx = alienvelx + 1
            Case 9 To 22: alienvelx = alienvelx + 1
        End Select
    End If
    lTimeToStep! = TimeToStep!

    startframe = (30 * elmPerSpr) 'point to start of score frames
    xscore = 1: yscore = 1
    xstep = 20
    gamescore& = gamescore& + points


    If cship.health = false Then

        onedigit = (gamescore& \ 1) Mod 10
        tendigit = (gamescore& \ 10) Mod 10
        hdigit = (gamescore& \ 100) Mod 10
        tdigit = (gamescore& \ 1000) Mod 10
        ttdigit = (gamescore& \ 10000) Mod 10

        Put (xscore, yscore), sprites(startframe + (ttdigit * elmPerSpr)), PSet
        Put (xscore + xstep, yscore), sprites(startframe + (tdigit * elmPerSpr)), PSet
        Put (xscore + (xstep * 2), yscore), sprites(startframe + (hdigit * elmPerSpr)), PSet
        Put (xscore + (xstep * 3), yscore), sprites(startframe + (tendigit * elmPerSpr)), PSet
        Put (xscore + (xstep * 4), yscore), sprites(startframe + (onedigit * elmPerSpr)), PSet


        'gunnerlives = 10
        For lives = 1 To 10
            If lives >= gunnerlives Then
                Put (280 - gx, yscore), sprites(elmPerSpr * 20), PSet
            Else
                Put (280 - gx, yscore), sprites(gunner.tile), PSet
            End If
            gx = gx + xstep
        Next



    End If


End Sub

Sub EndToDos

    Dim buffer(1000)

    x1 = 130
    x2 = 190
    y1 = 90
    y2 = 102

    Get (x1, y1)-(x2, y2), buffer()

    Line (x1, y1)-(x2, y2), 120, BF
    Line (x1, y1)-(x2, y2), 123, B
    p5x7font x1 + 3, y1 + 3, "Quit? (y/n)", 1
    Do
        event = returnevent

        Select Case event
            Case 89, 121
                Exit Do
            Case 78, 110
                Put (x1, y1), buffer(), PSet
                Exit Sub
        End Select
    Loop
    'zero out adlib regs incase of hanging sounds
    For sfx = 11 To 19 'sounds effects 11 through 19 zero out all channels
        If UesFX Then playsfx (sfx$(sfx))
    Next


    Width 80
    Screen 0, 0, 0

    End

End Sub

Sub FadePal (fc, lc, level, mode)

    Static savepal() As Hues

    If mode Then 'fade in

        For value = 0 To level 'bring 'em all up
            Out &H3C8, fc 'tell video card to get ready
            For attrib = fc To lc 'first color to last color

                '        IF pal(attrib).red < savepal(attrib).red THEN pal(attrib).red = pal(attrib).red + 1
                '        IF pal(attrib).grn < savepal(attrib).grn THEN pal(attrib).grn = pal(attrib).grn + 1
                '        IF pal(attrib).blu < savepal(attrib).blu THEN pal(attrib).blu = pal(attrib).blu + 1

                Out &H3C9, pal(attrib).red 'send red component
                Out &H3C9, pal(attrib).grn 'send green component
                Out &H3C9, pal(attrib).blu 'send blue component

            Next attrib
            stay (10)
            clearbuffer
        Next value

    Else 'fade out

        ReDim savepal(255) As hues

        For attrib = 0 To 255
            savepal(attrib).red = pal(attrib).red 'save pal to restore
            savepal(attrib).grn = pal(attrib).grn 'ditto
            savepal(attrib).blu = pal(attrib).blu 'ditto
        Next

        For value = 0 To level
            Out &H3C8, fc 'tell video card to get ready

            For attrib = fc To lc 'first color to last color


                If pal(attrib).red > 0 Then pal(attrib).red = pal(attrib).red - 1
                If pal(attrib).grn > 0 Then pal(attrib).grn = pal(attrib).grn - 1
                If pal(attrib).blu > 0 Then pal(attrib).blu = pal(attrib).blu - 1

                Out &H3C9, pal(attrib).red 'send red component
                Out &H3C9, pal(attrib).grn 'send green component
                Out &H3C9, pal(attrib).blu 'send blue component

            Next attrib

            stay (10)
            clearbuffer
        Next value

    End If

End Sub

Sub GetReady


    Do
        clearbuffer
    Loop Until TimeIsUp(7, 1) 'wait a bit so user can get ready
    clearbuffer

    x1 = 130
    y1 = 80

    Do

        If TimeIsUp(5, .4) Then toggle = Not toggle
        If toggle Then
            p5x7font x1, y1, "Get Ready", 0
            p5x7font x1, y1 + 8, "Wave " + Str$(level), 0
     

        Else
            p5x7font x1, y1, "Get Ready", 190
            p5x7font x1, y1 + 8, "Wave " + Str$(level), 190
        End If

        If TimeIsUp(6, 4) Then Exit Do

    Loop Until returnevent = space

    p5x7font x1, y1, "Get Ready", 0
    p5x7font x1, y1 + 8, "Wave " + Str$(level), 0

End Sub

Sub InitGameStart

    '--* set up aliens

    AliensPerRow = 6 'eight max
    If Hard Then AliensPerRow = 8
    AliensPerCol = 6 'six max
    numberofaliens = (AliensPerRow * AliensPerCol)
    AliensInPLay = numberofaliens
    Dim alien(AliensInPLay) As sprite 'need storage
    AlienStepX = 35 'spaceing
    AlienStepY = 20 'ditto
    AlienStartX = 35 'position
    AlienStartY = 20
    alienvelx = 2 'velocity
    AlienVely = AlienStepY / 2 'ditto
    Cornerx = AlienStartX 'for adding steps
    Cornery = AlienStartY 'ditto
    AlienEndX = (AlienStepX * AliensPerRow) + AlienStartX 'calc end column
    NewAlienFrame = (elmPerSpr * 2) 'to skip animation frames


    '--*set up gunner 1
    gunnerlives = 6
    gunnerMaxx = Maxx - (20 * 4) 'set limits of movement
    GunnerMinx = (20 * 3) 'ditto
    GunnerY = Maxy - 14 'placement
    gunnervel = 1 'velocity
    gunner.x = gunnerMaxx - 18 'start position
    gunner.y = Maxy - 14 'ditto
    gunner.lx = gunner.x - 1 'force update
    gunner.ly = gunner.y 'ditto
    gunner.w = spritewidth 'gunner width
    gunner.h = spriteheight 'gunner height
    gunner.health = 1 'set health
    gunner.sseg = elmPerSpr * 14 'pointer to image
    gunner.tile = elmPerSpr * 14 'offset to frame
    gunner.ltile = elmPerSpr * 14 'for erase

    '--* set up gunshots
    gunshot.w = 1
    gunshot.h = 4
    gunshot.health = 0
    GunShotVel = 2

    '--* set up alien bombs
    Numberofbombs = 3
    Dim abomb(Numberofbombs) As sprite
    For ab = 1 To Numberofbombs
        abomb(ab).w = 1
        abomb(ab).h = 4
        abomb(ab).health = 0
    Next
    Abombvel = 1
    AbombInterval! = .2

    '--* set up shields

    NumberofShields = 3
    Dim shield(NumberofShields) As sprite
    shield(1).x = 80
    shield(1).y = 170
    shield(2).x = 150
    shield(2).y = 170
    shield(3).x = 220
    shield(3).y = 170
    For s = 1 To NumberofShields
        shield(s).w = 20
        shield(s).h = 14
    Next

    '--* set up barriers

    Dim Barrier(2) As sprite
    Barrier(1).x = GunnerMinx - spritewidth
    Barrier(1).y = GunnerY
    Barrier(1).tile = elmPerSpr * 12
    Barrier(2).x = gunnerMaxx + spritewidth
    Barrier(2).y = GunnerY
    Barrier(2).tile = elmPerSpr * 13


    Put (Barrier(1).x, Barrier(1).y), sprites(Barrier(1).tile), PSet
    Put (Barrier(2).x, Barrier(2).y), sprites(Barrier(2).tile), PSet

    DoScore (0) 'display score


End Sub

Sub Initlevel

    Dolevel
    '--* reset alien bombs
    For ab = 1 To Numberofbombs 'Do alien bombs
        abomb(ab).health = 0 'reset em
        Line (abomb(ab).lx, abomb(ab).ly)-(abomb(ab).lx, abomb(ab).ly + abomb(ab).h), 0
        Line (abomb(ab).x, abomb(ab).y)-(abomb(ab).x, abomb(ab).y + abomb(ab).h), 0
    Next
    '--* reset barriers
    Put (shield(1).x, shield(1).y), sprites(elmPerSpr * 21), PSet
    Put (shield(2).x, shield(2).y), sprites(elmPerSpr * 22), PSet
    Put (shield(3).x, shield(3).y), sprites(elmPerSpr * 23), PSet
    '--* reset gunner1
    Put (gunner.x, gunner.y), sprites(20 * elmPerSpr), PSet
    gunner.x = gunnerMaxx - 18
    gunner.lx = gunner.x
    Put (gunner.x, gunner.y), sprites(gunner.tile), PSet
    '--* reset aliens
    AliensInPLay = numberofaliens
    movealiens = true 'so aliens appear
    Cornerx = AlienStartX 'for adding steps
    Cornery = AlienStartY 'ditto
    AlienEndX = (AlienStepX * AliensPerRow) + AlienStartX 'calc end column
    NewAlienFrame = (elmPerSpr * 2) 'to skip animation frames
    NextChar = 0
    NextFrame = 0
    For a = 1 To numberofaliens 'initilaize aliens
        alien(a).x = Cornerx 'position
        alien(a).y = Cornery 'ditto
        alien(a).lx = Cornerx 'ditto
        alien(a).ly = Cornery 'ditto
        alien(a).w = spritewidth 'size
        alien(a).h = spriteheight 'ditto
        alien(a).dir = 1 'walk towards left
        alien(a).health = 1 'make alive
        alien(a).sseg = NextChar 'pointer to images
        alien(a).tile = NextChar 'offset to frame
        alien(a).ltile = NextChar 'for erase
        NextFrame = (NextFrame + elmPerSpr) Mod NewAlienFrame 'calc next frame
        Cornerx = Cornerx + AlienStepX 'next column
        If Cornerx = AlienEndX Then 'last in row
            Cornerx = AlienStartX 'reset column
            Cornery = Cornery + AlienStepY 'next row
            NextChar = NextChar + (NewAlienFrame) 'next char
        End If
    Next


End Sub

Function InputText$ (xcur, ycur, length)

    PalRegInfo 255, red, 0, 0, 1 'define cursor color
    Dim Edit$(length) 'DIM array to edit
    ele = 1 'set first element
    Dim background(35, length + 2) 'DIM array to save background
    Get (xcur, ycur)-(xcur + 6, ycur + 8), background(35, 1) 'GET background
    p5x7font xcur, ycur, "_", 255 'init curser


    clearbuffer 'clear the keybuffer

    Do

        Do 'event loop
            event = returnevent 'anything happen ?
            If dir = 0 Then 'strobe cursor
                red = red + 1: If red > 62 Then dir = 1 'ditto
            Else 'ditto
                red = red - 1: If red < 10 Then dir = 0 'ditto
            End If 'ditto
            Palette 255, (65536 * blu) + (256 * grn) + red 'ditto
        Loop Until event 'back for event

        Select Case event

            Case Esc: Exit Do 'do Esc
            Case Enter: Exit Do 'do enter

            Case 1 To 7, 9 To 126 'do regular keys
                event$ = Chr$(event) 'convert for printing
                If ele < length Then 'stay in bounds
                    Put (xcur, ycur), background(35, ele), PSet
                    p5x7font xcur, ycur, Chr$(event), 191 'print font
                    Edit$(ele) = event$ 'in case of backspace
                    Select Case event$ 'adjust kern
                        Case "i": xcur = xcur + 2 'ditto
                        Case "j": xcur = xcur + 5 'ditto
                        Case "l": xcur = xcur + 2 'ditto
                        Case "r": xcur = xcur + 5 'ditto
                        Case ".": xcur = xcur + 3 'ditto
                        Case "(": xcur = xcur + 3 'ditto
                        Case ")": xcur = xcur + 3 'ditto
                        Case "'": xcur = xcur + 2 'ditto
                        Case "!": xcur = xcur + 2 'ditto
                        Case Else: xcur = xcur + 6 'ditto
                    End Select
                    ele = ele + 1 'advance to next element
                    Get (xcur, ycur)-(xcur + 6, ycur + 8), background(35, ele)
                    p5x7font xcur, ycur, "_", 255 'print cursor
                End If

            Case Backspace, Left 'do backspace
                         
                If ele > 1 Then
                    Put (xcur, ycur), background(35, ele), PSet 'restore background
                    ele = ele - 1 'move to previous element
                    Select Case (Edit$(ele)) 'adjust kern
                        Case "i": xcur = xcur - 2 'ditto
                        Case "j": xcur = xcur - 5 'ditto
                        Case "l": xcur = xcur - 2 'ditto
                        Case "r": xcur = xcur - 5 'ditto
                        Case ".": xcur = xcur - 3 'ditto
                        Case "(": xcur = xcur - 3 'ditto
                        Case ")": xcur = xcur - 3 'ditto
                        Case "'": xcur = xcur - 2 'ditto
                        Case "!": xcur = xcur - 2 'ditto
                        Case Else: xcur = xcur - 6 'ditto
                    End Select
                    Put (xcur, ycur), background(35, ele), PSet
                    p5x7font xcur, ycur, "_", 255 'print cursor
                    Edit$(ele) = Chr$(space) 'clear element
                End If
        End Select

    Loop

    For n = 1 To length - 1 'put elements into a string
        If Edit$(n) = "" Then Edit$(n) = Chr$(space) 'replace nulls
        Temp$ = Temp$ + Edit$(n) 'create string
    Next n

    InputText$ = Temp$ 'return the string

End Function

Sub p5x7font (x, y, text$, colour)

    length = Len(text$) 'get characters to print
    If length = 0 Then Exit Sub 'check length

    For char = 0 To length - 1 'print loop

        piece$ = Mid$(text$, char + 1, 1) 'look at each piece of string
        aski = Asc(piece$) 'assign it's ASCII value

        Select Case (piece$) 'adjust lower case
            Case "g": kerny = kerny + 2 'ditto
            Case "j": kerny = kerny + 2 'ditto
            Case "p": kerny = kerny + 2 'ditto
            Case "q": kerny = kerny + 2 'ditto
            Case "y": kerny = kerny + 2 'ditto
        End Select

        For ybit = 0 To 6 'top to Bottom
            For xbit = 0 To 4 'left to right
                If font(aski, xbit, ybit) = 1 Then 'set bits only
                    PSet (x + xbit + kernx, y + ybit + kerny), colour 'PSET data
                End If
            Next
        Next

        Select Case (piece$) 'kern adjusment
            Case "i": kernx = kernx + 2 'ditto
            Case "j": kernx = kernx + 5 'ditto
            Case "l": kernx = kernx + 2 'ditto
            Case "r": kernx = kernx + 5 'ditto
            Case ".": kernx = kernx + 3 'ditto
            Case "(": kernx = kernx + 3 'ditto
            Case ")": kernx = kernx + 3 'ditto
            Case "'": kernx = kernx + 2 'ditto
            Case "!": kernx = kernx + 2 'ditto
            Case Else: kernx = kernx + 6 'ditto
        End Select

        kerny = 0 'reset

    Next

End Sub

Sub PalRegInfo (reg, red, grn, blu, mode)
    Select Case mode
        Case 0 'get individual palette register
            Out &H3C7, reg 'tell video card which register
            red = Inp(&H3C9) 'get red component
            grn = Inp(&H3C9) 'get green component
            blu = Inp(&H3C9) 'get blue component
        Case 1 'set individual palette register
            Out &H3C8, reg 'tell video card which register to change
            Out &H3C9, red 'send red component
            Out &H3C9, grn 'send green component
            Out &H3C9, blu 'send blue component
    End Select
End Sub

Sub Pfont (text$, x, y, colour)


    Def Seg = &HFFA6
    For piece = 1 To Len(text$)
        address = (8 * Asc(Mid$(text$, piece))) + 14
        For hl = 0 To 7
            mask = Peek(address + hl) * 128
            Line (x + kernx, y + hl)-(x + 8 + kernx, y + hl), colour, , mask
        Next
        kernx = kernx + 8
    Next
    'x = 0
    Def Seg

End Sub

Sub playsfx (sfx$)

    'plays an sfx$ that is sent to it.
    'sub expects the c$() array (channel info) to be global

    chan% = Val(Mid$(sfx$, 61, 4))
    For in = 1 To 60 Step 4
        reg$ = Mid$(c$(chan%), in, 4): reg% = Val(reg$)
        dat$ = Mid$(sfx$, in, 4): dat% = Val(dat$)
        Out &H388, reg%: For d% = 1 To 6: b% = Inp(&H388): Next
        Out &H389, dat%: For d% = 1 To 35: b% = Inp(&H388): Next
    Next

End Sub

Function returnevent


    kee$ = InKey$
    If kee$ <> "" Then
        If Len(kee$) = 1 Then
            keycode = Asc(kee$)
        Else
            keycode = -Asc(Right$(kee$, 1))
        End If
    End If


    returnevent = keycode

End Function

Sub ShowHighScores (score() As highscores, mode)

    fc = 199
    Cls

    FadePal 16, 255, 23, 0


    alien = Int(Rnd * 12)

    For x = 1 To 300 Step 20
        For y = 1 To 186 Step 14
            Put (x, y), sprites(elmPerSpr * alien), PSet
        Next
    Next



    p5x7font 96, 17, "Invader Hall of Fame", 19
    p5x7font 96, 16, "Invader Hall of Fame", 7

    placey = 35
    shadow = 1

    For a = 1 To 15
        p5x7font 20 + 8 - shadow, placey + shadow, score(a).rank, 19
        p5x7font 38 + 8 - shadow, placey + shadow, score(a).dat, 19
        p5x7font 93 + 8 - shadow, placey + shadow, score(a).nam, 19
        p5x7font 240 + 8 - shadow, placey + shadow, score(a).score, 19
        p5x7font 20 + 8, placey, score(a).rank, 191
        p5x7font 38 + 8, placey, score(a).dat, 29
        p5x7font 93 + 8, placey, score(a).nam, 191
        p5x7font 240 + 8, placey, score(a).score, 29
        placey = placey + 10 ' drop y to a new line
    Next a

    If mode Then Exit Sub


    Do

        If TimeIsUp(6, 120) Then Exit Do
        event = returnevent
    Loop Until event



End Sub

Sub soundfx (fx)

    Select Case fx

        Case 1 'step sound

            Sound 60, .1
 
        Case 2 'gunner hit

            For freq! = 160 To 60 Step -10
                duration! = freq! / 100
                Sound freq!, duration!
            Next

        Case 3 'alien bomb hiting gunshot
                                 
            Sound 1160, .1

        Case 4 ' gunshot hit alien
    
            Play "MB" + "O0" + "L64" + "A" + "B" + "C" + "B" + "C" + "A"

        Case 5

            For freq! = 200 To 60 Step -8
                stay (10)
                Sound freq!, .1
            Next

        Case 6 'hit command ship

            Play "MB" + "O1" + "L20" + "G" + "G" + "G "

        Case 7
            'hit command ship with head up
            Play "MB" + "O2" + "L30" + "C" + "D" + "E " + "F"

        Case 8

            play$ = "C" + "D" + "E" + "F" + "G" + "F" + "E" + "D"
            Play "MB" + "O0" + "L40" + play$

    End Select



End Sub

DefSng A-Z
Sub stay (Millisecs!)

    Static Syspeed&, Time2

    If Syspeed& Then ' First time here -get relative system speed

        If Millisecs Then ' Start Delay loop

            factor& = (Syspeed& * Millisecs) \ 55 'num of loops needed

            If factor& < 1 Then Exit Sub
            Do ' delay loop
                factor& = factor& - 1 ' Sub the num of loops
            Loop Until Time2 = Peek(&H6C) Or factor& = 0 ' make loop same as below

        End If
    Else ' Relative system speed processed here

        Def Seg = &H40
        Time1 = Peek(&H6C)

        Do
            Time2 = Peek(&H6C) ' get another
        Loop Until Time1 <> Time2 ' loop until new clock tick


        Do ' start here at new clock tick
            Syspeed& = Syspeed& - 1 ' Count the number of times looped
        Loop Until Time2 <> Peek(&H6C) Or Syspeed& = 0 'make same as loop above
        Time2 = 1255
        Syspeed& = Abs(Syspeed&) 'cant use this neg -reverse it



    End If



End Sub

DefInt A-Z
Function TimeIsUp (n, tsecs!)


    ' Poll this function to check for passage of time. When the amount of
    ' time in tsecs has passed timeisup() returns TRUE, otherwise the function
    ' returns false.
    ' Initialize this routine with tsecs! = -1 and n = to the number
    ' of timers to set up.

    Static getclock(), oldtsecs!(), Time1!()

    If tsecs! = -1 Then ' initialize timers
        Dim getclock(n)
        Dim oldtsecs!(n)
        Dim Time1!(n)
    End If


    If tsecs! <> oldtsecs!(n) Then getclock(n) = 0

    If getclock(n) = 0 Then
        Time1!(n) = Timer
        getclock(n) = 1
        oldtsecs!(n) = tsecs!
    Else
        If Abs(Timer - Time1!(n)) >= tsecs! Then
            TimeIsUp = 1
            getclock(n) = 0
        Else
            TimeIsUp = 0
        End If
    End If



End Function

Sub TitleScreen


    text$ = "QB Invaders"

    For alien = 0 To 7 Step 2 'select alien to pull title
        If Int(Rnd * 11) = 5 Then Exit For
    Next


    For x = 300 To 95 Step -1
        counter = (counter + 1) Mod 6
        If counter = 2 Then frame = (frame + 1) Mod 2
        Put (lx, 90), sprites(elmPerSpr * 20), PSet 'erase last
        p5x7font lx + 20, 90, text$, 0
        event = returnevent
        If event Then Exit For
        Put (x, 90), sprites((alien + frame) * elmPerSpr), PSet
        p5x7font x + 20, 90, text$, 155
        lx = x
        _Delay .05
        Do: Loop Until Inp(&H3DA) And 8 'wait for VGA retrace
    Next


    Put (95, 90), sprites((alien + frame) * elmPerSpr), PSet
    _Delay 1
    event = 0
    If event = 0 Then FadePal 140, 187, 60, 1
    p5x7font 95 + 20, 90, text$ + " Ver 1.0", 155
    p5x7font 78, 120, "Atari graphics by John Denesha", 155
    p5x7font 69, 130, "Other graphics by Timothy Truman", 187
    p5x7font 79, 140, "Program Author Timothy Truman", 187
    p5x7font 59, 160, "Copyright (c) 1997 Nocturnal Creations", 170
    _Delay 2
    If event = 0 Then FadePal 154, 154, 60, 1


    'If event = 0 Then FadePal 154, 154, 60, 0
    p5x7font 65, 40, "Use right and left keys to move", 154
    p5x7font 100, 50, "Use Space bar to fire", 154
    p5x7font 130, 60, "Esc to Quit", 154

    _Delay 2

    'If event = 0 Then FadePal 154, 154, 60, 1


    Do
        Do: Loop Until Inp(&H3DA) And 8 'wait for VGA retrace
        If TimeIsUp(3, 1) Then cship.health = true
        DocommandShip
        event = returnevent
        If event = Esc Then
            EndToDos
            event = 0
        End If
    Loop Until event

    cship.health = false
    Cls

End Sub

