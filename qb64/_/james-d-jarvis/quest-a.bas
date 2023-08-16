'QUEST-A
'BASIC PROGRAMME FOR THE SPECTRAVIDEO CompuMate
'AUTHOR: Graham.J.Percy
'25th September, 1998.
'edited to work in QB but otherwise unchanged
1 Q$ = "+---------+"
2 Print Q$, " QUEST-A", Q$, " BY"
3 Print "GRAHAM PERCY", "1=PLAY"
4 Input C
5 R$ = "[ ]"
6 S$ = "+--- ---+"
7 T$ = " ]"
9 V$ = "+---+-+---+"
10 W$ = "[ O++ ]"
11 Y$ = "1=DOWN 2=RIGHT"
12 Print S$, R$, R$, T$, R$, Q$
13 Print "A BIG ROOM", "1=LEFT 2=UP"
14 Input "ACTION=", B
15 If B = 1 Then GoTo 32
16 If B <> 2 Then GoTo 14
18 If K <> 1 Then Print Q$, W$
20 If K = 1 Then Print Q$, R$
21 Print T$, R$, S$, "LONG HALL"
23 Print "1=LEFT 2=DOWN"
24 If K <> 1 Then Print "3=GET KEY"
25 Input "ACTION=", B
26 If B = 2 Then GoTo 12
27 If B = 1 Then GoTo 48
28 If B <> 3 Then GoTo 25
29 If K = 0 Then Print "YOU GOT KEY"
30 Let K = 1
31 GoTo 18
32 Print S$, R$, "[", Q$, "A DARK HALL"
33 If P = 1 Then GoTo 38
34 G = Int(1 + Rnd * 2): F = Int(1 + Rnd * 3)
35 If G <> 2 Then GoTo 38
36 Print "OGRE HERE", "1=UP 2=RIGHT", "3=FIGHT"
37 GoTo 39
38 Print "1=UP 2=RIGHT"
39 Input "ACTION=", B
40 If B = 3 And G = 2 And F = 3 Then GoTo 96
41 If B = 2 Then GoTo 12
42 If B = 1 Then GoTo 48
43 If B <> 3 Then GoTo 39
44 Print "GOT THE OGREGOT ARMOUR"
45 Let P = 1
46 GoTo 32
48 If D = 1 Then If E = 3 Then GoTo 70
49 If D = 0 Then If E = 3 Then GoTo 77
50 Print V$, R$, "[", R$, S$
51 Print "TROLL, DOOR", Y$, "3=OPEN 4=FIGHT"
52 Input "ACTION=", B
53 If B = 1 Then GoTo 32
54 If B = 2 Then GoTo 18
55 If B = 3 Then If K = 1 Then GoTo 60
56 If B = 3 Then Print "NEED A KEY"
57 If B = 4 Then GoSub 88
59 GoTo 48
60 Print "TROL SAY NO"
61 GoTo 48
70 Print S$, R$, "[", R$, S$, "OPEN DOOR", Y$, "3=UP"
71 Input "ACTION=", B
72 If B = 1 Then GoTo 32
73 If B = 2 Then GoTo 18
74 If B <> 3 Then GoTo 71
75 Print "* * *", " *", "", R$, R$, S$, "YOU,RE FREE"
76 GoTo 97
77 Print V$, R$, "[", R$, S$, "A DOOR", Y$, "3=OPEN DOOR"
79 Input "ACTION=", B
80 If B = 1 Then GoTo 32
81 If B = 2 Then GoTo 18
82 If B = 3 Then If K = 1 Then GoTo 85
83 If B = 3 Then Print "NEED A KEY"
84 GoTo 79
85 Print "YOU OPEN IT"
86 Let D = 1
87 GoTo 70
88 If P = 0 Then Let F = Int(Rnd * 1): E = E + 1
89 If P = 1 Then Let F = Int(Rnd * 14): E = E + 1
90 Print "YOU ATTACK,"
91 If F = 0 Then GoTo 96
92 If E = 3 Then Print "GOT HIM"
93 Return
96 Print "HE GOT YOU"
97 Print "BYE"