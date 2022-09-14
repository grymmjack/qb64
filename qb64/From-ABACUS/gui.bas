'Old code for a gui that I was working on back in 1996
'By: Abacus

1 Cls
2 Screen 12
3 Rem This is the main box
4 Draw "C8 BM0,0 R639 D479 L639 U479"
5 Paint (2, 2), 8, 8
6 Draw "c0 bm4,46 r630 d398 l629 u398"
7 Draw "C0 BM4,45 R631 D400 L631 U400"
8 Paint (10, 60), 7, 0
9 Draw "C0 BM5,474 R59 U24"
10 Draw "C0 BM5,450 R60 D25 L60 U25"
11 Paint (8, 455), 8, 0
12 Draw "C1 BM4,4 R631 D20 L631 U20"
13 Paint (5, 5), 1, 1
14 Draw "C0 BM4,24 R631 U20"
15 Draw "C0 BM4,23 R630 U19"

16 Rem This draws the icon face
17 Draw "c7 bm9,6 r15 d14 l15 u14"
18 Paint (10, 8), 7, 7
19 Circle (16, 13), 6, 0
20 Paint (13, 17), 14, 0
21 Circle (16, 13), 5, 0
22 PSet (13, 13), 0
23 PSet (14, 13), 0
24 PSet (18, 13), 0
25 PSet (19, 13), 0
26 Draw "c0 bm14,16 r4"

27 Rem This draws the exit box
28 Draw "c7 bm613,6 r15 d14 l15 u14"
29 Paint (614, 7), 7, 7
30 Draw "c4 bm617,8 d10 r6 l6 u5 r6 l6 u5 r6"
31 Draw "c0 bm616,9 d10 r6"
32 Draw "c0 bm618,14 r4"
33 Draw "c0 bm618,9 r4"

34 Rem This is the word OPEN
35 Draw "c0 bm8,454 r10 d15 l10 u15" 'Out line of the leter O
36 Draw "c0 bm10,457 r6 d9 l6 u9" 'In line of the leter O
37 Paint (12, 456), 4, 0
38 Draw "c0 bm21,454 r9 d8 l6 d7 l3 u14 " 'Out line of the leter P
39 Draw "c0 bm24,456 r4 d4 l4 u4" 'In line of the leter P
40 Paint (23, 459), 4, 0
41 Draw "c0 bm34,454 r9  d3 l7 d3 r7 d3 l7 d3 r7 d3 l10 u15 r2"
42 'The full leter E
43 Paint (35, 456), 4, 0
44 Draw "c0 bm46,454 r5 ta30 d10 ta0 u10 r4 d16 l4 ta40 u10 ta0 d8 l4 u14 "
45 'leter N
46 Paint (47, 455), 4, 0
47 Draw "c0 bm45,471 r16 " 'underline
48 Rem End of the word OPEN

49 Rem This is the word GUI
50 Draw "c0 bm30,6 r12 d3 l3 u1 l6 d10 r10 u4 l7 u2 r10 d9 l18 u15 r2" 'Leter G
51 Paint (31, 8), 4, 0
52 Draw "c0 bm50,6 d4 r3 d11 r16 u11 r3 u4 l10 d4 r2 d7 l6 u7 r2 u4 l10"
53 'Leter U
54 Paint (51, 8), 4, 0
55 Draw "c0 bm77,6 d4 r5 d6 l5 d5 r14 u5 l5 u6 r5 u4 l13 " 'Leter I
56 Paint (79, 7), 4, 0

57 Rem The Letters GUI on the other side
58 Draw "c0 bm547,6 r12 d3 l3 u1 l6 d10 r10 u4 l7 u2 r10 d9 l18 u15 r2" 'Leter G
59 Paint (548, 8), 4, 0
60 Draw "c0 bm567,6 d4 r3 d11 r16 u11 r3 u4 l10 d4 r2 d7 l6 u7 r2 u4 l10"
61 'Leter U
62 Paint (568, 8), 4, 0
63 Draw "c0 bm594,6 d4 r5 d6 l5 d5 r14 u5 l5 u6 r5 u4 l13 " 'Leter I
64 Paint (595, 7), 4, 0


65 Rem This is the option, about, and help list.
66 'word option
67 Draw "c15 bm30,29 r7 d10 l7 u10"
68 Draw "c15 bm40,29 r7 d5 l7 u5 d10"
69 Draw "c15 bm50,29 r8 l4 d10 "
70 Draw "c15 bm60,29 r8 l4 d10 l4 r8"
71 Draw "c15 bm70,29 r7 d10 l7 u10"
72 Draw "c15 bm81,39 u10 ta30 d11 ta0 u10"
73 Draw "c15 bm29,42 r9" 'underline

74 'word about
75 'leter A
78 Draw "c15 bm290,29 ta-20 d11 ta-20 u11 ta0 r4 ta20 d11 ta20 u6 ta0 l7"
79 ' leter B
80 Draw "c15 bm301,29 r8 d4 l8 u4 d10 r8 u10 "
81 'leter O
82 Draw "c15 bm312,29 r7 d10 l7 u10"
83 'leter U
84 Draw "c15 bm322,29 d10 r7 u10"
85 'leter T
86 Draw "c15 bm332,29 r8 l4 d10"
87 Draw "c15 bm284,42 r16 " 'underline

88 'word help
89 Draw "c15 bm525,29 d10 u5 r7 u5 d10" 'leter H
90 Draw "c15 bm535,29 d10 r5 l5 u5 r5 l5 u5 r5" 'E
91 Draw "c15 bm543,29 d10 r5" 'leter L
92 Draw "c15 bm551,29 d10 u4 r7 u6 l7" 'leter P
93 Draw "c15 bm524,42 r9"


Do
    check$ = InKey$
Loop While check$ = ""
Select Case check$
    Case Chr$(79)
        GoTo 94
    Case Chr$(111)
        GoTo 94
    Case Chr$(101)
        GoTo 200
    Case Chr$(69)
        GoTo 200
    Case Chr$(65)
        GoTo 97
    Case Chr$(97)
        GoTo 97
    Case Chr$(104)
        GoTo 104
    Case Chr$(72)
        GoTo 104
    Case Chr$(110)
        GoTo 108
    Case Chr$(78)
        GoTo 108
    Case Else
        GoTo 2
End Select

94 Rem This is the option box
95 Draw "c0 bm26,27 r70 d20 l70 u20 d300 r200 u280 l200 r201 d281 l199"
96 Paint (27, 90), 8, 0

Do
    check$ = InKey$
Loop While check$ = ""
Select Case check$
    Case Chr$(27)
        GoTo hold
    Case Else
        GoTo 94
End Select

hold:
Rem This is the option box
Draw "c7 bm26,27 r70 d20 l70 u20 d300 r200 u280 l200 r201 d281 l199"
Paint (27, 90), 7, 7
Draw "c8 bm26,27 r70 d17 u17 l70 d17"
GoTo 2


97 Rem this is the about box
99 Draw "c0 bm279,27 r70 d20 l70 u20 d140 r210 u120 l210"
100 Draw "c0 bm490,47 d121 l209"
101 Paint (281, 128), 8, 0
Do
    check$ = InKey$
Loop While check$ = ""
Select Case check$
    Case Chr$(27)
        GoTo hold2
    Case Else
        GoTo 97
End Select

hold2:
Draw "c7 bm279,27 r70 d20 l70 u20 d140 r210 u120 l210"
Draw "c7 bm490,47 d121 l209"
Paint (281, 128), 7, 7
Draw "c8 bm279,27 r70 d17 u17 l70 d17"
GoTo 2

103 Rem this is the help box
104 Draw "c8 bm519,27 r50 d20 l50 u20 d20 l150 d110 r200 u130"
107 Paint (519, 156), 8, 8
105 Draw "c0 bm519,158 l150 u111 d111 r201 u112 l1 u19 l50 d19"
106 Draw "bm521,159 l150 r200 u112"

Do
    check$ = InKey$
Loop While check$ = ""
Select Case check$
    Case Chr$(27)
        GoTo hold3
    Case Else
        GoTo 104
End Select
hold3:
Draw "c7 bm519,27 r50 d20 l50 u20 d20 l150 d110 r200 u130"
Paint (519, 156), 7, 7
Draw "c7 bm519,158 l150 u111 d111 r201 u112 l1 u19 l50 d19"
Draw " c7 bm521,159 l150 r200 u112"
Draw "c8 bm519,27 r50 d17 u17 l50 d17"
GoTo 2

108 Rem This is the open box
109 Draw "c8 bm2,450 u100 r150 d100 l150"
110 Paint (9, 438), 8, 8
111 Draw "c0 bm2,450 u100 r150 d100 l150"
112 Draw "c0 bm1,449 u100 r152 d102 l149"
Do
    check$ = InKey$
Loop While check$ = ""
Select Case check$
    Case Chr$(27)
        GoTo hold4
    Case Else
        GoTo 108
End Select
hold4:
Draw "c7 bm2,450 u100 r150 d100 l150"
Paint (9, 438), 7, 7
Draw "c7 bm2,450 u100 r150 d100 l150"
Draw "c7 bm1,449 u100 r152 d102 l149"
Draw "c8 bm1,450 u101 r2 d97 r150 d5 l89 u2 l60 d2 l2"
Paint (100, 449), 8, 8
Draw "c8 bm5,451 r60"
GoTo 2
200 End











