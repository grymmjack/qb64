10 REM Super Soccer Manager Part 2 V3.0
20 REM Written by A.SILL
30 REM (c). 1992
40 REM Part of THE BASIC ARRAY compilation of BASIC programs
50 REM
60 IF DISPLAY% = 0 THEN CLS : PRINT "SSM1 must be run first.": WHILE INKEY$ = "": WEND: STOP
70 IF DISPLAY% = 2 THEN SCREEN 9
80 TEAM% = 1: WEEK% = 1: PREV% = 1: RAND = 0: SPECIAL% = 0: HOURS% = 40: FIRSTNAME% = 128: SURNAME% = 397: SEASON% = 0: A = 16: FLAGX = 1: NUMPLA% = 11: GAMES% = 0
86 RESTORE 88
87 FOR A = 1 TO 10: READ GRADING$(A): NEXT A
88 DATA Abysmal,Terrible,Very Poor,Poor,Mediocre,Average,Good,Very Good,Excellent,Brilliant
90 POSITION$(1) = "Goalkeeper": POSITION$(2) = "Defender": POSITION$(3) = "Midfielder": POSITION$(4) = "Attacker"
95 A = 16
100 DIM T$(80), POINTS%(A), WINS%(A), POSITION%(A), LOSSES%(A), DRAWS%(A), SCORE%(A), GFOR%(A), GAGAINST%(A), FIXTURES$(30), FIXT%(A), TEAM$(A), P1$(FIRSTNAME%), P2$(SURNAME%), PLA$(A, A + 4), FIG%(A, A + 4, 2), CHANCE%(A), CHANCES%(A), LEAGUE%(80), TIMEH%(10)
110 DIM TIMEA%(10), GOALS%(A + 4), A%(A + 4), CHART%(30), TN%(A + 4), B(A), C(A), RES$(30)
120 GOSUB 590 ' ++++++++ READ IN TEAM DATA
130 GOSUB 2380 ' ++++++++ READ IN FIXTURE DATA
140 GOSUB 2770 ' ++++++++ READ IN INDIVIDUAL NAMES
150 REM ++++++++ PICK A TEAM ++++++++
160 CLS
170 IF DISPLAY% = 2 THEN COLOR 14 ELSE COLOR 15
180 LOCATE 2, 25: PRINT "CHOOSE A TEAM TO MANAGE"
190 IF DISPLAY% = 2 THEN COLOR 10
200 TEAM% = 1
210 FOR A = 1 TO 20
220 LOCATE A + 3, 1: PRINT T$(A)
230 LOCATE A + 3, 20: PRINT T$(A + 20)
240 LOCATE A + 3, 38: PRINT T$(A + 40)
250 LOCATE A + 3, 61: PRINT T$(A + 60)
260 NEXT A
270 COLOR 7
280 LOCATE 4, 1: PRINT T$(1)
290 A$ = ""
300 WHILE A$ <> CHR$(13)
310 A$ = INKEY$: IF A$ = "" THEN GOTO 310
320 A$ = RIGHT$(A$, 1)
330 IF A$ = "H" AND TEAM% <> 1 AND TEAM% <> 21 AND TEAM% <> 41 AND TEAM% <> 61 THEN PREV% = TEAM%: TEAM% = TEAM% - 1
340 IF A$ = "K" AND TEAM% > 20 THEN PREV% = TEAM%: TEAM% = TEAM% - 20
350 IF A$ = "P" AND TEAM% <> 20 AND TEAM% <> 40 AND TEAM% <> 60 AND TEAM% <> 80 THEN PREV% = TEAM%: TEAM% = TEAM% + 1
360 IF A$ = "M" AND TEAM% < 61 THEN PREV% = TEAM%: TEAM% = TEAM% + 20
370 IF TEAM% < 21 THEN LOCATE TEAM% + 3, 1
380 IF TEAM% > 20 AND TEAM% < 41 THEN LOCATE TEAM% - 20 + 3, 20
390 IF TEAM% < 61 AND TEAM% > 40 THEN LOCATE TEAM% - 40 + 3, 38
400 IF TEAM% > 60 AND TEAM% < 81 THEN LOCATE TEAM% - 60 + 3, 61
410 COLOR 7
420 PRINT T$(TEAM%)
430 IF PREV% < 21 THEN LOCATE PREV% + 3, 1
440 IF PREV% > 20 AND PREV% < 41 THEN LOCATE PREV% - 20 + 3, 20
450 IF PREV% < 61 AND PREV% > 40 THEN LOCATE PREV% - 40 + 3, 38
460 IF PREV% > 60 AND PREV% < 81 THEN LOCATE PREV% - 60 + 3, 61
470 IF DISPLAY% = 2 THEN COLOR 10 ELSE COLOR 15
480 PRINT T$(PREV%)
490 RAND% = RAND% + 1
500 WEND
510 C = 0: TEAMNO% = TEAM%
520 B = 0: FOR A = 1 TO 80: IF LEAGUE%(TEAM%) = LEAGUE%(A) THEN B = B + 1: TEAM$(B) = T$(A): TN%(B) = A
530 IF TEAM% = A THEN C = B: D = LEAGUE%(TEAM%)
540 NEXT A
550 TEAM% = C: LEAGUE% = D: FLAGX = 1: PREV% = 0
560 GOSUB 2500 ' ++++++++ GET MANAGERS NAME
570 MANAGER$ = ST$
580 GOTO 830
590 REM ++++++++ READ IN TEAM DATA
600 RESTORE 620
610 FOR A = 1 TO 80: READ T$(A), LEAGUE%(A): NEXT A
620 DATA AFC Bournemouth,3,Arsenal,1,Aston Villa,1,Barnsley,2,Birmingham City,3
630 DATA Blackburn Rovers,2,Blackpool,4,Bolton Wanderers,4,Bradford City,3,Brentford,4
640 DATA Brighton,3,Bristol City,3,Bristol Rovers,4,Burnley,5,Bury,5
650 DATA Cambridge United,2,Cardiff City,5,Charlton Athletic,2
660 DATA Chelsea,1,Chester City,5,Coventry City,1,Crewe Alexandra,5
670 DATA Crystal Palace,1,Darlington,5,Derby County,2,Doncaster Rovers,5
680 DATA Everton,1,Exeter City,4,Fulham,4,Gillingham,5,Grimsby Town,3
690 DATA Huddersfield Town,4,Hull City,3
700 DATA Ipswich Town,2,Leeds United,1,Leicester City,2,Leyton Orient,5,Lincoln City,5
710 DATA Liverpool,1,Luton Town,2,Manchester City,1
720 DATA Manchester United,1,Mansfield Town,5,Middlesbrough,2,Millwall,2
730 DATA Newcastle United,2,Northampton Town,5,Norwich City,2,Nottingham Forest,1
740 DATA Notts County,1,Oldham Athletic,2,Oxford United,3,Peterbrough United,5
750 DATA Plymouth Argyle,3,Portsmouth,2,Port Vale,3,Preston North End,4
760 DATA Queens Park Rangers,2,Reading,4,Rotherham United,5
770 DATA Scunthorpe United,4,Sheffield United,1,Sheffield Wednesday,1
780 DATA Shrewsbury Town,5,Southampton,2,Southend United,4,Stockport County,5
790 DATA Stoke City,4,Sunderland,3,Swansea City,4,Swindon Town,3,Torquay United,4
800 DATA Tottenham Hotspur,1,Tranmere Rovers,3,Watford,3,West Brom,4
810 DATA West Ham United,3,Wigan Athletic,4,Wimbledon,1,Wolves,3
820 RETURN
830 REM ++++++++ SELECT PLAYERS FOR YOUR TEAM
840 CLS
850 IF DISPLAY% = 2 THEN COLOR 11 ELSE COLOR 15
860 LOCATE 2, 28: PRINT "SUPER SOCCER MANAGER v3.0"
870 IF DISPLAY% = 2 THEN COLOR 10 ELSE COLOR 15
880 LOCATE 4, 9: PRINT "Part of THE BASIC ARRAY shareware package. (c).1992 by A.Sill."
881 PRINT "This program was written as a last desperate resort, and was seen as the last   possible chance to take Doncaster Rovers into the Premier League.  In reality   this may be seen as a slightly difficult task.  Therefore, Super Soccer Manager"
882 PRINT "was designed and coded for this very purpose.  It did however become known to   me that this plight was mirrored by hundreds and thousands of fans from various other (albeit substandard) clubs.  It also became aware to me that several other";
883 PRINT "clubs had different ambitions, ranging from Leeds winning away to Torquay       climbing out of the third division.  Obviously some are quite impossible, but   many people (strange as it may seem) would like to try to achieve these dreams.";
884 PRINT "So the universal, multi talented centre forward menu style program, Super SoccerManager was born.  Now into it's fourth version (which actually works), it has  collected a huge fan base and now you are going to join that bunch of groupies.";
885 PRINT "Good luck, and have loads of fun while you try to achieve your goals, ho ho ho. Oh by the way, the full story of this program and other transcripts can be foundon this disk.  Yes that goes for Millers fans too.  "
900 IF DISPLAY% = 1 THEN COLOR 15 ELSE COLOR 10
910 LOCATE 23, 30: PRINT "PLEASE WAIT - LOADING"
920 REM ***** AFC BOURNEMOUTH
930 IF TEAMNO% = 1 THEN GROUND$ = "Dean Court          Red And White         Cherries       1890"
940 REM ***** ARSENAL
950 IF TEAMNO% = 2 THEN GROUND$ = "Highbury            Red And White         Gunners        1886"
960 REM ***** ASTON VILLA
970 IF TEAMNO% = 3 THEN GROUND$ = "Villa Park          Claret And Blue       Villa          1874"
980 REM ***** BARNSLEY
990 IF TEAMNO% = 4 THEN GROUND$ = "Oakwell             Red And White         Reds           1887"
1000 REM ***** BIRMINGHAM CITY
1010 IF TEAMNO% = 5 THEN GROUND$ = "St.Andrews          Blue And White        Blues          1875"
1020 REM ***** BLACKBURN ROVERS
1030 IF TEAMNO% = 6 THEN GROUND$ = "Ewood Park          Blue And White        Rovers         1875"
1040 REM ***** BLACKPOOL
1050 IF TEAMNO% = 7 THEN GROUND$ = "Bloomfield Road     Tangerine And White   Seasiders      1887"
1060 REM ***** BOLTON WANDERERS
1070 IF TEAMNO% = 8 THEN GROUND$ = "Burnden Park        White And Blue        Trotters       1874"
1080 REM ***** BRADFORD CITY
1090 IF TEAMNO% = 9 THEN GROUND$ = "Valley Parade       Claret And Amber      Bantams        1903"
1100 REM ***** BRENTFORD
1110 IF TEAMNO% = 10 THEN GROUND$ = "Griffin Park        Red/White And Black   Bees           1889"
1120 REM ***** BRIGHTON AND HOVE ALBION
1130 IF TEAMNO% = 11 THEN GROUND$ = "Goldstone Ground    Blue And White        Seagulls       1900"
1140 REM ***** BRISTOL CITY
1150 IF TEAMNO% = 12 THEN GROUND$ = "Ashton Gate         Red And White         Robins         1894"
1160 REM ***** BRISTOL ROVERS
1170 IF TEAMNO% = 13 THEN GROUND$ = "Twerton Park        White And Blue        Pirates        1883"
1180 REM ***** BURNLEY
1190 IF TEAMNO% = 14 THEN GROUND$ = "Turf Moor           Claret And Blue       Clarets        1882"
1200 REM ***** BURY
1210 IF TEAMNO% = 15 THEN GROUND$ = "Gigg Lane           Navy And White        Shakers        1885"
1220 REM ***** CAMBRIDGE UNITED
1230 IF TEAMNO% = 16 THEN GROUND$ = "Abbey Stadium       Amber And Black       U's            1919"
1240 REM ***** CARDIFF CITY
1250 IF TEAMNO% = 17 THEN GROUND$ = "Ninian Park         Blue And White        Bluebirds      1899"
1260 REM ***** CHARLTON ATHLETIC
1270 IF TEAMNO% = 18 THEN GROUND$ = "Selhurst Park       Red And White         Valiants       1905"
1280 REM ***** CHELSEA
1290 IF TEAMNO% = 19 THEN GROUND$ = "Stamford Bridge     All Blue              Blues          1905"
1300 REM ***** CHESTER CITY
1310 IF TEAMNO% = 20 THEN GROUND$ = "Moss Rose Ground    Blue And White        City           1884"
1320 REM ***** COVENTRY CITY
1330 IF TEAMNO% = 21 THEN GROUND$ = "Highfield Road      Blue And White        Sky Blues      1883"
1340 REM ***** CREWE ALEXANDRA
1350 IF TEAMNO% = 22 THEN GROUND$ = "Gresty Road         Red And White         Railwaymen     1877"
1360 REM ***** CRYSTAL PALACE
1370 IF TEAMNO% = 23 THEN GROUND$ = "Selhurst Park       Red And Blue          Eagles         1905"
1380 REM ***** DARLINGTON
1390 IF TEAMNO% = 24 THEN GROUND$ = "Feethams Ground     All White             Quakers        1883"
1400 REM ***** DERBY COUNTY
1410 IF TEAMNO% = 25 THEN GROUND$ = "Baseball Ground     Black And White       Rams           1884"
1420 REM ***** DONCASTER ROVERS
1430 IF TEAMNO% = 26 THEN GROUND$ = "Belle Vue           Red And White         Rovers         1879"
1440 REM ***** EVERTON
1450 IF TEAMNO% = 27 THEN GROUND$ = "Goodison Park       Blue And White        Toffeemen      1878"
1460 REM ***** EXETER CITY
1470 IF TEAMNO% = 28 THEN GROUND$ = "St.James Park       Red/White And Black   Grecians       1904"
1480 REM ***** FULHAM
1490 IF TEAMNO% = 29 THEN GROUND$ = "Craven Cottage      White And Black       Cottagers      1879"
1500 REM ***** GILLINGHAM
1510 IF TEAMNO% = 30 THEN GROUND$ = "Priestfield Stadium Blue And White        Gills          1893"
1520 REM ***** GRIMSBY TOWN
1530 IF TEAMNO% = 31 THEN GROUND$ = "Blundell Park       Black And White       Mariners       1878"
1540 REM ***** HUDDERSFIELD TOWN
1550 IF TEAMNO% = 32 THEN GROUND$ = "Leeds Road          Blue And White        Terriers       1908"
1560 REM ***** HULL CITY
1570 IF TEAMNO% = 33 THEN GROUND$ = "Boothferry Park     Amber And Black       Tigers         1904"
1580 REM ***** IPSWICH TOWN
1590 IF TEAMNO% = 34 THEN GROUND$ = "Portman Road        Blue And White        Super Blues    1887"
1600 REM ***** LEEDS UNITED
1610 IF TEAMNO% = 35 THEN GROUND$ = "Elland Road         All White             United         1919"
1620 REM ***** LEICESTER CITY
1630 IF TEAMNO% = 36 THEN GROUND$ = "Filbert Street      Blue And White        Foxes          1884"
1640 REM ***** LEYTON ORIENT
1650 IF TEAMNO% = 37 THEN GROUND$ = "Brisbane Road       Red And White         O's            1881"
1660 REM ***** LINCOLN CITY
1670 IF TEAMNO% = 38 THEN GROUND$ = "Sincil Bank         Red And White         Red Imps       1883"
1680 REM ***** LIVERPOOL
1690 IF TEAMNO% = 39 THEN GROUND$ = "Anfield             All Red               Reds           1892"
1700 REM ***** LUTON TOWN
1710 IF TEAMNO% = 40 THEN GROUND$ = "Kenilworth Road     White And Navy Blue   Hatters        1885"
1720 REM ***** MANCHESTER CITY
1730 IF TEAMNO% = 41 THEN GROUND$ = "Maine Road          Sky Blue And White    Citizens       1887"
1740 REM ***** MANCHESTER UNITED
1750 IF TEAMNO% = 42 THEN GROUND$ = "Old Trafford        Red And White         Red Devils     1878"
1760 IF TEAMNO% = 43 THEN GROUND$ = "Field Mill          All Amber             Stags          1891"
1770 IF TEAMNO% = 44 THEN GROUND$ = "Ayresome Park       Red And White         Boro           1876"
1780 IF TEAMNO% = 45 THEN GROUND$ = "The Den             Blue And White        Lions          1885"
1790 REM ***** NEWCASTLE UNITED
1800 IF TEAMNO% = 46 THEN GROUND$ = "St. James Park      Black And White       Magpies        1882"
1810 REM ***** NORTHAMPTON TOWN
1820 IF TEAMNO% = 47 THEN GROUND$ = "County Ground       Claret And Maroon     Cobblers       1897"
1830 REM ***** NORWICH CITY
1840 IF TEAMNO% = 48 THEN GROUND$ = "Carrow Road         Yellow And Green      Canaries       1905"
1850 REM ***** NOTTINGHAM FOREST
1860 IF TEAMNO% = 49 THEN GROUND$ = "City Ground         Red And White         Forest         1865"
1870 IF TEAMNO% = 50 THEN GROUND$ = "Meadow Lane         Black And White       Magpies        1862"
1880 IF TEAMNO% = 51 THEN GROUND$ = "Boundary Park       All Blue              Latics         1894"
1890 IF TEAMNO% = 52 THEN GROUND$ = "Manor Ground        Gold And Navy Blue    U's            1893"
1900 IF TEAMNO% = 53 THEN GROUND$ = "London Road         Blue And White        Posh           1923"
1910 IF TEAMNO% = 54 THEN GROUND$ = "Home Park           Green And White       Pilgrims       1886"
1920 IF TEAMNO% = 55 THEN GROUND$ = "Fratton Park        Blue And Black        Pompey         1898"
1930 IF TEAMNO% = 56 THEN GROUND$ = "Vale Park           White And Black       Valiants       1876"
1940 IF TEAMNO% = 57 THEN GROUND$ = "Deepdale            White And Blue        Lilywhites     1881"
1950 IF TEAMNO% = 58 THEN GROUND$ = "Rangers Stadium     Blue And White        Rangers        1882"
1960 IF TEAMNO% = 59 THEN GROUND$ = "Elm Park            Blue And Yellow       Royals         1871"
1970 IF TEAMNO% = 60 THEN GROUND$ = "Millmoor            Red And White         Merry Millers  1884"
1980 IF TEAMNO% = 61 THEN GROUND$ = "Glanford Park       Sky Blue And Claret   Irons          1899"
1990 REM ***** SHEFFIELD UNITED
2000 IF TEAMNO% = 62 THEN GROUND$ = "Bramall Lane        Red/White And Black   Blades         1889"
2010 REM ***** SHEFFIELD WEDNESDAY
2020 IF TEAMNO% = 63 THEN GROUND$ = "Hillsborough        Blue And White        Owls           1867"
2030 REM ***** SHREWSBURY TOWN
2040 IF TEAMNO% = 64 THEN GROUND$ = "Gay Meadow          All White             Shrews         1886"
2050 IF TEAMNO% = 65 THEN GROUND$ = "The Dell            Red/White And Black   Saints         1885"
2060 IF TEAMNO% = 66 THEN GROUND$ = "Roots Hall          Blue And Yellow       Shrimpers      1906"
2070 IF TEAMNO% = 67 THEN GROUND$ = "Edgeley Park        White And Blue        Hatters        1883"
2080 IF TEAMNO% = 68 THEN GROUND$ = "Victoria Ground     Red And White         Potters        1863"
2090 IF TEAMNO% = 69 THEN GROUND$ = "Roker Park          Red/White And Black   Rokerites      1879"
2100 IF TEAMNO% = 70 THEN GROUND$ = "Vetch Field         All White             Swans          1900"
2110 IF TEAMNO% = 71 THEN GROUND$ = "County Ground       Red And White         Robins         1881"
2120 IF TEAMNO% = 72 THEN GROUND$ = "Plainmoor           All Yellow            Gulls          1898"
2130 IF TEAMNO% = 73 THEN GROUND$ = "White Hart Lane     White And Navy Blue   Spurs          1882"
2140 IF TEAMNO% = 74 THEN GROUND$ = "Prenton Park        All White             Rovers         1881"
2150 IF TEAMNO% = 75 THEN GROUND$ = "Vicarage Road       Yellow/Black And Red  Hornets        1891"
2160 IF TEAMNO% = 76 THEN GROUND$ = "The Hawthorns       Navy Blue And White   Throstles      1879"
2170 IF TEAMNO% = 77 THEN GROUND$ = "Upton Park          Claret/Blue And White Hammers        1895"
2180 IF TEAMNO% = 78 THEN GROUND$ = "Springfield Park    Blue And White        Latics         1932"
2190 IF TEAMNO% = 79 THEN GROUND$ = "Plough Lane         All Blue              Dons           1889"
2200 IF TEAMNO% = 80 THEN GROUND$ = "Molineux            Gold And Black        Wolves         1877"
2210 REM ***** LOAD AND PICK NAMES
2220 C% = 0: D% = 1
2230 OPEN "NAMES.TXT" FOR INPUT AS #1
2240 OPEN "NAMES.TMP" FOR OUTPUT AS #2
2250 FOR B% = 1 TO 80
2260 FOR A% = 1 TO 16
2270 INPUT #1, A$
2280 IF A$ = "" AND A% < 15 THEN GOSUB 3230
2290 PRINT #2, A$
2300 IF LEAGUE%(B%) = LEAGUE% THEN PLA$(D%, A%) = A$: C% = 1
2310 NEXT A%
2320 IF C% = 1 THEN D% = D% + 1: C% = 0
2330 NEXT B%
2340 CLOSE #2
2350 CLOSE #1
2360 REM ***** LOAD Super Soccer Manager and use ALL the variables set up in                   this part 1 loader.
2370 CHAIN "SSM3"
2380 REM ++++++++ READ IN FIXTURE DATA
2390 RESTORE 2410
2400 FOR A = 1 TO 30: READ FIXTURES$(A): NEXT A
2410 DATA 123F4E5D6C7B8A9G,132G4F5E6D7C8B9A,14235F6E7D8C9BAG,15243G6F7E8D9CAB
2420 DATA 1G2F3E4D5C6B7A89,1F2E3D4C5B6A798G,1E2D3C4B5A6978FG,1D2C3B4A59687GEF
2430 DATA C1B2A3948576FDGE,B1A2938475G6FCED,A192837465FBECGD
2440 DATA 615243F7E8D9CAGB,716253G4F8E9DABC,81726354F9EADBGC,91827364G5FAEBDC
2450 DATA 1625347F8E9DACBG,1726354G8F9EADBC,182736459FAEBDCG,192837465GAFBECD
2460 DATA 21F3E4D5C6B7A8G9,31G2F4E5D6C7B8A9,4132F5E6D7C8B9GA,5142G3F6E7D8C9BA
2470 DATA G1F2E3D4C5B6A798,F1E2D3C4B5A697G8,E1D2C3B4A59687GF,D1C2B3A49586G7FE
2480 DATA 1C2B3A495867DFEG,1B2A3948576GCFDE,1A29384756BFCEDG
2490 RETURN
2500 REM ++++++++ ENTER MANAGERS NAME
2510 CLS
2520 IF DISPLAY% = 2 THEN COLOR 14 ELSE COLOR 15
2530 LOCATE 2, 25: PRINT "Managerial Application Form"
2540 IF DISPLAY% = 2 THEN COLOR 7 ELSE COLOR 15
2550 LOCATE 4, 55: PRINT "1 High Street"
2560 LOCATE 5, 55: PRINT "MarketTown"
2570 LOCATE 6, 55: PRINT "LONDON"
2580 LOCATE 7, 55: PRINT "LW1 S19"
2590 LOCATE 8, 55: PRINT DATE$
2600 LOCATE 9, 1: PRINT "Dear "; T$(TEAMNO%); " F.C."
2610 LOCATE 11, 1: PRINT "                Please find enclosed a C.V. detailing my career in Football, I  would like to be given a chance to manage your football club. I believe I have  the correct qualities and experiance to better the clubs future."
2620 PRINT "            I would like to start as soon as possible and bring as much success as I can provide, as soon as possible."
2630 PRINT : PRINT "                   Yours faithfully,"
2640 PRINT : PRINT "                         SIGN HERE :";
2650 IF DISPLAY% = 2 THEN COLOR 6 ELSE COLOR 7
2660 MAX% = 22: Y = 19: X = 38
2670 A$ = INKEY$: IF A$ = "" THEN GOTO 2670
2680 IF A$ = CHR$(13) AND ST$ <> "" THEN RETURN
2690 IF A$ = CHR$(13) AND ST$ = "" THEN PRINT CHR$(7): GOTO 2670
2700 IF A$ = CHR$(8) AND ST$ <> "" THEN ST$ = LEFT$(ST$, LEN(ST$) - 1): LOCATE Y, X: PRINT ST$; "     ": GOTO 2670
2710 IF (ASC(A$) > 64 AND ASC(A$) < 91) OR (A$ = " " OR A$ = "-") OR (ASC(A$) > 96 AND ASC(A$) < 123) THEN GOTO 2720 ELSE GOTO 2670
2720 IF LEN(ST$) > MAX% - 1 THEN GOTO 2670
2730 ST$ = ST$ + A$
2740 LOCATE Y, X: PRINT ST$ + " "
2750 GOTO 2670
2760 REM +++++++ READ IN INDIVIDUAL PLAYERS NAMES
2770 RESTORE 2790
2780 FOR A = 1 TO FIRSTNAME%: READ P1$(A): NEXT A
2790 DATA Andrew,Andy,Adam,Alan,Alex,Adrian,Anthony,Archie,Alec
2800 DATA Bill,Billy,Brian,Brad,Brendan,Bernard,Bob,Bert,Bobby,Bernie
2810 DATA Chris,Colin,Craig,Charles,Charlie,Clay,Clem,Chris,Craig
2820 DATA Danny,David,Darren,Duncan,Dean,Daniel,Dan,Dave
2830 DATA Eric,Eddie,Edward,Ed
2840 DATA Fred,Freddy,Frank,Francis
2850 DATA Graham,Geoff,Gareth,Gary,Gregory,Gavin,Gordon,George
2860 DATA Harry,Henry,Hugh
2870 DATA Ian,Iain
2880 DATA John,Johnny,Jim,James,Jimmy,Jeff,Jack,Jock,Joseph,Joe,Joey
2890 DATA Kevin,Keith,Kenny
2900 DATA Lee,Les,Laurence,Larry,Laurie
2910 DATA Martin,Mark,Mick,Michael,Mickey,Max,Mike,Micky
2920 DATA Nick,Nicky,Neil,Nigel,Ned
2930 DATA Paul,Phillip,Phil,Perry,Patrick,Pat,Paddy,Peter,Pete
2940 DATA Ryan,Rodney,Roger,Ray,Russell,Richard,Robert,Robin
2950 DATA Steven,Stephen,Steve,Stuart,Stewart,Scott,Sam,Shane,Simon,Samuel,Sandy
2960 DATA Trevor,Terry,Tony,Thomas,Tommy,Ted,Tom
2970 DATA William,Will,Willie,Walter
2980 FOR A = 1 TO SURNAME%: READ P2$(A): NEXT A
2990 DATA Adams,Allen,Ablett,Aldridge,Adamson,Arkwright,Aliss,Ashurst,Andrews,Anderson,Alder,Appleby,Albiston,Ashcroft,Ash,Allison,Anchorage,Aspen,Ashen,Anderton,Astbury,Alderson,Archer,Ashburn
3000 DATA Brown,Bonney,Burrows,Barrett,Bradley,Bruce,Bright,Burns,Berry,Barton,Barnes,Brandon,Brady,Bould,Bird,Brightman,Broad,Bryant,Bramble,Bolton,Bradwell,Baker,Ball,Burman,Birch,Burnden,Burne,Brent,Becker,Bailey,Bell
3010 DATA Cherry,Charles,Clarke,Campbell,Crossley,Crosby,Chettle,Chapman,Cooke,Cook,Cripps,Cripsey,Cundy,Cookson,Charleston,Cranberry,Carter,Cartwright,Chambers,Cross,Chester,Chest,Chestnut,Crest,Carlston,Cutts,Chimney,Chivers
3020 DATA Dale,Daley,Durie,Dorley,Davison,Davidson,Davies,Dublin,Dougle,Duxbury,Dawson,Dawlear,Dixon,Dillen,Darrington,Delaney,Duggen,Davis,Dessie,Deere,Deehan,Dranbury,Dane,Day,Dunn
3030 DATA Earle,Edwards,Easter,Ellis,Essex,Edmonds,Emerson,Elliott,East,Eastwick,Ellison,Everly,Evers,Etherton,Eaves
3040 DATA Francis,Franklin,Flowers,Fenwick,Fishenden,Farrell,Foster,Finney,Franks,Finbow,Ferguson,French,Fife,Frederick,Fisher,Fife
3050 DATA Garrett,Gates,Gidman,Gillard,Goddard,Gallacher,Grimes,Grade,Goats
3060 DATA Hughes,Hunter,Hirst,Hasten,Holden,Hay,Haines,Hagan,Hardwick,Helliwell,Hill,Hunt,Howe,Hodge,Harford,Higgins,Hilman,Hick,Hickling,Hales,Holling,Hartley,Hart,Healy,Harvey,Hawkins
3070 DATA Innes,Innersly,Inman,Ilkley
3080 DATA Jeffrey,Jones,Johnson,Johnstone,Jeffs,Jefferson,James,Jameson
3090 DATA Kelly,Knight,Kay,Kennedy,Kidd,Knowles,Kerry,Kilson
3100 DATA Lambert,Laws,Lintell,Lynagh,Lukas,Lawlor,Laker,Lines,Lester,Lloyd,Leicester,Lampard,Lake,Lamb,London,Linton,Lyon,Little,Larderly,Liddell,Lane,Lintell,Lacey
3110 DATA Marshall,Malcolm,Mariner,Marsh,McDonald,Mullen,Morris,Moore,Murphy,McGlinchey,Miles,MacLeod,McPhillips,Middleton,Main,Morton,McKinley,McKinnon,McCain,McDuff,McSwain,Mensley,Melon,Mason
3120 DATA Norris,Nicol,Nicholas,Nicholson,Nixon,Nester,Norse,Narey,Nearsly,Naylor
3130 DATA Oliver,Ormsby,Ord,O'Reilly,O'Dowd,Ostin,Owers,Ostle,O'Connor,O'Neill,O'Neil,Oldroyd,Ostwick,Orly,Oban,Ockley,Otter,Oats,Oades,Oarly,O'Hara,Oldfield
3140 DATA Price,Pearce,Pallister,Parker,Prince,Phelan,Pleat,Peake,Palmer,Prince,Parnell,Purse,Parrott,Penny,Pembridge,Prean,Preston,Painter,Purcell,Printon,Prean,Pinter,Peckett,Potts
3150 DATA Rogers,Rush,Robson,Robinson,Radford,Reeves,Ramsey,Roberts,Rix,Royle,Rowley,Reid,Reed,Rowlston,Rowing,Rippon,Raven,Reade,Rakes,Reever,Rinton,Raynor,Rhodes
3160 DATA Stevens,Steven,Swales,Smith,Samways,Stark,Sill,Sinton,Slater,Stiles,Swift,Storey,Shaw,Stock,Stocksley,Shiels,Stones,Stone,Stoneham,Stead,Steadman,Stanson,Slate,Stealer,Stetson,Stream,Strickers,Sneap,Sanderson,Spiers,Skippon
3170 DATA Terry,Thomas,Talbot,Taylor,Temple,Thompson,Thomson,Todd,Towers,Teale,Tyson,Tracer,Thimble,Thorn,Timson,Trent,Tydesley,Tilder,Tracey
3180 DATA Vanes,Vine,Verse
3190 DATA Whelan,Wright,Williams,Waddle,Wakefield,Wilkins,Webb,Ward,Wardley,West,Weston,Westerley,Waverley,Wheeler,White,Weeks,Wheat,Wingley,Willis,Wellington,Walton,Wilmot,Wood
3200 DATA Young,Yorke,Yale,Yugo,Yates
3210 RETURN
3220 REM ++++++++ PICK A NAME AT RANDOM
3230 G% = (RND * (FIRSTNAME% - 1)) + 1: H% = (RND * (SURNAME% - 1)) + 1
3240 A$ = P1$(G%) + " " + P2$(H%)
3250 RETURN

