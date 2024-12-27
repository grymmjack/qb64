'Lamonade Stand Unlimited
'December 4, 2024
'This is the 3rd version of Lemonade Stand that I've made.
'Thank you to https://www.pexels.com/ for the photos.
'Thank you also to the QB64pe Forum for the inspiration.
'Which is here: https://qb64phoenix.com/forum/index.php

Dim day As Double
Dim money As Double
Dim l2 As Double
Dim ll2 As Double
Dim gallons As Double
Dim pallets As Double
Dim totalpal As Double
Dim pallets2 As Double
Dim totalpal2 As Double
Dim semis As Double
Dim totalsemi As Double
Dim semis2 As Double
Dim totalsemi2 As Double
Dim cups As Double
Dim signs As Double
Dim weblevel As Double
Dim weblevel2 As Double
Dim buyinternetad As Double
Dim internetad As Double
Dim standsize As Single
Dim menu1 As Single
Dim people As Double
Dim drinks As Long
Dim buycups As Double
Dim totalcups As Double
Dim buygallons As Double
Dim signs2 As Double
Dim image&

start:

day = 1
money = 50
gallons = 5
cups = 90
signs = 1
weblevel = 0
internetad = 0
standsize = 1

_Title "Lemonade Stand Unlimited - by SierraKen"

Screen _NewImage(800, 600, 32)
Cls
filename$ = "pics/stand1.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 3
Cls
Print: Print: Print: Print: Print
Print "                                     Lemonade Stand Unlimited"
Print
Print "                                          By SierraKen"
Print: Print: Print
Print "                         This is a lemonade stand simulator game to"
Print "                         see how much money you can make during"
Print "                         different circumstances that keep changing."
Print
Print "                         You start out with $50, 5 gallons of lemonade,"
Print "                         90 cups, and 1 sign."
Print: Print
Print "                         You can save your game and come back at any time."
Print: Print
Print "                         If your game gets over a trillion dollars, you win!"
Print: Print: Print: Print
Print "                         Thank you to https://www.pexels.com/ for the photos."
Print "                         Thank you also to the QB64pe Forum for the inspiration."
Print "                         Which is here: https://qb64phoenix.com/forum/index.php"
Print: Print: Print: Print: Print: Print
Input "                                   Press Enter To Begin.", a$

Randomize Timer

Do
    Cls
    GoSub weather:
    menu:
    If weather$ = "Sunny" Then filename$ = "pics/sunny.jpg"
    If weather$ = "Rainy" Then filename$ = "pics/rainy.jpg"
    If weather$ = "Snowy" Then filename$ = "pics/snowy.jpg"
    If weather$ = "Windy" Then filename$ = "pics/windy.jpg"
    If weather$ = "Hot" Then filename$ = "pics/hot.jpg"
    If weather$ = "Cold" Then filename$ = "pics/cold.jpg"
    If weather$ = "Freezing" Then filename$ = "pics/freezing.jpg"
    If weather$ = "Breezy" Then filename$ = "pics/breezy.jpg"
    If weather$ = "Cloudy" Then filename$ = "pics/cloudy.jpg"
    If weather$ = "Hail" Then filename$ = "pics/hail.jpg"
    If image& <> 0 Then _FreeImage image&
    image& = _LoadImage(filename$, 32)
    _PutImage , image&
    _Delay 2
    Cls
    If money < 1 And gallons < 1 Then
        Print: Print: Print
        Print "     Your lemonade and money have been used up!"
        Print
        Print "     You can start over or quit this game."
        Print
        Input "     Would you like to start over (Y/N)"; startover$
        If Left$(startover$, 1) = "y" Or Left$(startover$, 1) = "Y" Then GoTo start:
        Print
        Print "     Have a great day!"
        End
    End If
    If money > 1000000000000 Then
        Cls
        Print: Print: Print
        Print "                         YOU WIN THE GAME!"
        Print: Print: Print
        Print "     You have have over a trillion dollars which makes you a"
        Print "     trillionaire so you have decided to close the stand"
        Print "     and retire. Congratulations!"
        Print: Print: Print
        Print "     Thank you for playing!"
        End
    End If
    menu1:
    Locate 3, 1: Print " Weather: " + weather$
    Locate 4, 1: Print " Money: " + Str$(money)
    Locate 4, 20: Print "               Day: " + Str$(day)
    Locate 6, 1: Print " You Have                         Make A Choice"
    Locate 7, 1: Print " --------                         -------------"
    Locate 9, 25: Print "(0) Buy Nothing And Keep Selling"
    Locate 10, 1: Print " Gallons: " + Str$(gallons)
    Locate 10, 25: Print "(1) Buy Gallons Of Lemonade ($4)"

    Locate 11, 25: Print "(2) Buy Pallets Of Lemonade (200 Gallons) ($800)"
    Locate 12, 25: Print "(3) Buy Semi-Trailer Loads Of Lemonade (5,200 Gallons) ($20,800)"
    Locate 14, 1: Print " Cups:  " + Str$(cups)
    Locate 14, 25: Print "(4) Buy Bags Of Cups (30 Cups) ($5)"
    Locate 15, 25: Print "(5) Buy Pallets Of Cups (24,000 Cups) ($4,000)"
    Locate 16, 25: Print "(6) Buy Semi-Trailer Loads Of Cups (1,350,000 Cups) ($225,000)"
    Locate 18, 1: Print " Signs: " + Str$(signs)
    Locate 18, 25: Print "(7) Buy Signs, Tape, and Pen ($10)"
    Locate 20, 1: Print " Web Level: " + Str$(weblevel)
    Locate 20, 25: Print "(8) Create Website ($100)"

    Locate 21, 1: Print " Internet Ads: " + Str$(buyinternetad)
    Locate 21, 25: Print "(9) Buy Internet Ad ($1,000)"
    Print
    Print
    Print "                        Your Stand Size: " + Str$(standsize)
    Print "                        (10) Buy Stand Size 2 ($1,000)"
    Print "                        (11) Buy Stand Size 3 ($2,000)"
    Print "                        (12) Buy Stand Size 4 ($10,000)"
    Print
    Print "                        (13) Sell The Company"
    Print "                        (14) Save Game"
    Print "                        (15) Load Game"
    Print "                        (16) Start Over"
    Print "                        (17) Quit"
    Print "                        ---------------------------------------------------------------"
    Print
    Input "                         Choose (1-17):", menu1
    If Int(menu1) <> menu1 Then GoTo menu1:
    If menu1 < 0 Or menu1 > 17 Then GoTo menu1:

    If menu1 = 0 Then GoTo begin:
    If menu1 = 1 Then GoSub buylemonade:
    If menu1 = 2 Then GoSub buypallets:
    If menu1 = 3 Then GoSub buysemis:
    If menu1 = 4 Then GoSub buycups:
    If menu1 = 5 Then GoSub buycuppallets:
    If menu1 = 6 Then GoSub buysemicups:
    If menu1 = 7 Then GoSub buysigns:
    If menu1 = 8 Then GoSub createwebsite:
    If menu1 = 9 Then GoSub buyinternetad:
    If menu1 = 10 Then GoSub buystandsize2:
    If menu1 = 11 Then GoSub buystandsize3:
    If menu1 = 12 Then GoSub buystandsize4:
    If menu1 = 13 Then
        Cls
        Print: Print: Print
        value = (gallons * 4) + (cups * 5) + (signs * 10) + (weblevel * 100) + (buyinternetad * 1000)
        If standsize = 1 Then standvalue = 50
        If standsize = 2 Then standvalue = 1000
        If standsize = 3 Then standvalue = 2000
        If standsize = 4 Then standvalue = 10000
        value = value + standvalue
        Print "     You have sold your lemonade stand to Little Johnny down the street for $" + Str$(value) + "."
        Print
        money = money + value
        Print "     That brings your money to: $" + Str$(money) + "."
        Print: Print: Print
        Input "     Would you like to start the game over (Y/N):", so2$
        If Left$(so2$, 1) = "y" Or Left$(so2$, 1) = "Y" Then GoTo start:
        Print: Print
        Print "     Thank you for playing."
        End
    End If
    If menu1 = 14 Then GoTo save:
    If menu1 = 15 Then GoTo load:
    If menu1 = 16 Then
        Print: Print
        Input "     Are you sure you want to start over (Y/N)", so$
        If Left$(so$, 1) = "y" Or Left$(so$, 1) = "Y" Then GoTo start:
        Cls
        GoTo menu1:
    End If
    If menu1 = 17 Then
        Print: Print
        Input "     Are you sure you want to quit (Y/N)", q$
        If Left$(q$, 1) = "y" Or Left$(q$, 1) = "Y" Then
            Print: Print
            Print "     Thank you for playing."
            End
        End If
        Cls
        GoTo menu1:
    End If
    begin:
    Cls
    filename$ = "pics/lemonadecup.jpg"
    If image& Then _FreeImage image&
    image& = _LoadImage(filename$, 32)
    _PutImage , image&
    _Delay 2
    Cls
    Print "         Day " + Str$(day) + " Sell"
    Print: Print: Print
    Print "     Weather: "; weather$
    Print: Print: Print
    badthings = Int(Rnd * 20) + 1
    If badthings < 4 And weather$ = "Rainy" And day > 5 Then
        Print "     News! The rain has caused a flood on your street!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in more wood, nails, and supplies."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Snowy" And day > 5 Then
        Print "     News! The snow has caused your stand to collapse!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in more wood, nails, and supplies."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Sunny" And day > 5 Then
        Print "     News! The heat has given you a terrible sunburn!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in skin lotion or a Dermatology visit."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Windy" And day > 5 Then
        Print "     News! The wind has blown down a part of your stand!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in more wood and nails."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Hot" And day > 5 Then
        Print "     News! The heat is too unbearable to work!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 10) + 2
        If standsize = 3 Then damage = Int(Rnd * 15) + 5
        If standsize = 4 Then damage = Int(Rnd * 20) + 10
        Print "     It costs $" + Str$(damage) + " in buying bags of ice."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Cold" And day > 5 Then
        Print "     News! The cold is too unbearable to work!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in buying more clothes to wear."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Freezing" And day > 5 Then
        Print "     News! I'm as cold as a popsicle!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in a heavy jacket."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Breezy" And day > 5 Then
        Print "     News! Leaves have fallen in my lemonade!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in washing the jars and making new lemonade."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Cloudy" And day > 5 Then
        Print "     News! The clouds are making it too dark to see anything!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in new supplies after I tripped onto my stand."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    If badthings < 4 And weather$ = "Hail" And day > 5 Then
        Print "     News! The hail is destroying the stand!"
        If standsize = 1 Then damage = Int(Rnd * 20) + 10
        If standsize = 2 Then damage = Int(Rnd * 60) + 20
        If standsize = 3 Then damage = Int(Rnd * 80) + 30
        If standsize = 4 Then damage = Int(Rnd * 200) + 100
        Print "     It costs $" + Str$(damage) + " in wood, nails, and supplies."
        money = money - damage
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If

    Input "     Enter the cost of each cup of lemonade (1-20): ", price
    If price > 20 Or price < 1 Then GoTo begin:
    Print: Print: Print
    people = Int(Rnd * drink) + 10 + (signs * Int((Rnd(10) + 1))) + (weblevel * Int(Rnd * 10) + 1)
    people = people + Int(Rnd * buyinternetad * 1000) + 5
    If standsize = 1 Then GoTo skip:
    people = people * (standsize * 2)
    skip:
    people = people + drink
    If price > 7 And price < 11 Then pr = Int(Rnd * 15) + 5
    If price < 7 Or price = 7 Then pr = Int(Rnd * 5) + 1
    If price > 11 Or price = 11 Then pr = Int(Rnd * 30) + 15
    If people > 75 Then pr = pr + Int(Rnd * 20) + 2
    drinks = people - pr
    If drinks < 0 Then drinks = 0
    drinks = Int(drinks)
    If signs > 1 Then si$ = "signs"
    If signs = 1 Then si$ = "sign"
    '----------------------------------------------------------------------------------------------------------------------------
    Print "     Today's " + weather$ + " weather brings out " + Str$(people) + " people, using " + Str$(signs) + " " + si$ + "."
    Print: Print: Print
    If gallons < 0 Or gallons = 0 Then
        Print: Print: Print
        Print "     You have no lemonade to sell."
        Print: Print: Print
        Input "     Press enter to go to main menu.", mm$
        GoTo menu:
    End If
    Print "     You have sold, " + Str$(drinks) + " cups of lemonade."
    Print: Print
    gallons = gallons - (drinks * 1 / 16) / 1
    money = money + (drinks * price)
    cups = cups - drinks
    If cups < 0 Then
        m = price + cups
        drinks = drinks + cups
        Print: Print
        Print "     Since you tried to sell more cups than what you had,"
        Print
        Print "     you actually only sold " + Str$(drinks) + " cups of lemonade."
        cups = 0
    End If
    If money < 1 And gallons < 1 Then
        Print: Print: Print
        Print "     You have ran out of money and lemonade."
        Print: Print: Print
        Input "     Would you like to play again"; ag$
        If Left$(ag$, 1) = "y" Or Left$(ag$, 1) = "Y" Then GoTo start:
        End
    End If
    Print: Print: Print
    Input "     Press enter to go to main menu.", c$
    day = day + 1
    Cls
Loop

weather:
'The drink variable is used in the percentage to see how many people buy your lemonade.

w = Int(Rnd * 10) + 1
If w = 1 Then
    weather$ = "Sunny"
    drink = 75
End If

If w = 2 Then
    weather$ = "Rainy"
    drink = 20
End If

If w = 3 Then
    weather$ = "Snowy"
    drink = 10
End If

If w = 4 Then
    weather$ = "Windy"
    drink = 35
End If

If w = 5 Then
    weather$ = "Hot"
    drink = 90
End If

If w = 6 Then
    weather$ = "Cold"
    drink = 25
End If

If w = 7 Then
    weather$ = "Freezing"
    drink = 5
End If

If w = 8 Then
    weather$ = "Breezy"
    drink = 55
End If

If w = 9 Then
    weather$ = "Cloudy"
    drink = 80
End If

If w = 10 Then
    weather$ = "Hail"
    drink = 2
End If

Return

buylemonade:
Cls
filename$ = "pics/lemonadegallon.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
again1:
Print: Print: Print
Print "                         Buy Lemonade"
Print: Print
Print "     Money: "; money
Print: Print
Print "     Each gallon of lemonade costs $4."
Print
Print "     There are 16 cups of lemonade per gallon."
Print
L = money / 4
ll = Int(L)
If L < ll Then ll = ll - 1
Print "     You have enough money to buy " + Str$(ll) + " gallons."
Print
Input "     How many gallons would you like"; buygallons
If buygallons > ll Then
    Print
    Print "     You don't have enough money for that many, try again."
    GoTo again1:
End If
If buygallons < 0 Or buygallons <> Int(buygallons) Then GoTo again1:
gallons = gallons + buygallons
money = money - (ll * 4)
Print
Print "     You have bought " + Str$(buygallons) + " gallons of lemonade."
Print
Print "     You now have " + Str$(gallons) + " gallons of lemonade."
Print
Input "     Press Enter.", b$
Cls
Return

buypallets:
Cls
filename$ = "pics/pallets.jpg"
If image& <> 0 Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
pallet1:
Print: Print: Print
Print "                      Pallets Of Lemonade (200 Gallons)"
Print: Print
Print "          Each pallet contains 200 gallons of lemonade and costs $800 each."
Print
totalpal = Int(money / 800)
Print "          You have enough money to buy " + Str$(totalpal) + " pallets."
Print
Print "          Or just press enter to go to main menu."
Print
Input "          How many pallets would you like: ", pallets
If pallets < 0 Or pallets <> Int(pallets) Then GoTo buypallets:
If pallets = 0 Then GoTo menu:
If (pallets * 800) > money Then
    Print "          You don't have enough for that much quantity, try again."
    GoTo pallet1:
End If
gallons = gallons + (pallets * 200)
money = money - (pallets * 800)
Print
Print "          You have bought " + Str$(pallets) + " pallets which equals " + Str$(pallets * 200) + " gallons."
Print
Print "          You now have " + Str$(gallons) + " gallons of lemonade."
Print
Input "          Press Enter.", pg$
Cls
Return

buysemis:
Cls
filename$ = "pics/semis.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
semis1:
Print: Print: Print
Print "                      Semi-Trailers Of Lemonade (5200 Gallons)"
Print: Print: Print
Print "          Each semi truck contains 5200 gallons of lemonade and costs $20800 each."
Print
totalsemi = Int(money / 20800)
Print "          You have enough money to buy " + Str$(totalsemi) + " pallets."
Print
Print "          Or just press enter to go to main menu."
Print
Input "          How many semi loads would you like: ", semis
If semis < 0 Or semis <> Int(semis) Then GoTo buysemis:
If semis = 0 Then GoTo menu:
If (semis * 20800) > money Then
    Print "          You don't have enough for that much quantity, try again."
    GoTo semis1:
End If
gallons = gallons + (semis * 5200)
money = money - (semis * 20800)
Print
Print "          You have bought " + Str$(semis) + " pallets which equals " + Str$(semis * 5200) + " gallons."
Print
Print "          You now have " + Str$(gallons) + " gallons of lemonade."
Print
Input "          Press Enter.", pg$
Cls
Return

buycups:
Cls
filename$ = "pics/cups.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
again2:
Print: Print: Print
Print "                         Buy Cups"
Print: Print: Print
Print "     Money: "; money
Print: Print
Print "     Each bag of 30 cups costs $5."
Print
l2 = money / 5
ll2 = Int(l2)
Print "     You have enough money to buy " + Str$(ll2) + " bags of cups."
Print
Input "     How many bags of cups would you like"; buycups
If buycups > ll2 Then
    Print
    Print "     You don't have enough money for that many, try again."
    GoTo again2:
End If
If buycups < 0 Or buycups <> Int(buycups) Then GoTo again2:
totalcups = buycups * 30
cups = cups + totalcups
money = money - (buycups * 5)
Print "     You have bought " + Str$(buycups) + " bags of cups,"
Print
Print "     which are " + Str$(totalcups) + " cups."
Print
Print "     You now have " + Str$(cups) + " total cups."
Print
Print
Input "     Press Enter.", b$
Cls
Return

buycuppallets:
Cls
filename$ = "pics/pallets.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
pallet2:
Print: Print: Print
Print "                      Pallets Of Cups (800 Bags Of 30 Cups Each)"
Print: Print: Print
Print "          Each pallet contains 800 plastic cup bags and costs $4000 each."
Print
totalpal2 = Int(money / 4000)
Print "          You have enough money to buy " + Str$(totalpal2) + " pallets."
Print
Print "          Or just press enter to go to main menu."
Print
Input "          How many pallets would you like: ", pallets2
If pallets2 < 0 Or pallets2 <> Int(pallets2) Then GoTo buycuppallets:
If pallets2 = 0 Then GoTo menu:
If (pallets2 * 4000) > money Then
    Print "          You don't have enough for that much quantity, try again."
    GoTo pallet2:
End If
cups = cups + (pallets2 * (800 * 30))
money = money - (pallets2 * 4000)
Print
Print "          You have bought " + Str$(pallets2) + " pallets of cups which equals " + Str$(pallets2 * 800) + " bags of cups."
Print
Print "          You now have " + Str$(cups) + " total cups."
Print
Print
Input "          Press Enter.", pg$
Cls
Return

buysemicups:
Cls
filename$ = "pics/semis.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
semis2:
Print: Print: Print
Print "                      Semi-Trucks Of Cups (45,000 Bags Of 30 Cups Each)"
Print: Print: Print
Print "          Each truck contains 45,000 plastic cup bags and costs $225,000 each."
Print
totalsemi2 = Int(money / 225000)
Print "          You have enough money to buy " + Str$(totalsemi2) + " truck loads."
Print
Print "          Or just press enter to go to main menu."
Print
Input "          How many pallets would you like: ", semis2
If semis2 < 0 Or semis2 <> Int(semis2) Then GoTo buysemicups:
If semis2 = 0 Then GoTo menu:
If (semis2 * 225000) > money Then
    Print "          You don't have enough for that much quantity, try again."
    GoTo semis2:
End If
cups = cups + (semis2 * (45000 * 30))
money = money - (semis2 * 225000)
Print
Print "          You have bought " + Str$(semis2) + " truck loads of cups which equals " + Str$(semis2 * 45000) + " bags of cups."
Print
Print "          You now have " + Str$(cups) + " total cups."
Print
Print
Input "          Press Enter.", pg$
Cls
Return

buysigns:
Cls
filename$ = "pics/sign.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
Print: Print: Print
Print "                         Buy Signs"
Print: Print: Print
Print "     Each packet of 1 sign, 1 tape roll, and 1 ink pen costs $10."
Print: Print
costsigns = money / 10
costsigns2 = Int(costsigns)
If costsigns < costsigns2 Then costsigns2 = costsigns2 - 1
Print "     You have enough money to buy " + Str$(costsigns2) + " signs."
Print: Print
Input "     How many signs, tape, and pens would you like to buy (altogether): ", signs2
If signs2 <> Int(signs2) Or signs2 < 0 Then GoTo buysigns:
If signs2 > money / 10 Then
    Print
    Print "     You don't have enough money for that many, try again."
    GoTo buysigns:
End If
Print: Print
signs = signs + signs2
Print "     You have bought " + Str$(signs2) + " signs."
Print
Print "     You now have " + Str$(signs) + " signs."
Print: Print
Input "     Press Enter.", e$
Cls
Return

createwebsite:
Cls
filename$ = "pics/website.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
Print: Print: Print
web2:
Print "                              Create Website"
Print: Print: Print
If weblevel = 10 Then
    Print "     Your website level is at its maximum of 10, you cannot get more."
    Print: Print
    Input "     Press enter to go to main menu.", mm$
    GoTo menu:
End If

Print "     You have $" + Str$(money) + ", how much would you like to spend on your website?"
Print "     The least you can spend is $100."
Print
Input "     ->", web

If web < 100 Then GoTo createwebsite:
If web > money Then

    Print: Print
    Print "     You tried to spend more than you have, try again."
    Print: Print
    GoTo web2:
End If
Print: Print
Print "     You spent $" + Str$(web) + " on your website."
weblevel2 = web / 100
weblevel2 = Int(weblevel2)
weblevel = weblevel + weblevel2
If weblevel > 10 Then weblevel = 10
Print: Print
Print "     Your website level is now at " + Str$(weblevel) + "."
Print: Print
Input "     Press Enter.", mm$
Return

buyinternetad:
Cls
filename$ = "pics/internetnetad.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
buyinternetad2:
Print "                            Internet Ads"
Print: Print: Print
Print "     In order to sell more, you need more people to know about it."
Print "     In the real world, the cost varies a lot with different types"
Print "     of ads and different companies. So for this game we will just"
Print "     make up our own type."
Print
Print "     One ad can be shown to 1,000 online viewers. That doesn't"
Print "     mean that there will be 1,000 people going to your stand."
Print "     But the more ads you buy, the more chances you will get."
Print
Print "     Ads costs $1000 each."
Print
If buyinternetad > 5 Then
    Print
    Print "     You are at the maximum amount of 5 Internet Ads."
    Print
    Input "     Press Enter to go to main menu.", mm$
    GoTo menu:
End If
totalads = Int(money / 1000)
Print "     You have enough to buy " + Str$(totalads) + " ads."
Print
Print "     Press just Enter to to go Main Menu."
Print
Input "     How many ads would you like to buy"; internetad
If internetad = 0 Then GoTo menu:
If internetad * 1000 > money Then
    Print: Print: Print
    Print "     You bought more than you can spend. Try again."
    Print
    GoTo buyinternetad2:
End If
buyinternetad = buyinternetad + internetad
Print
Print "     You have bought " + Str$(internetad) + " Internet ads."
Print
Print "     You now have a total of " + Str$(buyinternetad) + " Internet ads."
Print
Input "Press enter.", ia$
Return

buystandsize2:
Cls
filename$ = "pics/stand2.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
Print: Print: Print
Print "               Buy Stand Size 2"
Print: Print: Print
Print "     A larger stand size draws-in more people."
Print: Print
If standsize > 1 Then
    Print "     You already have a stand size greater than 1."
    Print
    Input "     Press Enter to go back to main menu.", mm$
    GoTo menu:
End If
Print "     Stand Size 2 costs $1000."
Print
If money < 1000 Then
    Print "     You don't have enough money to upgrade right now."
    Print
    Input "     Press Enter to go to main menu.", mm$
    GoTo menu:
End If
Input "     Would you like to buy it (Y/N)"; yn2$
If Left$(yn2$, 1) = "y" Or Left$(yn2$, 1) = "Y" Then
    standsize = 2
    money = money - 1000
    Print
    Print "     You have upgraded your stand size to level 2!"
    Print
    Input "     Press Enter."; mm$
    Cls
    Return
End If
Print
Print "     You have decided not to upgrade this time."
Print
Input "     Press Enter.", m$
GoTo menu:

buystandsize3:

Cls
filename$ = "pics/stand3.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
Print: Print: Print
Print "               Buy Stand Size 3"
Print: Print: Print
Print "     Stand Size 3 draws in even more people."
Print: Print
If standsize > 2 Then
    Print "     You already have a stand size greater than 2."
    Print
    Input "     Press Enter to go back to main menu.", mm$
    GoTo menu:
End If
Print "     Stand Size 3 costs $2000."
Print
If money < 2000 Then
    Print "     You don't have enough money to upgrade right now."
    Print
    Input "     Press Enter to go to main menu.", mm$
    GoTo menu:
End If
Input "     Would you like to buy it (Y/N)"; yn3$
If Left$(yn3$, 1) = "y" Or Left$(yn3$, 1) = "Y" Then
    standsize = 3
    money = money - 2000
    Print
    Print "     You have upgraded your stand size to level 3!"
    Print
    Input "     Press Enter."; mm$
    Cls
    Return
End If
Print
Print "     You have decided not to upgrade this time."
Print
Input "     Press Enter.", m$
GoTo menu:

buystandsize4:

Cls
filename$ = "pics/stand4.jpg"
If image& Then _FreeImage image&
image& = _LoadImage(filename$, 32)
_PutImage , image&
_Delay 2
Cls
Print: Print: Print
Print "               Buy Stand Size 4"
Print: Print: Print
Print "     Stand Size 4 is the largest stand."
Print: Print
If standsize = 4 Then
    Print "     You already have stand size 4."
    Print
    Input "     Press Enter to go back to main menu.", mm$
    GoTo menu:
End If
Print "     Stand Size 4 costs $10000."
Print
If money < 10000 Then
    Print "     You don't have enough money to upgrade right now."
    Print
    Input "     Press Enter to go to main menu.", mm$
    GoTo menu:
End If
Input "     Would you like to buy it (Y/N)"; yn4$
If Left$(yn4$, 1) = "y" Or Left$(yn4$, 1) = "Y" Then
    standsize = 4
    money = money - 10000
    Print
    Print "     You have upgraded your stand size to level 4!"
    Print
    Input "     Press Enter."; mm$
    Cls
    Return
End If
Print
Print "     You have decided not to upgrade this time."
Print
Input "     Press Enter.", m$
GoTo menu:

save:
Cls
Print: Print: Print
Print "                         Save Game"
Print: Print: Print
Input "     Type name to save it under (without the .dat ending): ", nm$
nm$ = nm$ + ".dat"
If _FileExists(nm$) Then
    Print "     " + nm$ + " exists, would you like to overwrite it?";
    Input yn$
    If Left$(yn$, 1) = "y" Or Left$(yn$, 1) = "Y" Then
        Open nm$ For Output As #1
        Write #1, day
        Print #1, weather$
        Write #1, drink
        Write #1, money
        Write #1, gallons
        Write #1, cups
        Write #1, signs
        Write #1, weblevel
        Write #1, buyinternetad
        Write #1, standsize
        Close #1
        Print "     Game saved as " + nm$ + "."
        Print: Print: Print
        Input "     Press enter to go to main menu.", a2$
        GoTo menu:
    Else
        GoTo save:
    End If
Else
    Open nm$ For Output As #1
    Write #1, day
    Print #1, weather$
    Write #1, drink
    Write #1, money
    Write #1, gallons
    Write #1, cups
    Write #1, signs
    Write #1, weblevel
    Write #1, buyinternetad
    Write #1, standsize
    Close #1
    Print "     Game saved as " + nm$ + "."
    Print: Print: Print
    Input "     Press enter to go to main menu.", a3$
    GoTo menu:
End If
GoTo menu:

load:
Cls
Print: Print: Print
Print "                                   Load Game"
Print: Print: Print
load2:
Print "     Type name of game (without the .dat ending), or type: list to see list of saved games."
Print "     To go back to menu, just press Enter without typing anything."
Input "     -> "; nm$
If Len(_Trim$(nm$)) = 0 Then GoTo menu:
If nm$ = "list" Or nm$ = "List" Or nm$ = "LIST" Or nm$ = "lIST" Or nm$ = "liST" Or nm$ = "lisT" Or nm$ = "LIst" Or nm$ = "LISt" Then
    Print: Print
    Print "          Saved games are listed on your Notepad that has just appeared."
    Print "          If you see nothing on your Notepad, then you have none saved."
    Print
    Shell _Hide "dir " + Chr$(34) + "*.dat" + Chr$(34) + " /b > temp.dir"
    Shell "start Notepad temp.dir" ' display temp file contents in Notepad window
    Print: Print
    GoTo load2:
End If
nm$ = nm$ + ".dat"
nn = _FileExists(nm$)
If nn = 0 Then
    Print: Print
    Print "     " + nm$ + " doesn't exist, try again."
    Print: Print: Print
    GoTo load2:
End If
Open nm$ For Input As #1
Input #1, day
Input #1, weather$
Input #1, drink
Input #1, money
Input #1, gallons
Input #1, cups
Input #1, signs
Input #1, weblevel
Input #1, buyinternetad
Input #1, standsize
Close #1
GoTo menu:







