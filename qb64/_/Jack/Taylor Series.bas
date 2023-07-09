 
_Title "Taylor"
'program deriv by Oliver Aberth
 
'the original program computed the derivatives of the expression
'I changed it to compute the taylor series instead
'it was included as an example in the Basic interpreter called
'precision Basic which ran on CP/M and IMB compatible PC's
 
'there are shortcomings to the program, for example it fails to compute
'the series for sin(x)/x at x=0 due to division by 0.
 
'if the number of terms is 0 then it simply evaluates the expression
'involving the variable x using the value of the expansion point.
 
10 Dim A$(26), C#(200), E%(200), K%(200)
20 PI# = 3.141592653589793#
30 M% = 60
40 J% = 0
50 A$(2) = "x": A$(3) = "(": A$(4) = "Acos(": A$(5) = "Asin("
60 A$(6) = "Atan(": A$(7) = "Cos(": A$(8) = "Cosh(": A$(9) = "Exp("
70 A$(10) = "Log(": A$(11) = "Sin(": A$(12) = "Sinh(": A$(13) = "Sqr("
80 A$(14) = "Tan(": A$(15) = "Tanh(": A$(16) = "-": A$(17) = "+"
90 A$(21) = "+": A$(22) = "-": A$(23) = "*": A$(24) = "/": A$(25) = "^": A$(26) = ")"
100 Cls
110 Print
120 Print Tab(10); "Program to expand f(x) into a Taylor series"
130 Print
140 Input "Enter by number the highest term to be calculated ", N%
150 If Int(N%) <> N% Or N% < 0 Then 140
160 Print
170 Print "specify f(x) by entering successive elements of f(x) by code below"
180 Print "(entering a zero will delete the last f(x) element)"
190 Print
200 Print "C denotes any constant"
210 J% = 1: K% = 1: E9% = 0: E3% = 17
220 Print
230 GoTo 260
240 Print
250 Cls
260 Print "f(x)=";
270 If J% = 1 Then 360
280 For I% = 1 To J% - 1
    290 E% = E%(I%)
    300 If E% <> 1 Then 340
    310 K1% = K%(I%)
    320 Print C#(K1%);
    330 GoTo 350
    340 Print A$(E%);
350 Next I%
360 Print: Print
370 If E3% = 6 Then 450
380 Print "C X ( acos asin atan cos cosh exp  log sin sinh sqr  tan tanh";
390 If E3% = 17 Then Print "  -  +": GoTo 410
400 Print
410 Print "1 2 3  4    5    6  7    8  9    10  11  12  13  14  15";
420 If E3% = 17 Then Print "  16  17": GoTo 510
430 Print
440 GoTo 510
450 Print "+  -  *  /  ^  ";
460 If E9% > 0 Then Print ")": GoTo 480
470 Print "end of f(x)"
480 Print "1  2  3  4  5";
490 If E9% > 0 Then Print "  6": GoTo 510
500 Print "          6"
510 Input "Enter code integer ", E%
520 If Int(E%) <> E% Or E% < 0 Or E% > E3% Then 240
530 If E% > 0 Then 690
540 If J% = 1 Then 240
550 J% = J% - 1
560 E% = E%(J%)
570 If E% < 21 Then 610
580 E3% = 6
590 If E% = 26 Then E9% = E9% + 1
600 GoTo 240
610 If E% < 16 Then 640
620 E3% = 17
630 GoTo 240
640 E3% = 17
650 If E%(J% - 1) = 16 Or E%(J% - 1) = 17 Then E3% = 15
660 If E% = 1 Then K% = K% - 1
670 If E% >= 3 Then E9% = E9% - 1
680 GoTo 240
690 If E3% = 6 Then 860
700 If E3% = 15 Then 740
710 If E% <= 15 Then 740
720 E3% = 15
730 GoTo 920
740 If E% <> 1 Then 800
750 Input "Enter constant ", A$
760 C#(K%) = Val(A$ + "#")
770 K%(J%) = K%: K% = K% + 1
780 E3% = 6
790 GoTo 920
800 If E% <> 2 Then 830
810 E3% = 6
820 GoTo 920
830 E9% = E9% + 1
840 E3% = 17
850 GoTo 920
860 E% = E% + 20
870 If E% <> 26 Then 910
880 If E9% = 0 Then 950
890 E9% = E9% - 1
900 GoTo 920
910 E3% = 17
920 E%(J%) = E%
930 J% = J% + 1
940 GoTo 240
950 E%(J%) = 27
960 N1% = N% + 1
970 Dim O%(M%), V%(M%), S#(M%, N1%)
980 S#(0, 1) = 1#
990 If N% < 2 Then 1030
1000 For L% = 2 To N%
    1010 S#(0, L%) = 0#
1020 Next L%
1030 For L% = 1 To M%
    1040 S#(L%, N1%) = 0#
1050 Next L%
1060 Print
1070 For L% = 1 To M%
    1080 If S#(L%, N1%) <> 0# Then Stop
1090 Next L%
1100 Print "    press return to end or enter expantion point"
1101 Input "Enter x value at which series is to be expanded ", A$
1110 If A$ = "" Then End
1120 Z# = Val(A$ + "#")
1130 C#(0) = Z#
1140 Cls
1150 S#(0, 0) = C#(0): O% = 0: V% = 0: S# = 0#: J% = 0: O%(0) = 0: E3% = 17
1160 J% = J% + 1: E% = E%(J%)
1170 If E3% = 6 Then 1540
1180 If E3% = 15 Then 1250
1190 If E% < 16 Then 1250
1200 E3% = 15
1210 If E% = 17 Then 1160
1220 O% = O% + 1
1230 O%(O%) = 30
1240 GoTo 1160
1250 If E% = 1 Then 1380
1260 If E% = 2 Then 1340
1270 If E% = 3 Then 1300
1280 O% = O% + 1
1290 O%(O%) = E% + 30
1300 O% = O% + 1
1310 O%(O%) = 10
1320 E3% = 17
1330 GoTo 1160
1340 V%(V%) = 0
1350 V% = V% + 1
1360 E3% = 6
1370 GoTo 1160
1380 For I% = 1 To M%
    1390 If S#(I%, N1%) = 0# Then 1430
1400 Next I%
1410 Print "Stack filled"
1420 Stop
1430 V%(V%) = I%
1440 V% = V% + 1
1450 K% = K%(J%)
1460 S#(I%, 0) = C#(K%)
1470 If N% < 1 Then 1510
1480 For K% = 1 To N%
    1490 S#(I%, K%) = 0#
1500 Next K%
1510 S#(I%, N1%) = 1#
1520 E3% = 6
1530 GoTo 1160
1540 If E% > 24 Then 1580
1550 O2% = 20
1560 If E% > 22 Then O2% = 22
1570 GoTo 1600
1580 O2% = 30
1590 If E% > 25 Then O2% = 20
1600 If O%(O%) <= O2% Then 1630
1610 GoSub 1880
1620 GoTo 1600
1630 If E% = 27 Then 1720
1640 If E% = 26 Then 1690
1650 O% = O% + 1
1660 O%(O%) = E%
1670 E3% = 17
1680 GoTo 1160
1690 If O%(O%) <> 10 Then Stop
1700 O% = O% - 1
1710 GoTo 1160
1720 If O%(O%) <> 0 Or V% <> 1 Then Stop
1730 I% = V%(0)
1740 S#(I%, N1%) = 0#
1750 Print
1751 Print "if there are more than 20 terms to be printed then the program"
1752 Print "will pause after printing 20 terms and wait for a keypress"
1753 Print "to print another 20 terms and so on until all terms are printed"
1754 Input "press return to continue", A$
1756 Print
1760 Print "function    = ";
1770 If S#(I%, 0) >= 0# Then Print " ";
1780 Print S#(I%, 0)
1790 If N% < 1 Then 1870
1800 For K% = 1 To N%
    1810 Print "A"; K%;
    1820 Print Tab(14); "= ";
    1830 If S#(I%, K%) >= 0 Then Print " ";
    1840 Print S#(I%, K%)
    1850 If (K% Mod 20) = 0 Then Input "", A$
1860 Next K%
1865 Input "", A$
1870 GoTo 1060
1880 O1% = O%(O%): O% = O% - 1
1890 For K% = 1 To M%
    1900 If S#(K%, N1%) = 0# Then 1930
1910 Next K%
1920 Stop
1930 S#(K%, N1%) = 1#
1940 Z# = V% - 1#
1950 K2% = V%(Z#)
1960 S#(K2%, N1%) = 0#
1970 If O1% >= 30 Then 2890
1980 V% = Z#
1990 Z# = Z# - 1#
2000 K1% = V%(Z#)
2010 V%(Z#) = K%
2020 S#(K1%, N1%) = 0#
2030 If O1% = 21 Then 2080
2040 If O1% = 22 Then 2120
2050 If O1% = 23 Then 2160
2060 If O1% = 24 Then 2240
2070 GoTo 2340
2080 For L% = 0 To N%
    2090 S#(K%, L%) = S#(K1%, L%) + S#(K2%, L%)
2100 Next L%
2110 Return
2120 For L% = 0 To N%
    2130 S#(K%, L%) = S#(K1%, L%) - S#(K2%, L%)
2140 Next L%
2150 Return
2160 For L% = 0 To N%
    2170 Z# = 0#
    2180 For M1% = 0 To L%
        2190 Z# = Z# + S#(K1%, M1%) * S#(K2%, L% - M1%)
    2200 Next M1%
    2210 S#(K%, L%) = Z#
2220 Next L%
2230 Return
2240 Z1# = S#(K2%, 0)
2250 For L% = 0 To N%
    2260 Z# = S#(K1%, L%)
    2270 If L% = 0 Then 2310
    2280 For M1% = 1 To L%
        2290 Z# = Z# - S#(K2%, M1%) * S#(K%, L% - M1%)
    2300 Next M1%
    2310 S#(K%, L%) = Z# / Z1#
2320 Next L%
2330 Return
2340 If N% < 1 Then 2390
2350 For L% = 1 To N%
    2360 Z# = S#(K2%, L%)
    2370 If Z# <> 0# Then 2800
2380 Next L%
2390 Z1# = S#(K1%, 0)
2400 Z# = S#(K2%, 0)
2410 Z2# = Z# + 1#
2420 If Z1# = 0# Then If Int(Z#) = Z# And Z# > 0# Then 2550
2430 S#(K%, 0) = Z1# ^ Z#
2440 If N% < 1 Then 2540
2450 For L% = 1 To N%
    2460 Z# = 0#: Z3# = 0#
    2470 For M1% = 1 To L%
        2480 Z4# = S#(K%, L% - M1%) * S#(K1%, M1%)
        2490 Z3# = Z3# + Z4#
        2500 Z# = Z# + M1% * Z4#
    2510 Next M1%
    2520 S#(K%, L%) = (Z# * Z2# / L% - Z3#) / Z1#
2530 Next L%
2540 Return
2550 For K3% = 1 To M%
    2560 If S#(K3%, N1%) = 0 Then If K3% <> K2% Then 2590
2570 Next K3%
2580 Stop
2590 S#(K%, N1%) = 0#
2600 Z2# = Z#
2610 For L% = 0 To N%
    2620 S#(K%, L%) = 0#
    2630 S#(K3%, L%) = S#(K1%, L%)
2640 Next L%
2650 S#(K%, 0) = 1#
2660 K4% = K%
2670 Z# = Int(Z2# / 2)
2680 Z1# = Z2# - Z# - Z#
2690 Z2# = Z#
2700 If Z1# = 0 Then 2770
2710 K1% = K3%: Z# = K2%: K2% = K4%: K% = Z#: K4% = Z#
2720 GoSub 2160
2730 If Z2# > 0 Then 2770
2740 S#(K%, N1%) = 1#
2750 V%(V% - 1) = K%
2760 Return
2770 K1% = K3%: Z# = K2%: K2% = K3%: K% = Z#: K3% = Z#
2780 GoSub 2160
2790 GoTo 2670
2800 V%(V%) = K2%
2810 S#(K2%, N1%) = 1#
2820 V% = V% + 1: K2% = K1%
2830 GoSub 3070
2840 O1% = 23
2850 GoSub 1890
2860 O1% = 39
2870 GoSub 1890
2880 Return
2890 V%(Z#) = K%
2900 If O1% <> 30 Then 2950
2910 For L% = 0 To N%
    2920 S#(K%, L%) = -S#(K2%, L%)
2930 Next L%
2940 Return
2950 If O1% <> 39 Then 3060
2960 S#(K%, 0) = Exp(S#(K2%, 0))
2970 If N% < 1 Then 3050
2980 For L% = 1 To N%
    2990 Z# = 0#
    3000 For M1% = 1 To L%
        3010 Z# = Z# + M1% * S#(K%, L% - M1%) * S#(K2%, M1%)
    3020 Next M1%
    3030 S#(K%, L%) = Z# / L%
3040 Next L%
3050 Return
3060 If O1% <> 40 Then 3190
3070 Z2# = S#(K2%, 0)
3080 S#(K%, 0) = Log(Z2#)
3090 If N% < 1 Then 3180
3100 For L% = 1 To N%
    3110 Z# = 0#
    3120 If L% = 1 Then 3160
    3130 For M1% = 1 To L% - 1
        3140 Z# = Z# + M1% * S#(K2%, L% - M1%) * S#(K%, M1%)
    3150 Next M1%
    3160 S#(K%, L%) = (S#(K2%, L%) - Z# / L%) / Z2#
3170 Next L%
3180 Return
3190 If O1% = 37 Or O1% = 38 Or O1% = 41 Or O1% = 42 Or O1% = 44 Or O1% = 45 Then 3210
3200 GoTo 3550
3210 For K3% = 1 To M%
    3220 If S#(K3%, N1%) = 0 Then If K3% <> K2% Then 3250
3230 Next K3%
3240 Stop
3250 If Not (O1% = 37 Or O1% = 38) Then 3270
3260 Z# = K%: K% = K3%: K3% = Z#
3270 Z# = S#(K2%, 0)
3280 If O1% = 38 Or O1% = 42 Or O1% = 45 Then 3330
3290 S#(K%, 0) = Sin(Z#)
3300 S#(K3%, 0) = Cos(Z#)
3310 Z1# = -1#
3320 GoTo 3380
3330 S#(K%, 0) = Exp(Z#)
3340 S#(K%, 0) = .5# * (S#(K%, 0) - 1# / S#(K%, 0))
3350 S#(K3%, 0) = Exp(Z#)
3360 S#(K3%, 0) = .5# * (S#(K3%, 0) + 1# / S#(K3%, 0))
3370 Z1# = 1#
3380 If N% < 1 Then 3490
3390 For L% = 1 To N%
    3400 Z# = 0#: Z2# = 0#
    3410 For M1% = 1 To L%
        3420 Z3# = M1% * S#(K2%, M1%)
        3430 Z# = Z# + S#(K3%, L% - M1%) * Z3#
        3440 Z2# = Z2# + S#(K%, L% - M1%) * Z3#
    3450 Next M1%
    3460 S#(K%, L%) = Z# / L%
    3470 S#(K3%, L%) = Z2# * Z1# / L%
3480 Next L%
3490 If Not (O1% = 44 Or O1% = 45) Then Return
3500 S#(K3%, N1%) = 1#
3510 V%(V%) = K3%
3520 V% = V% + 1
3530 O1% = 24
3540 GoTo 1890
3550 If O1% <> 43 Then 3610
3560 Z1# = S#(K2%, 0)
3570 Z2# = 1.5#
3580 S#(K%, 0) = Sqr(Z1#)
3590 K1% = K2%
3600 GoTo 2440
3610 For K3% = 1 To M%
    3620 If S#(K3%, N1%) = 0 Then If K3% <> K2% Then 3650
3630 Next K3%
3640 Stop
3650 Z1# = -1#
3660 If O1% = 36 Then Z1# = 1#
3670 S#(K3%, 0) = 1# + Z1# * S#(K2%, 0) * S#(K2%, 0)
3680 If N% < 1 Then 3760
3690 For L% = 1 To N%
    3700 Z# = 0#
    3710 For M1% = 0 To L%
        3720 Z# = Z# + S#(K2%, M1%) * S#(K2%, L% - M1%)
    3730 Next M1%
    3740 S#(K3%, L%) = Z# * Z1#
3750 Next L%
3760 If O1% <> 36 Then 3890
3770 S#(K%, 0) = Atn(S#(K2%, 0))
3780 Z1# = S#(K3%, 0)
3790 If N% < 1 Then 3880
3800 For L% = 1 To N%
    3810 Z# = 0#
    3820 If L% = 1 Then 3860
    3830 For M1% = 1 To L% - 1
        3840 Z# = Z# + M1% * S#(K3%, L% - M1%) * S#(K%, M1%)
    3850 Next M1%
    3860 S#(K%, L%) = (S#(K2%, L%) - Z# / L%) / Z1#
3870 Next L%
3880 Return
3890 S#(K3%, N1%) = 1#
3900 S#(K%, N1%) = 0#
3910 V%(V% - 1) = K3%
3920 Z1# = S#(K3%, 0)
3930 S#(K%, 0) = Sqr(Z1#)
3940 Z2# = 1.5#
3950 If N% < 1 Then 4060
3960 For L% = 1 To N%
    3970 Z# = 0#
    3980 Z3# = 0#
    3990 For M1% = 1 To L%
        4000 Z4# = S#(K%, L% - M1%) * S#(K3%, M1%)
        4010 Z3# = Z3# + Z4#
        4020 Z# = Z# + Z4# * M1%
    4030 Next M1%
    4040 S#(K%, L%) = (Z# * Z2# / L% - Z3#) / Z1#
4050 Next L%
4060 Z1# = S#(K%, 0)
4070 X# = S#(K2%, 0)
4080 If Abs(X#) = 1 Then Y# = Sgn(X#) * .5 * PI# Else Y# = Atn(X# / Sqr(1# - X# * X#))
4090 S#(K3%, 0) = Y#
4100 If N% < 1 Then 4190
4110 For L% = 1 To N%
    4120 Z# = 0#
    4130 If L% = 1 Then 4170
    4140 For M1% = 1 To L% - 1
        4150 Z# = Z# + M1% * S#(K%, L% - M1%) * S#(K3%, M1%)
    4160 Next M1%
    4170 S#(K3%, L%) = (S#(K2%, L%) - Z# / L%) / Z1#
4180 Next L%
4190 If O1% = 35 Then Return
4200 S#(K3%, 0) = S#(K3%, 0) - .5# * PI#
4210 O1% = 30
4220 GoTo 1890