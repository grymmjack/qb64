Option _Explicit
' Lost in the Jungle: a silly little survival game.
' 2023-08-10 Felix PleÅŸoianu <https://felix.plesoianu.ro/>
' Use as you like, and enjoy!

' port to QB64pe b+ 2023-08-14

_Title "Lost in Jungle - port felixp7 port to FB to QB64pe"
Randomize Timer
Dim Shared nl$: nl$ = Chr$(10)
Dim Shared fatigue: fatigue = 0.0
Dim Shared health: health = 5.0
Dim Shared bullets: bullets = 6

Dim Shared skill: skill = 0.15
Dim Shared distance: distance = 50.0
Dim Shared hours: hours = 0

Dim Shared chances(0 To 7)

Print "You survived the plane crash."
Print
Print "With all your gear intact, too:"
Print
Print "Gun, knife, compass, lighter."
Print
Print "But you have no food or water."
Print
Print "And a big bad jungle to cross."

Dim GameMenu$(1 To 3)
GameMenu$(1) = "Play"
GameMenu$(2) = "Help"
GameMenu$(3) = "Quit"
again:
Select Case menu&(GameMenu$())
    Case 1: startGame: playGame
    Case 2: Print: help: GoTo again
    Case 3: Print: Print "See you around!"
End Select

Print: Print "(press any key)"
Sleep
Sub startGame
    fatigue = 0.0
    health = 5.0
    bullets = 6

    skill = 0.15
    distance = 45 + Int(Rnd * 11)
    hours = 0
    Dim i
    For i = 0 To 7
        chances(i) = 0.0
    Next
End Sub

Function tiredness$ (fatigue, health)
    Dim energy
    energy = health - fatigue
    If energy <= 1 Then
        tiredness$ = "drained"
    ElseIf energy <= 3 Then
        tiredness$ = "tired"
    Else
        tiredness$ = "fresh"
    End If
End Function

Function healthLevel$ (health)
    If health < 2 Then
        healthLevel$ = "bad"
    ElseIf health < 4 Then
        healthLevel$ = "decent"
    Else
        healthLevel$ = "good"
    End If
End Function

Sub setStatus (status1 As String, status2 As String)
    Cls
    status1 = "In " + healthLevel$(health) + " health; " + tiredness$(fatigue, health) + nl$ + _
    "  Bullets:" + Str$(bullets) + nl$ + "  Time:" + Str$(hours) + " hrs." + nl$
    If distance >= 35 Then
        status2 = " Can't see the sky for the forest canopy."
    ElseIf distance >= 15 Then
        status2 = " Shafts of sunlight mark the path ahead."
    Else
        status2 = " The trees are growing farther apart now."
    End If
End Sub

Function menu& (options() As String)
    Print
    Dim i
    For i = LBound(options) To UBound(options)
        Print i; ") "; options(i)
    Next
    Print
    Dim result As Long
    Do
        Input ; result
    Loop Until result >= LBound(options) And result <= UBound(options)
    Print
    menu& = result
End Function

Sub noEncounter
    Print " Around you, the jungle looms."
    Dim QuietMenu$(1 To 2)
    QuietMenu$(1) = "March on"
    QuietMenu$(2) = "Get some rest"
    Select Case menu&(QuietMenu$())
        Case 1: doWalk
        Case 2: doRest
    End Select
End Sub

Sub doWalk
    If fatigue >= health Then
        Print "You can't take another step."
        doRest
    Else
        Dim walked
        walked = health - fatigue
        distance = distance - walked
        fatigue = fatigue - 1
        hours = hours + 1
        If walked <= 1 Then
            Print "You crawl along tiredly."
        ElseIf walked <= 3 Then
            Print "You march on, making steady progress."
        Else
            Print "You advance quickly for now..."
        End If
    End If
End Sub

Sub doRest
    hours = hours + 1

    If health < 5 Then
        health = health + 0.5
        If health > 5 Then health = 5
        If fatigue >= health Then
            fatigue = fatigue - 1
        Else
            fatigue = fatigue - 0.5
        End If
        If fatigue < 0 Then fatigue = 0
        Print "You rest and heal a little."
    Else
        If fatigue >= health Then
            fatigue = fatigue - 2
        Else
            fatigue = fatigue - 1
        End If
        If fatigue < 0 Then fatigue = 0
        Print "You get some good rest."
    End If
    Select Case Rnd
        Case Is < 0.15
            Print "But while you were sleeping..." ' what is !"But
            fightMonkeys
        Case Is < 0.3
            Print "But while you were sleeping..." ' what is !"But
            itsVenomous
    End Select
End Sub

Sub findWater
    Print "You find a pool of water."
    Dim water_menu(1 To 2) As String
    water_menu(1) = "Drink some"
    water_menu(2) = "Leave it"
    Select Case menu&(water_menu())
        Case 1: drinkWater
        Case 2: noDrinking
    End Select
End Sub

Sub drinkWater
    fatigue = fatigue - 2
    If fatigue < 0 Then fatigue = 0
    Print "The water is cool. You feel refreshed."
    If Rnd >= skill Then
        Print "But drinking from the pool soon makes you ill."
        Print "At least you learn the signs better."
        health = health - 1
        skill = skill + 0.05
    End If
End Sub

Sub noDrinking
    Print "Better not chance taking a drink at this time."
End Sub

Sub findFruit
    Print "You find strange fruit."
    Dim fruit_menu(1 To 2) As String
    fruit_menu(1) = "Eat some"
    fruit_menu(2) = "Leave it"
    Select Case menu&(fruit_menu())
        Case 1: eatFruit
        Case 2: noEating
    End Select
End Sub

Sub eatFruit
    health = health + 1
    If health > 5 Then health = 5
    Print "The fruit is tasty. You recover some strength."
    If Rnd >= skill Then
        Print "But soon after eating it you feel drowsy."
        Print "At least you learn the signs better."
        fatigue = fatigue + 2
        skill = skill + 0.05
    End If
End Sub

Sub noEating
    Print "Better not chance taking a bite at this time."
End Sub

Sub huntGame
    Dim critter(0 To 2) As String
    critter(0) = "A small herbivore"
    critter(1) = "Some large rodent"
    critter(2) = "A flightless bird"
    Dim action(0 To 1) As String
    action(0) = " hears your steps and bolts."
    action(1) = " stumbles out of the bushes."
    Dim hunt_menu(1 To 3) As String
    hunt_menu(1) = "Shoot it"
    hunt_menu(2) = "Run after it"
    hunt_menu(3) = "Just move on"

    Print critter(Int(Rnd * 3)); action(Int(Rnd * 2))
    Select Case menu&(hunt_menu())
        Case 1: shootGame
        Case 2: chaseGame
        Case 3: ignoreGame
    End Select
End Sub
Sub shootGame

    If bullets < 1 Then
        Print "Click! Click! No more bullets..."
        Print "The lucky creature soon vanishes."
    Else
        bullets = bullets - 1
        Print "You carefully take aim and... BANG!"
        eatGame
    End If
End Sub

Sub chaseGame
    If fatigue >= health Then
        Print "You're too tired to give chase."
    ElseIf Rnd < skill Then
        fatigue = fatigue + 1
        Print "You hunt it down and catch it."
        eatGame
    Else
        fatigue = fatigue + 1
        skill = skill + 0.05
        Print "You chase after it, but it's too fast."
        Print "At least you learn new tricks."
    End If
End Sub

Sub eatGame
    hours = hours + 1
    health = health + 2
    If health > 5 Then health = 5
    Print "Poor critter is tasty roasted on a tiny fire."
    Print "You recover much of your strength."
End Sub

Sub ignoreGame
    Print "You decide against playing hunter right now."
End Sub

Sub fightMonkeys
    Print "Screaming monkeys come out of nowhere to harass you!"
    Dim monkey_menu(1 To 3) As String
    monkey_menu(1) = "Shoot at them"
    monkey_menu(2) = "Look scary"
    monkey_menu(3) = "Run away"
    Select Case menu&(monkey_menu())
        Case 1: shootMonkeys
        Case 2: scareMonkeys
        Case 3: runAway
    End Select
End Sub

Sub shootMonkeys
    If bullets < 1 Then
        Print "Click! Click! No more bullets..."
        getMauled
    Else
        bullets = bullets - 1
        Print "BANG! Your bullet goes crashing through the foliage."
        Print "The monkeys scatter, shrieking even more loudly."
    End If
End Sub

Sub scareMonkeys
    Print "You shout and wave a branch, trying to look bigger."
    If Rnd < skill Then
        Print "The monkeys laugh mockingly at you as they scatter."
    Else
        skill = skill + 0.05
        Print "It doesn't seem to be working very well at all."
        getMauled
    End If
End Sub

Sub getMauled
    health = health - 2
    Print "A rain of kicks and bites descends upon you!"
    Print "At long last, the monkeys scatter, shrieking."
End Sub

Sub runAway
    hours = hours + 1
    fatigue = fatigue + 1 ' Should be less bad than what we're risking.
    Print "You run away blindly, until your lungs burn."
    Print "The chorus of shrieks slowly remains behind."
End Sub

Sub itsVenomous
    Dim crawlie(0 To 2) As String
    crawlie(0) = "giant centipede"
    crawlie(1) = "big hairy spider"
    crawlie(2) = "colorful snake"
    Print "A "; crawlie(Int(Rnd * 3)); " falls on you from above!"
    Dim crawlie_menu(1 To 2) As String
    crawlie_menu(1) = "Remove it carefully"
    crawlie_menu(2) = "Stand still"
    Select Case menu&(crawlie_menu())
        Case 1: removeCrawlie
        Case 2: waitOutCrawlie
    End Select
End Sub

Sub removeCrawlie
    If Rnd < skill Then
        Print "The crawlie wriggles wetly in your grasp. Yuck!"
    Else
        skill = skill + 0.05
        health = health - 1.5
        Print "You carefully try to pick up the crawlie, but... OW!"
        Print "It bites! You're poisoned. Burns pretty badly, too."
    End If
    Print "At least it's gone now. Hopefully."
End Sub

Sub waitOutCrawlie
    hours = hours + 1
    fatigue = fatigue + 1 ' Should be less bad than what we're risking.
    Print "You wait tensely for what seems like hours."
    Print "In the end, it's gone, and you're sweating."
End Sub

Sub findRuins
    Print "You discover ancient ruins..."
    Dim ruins_menu(1 To 3) As String
    ruins_menu(1) = "Rest here"
    ruins_menu(2) = "Search the place"
    ruins_menu(3) = "Just move on"
    Select Case menu&(ruins_menu())
        Case 1: restAtRuins
        Case 2: searchRuins
        Case 3: leaveRuins
    End Select
End Sub

Sub restAtRuins
    fatigue = fatigue - 1
    If fatigue < 0 Then fatigue = 0
    health = health + 1
    If health > 5 Then health = 5
    hours = hours + 2
    Print "You sleep undisturbed for once, before moving on."
End Sub

Sub searchRuins
    hours = hours + 1
    Select Case Rnd
        Case Is < 0.3
            skill = skill + 0.05
            Print "You find old inscriptions teaching about the jungle."
        Case Is < 0.6
            Print "You find gold and diamonds. Not much use right now."
        Case Else
            Print "You find nothing of interest this time around."
    End Select
End Sub

Sub leaveRuins
    hours = hours + 1
    fatigue = fatigue + 1
    distance = distance - 3 ' Not too much, because it's for free.
    Print "You march on, emboldened, covering a good distance."
End Sub


Sub reachSwamp
    Print "A vast swamp bars your way."
    Dim swamp_menu(1 To 2) As String
    swamp_menu(1) = "Risk a crossing"
    swamp_menu(2) = "Go around it"
    Select Case menu&(swamp_menu())
        Case 1: crossSwamp
        Case 2: avoidSwamp
    End Select
End Sub

Sub crossSwamp
    If Rnd < skill Then
        Print "Somehow you navigate the maze more or less safely."
    Else
        ' Probably too harsh since you get tired either way.
        ' fatigue++;
        health = health - 1
        skill = skill + 0.05
        Print "Mud pulls at your feet, and you nearly drown once."
        Print "Mosquitos besiege you; their bites make you ill."
    End If
    hours = hours + 1
    fatigue = fatigue + 1
    distance = distance - 5
    Print "It's a scary shortcut to take, but it saves a lot of travel."
End Sub

Sub avoidSwamp
    fatigue = fatigue + 1.5 ' Should be bad, but not too bad.
    hours = hours + 2
    Print "A long, tiresome detour. Safe, but no closer to your goal."
End Sub

Sub triggerPlant
    Print "Creeping vines entangle your limbs and drag you down."
    Print "Oh no! It's a man-eating mandragore, and it's hungry!"
    Dim plant_menu(1 To 3) As String
    plant_menu(1) = "Shoot it"
    plant_menu(2) = "Wrestle free"
    plant_menu(3) = "Cut the vines"
    Select Case menu&(plant_menu())
        Case 1: shootPlant
        Case 2: wrestlePlant
        Case 3: cutPlant
    End Select
End Sub

Sub shootPlant
    If bullets < 1 Then
        Print "Click! Click! No more bullets..."
        getChewedOn
    Else
        bullets = bullets - 1
        Print "BANG! You hit the plant's smelly flower dead center."
        Print "It wilts away with a horrible squelching sound."
    End If
End Sub

Sub wrestlePlant
    Dim energy
    energy = (health - fatigue) * 2 / 10
    If Rnd < energy Then
        Print "You vigorously pull at the vines, breaking a few."
        Print "The plant soon decides to wait for easier prey."
    Else
        Print "You pull tiredly at the vines. It's not enough."
        getChewedOn
    End If
    fatigue = fatigue + 1
End Sub

Sub cutPlant
    fatigue = fatigue + 1
    If Rnd < skill Then
        Print "You expertly hack at the vines with your knife."
        Print "The plant soon decides to wait for easier prey."
    Else
        skill = skill + 0.05
        Print "You clumsily hack at the vines with your knife."
        getChewedOn
    End If
End Sub

Sub getChewedOn
    health = health - 1
    Print "The plants chews on you with its toothless maw,";
    Print " burning you with digestive juices before you escape."
End Sub

'dim shared encounters(0 to 7) as sub = { _
'        @findWater, @findFruit, @huntGame, @fightMonkeys, _
'        @itsVenomous, @findRuins, @reachSwamp, @triggerPlant}

Sub pickEncounter
    Dim i
    For i = 0 To 7
        If Rnd < chances(i) Then
            chances(i) = chances(i) / 5
            Select Case i
                Case 0: findWater
                Case 1: findFruit
                Case 2: huntGame
                Case 3: fightMonkeys
                Case 4: itsVenomous
                Case 5: findRuins
                Case 6: reachSwamp
                Case 7: triggerPlant
            End Select
            'return encounters(i)
        Else
            chances(i) = chances(i) + 0.05
        End If
    Next
    noEncounter
End Sub

Sub playGame
    While health > 0 And distance > 0
        Dim status1 As String, status2 As String
        setStatus status1, status2
        Print status1; status2;
        pickEncounter
        'encounter()
    Wend

    If health <= 0 Then
        Print "You died in the jungle, after ";
        Print hours; " hours of struggle."
        Print "No more than "; distance; "km away from safety."
        If bullets = 6 Then
            Print "Without as much as firing a single bullet."
        End If
        Print "Oh well, better luck next time."
    ElseIf distance <= 0 Then
        Print "At last, the trees open up. You see a village. Saved!"
        Print "Unless it's a hostile tribe? Just kidding. You win!"
        Print "(In "; hours; " hours, with ";
        Print bullets; " bullets left.)"
    Else
        Print "Game ended abnormally."
    End If
End Sub

Sub help
    Print "The goal is to cross the 50Km or so separating you from safety."
    Print "The exact distance varies every time you play."
    Print
    Print "Advance in the game by marching on whenever you get the chance."
    Print "But you have to balance your health and fatigue."
    Print
    Print "The worse your health, the easier you get tired."
    Print "It's not possible to die from exhaustion."
    Print
    Print "But being tired all the time will hold you up,"
    Print "allowing more dangers to catch up with you and sap your health."
    Print
    Print "Hope this helps. Enjoy!"
End Sub