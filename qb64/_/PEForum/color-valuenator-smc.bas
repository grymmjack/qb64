_Title "Color Valuenator(tm) by Steve the Awesome(tm)(c)"

$Color:32
Color 15
Print "Hello World!  Be in awe of my Color Valuenator!!(tm)"


Print ColorValue("_RGB32(128,128,128)"), _RGB32(128, 128, 128)
Print ColorValue("15"), 15
Print ColorValue("RGB(255,0,0)"), _RGB(255, 0, 0)
Print ColorValue("Black"), Black
Print ColorValue("Red"), Red
Print ColorValue("_RGB32(37)"), _RGB32(37)
Print ColorValue("Frog"), Frog, "<-- -1 says invalid color value"




Function ColorValue&& (text$)
    ReDim values(1000) As String
    ColorValue = -1 'This is to report a failed attempt to get a valid color.
    '                All valid colors will be greater than -1, so be certain the return variable is an _INTEGER64 type
    '                so that this -1 value doesn't overflow and become bright white (most likely), or some other color

    If IsNum(text$) Then 'our color is either in plain number form (COLOR 15, for example), or hex form (&HFFFFFFFF, for example)
        temp&& = Val(text$)
        If temp&& >= 0 Then
            ColorValue = temp&&
        Else
            If temp&& >= -2147483648 Then 'it's probably a color, but in LONG (signed) format.  Let's convert it automagically and roll with it.
                temp& = temp&&
                ColorValue = temp&
            End If
        End If
    Else
        temp$ = _Trim$(UCase$(text$))
        If Left$(temp$, 7) = "_RGBA32" Or Left$(temp$, 6) = "RGBA32" Then 'It's in RGBA32 format
            If ParseValues(text$, values()) <> 4 Then ColorValue = -1: Exit Function
            r% = Val(values(1))
            g% = Val(values(2))
            b% = Val(values(3))
            a% = Val(values(4))
            ColorValue = _RGBA32(r%, g%, b%, a%)
        ElseIf Left$(temp$, 5) = "_RGBA" Or Left$(temp$, 4) = "RGBA" Then 'It's in RGBA format
            p = ParseValues(text$, values())
            If p < 4 Or p > 5 Then ColorValue = -1: Exit Function
            r% = Val(values(1))
            g% = Val(values(2))
            b% = Val(values(3))
            a% = Val(values(4))
            If p = 5 Then
                d% = Val(values(5)) 'the destination of the screen whose palette we're matching against
                ColorValue = _RGBA(r%, g%, b%, a%, d%)
            Else
                ColorValue = _RGBA(r%, g%, b%, a%) 'note that this value will change depending upon the screen that it's called from
                'RGBA tries to match the called value to the closest possible color match that the existing palette has.
            End If
        ElseIf Left$(temp$, 6) = "_RGB32" Or Left$(temp$, 5) = "RGB32" Then 'It's in RGB32 format
            p = ParseValues(text$, values())
            Select Case p
                Case 4 '_RGB32(num, num2, num3, num4) <-- this is RGBA format
                    r% = Val(values(1))
                    g% = Val(values(2))
                    b% = Val(values(3))
                    a% = Val(values(4))
                    ColorValue = _RGBA32(r%, g%, b%, a%)
                Case 3 ' _RGB32(num, num2, num3) <-- this is RGB format
                    r% = Val(values(1))
                    g% = Val(values(2))
                    b% = Val(values(3))
                    ColorValue = _RGB32(r%, g%, b%)
                Case 2 ' _RGB32(num, num2) <-- Grayscale with alpha
                    r% = Val(values(1))
                    g% = Val(values(2))
                    ColorValue = _RGB32(r%, g%)
                Case 1 ' _RGB32(num) <-- Grayscale alone
                    r% = Val(values(1))
                    ColorValue = _RGB32(r%)
                Case Else
                    ColorValue = -1: Exit Function '<-- can not return a valid color value
            End Select
        ElseIf Left$(temp$, 4) = "_RGB" Or Left$(temp$, 3) = "RGB" Then 'It's in RGB format
            p = ParseValues(text$, values())
            If p < 3 Or p > 4 Then ColorValue = -1: Exit Function
            r% = Val(values(1))
            g% = Val(values(2))
            b% = Val(values(3))
            If p = 4 Then
                d% = Val(values(4)) 'the destination of the screen whose palette we're matching against
                ColorValue = _RGB(r%, g%, b%, d%)
            Else
                ColorValue = _RGB(r%, g%, b%) 'note that this value will change depending upon the screen that it's called from
                'RGBA tries to match the called value to the closest possible color match that the existing palette has.
            End If
        Else 'check to see if it's a color name value
            ReDim kolor$(1000), value(1000) As _Integer64
            count = count + 1: kolor$(count) = "AliceBlue": value(count) = 4293982463
            count = count + 1: kolor$(count) = "Almond": value(count) = 4293910221
            count = count + 1: kolor$(count) = "AntiqueBrass": value(count) = 4291663221
            count = count + 1: kolor$(count) = "AntiqueWhite": value(count) = 4294634455
            count = count + 1: kolor$(count) = "Apricot": value(count) = 4294826421
            count = count + 1: kolor$(count) = "Aqua": value(count) = 4278255615
            count = count + 1: kolor$(count) = "Aquamarine": value(count) = 4286578644
            count = count + 1: kolor$(count) = "Asparagus": value(count) = 4287080811
            count = count + 1: kolor$(count) = "AtomicTangerine": value(count) = 4294943860
            count = count + 1: kolor$(count) = "Azure": value(count) = 4293984255
            count = count + 1: kolor$(count) = "BananaMania": value(count) = 4294633397
            count = count + 1: kolor$(count) = "Beaver": value(count) = 4288643440
            count = count + 1: kolor$(count) = "Beige": value(count) = 4294309340
            count = count + 1: kolor$(count) = "Bisque": value(count) = 4294960324
            count = count + 1: kolor$(count) = "Bittersweet": value(count) = 4294802542
            count = count + 1: kolor$(count) = "Black": value(count) = 4278190080
            count = count + 1: kolor$(count) = "BlanchedAlmond": value(count) = 4294962125
            count = count + 1: kolor$(count) = "BlizzardBlue": value(count) = 4289521134
            count = count + 1: kolor$(count) = "Blue": value(count) = 4278190335
            count = count + 1: kolor$(count) = "BlueBell": value(count) = 4288848592
            count = count + 1: kolor$(count) = "BlueGray": value(count) = 4284914124
            count = count + 1: kolor$(count) = "BlueGreen": value(count) = 4279081146
            count = count + 1: kolor$(count) = "BlueViolet": value(count) = 4287245282
            count = count + 1: kolor$(count) = "Blush": value(count) = 4292763011
            count = count + 1: kolor$(count) = "BrickRed": value(count) = 4291510612
            count = count + 1: kolor$(count) = "Brown": value(count) = 4289014314
            count = count + 1: kolor$(count) = "BurlyWood": value(count) = 4292786311
            count = count + 1: kolor$(count) = "BurntOrange": value(count) = 4294934345
            count = count + 1: kolor$(count) = "BurntSienna": value(count) = 4293557853
            count = count + 1: kolor$(count) = "CadetBlue": value(count) = 4284456608
            count = count + 1: kolor$(count) = "Canary": value(count) = 4294967193
            count = count + 1: kolor$(count) = "CaribbeanGreen": value(count) = 4280079266
            count = count + 1: kolor$(count) = "CarnationPink": value(count) = 4294945484
            count = count + 1: kolor$(count) = "Cerise": value(count) = 4292691090
            count = count + 1: kolor$(count) = "Cerulean": value(count) = 4280134870
            count = count + 1: kolor$(count) = "ChartReuse": value(count) = 4286578432
            count = count + 1: kolor$(count) = "Chestnut": value(count) = 4290534744
            count = count + 1: kolor$(count) = "Chocolate": value(count) = 4291979550
            count = count + 1: kolor$(count) = "Copper": value(count) = 4292711541
            count = count + 1: kolor$(count) = "Coral": value(count) = 4294934352
            count = count + 1: kolor$(count) = "Cornflower": value(count) = 4288335595
            count = count + 1: kolor$(count) = "CornflowerBlue": value(count) = 4284782061
            count = count + 1: kolor$(count) = "Cornsilk": value(count) = 4294965468
            count = count + 1: kolor$(count) = "CottonCandy": value(count) = 4294950105
            count = count + 1: kolor$(count) = "CrayolaAquamarine": value(count) = 4286110690
            count = count + 1: kolor$(count) = "CrayolaBlue": value(count) = 4280251902
            count = count + 1: kolor$(count) = "CrayolaBlueViolet": value(count) = 4285753021
            count = count + 1: kolor$(count) = "CrayolaBrown": value(count) = 4290013005
            count = count + 1: kolor$(count) = "CrayolaCadetBlue": value(count) = 4289771462
            count = count + 1: kolor$(count) = "CrayolaForestGreen": value(count) = 4285378177
            count = count + 1: kolor$(count) = "CrayolaGold": value(count) = 4293379735
            count = count + 1: kolor$(count) = "CrayolaGoldenrod": value(count) = 4294760821
            count = count + 1: kolor$(count) = "CrayolaGray": value(count) = 4287992204
            count = count + 1: kolor$(count) = "CrayolaGreen": value(count) = 4280069240
            count = count + 1: kolor$(count) = "CrayolaGreenYellow": value(count) = 4293978257
            count = count + 1: kolor$(count) = "CrayolaIndigo": value(count) = 4284315339
            count = count + 1: kolor$(count) = "CrayolaLavender": value(count) = 4294751445
            count = count + 1: kolor$(count) = "CrayolaMagenta": value(count) = 4294337711
            count = count + 1: kolor$(count) = "CrayolaMaroon": value(count) = 4291311706
            count = count + 1: kolor$(count) = "CrayolaMidnightBlue": value(count) = 4279912566
            count = count + 1: kolor$(count) = "CrayolaOrange": value(count) = 4294931768
            count = count + 1: kolor$(count) = "CrayolaOrangeRed": value(count) = 4294912811
            count = count + 1: kolor$(count) = "CrayolaOrchid": value(count) = 4293306583
            count = count + 1: kolor$(count) = "CrayolaPlum": value(count) = 4287513989
            count = count + 1: kolor$(count) = "CrayolaRed": value(count) = 4293795917
            count = count + 1: kolor$(count) = "CrayolaSalmon": value(count) = 4294941610
            count = count + 1: kolor$(count) = "CrayolaSeaGreen": value(count) = 4288668351
            count = count + 1: kolor$(count) = "CrayolaSilver": value(count) = 4291675586
            count = count + 1: kolor$(count) = "CrayolaSkyBlue": value(count) = 4286634731
            count = count + 1: kolor$(count) = "CrayolaSpringGreen": value(count) = 4293716670
            count = count + 1: kolor$(count) = "CrayolaTann": value(count) = 4294616940
            count = count + 1: kolor$(count) = "CrayolaThistle": value(count) = 4293642207
            count = count + 1: kolor$(count) = "CrayolaViolet": value(count) = 4287786670
            count = count + 1: kolor$(count) = "CrayolaYellow": value(count) = 4294764675
            count = count + 1: kolor$(count) = "CrayolaYellowGreen": value(count) = 4291158916
            count = count + 1: kolor$(count) = "Crimson": value(count) = 4292613180
            count = count + 1: kolor$(count) = "Cyan": value(count) = 4278255615
            count = count + 1: kolor$(count) = "Dandelion": value(count) = 4294826861
            count = count + 1: kolor$(count) = "DarkBlue": value(count) = 4278190219
            count = count + 1: kolor$(count) = "DarkCyan": value(count) = 4278225803
            count = count + 1: kolor$(count) = "DarkGoldenRod": value(count) = 4290283019
            count = count + 1: kolor$(count) = "DarkGray": value(count) = 4289309097
            count = count + 1: kolor$(count) = "DarkGreen": value(count) = 4278215680
            count = count + 1: kolor$(count) = "DarkKhaki": value(count) = 4290623339
            count = count + 1: kolor$(count) = "DarkMagenta": value(count) = 4287299723
            count = count + 1: kolor$(count) = "DarkOliveGreen": value(count) = 4283788079
            count = count + 1: kolor$(count) = "DarkOrange": value(count) = 4294937600
            count = count + 1: kolor$(count) = "DarkOrchid": value(count) = 4288230092
            count = count + 1: kolor$(count) = "DarkRed": value(count) = 4287299584
            count = count + 1: kolor$(count) = "DarkSalmon": value(count) = 4293498490
            count = count + 1: kolor$(count) = "DarkSeaGreen": value(count) = 4287609999
            count = count + 1: kolor$(count) = "DarkSlateBlue": value(count) = 4282924427
            count = count + 1: kolor$(count) = "DarkSlateGray": value(count) = 4281290575
            count = count + 1: kolor$(count) = "DarkTurquoise": value(count) = 4278243025
            count = count + 1: kolor$(count) = "DarkViolet": value(count) = 4287889619
            count = count + 1: kolor$(count) = "DeepPink": value(count) = 4294907027
            count = count + 1: kolor$(count) = "DeepSkyBlue": value(count) = 4278239231
            count = count + 1: kolor$(count) = "Denim": value(count) = 4281035972
            count = count + 1: kolor$(count) = "DesertSand": value(count) = 4293905848
            count = count + 1: kolor$(count) = "DimGray": value(count) = 4285098345
            count = count + 1: kolor$(count) = "DodgerBlue": value(count) = 4280193279
            count = count + 1: kolor$(count) = "Eggplant": value(count) = 4285419872
            count = count + 1: kolor$(count) = "ElectricLime": value(count) = 4291755805
            count = count + 1: kolor$(count) = "Fern": value(count) = 4285643896
            count = count + 1: kolor$(count) = "FireBrick": value(count) = 4289864226
            count = count + 1: kolor$(count) = "Floralwhite": value(count) = 4294966000
            count = count + 1: kolor$(count) = "ForestGreen": value(count) = 4280453922
            count = count + 1: kolor$(count) = "Fuchsia": value(count) = 4290995397
            count = count + 1: kolor$(count) = "FuzzyWuzzy": value(count) = 4291585638
            count = count + 1: kolor$(count) = "Gainsboro": value(count) = 4292664540
            count = count + 1: kolor$(count) = "GhostWhite": value(count) = 4294506751
            count = count + 1: kolor$(count) = "Gold": value(count) = 4294956800
            count = count + 1: kolor$(count) = "GoldenRod": value(count) = 4292519200
            count = count + 1: kolor$(count) = "GrannySmithApple": value(count) = 4289258656
            count = count + 1: kolor$(count) = "Gray": value(count) = 4286611584
            count = count + 1: kolor$(count) = "Green": value(count) = 4278222848
            count = count + 1: kolor$(count) = "GreenBlue": value(count) = 4279329972
            count = count + 1: kolor$(count) = "GreenYellow": value(count) = 4289593135
            count = count + 1: kolor$(count) = "Grey": value(count) = 4286611584
            count = count + 1: kolor$(count) = "HoneyDew": value(count) = 4293984240
            count = count + 1: kolor$(count) = "HotMagenta": value(count) = 4294909390
            count = count + 1: kolor$(count) = "HotPink": value(count) = 4294928820
            count = count + 1: kolor$(count) = "Inchworm": value(count) = 4289915997
            count = count + 1: kolor$(count) = "IndianRed": value(count) = 4291648604
            count = count + 1: kolor$(count) = "Indigo": value(count) = 4283105410
            count = count + 1: kolor$(count) = "Ivory": value(count) = 4294967280
            count = count + 1: kolor$(count) = "JazzberryJam": value(count) = 4291442535
            count = count + 1: kolor$(count) = "JungleGreen": value(count) = 4282101903
            count = count + 1: kolor$(count) = "Khaki": value(count) = 4293977740
            count = count + 1: kolor$(count) = "LaserLemon": value(count) = 4294901282
            count = count + 1: kolor$(count) = "Lavender": value(count) = 4293322490
            count = count + 1: kolor$(count) = "LavenderBlush": value(count) = 4294963445
            count = count + 1: kolor$(count) = "LawnGreen": value(count) = 4286381056
            count = count + 1: kolor$(count) = "LemonChiffon": value(count) = 4294965965
            count = count + 1: kolor$(count) = "LemonYellow": value(count) = 4294964303
            count = count + 1: kolor$(count) = "LightBlue": value(count) = 4289583334
            count = count + 1: kolor$(count) = "LightCoral": value(count) = 4293951616
            count = count + 1: kolor$(count) = "LightCyan": value(count) = 4292935679
            count = count + 1: kolor$(count) = "LightGoldenRodYellow": value(count) = 4294638290
            count = count + 1: kolor$(count) = "LightGray": value(count) = 4292072403
            count = count + 1: kolor$(count) = "LightGreen": value(count) = 4287688336
            count = count + 1: kolor$(count) = "LightPink": value(count) = 4294948545
            count = count + 1: kolor$(count) = "LightSalmon": value(count) = 4294942842
            count = count + 1: kolor$(count) = "LightSeaGreen": value(count) = 4280332970
            count = count + 1: kolor$(count) = "LightSkyBlue": value(count) = 4287090426
            count = count + 1: kolor$(count) = "LightSlateGray": value(count) = 4286023833
            count = count + 1: kolor$(count) = "LightSteelBlue": value(count) = 4289774814
            count = count + 1: kolor$(count) = "LightYellow": value(count) = 4294967264
            count = count + 1: kolor$(count) = "Lime": value(count) = 4278255360
            count = count + 1: kolor$(count) = "LimeGreen": value(count) = 4281519410
            count = count + 1: kolor$(count) = "Linen": value(count) = 4294635750
            count = count + 1: kolor$(count) = "MacaroniAndCheese": value(count) = 4294950280
            count = count + 1: kolor$(count) = "Magenta": value(count) = 4294902015
            count = count + 1: kolor$(count) = "MagicMint": value(count) = 4289392849
            count = count + 1: kolor$(count) = "Mahogany": value(count) = 4291643980
            count = count + 1: kolor$(count) = "Maize": value(count) = 4293775772
            count = count + 1: kolor$(count) = "Manatee": value(count) = 4288125610
            count = count + 1: kolor$(count) = "MangoTango": value(count) = 4294935107
            count = count + 1: kolor$(count) = "Maroon": value(count) = 4286578688
            count = count + 1: kolor$(count) = "Mauvelous": value(count) = 4293892266
            count = count + 1: kolor$(count) = "MediumAquamarine": value(count) = 4284927402
            count = count + 1: kolor$(count) = "MediumBlue": value(count) = 4278190285
            count = count + 1: kolor$(count) = "MediumOrchid": value(count) = 4290401747
            count = count + 1: kolor$(count) = "MediumPurple": value(count) = 4287852763
            count = count + 1: kolor$(count) = "MediumSeaGreen": value(count) = 4282168177
            count = count + 1: kolor$(count) = "MediumSlateBlue": value(count) = 4286277870
            count = count + 1: kolor$(count) = "MediumSpringGreen": value(count) = 4278254234
            count = count + 1: kolor$(count) = "MediumTurquoise": value(count) = 4282962380
            count = count + 1: kolor$(count) = "MediumVioletRed": value(count) = 4291237253
            count = count + 1: kolor$(count) = "Melon": value(count) = 4294818996
            count = count + 1: kolor$(count) = "MidnightBlue": value(count) = 4279834992
            count = count + 1: kolor$(count) = "MintCream": value(count) = 4294311930
            count = count + 1: kolor$(count) = "MistyRose": value(count) = 4294960353
            count = count + 1: kolor$(count) = "Moccasin": value(count) = 4294960309
            count = count + 1: kolor$(count) = "MountainMeadow": value(count) = 4281383567
            count = count + 1: kolor$(count) = "Mulberry": value(count) = 4291120012
            count = count + 1: kolor$(count) = "NavajoWhite": value(count) = 4294958765
            count = count + 1: kolor$(count) = "Navy": value(count) = 4278190208
            count = count + 1: kolor$(count) = "NavyBlue": value(count) = 4279858386
            count = count + 1: kolor$(count) = "NeonCarrot": value(count) = 4294943555
            count = count + 1: kolor$(count) = "OldLace": value(count) = 4294833638
            count = count + 1: kolor$(count) = "Olive": value(count) = 4286611456
            count = count + 1: kolor$(count) = "OliveDrab": value(count) = 4285238819
            count = count + 1: kolor$(count) = "OliveGreen": value(count) = 4290426988
            count = count + 1: kolor$(count) = "Orange": value(count) = 4294944000
            count = count + 1: kolor$(count) = "OrangeRed": value(count) = 4294919424
            count = count + 1: kolor$(count) = "OrangeYellow": value(count) = 4294497640
            count = count + 1: kolor$(count) = "Orchid": value(count) = 4292505814
            count = count + 1: kolor$(count) = "OuterSpace": value(count) = 4282468940
            count = count + 1: kolor$(count) = "OutrageousOrange": value(count) = 4294929994
            count = count + 1: kolor$(count) = "PacificBlue": value(count) = 4280068553
            count = count + 1: kolor$(count) = "PaleGoldenRod": value(count) = 4293847210
            count = count + 1: kolor$(count) = "PaleGreen": value(count) = 4288215960
            count = count + 1: kolor$(count) = "PaleTurquoise": value(count) = 4289720046
            count = count + 1: kolor$(count) = "PaleVioletRed": value(count) = 4292571283
            count = count + 1: kolor$(count) = "PapayaWhip": value(count) = 4294963157
            count = count + 1: kolor$(count) = "Peach": value(count) = 4294954923
            count = count + 1: kolor$(count) = "PeachPuff": value(count) = 4294957753
            count = count + 1: kolor$(count) = "Periwinkle": value(count) = 4291154150
            count = count + 1: kolor$(count) = "Peru": value(count) = 4291659071
            count = count + 1: kolor$(count) = "PiggyPink": value(count) = 4294827494
            count = count + 1: kolor$(count) = "PineGreen": value(count) = 4279599224
            count = count + 1: kolor$(count) = "Pink": value(count) = 4294951115
            count = count + 1: kolor$(count) = "PinkFlamingo": value(count) = 4294735101
            count = count + 1: kolor$(count) = "PinkSherbet": value(count) = 4294414247
            count = count + 1: kolor$(count) = "Plum": value(count) = 4292714717
            count = count + 1: kolor$(count) = "PowderBlue": value(count) = 4289781990
            count = count + 1: kolor$(count) = "Purple": value(count) = 4286578816
            count = count + 1: kolor$(count) = "PurpleHeart": value(count) = 4285809352
            count = count + 1: kolor$(count) = "PurpleMountainsMajesty": value(count) = 4288512442
            count = count + 1: kolor$(count) = "PurplePizzazz": value(count) = 4294856410
            count = count + 1: kolor$(count) = "RadicalRed": value(count) = 4294920556
            count = count + 1: kolor$(count) = "RawSienna": value(count) = 4292250201
            count = count + 1: kolor$(count) = "RawUmber": value(count) = 4285614883
            count = count + 1: kolor$(count) = "RazzleDazzleRose": value(count) = 4294920400
            count = count + 1: kolor$(count) = "Razzmatazz": value(count) = 4293076331
            count = count + 1: kolor$(count) = "Red": value(count) = 4294901760
            count = count + 1: kolor$(count) = "RedOrange": value(count) = 4294923081
            count = count + 1: kolor$(count) = "RedViolet": value(count) = 4290790543
            count = count + 1: kolor$(count) = "RobinsEggBlue": value(count) = 4280274635
            count = count + 1: kolor$(count) = "RosyBrown": value(count) = 4290547599
            count = count + 1: kolor$(count) = "RoyalBlue": value(count) = 4282477025
            count = count + 1: kolor$(count) = "RoyalPurple": value(count) = 4286075305
            count = count + 1: kolor$(count) = "SaddleBrown": value(count) = 4287317267
            count = count + 1: kolor$(count) = "Salmon": value(count) = 4294606962
            count = count + 1: kolor$(count) = "SandyBrown": value(count) = 4294222944
            count = count + 1: kolor$(count) = "Scarlet": value(count) = 4294715463
            count = count + 1: kolor$(count) = "ScreaminGreen": value(count) = 4285988730
            count = count + 1: kolor$(count) = "SeaGreen": value(count) = 4281240407
            count = count + 1: kolor$(count) = "SeaShell": value(count) = 4294964718
            count = count + 1: kolor$(count) = "Sepia": value(count) = 4289030479
            count = count + 1: kolor$(count) = "Shadow": value(count) = 4287265117
            count = count + 1: kolor$(count) = "Shamrock": value(count) = 4282764962
            count = count + 1: kolor$(count) = "ShockingPink": value(count) = 4294672125
            count = count + 1: kolor$(count) = "Sienna": value(count) = 4288696877
            count = count + 1: kolor$(count) = "Silver": value(count) = 4290822336
            count = count + 1: kolor$(count) = "SkyBlue": value(count) = 4287090411
            count = count + 1: kolor$(count) = "SlateBlue": value(count) = 4285160141
            count = count + 1: kolor$(count) = "SlateGray": value(count) = 4285563024
            count = count + 1: kolor$(count) = "Snow": value(count) = 4294966010
            count = count + 1: kolor$(count) = "SpringGreen": value(count) = 4278255487
            count = count + 1: kolor$(count) = "SteelBlue": value(count) = 4282811060
            count = count + 1: kolor$(count) = "Sunglow": value(count) = 4294954824
            count = count + 1: kolor$(count) = "SunsetOrange": value(count) = 4294794835
            count = count + 1: kolor$(count) = "Tann": value(count) = 4291998860
            count = count + 1: kolor$(count) = "Teal": value(count) = 4278222976
            count = count + 1: kolor$(count) = "TealBlue": value(count) = 4279805877
            count = count + 1: kolor$(count) = "Thistle": value(count) = 4292394968
            count = count + 1: kolor$(count) = "TickleMePink": value(count) = 4294740396
            count = count + 1: kolor$(count) = "Timberwolf": value(count) = 4292597714
            count = count + 1: kolor$(count) = "Tomato": value(count) = 4294927175
            count = count + 1: kolor$(count) = "TropicalRainForest": value(count) = 4279730285
            count = count + 1: kolor$(count) = "Tumbleweed": value(count) = 4292782728
            count = count + 1: kolor$(count) = "Turquoise": value(count) = 4282441936
            count = count + 1: kolor$(count) = "TurquoiseBlue": value(count) = 4286045671
            count = count + 1: kolor$(count) = "UnmellowYellow": value(count) = 4294967142
            count = count + 1: kolor$(count) = "Violet": value(count) = 4293821166
            count = count + 1: kolor$(count) = "VioletBlue": value(count) = 4281486002
            count = count + 1: kolor$(count) = "VioletRed": value(count) = 4294398868
            count = count + 1: kolor$(count) = "VividTangerine": value(count) = 4294942857
            count = count + 1: kolor$(count) = "VividViolet": value(count) = 4287582365
            count = count + 1: kolor$(count) = "Wheat": value(count) = 4294303411
            count = count + 1: kolor$(count) = "White": value(count) = 4294967295
            count = count + 1: kolor$(count) = "Whitesmoke": value(count) = 4294309365
            count = count + 1: kolor$(count) = "WildBlueYonder": value(count) = 4288851408
            count = count + 1: kolor$(count) = "WildStrawberry": value(count) = 4294919076
            count = count + 1: kolor$(count) = "WildWatermelon": value(count) = 4294732933
            count = count + 1: kolor$(count) = "Wisteria": value(count) = 4291667166
            count = count + 1: kolor$(count) = "Yellow": value(count) = 4294967040
            count = count + 1: kolor$(count) = "YellowGreen": value(count) = 4288335154
            count = count + 1: kolor$(count) = "YellowOrange": value(count) = 4294946370
            ReDim _Preserve kolor$(count), value(count)
            For i = 1 To count
                If UCase$(temp$) = UCase$(kolor$(i)) Then ColorValue = value(i): Exit Function
            Next
        End If
    End If

End Function

Function ParseValues (text$, values() As String)
    ReDim values(1000) As String

    temp$ = text$ 'preserve without changing our text
    lp = InStr(temp$, "("): temp$ = Mid$(temp$, lp + 1) 'strip off any left sided parenthesis, such as _RGB32(
    rp = _InStrRev(temp$, ")"): If rp Then temp$ = Left$(temp$, rp - 1) 'strip off the right sided parenthesis )

    Do
        p = InStr(temp$, ",")
        If p Then
            eval$ = Left$(temp$, p - 1)
            If IsNum(eval$) = 0 Then ParseValues = -1: Exit Function
            count = count + 1
            If count > UBound(values) Then ReDim _Preserve values(UBound(values) + 1000) As String
            values(count) = eval$
            temp$ = Mid$(temp$, p + 1)
        Else
            eval$ = temp$
            If IsNum(eval$) = 0 Then ParseValues = -1: Exit Function
            count = count + 1
            If count > UBound(values) Then ReDim _Preserve values(UBound(values) + 1) As String
            values(count) = eval$
            temp$ = ""
        End If
    Loop Until temp$ = ""
    ReDim _Preserve values(count) As String
    ParseValues = count
End Function


Function IsNum%% (PassedText As String)
    text$ = _Trim$(PassedText)
    special$ = UCase$(Left$(text$, 2))
    Select Case special$
        Case "&H", "&B", "&O"
            'check for symbols on right side of value
            r3$ = Right$(text$, 3)
            Select Case r3$
                Case "~&&", "~%%", "~%&" 'unsigned int64, unsigned byte, unsigned offset
                    text$ = Left$(text$, Len(text$) - 3)
                Case Else
                    r2$ = Right$(text$, 2)
                    Select Case r2$
                        Case "~&", "##", "%&", "%%", "~%", "&&" 'unsigned long, float, offset, byte, unsigned integer, int64
                            text$ = Left$(text$, Len(text$) - 2)
                        Case Else
                            r$ = Right$(text$, 1)
                            Select Case r$
                                Case "&", "#", "%", "!" 'long, double, integer, single
                                    text$ = Left$(text$, Len(text$) - 1)
                            End Select
                    End Select
            End Select
            check$ = "0123456789ABCDEF"
            If special$ = "&O" Then check$ = "01234567"
            If special$ = "&B" Then check$ = "01"
            temp$ = Mid$(UCase$(text$), 2)
            For i = 1 To Len(temp$)
                If InStr(check$, Mid$(temp$, i, 1)) = 0 Then Exit For
            Next
            If i <= Len(temp$) Then IsNum = -1
        Case Else
            If _Trim$(Str$(Val(text$))) = text$ Then IsNum = -1
    End Select
End Function