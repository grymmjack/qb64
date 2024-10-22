'RETRO.BAS by Matt Bross, 1997
'HOMEPAGE - http://www.GeoCities.Com/SoHo/7067/
'EMAIL    - oh_bother@GeoCities.Com
DEFINT A-Z
DECLARE SUB BYE ()
DECLARE SUB ShowHiScore ()
DECLARE SUB DELAY (SEC!)
DECLARE SUB FrogINTRO ()
DECLARE SUB OptScn (SPECIAL)
DECLARE SUB Frogger (TLIVES%, ODIF%, OT%, OD!)
DECLARE SUB NewHiScore (SCORE%)

TYPE ScoreType
  SCORE AS LONG
  PERSON AS STRING * 3
END TYPE

DIM SHARED HISCORE(9) AS ScoreType

SCREEN 7: CLS
RANDOMIZE TIMER + VAL(DATE$) + RND
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INTRO AND GAME%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FrogINTRO
ShowHiScore
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%BEGIN DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FroggerGraphics:
'frog
DATA 9,9,0,-32612,0,-32612,20,-32578,0,-32598,0,-32513,0,-32513,-32567,-32513
DATA 0,54,8,62,0,54,0,127,0,127,28,127,0,99,34,-32541,0,-32575,-32575,-32575
DATA 0,0
'car1
DATA 9,9,-32513,-32513,-32513,0,-32575,-32575,-32513,0,-32575,-32575,-32541,0
DATA 0,0,-32541,0,0,128,-32513,128,0,0,-32513,0,0,0,-32578,0,0,0,28,65,-32578
DATA -32578,-32578,0
'car2
DATA 9,9,-32513,-32513,-32513,0,-32513,-32575,-32575,0,-32541,-32575,-32575,0
DATA -32541,0,0,0,255,-32768,-32768,-32768,-32513,0,0,0,-32578,0,0,0,28,0,0
DATA 65,-32578,-32578,-32578,0
'log1
DATA 9,9,-32640,-32513,127,-32640,0,-32513,-32513,64,0,-32513,-32513,64,0
DATA -32513,-32513,64,0,-32513,-32513,64,0,-32513,-32513,64,0,-32513,-32513
DATA 64,0,-32513,-32513,64,-32640,-32513,127,-32640
'lily
DATA 9,9,-32547,-32513,0,-32513,-32632,127,0,127,0,-32513,0,-32513,8,-32513,0
DATA -32521,-32632,-32513,0,119,-32567,-32513,0,-32586,-32575,255,0,255
DATA -32541,127,0,93,-32513,-32513,0,-32541
'water
DATA 9,9,-32513,-32513,0,-32513,-32513,219,0,219,-32513,146,0,146,-32513,73,0
DATA 73,-32513,-32513,0,-32513,-32513,219,0,219,-32513,146,0,146,-32513,73,0
DATA 73,-32513,-32513,0,-32513
'road
DATA 9,9,-32513,-32513,-32513,0,-32513,-32513,-32513,0,-32513,-32513,-32513,0
DATA -32513,-32513,-32513,0,-32513,-32513,-32513,127,-32513,-32513,-32513,0
DATA -32513,-32513,-32513,0,-32513,-32513,-32513,0,-32513,-32513,-32513,0
'exit1
DATA 9,9,-32513,0,0,-32513,-32513,127,127,-32640,-32576,64,64,-32577,-32576
DATA 64,64,-32577,-32576,64,64,-32577,-32576,64,64,-32577,-32576,64,64,-32577
DATA -32576,64,64,-32577,-32576,64,64,-32577
FroggerIntroPalette:
DATA 1,0,7,2,8,7,4,5,7,7,10,10,10,8,7,15
FroggerIntroGraphics:
'title1
DATA 57,87,0,0,48,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-3976,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,-3841,0,0,0,-24576,0,0,0,0,0,0,0,0,0,0,0,-1793,0,0,0,-16369
DATA 0,0,0,0,0,0,0,0,0,0,768,-1793,0,0,0,-3969,0,0,0,0,0,0,0,0,0,0,7936
DATA -1793,0,0,256,28927,0,0,0,0,0,0,0,0,0,0,16128,-1793,0,0,3840,28784
DATA 0,0,0,0,0,0,0,8192,0,0,32512,-3841,0,0,1536,-8159,0,0,0,0,0,0,0,-8192
DATA 0,0,-256,-3841,0,0,2048,-8189,0,0,0,0,0,0,0,-8190,0,0,-253,-7937,0
DATA 0,20224,-16361,0,0,0,0,0,0,0,-16363,0,0,-249,-16129,0,0,-26623,-32513
DATA 0,0,0,0,0,0,0,-32705,0,0,-241,-16129,0,0,-20477,127,0,0,0,0,0,0,0
DATA 63,0,0,-481,15615,0,0,8199,-16322,0,0,0,0,0,0,0,30,0,0,-225,1023,128
DATA 0,16399,-994,0,0,0,0,0,0,0,30,0,0,-225,1790,96,0,16399,-2019,0,0,0
DATA 0,0,0,0,28,0,0,-193,1276,32,0,16399,-1765,192,0,0,0,0,0,0,24,0,0,-129
DATA 1272,32,0,24604,-1225,0,0,0,0,0,0,0,48,0,0,-129,1272,16,0,12344,-1673
DATA 192,0,0,0,0,0,0,112,0,0,-1,-31503,16,0,2096,31470,96,0,0,0,0,0,0,224
DATA 0,256,-1,29935,16,0,26466,2496,160,0,0,0,0,0,768,192,0,768,-1,7904
DATA 8,0,-10265,0,192,0,0,0,0,0,1536,0,0,1792,-1,608,8,256,-8977,128,112
DATA 0,0,0,0,0,1024,0,0,3840,-257,832,8,768,-15889,128,144,0,0,0,0,0,0
DATA 0,0,7936,-769,64,232,1792,-27665,128,0,0,0,0,0,0,0,0,0,16128,-257
DATA 64,56,3840,4591,128,0,0,0,0,0,0,0,0,0,16128,-1537,64,16,7936,32495
DATA 128,0,0,0,0,0,0,0,0,0,32512,-1537,64,16,7936,32494,128,0,0,0,0,0,0
DATA 0,0,0,-256,-1537,192,16,16128,-308,0,0,0,0,0,0,0,0,0,0,-255,-769,192
DATA 16,32256,32732,0,0,0,0,0,0,0,0,0,0,-255,-1281,128,16,31744,-232,0
DATA 0,0,0,0,0,0,0,0,0,-255,-1793,128,16,32256,-200,0,0,0,0,0,0,0,0,0,0
DATA -255,-513,192,32,-512,-208,0,0,0,0,0,0,0,0,0,0,-255,-3329,192,32,-512
DATA -208,0,0,0,0,0,0,0,0,0,0,-205,-8449,64,32,-512,-14,128,0,0,0,0,0,0
DATA 0,0,0,-197,-769,96,64,-8704,-14,160,0,0,0,32,0,0,0,0,0,-217,-3841
DATA 48,64,-9191,-14,208,0,0,0,16,0,0,0,0,0,-221,-11777,40,128,-8931,-10
DATA 248,0,0,256,40,0,0,0,0,0,-221,-513,52,128,-9955,-10,220,0,0,256,20
DATA 0,0,0,0,0,-205,-16385,-73,0,-9443,-9,236,0,0,768,164,0,0,0,0,0,-185
DATA -4865,19548,0,-27847,-17,-3857,0,0,0,76,0,0,0,0,0,-185,-3329,-391
DATA 0,-18631,-49,-1801,0,0,512,112,0,0,0,0,0,-153,255,-16404,128,-18631
DATA -33,-1805,0,0,0,224,0,0,0,0,0,-185,16639,32566,240,-18629,-97,-2079
DATA 0,0,0,32,0,0,0,0,0,-185,8446,-221,254,14139,-65,15808,224,0,0,0,0
DATA 0,0,0,0,-185,254,-224,235,28475,-65,2016,92,0,0,32,0,0,0,0,0,-153
DATA 254,3904,-32519,20283,-65,128,254,0,0,0,0,0,0,0,0,-185,24820,128,-32514
DATA 32571,-1,0,1,0,0,0,0,0,0,0,0,-185,205,128,-32765,-197,-1,0,0,0,0,0
DATA 0,0,0,0,0,-185,192,128,0,-197,-1,0,0,0,0,0,0,0,0,0,0,-121,6608,0,0
DATA -133,-257,0,0,0,6144,0,0,0,0,0,0,-121,5504,0,0,-133,-257,0,0,0,5120
DATA 0,0,0,0,0,0,-121,-4672,0,0,-133,-257,0,0,0,-5120,0,0,0,0,0,0,-313
DATA -17024,0,0,-133,-257,0,0,0,-17408,0,0,0,0,0,0,-1401,-9340,0,0,-133
DATA -769,0,0,0,-10236,0,0,0,0,0,0,-1401,-17729,0,0,-133,-769,0,0,0,-18241
DATA 0,0,0,0,0,0,-377,-2823,0,0,-135,-1793,0,0,0,-3847,0,0,0,0,0,0,-9329
DATA -19233,0,0,-143,-1793,0,0,768,-20257,0,0,0,0,0,0,-3509,-1793,0,0,-207
DATA -3841,0,0,512,-3841,0,0,0,0,0,0,-31919,-28469,0,0,-224,-7937,0,0,768
DATA -32565,0,0,0,0,0,0,-30383,-7970,0,0,32544,255,0,0,2304,222,0,0,0,0
DATA 0,0,865,87,0,0,-256,252,0,0,768,84,0,0,0,0,0,0,-6656,188,0,0,7936
DATA 248,0,0,1536,184,0,0,0,0,0,0,8960,248,0,0,7936,240,0,0,768,240,0,0
DATA 0,0,0,0,13056,248,0,0,3840,240,0,0,768,240,0,0,0,0,0,0,4352,248,0
DATA 0,3840,240,0,0,256,240,0,0,0,0,0,0,7168,248,0,0,3840,240,0,0,3072
DATA 240,0,0,0,0,0,0,7680,124,0,0,3840,248,0,0,3584,120,0,0,0,0,0,0,7936
DATA 28,0,0,3840,248,0,0,3840,24,0,0,0,0,0,0,32512,140,0,0,1792,248,0,0
DATA 0,8,0,0,0,0,0,0,-253,228,0,0,16128,248,0,0,0,0,0,0,0,0,0,0,-241,244
DATA 0,0,-255,248,0,0,0,0,0,0,0,0,0,0,-225,252,0,0,-241,240,0,0,0,0,0,0
DATA 0,0,0,0,-193,248,0,0,-993,0,0,0,0,0,0,0,0,0,0,0,-385,0,0,0,56,0,0
DATA 0,0,0,0,0,0,0,0,0,-8000,0,0,0,63,0,0,0,0,0,0,0,0,0,0,0,30832,0,0,0
DATA -32753,0,0,0,0,0,0,0,0,0,0,0,-14577,-8057,0,0,14336,0,0,0,0,0,0,0
DATA 0,0,0,0,16128,-3969,0,0,0,-8057,0,0,0,-8185,0,0,0,0,0,0,0,-7937,0
DATA 0,0,8,0,0,0,8,0,0,0,0,0,0,0,-1921,0,0,0,-16345,0,0,0,-16345,0,0,0
DATA 0,0,0,0,-385,0,0,0,14352,0,0,0,14352,0,0,0,0,0,0,0,31800,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
'title2
DATA 54,81,0,0,48,0,0,0,0,0,0,0,0,0,0,0,0,0,48,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,-7951,0,0,0,0,0,0,0,0,0,0,0,0,0,-7951,0,0,2048,0,0,0,8192,0,0,0
DATA 0,0,256,-24322,0,0,0,0,0,0,16385,0,0,0,0,0,256,-7937,0,0,2816,64,0
DATA 0,8192,0,0,0,0,0,256,-3842,0,0,0,64,0,0,1,0,0,0,0,0,256,-7945,0,0
DATA 2,32,0,0,24,0,0,0,0,0,16128,-3841,0,0,-19455,80,0,0,0,0,0,0,0,0,16128
DATA -3841,0,0,-7671,32,0,0,16384,0,0,0,32,0,32512,-24322,0,0,16514,240
DATA 0,0,1,0,0,0,0,0,-256,24829,0,0,-32766,176,0,0,16386,0,0,0,0,0,-249
DATA -24321,0,2304,-24824,0,0,1280,16384,0,0,5376,0,0,-243,16607,0,0,-8440
DATA 0,0,4098,-20448,0,0,2560,0,0,-225,-7937,0,512,-256,16,0,4100,2048
DATA 0,0,7424,0,0,-489,2047,192,1024,-16640,48,0,8456,-16384,0,0,7680,0
DATA 0,-193,1258,64,1792,4352,184,0,16384,16396,128,0,0,0,0,-129,16626
DATA 64,1792,2304,-24574,0,8192,-12028,0,0,0,0,0,-4225,-23324,32,3584,5120
DATA 16386,0,4144,-6133,160,0,0,0,0,30079,1093,32,15872,2576,184,0,-21888
DATA 16529,96,0,0,0,768,-1,-19272,48,20736,25856,74,0,1024,-32750,0,0,0
DATA 0,1792,-1,7792,16,-3326,-32262,16512,0,256,352,160,0,0,0,3840,-257
DATA 688,16,-2298,-7447,233,0,512,0,224,0,0,0,7936,-1,864,208,-221,-31520
DATA 92,0,2048,80,32,0,0,0,16128,-1,16,112,-2289,-23836,-32618,0,0,10240
DATA 0,0,0,0,32512,-1,144,32,-1265,1484,20490,4096,0,5376,0,0,0,0,-256
DATA -257,80,32,-1177,735,180,0,0,2560,128,0,0,0,-255,-257,80,544,-3105
DATA 9375,80,0,0,0,0,0,0,0,-255,-1,48,32,1407,-13793,16,0,80,8192,0,0,0
DATA 0,-255,-257,32,32,1791,20751,16,0,8192,128,0,0,0,0,-255,-257,32,0
DATA 3807,21020,12448,0,256,2176,0,0,0,0,-255,-1,184,8192,3775,16522,4184
DATA 0,0,0,0,0,0,0,-253,-257,88,64,7799,-23024,-28644,48,256,-32768,40
DATA 0,0,0,-214,-1,140,5184,3819,25408,8208,1,0,1040,16,0,0,0,-201,-257
DATA 6,2176,17486,22612,4272,0,256,2720,96,0,0,0,-253,-1,37,-31616,3754
DATA -29744,16627,112,384,81,0,0,0,0,-221,-1,16038,-11264,-12224,22980
DATA 1089,8,0,-32768,0,0,-31232,0,-201,-1,21499,2048,-3864,9312,1156,512
DATA 0,26656,0,0,-29952,0,-217,-257,-16409,-16256,-12208,6608,1032,56,256
DATA 16385,8,0,1536,0,-187,-769,-10466,-22416,6200,-26368,2052,18,768,10842
DATA 132,0,1537,0,-16537,-2817,27299,-25604,20737,21568,16,16384,2816,1448
DATA 0,0,0,0,-185,-7425,8002,-18200,-13559,9608,0,0,5376,8408,20,0,0,0
DATA -185,-7937,946,-28420,20997,68,4,40,6912,-22280,0,0,0,0,32611,-3841
DATA 2,-31744,-17919,15626,-22384,-32752,1280,17728,64,0,0,0,-189,25342
DATA 4,-18432,-11115,23191,49,4,2561,-30048,40,0,0,0,-189,255,4,-20480
DATA -5380,-30556,4181,4,22785,81,0,0,0,0,-189,-32514,200,-28672,22751
DATA 12309,-22452,44,27137,-24058,0,0,0,0,-189,253,168,-31744,-19974,17799
DATA 17476,48,28674,0,0,0,-32768,0,-61,2046,104,0,12663,-27328,2050,29
DATA -18432,-30718,128,0,0,0,-637,1524,216,1280,-23813,9386,29,152,20489
DATA 1,20,0,0,0,-893,-3628,208,1024,16637,10254,1,569,43,10752,160,0,144
DATA 0,-893,-6149,96,19456,16637,4104,12312,657,4108,128,4,0,8352,0,-53
DATA 32495,160,1024,21757,149,0,56,5124,64,0,0,72,0,-4729,-2101,192,24576
DATA 9470,8238,0,152,9744,0,0,0,209,0,-860,11791,64,20736,4350,-32555,0
DATA 266,1248,0,0,0,40,0,25516,29223,128,20736,-9807,165,0,3584,10241,0
DATA 0,0,80,0,-860,11791,64,21248,4096,-32560,0,17160,480,0,0,2048,32,0
DATA -4857,-2101,192,0,1106,32,0,-24424,10768,0,0,512,16400,0,-30654,-3897
DATA 0,0,11552,12,0,-30961,533,0,0,512,16,0,20032,24609,0,2560,3584,176
DATA 0,16901,9232,0,0,256,64,0,1536,-24519,0,3328,1032,16,0,-24574,18450
DATA 0,0,2048,160,0,1024,-4036,0,1280,544,12,0,4864,1,0,0,3072,48,0,1536
DATA 28734,0,1280,16457,128,0,-24568,2049,0,0,512,0,0,3840,4349,0,1280
DATA 176,104,0,16384,-32766,0,0,3328,0,0,16128,-12033,0,1280,16708,32,0
DATA -32766,0,0,0,0,0,0,-256,-3841,0,1280,-8183,0,0,512,0,0,0,0,0,0,-256
DATA -16129,0,768,12367,32,0,0,72,0,0,0,0,0,-253,248,0,1024,770,80,0,0
DATA 0,0,0,0,0,0,3590,0,0,2048,-10240,8,0,-3839,-32734,0,0,0,0,0,-30965
DATA 3264,0,1024,8232,144,0,21000,16,0,0,0,0,0,29456,-264,0,0,1420,0,0
DATA 16,2,0,0,0,0,0,800,-4065,0,0,-24528,0,0,544,2112,0,0,0,0,0,64,-16889
DATA 0,-24576,2048,0,0,0,20480,0,0,0,0,0,128,-2801,128,16384,0,16384,0
DATA 128,2560,0,0,256,128,0,0,-29949,0,0,1024,64,0,0,8192,0,0,0,8,0,0,-16383
DATA 0,0,0,16,0,0,0,0,0,0,0,0,0,-16384,0,0,256,0,0,0,0,0,0,0,0,0,0,-16384
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,-32767,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0
DATA 0,0,0,-32768,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0
'title3
DATA 55,82,0,0,48,0,0,0,0,0,0,32,0,0,0,0,0,0,16,0,0,0,0,0,0,32,0,0,0,0
DATA 0,0,96,0,0,0,0,0,0,64,0,0,0,0,0,0,64,0,0,0,0,0,0,32,0,0,0,0,0,0,-7952
DATA 0,0,0,16,0,0,65,0,0,0,0,0,0,16465,0,0,16384,0,0,0,-32608,0,0,0,0,0
DATA 0,-7951,0,0,8192,16,0,0,81,0,0,0,0,0,256,16483,0,0,16384,0,0,0,-32638
DATA 0,0,0,0,0,256,-32605,0,0,256,0,0,0,16448,0,0,0,0,0,768,16597,0,0,768
DATA 0,0,512,-32520,0,0,0,0,0,768,16633,0,0,2304,0,0,256,-32554,0,0,0,0
DATA 0,768,85,0,0,0,192,0,0,234,0,0,0,0,0,512,-16134,0,0,-1536,0,0,256
DATA 5,0,0,0,0,0,256,21,0,0,8452,0,0,2560,-32546,0,0,0,0,0,11776,-16129
DATA 0,0,-16374,0,0,5376,0,0,0,0,0,0,-6400,16639,0,0,8,128,0,-4096,16384
DATA 0,0,0,0,0,-16637,254,0,256,256,128,0,24576,16384,0,0,0,0,0,-235,-16132
DATA 0,8192,2816,0,0,523,160,0,0,0,0,0,-5607,-3345,128,3072,18184,1,0,5890
DATA 12344,0,0,0,0,0,-233,-18945,0,0,26112,-16246,0,10,16408,0,0,0,0,0
DATA -193,-21254,192,0,256,67,0,-2781,4190,0,0,0,0,0,22301,16630,64,256
DATA 512,-32624,0,-21978,10413,0,0,0,0,0,-4113,24818,32,-30976,512,-12261
DATA 0,21784,-16307,0,0,0,0,256,-2057,20708,32,514,6656,16552,0,-21992
DATA 165,0,0,0,0,3840,-1026,-29779,32,15878,16512,112,0,17729,1844,0,0
DATA 0,0,14080,30167,1916,160,22279,-32162,16400,14336,-24408,3176,32,0
DATA 0,0,-1280,-1025,584,192,-18425,18088,176,12288,21829,1952,128,0,0
DATA 0,7937,30719,1476,576,21543,-30638,-32688,-16384,-22102,3856,0,0,0
DATA 0,-22016,-5,144,64,-22134,-9542,248,21761,17748,32,0,0,1024,0,22273
DATA 32725,1092,64,-11245,24645,8272,-22528,-21974,146,0,0,2048,0,-255
DATA -1,230,96,21763,-20090,4344,0,20736,72,0,0,0,0,-255,30079,226,32,-24053
DATA 13665,84,2,-30200,520,112,0,0,0,-2034,-18310,1015,2256,1,128,80,1537
DATA 17541,-32504,48,322,7,0,-1785,22524,1016,3104,512,2128,4208,1616,-24575
DATA 6927,224,262,8,128,-201,-1281,-15880,-32632,0,1280,8,76,0,4354,8,0
DATA 5,32,-29,-3585,3042,2200,0,1024,8388,22,512,14617,24,0,14,0,-57,-1
DATA -3075,4348,0,0,128,172,0,-13310,12,4,16,80,-2105,-2049,-4916,10342
DATA -32768,0,4112,10450,2048,-24013,138,128,128,224,-2073,-1,-6408,4346
DATA 0,0,1144,2156,0,-7929,0,0,64,128,-191,-1,29904,-24388,0,10240,8441
DATA 22,0,28679,66,0,32,0,-18653,16351,2946,5290,0,17408,4112,2120,96,-6863
DATA 228,64,2248,0,32515,22527,5120,11264,0,512,13921,18,2048,-29143,192
DATA 128,-11104,0,-8397,-5633,-28152,7296,0,20484,14944,64,512,3079,64
DATA 32,-24560,0,7937,-11777,1025,1024,8224,256,22211,-16334,3840,7423
DATA 0,192,32,0,-253,-1409,6314,2048,160,-24319,32290,16404,1152,-13068
DATA 0,-32768,2144,0,-255,-2561,20492,3072,64,1281,31777,8208,2816,-29450
DATA 0,0,100,64,-1455,-22481,-22491,1536,4330,12112,-21936,5465,1984,1269
DATA 0,-32767,160,0,-2799,-19121,-32523,2640,20727,264,2600,2052,25248
DATA 265,244,8192,-2928,0,-504,31,-32544,29962,-8136,-26609,0,17666,12048
DATA 133,6,0,208,0,-2814,2143,-16169,14336,16469,4207,2048,10887,20384
DATA 25,0,0,9872,0,-1270,2192,-32745,256,-11927,12300,64,5252,-9170,-32676
DATA 0,0,-32733,0,29957,528,13,512,-20076,28799,128,11144,-31154,128,0
DATA 0,256,0,14495,-30559,40,0,1,-32202,0,-15668,16734,84,0,0,8,0,4373
DATA -6909,112,8704,-6078,28,0,-21112,1556,142,0,0,16385,0,11818,8216,248
DATA 1024,-15615,14,0,-3949,-28416,12,0,1024,0,0,18224,5320,96,512,1924
DATA 232,0,30881,816,152,0,0,0,0,11818,-20196,252,1024,-7360,78,0,-28271
DATA 4356,12,0,0,0,0,5397,-6369,242,-24064,12352,-30712,0,-20711,4684,6
DATA 0,0,0,0,2624,-129,224,-28672,0,0,0,15616,16516,0,0,0,0,0,1344,29695
DATA 192,-32768,42,0,0,5120,-17366,128,0,0,0,0,2816,-1281,160,0,0,4096
DATA 0,5120,1280,192,0,0,0,0,1280,5616,0,0,3072,-32760,0,2560,-2302,96
DATA 0,0,0,0,2816,-13316,224,0,0,0,0,1536,13507,0,0,0,0,0,5376,-2161,32
DATA 0,4104,-32768,0,4096,2176,96,0,0,0,0,24576,-2032,128,0,784,16384,0
DATA 16384,1792,0,0,0,0,0,-16384,29696,224,0,0,3,0,0,19456,96,0,0,16,0
DATA 1,2816,32,0,0,0,0,1,1024,0,0,0,0,0,2,768,0,0,0,12,0,2,0,0,0,0,0,0
DATA 4,1536,0,512,0,0,0,4,0,0,0,0,0,0,24,1024,0,8192,0,8,0,8,512,0,0,0
DATA 0,0,32,3072,0,2048,0,0,0,32,0,0,0,0,0,0,64,4096,0,16384,0,44,0,0,0
DATA 0,0,0,0,0,0,6144,0,0,0,0,0,0,0,0,0,0,0,0,128,12288,0,0,0,0,0,128,8192
DATA 0,0,0,0,0,0,12288,0,0,0,0,0,0,0,0,0,0,0,0,0,24576,0,0,0,128,0,0,8192
DATA 0,0,0,0,0,0,-16384,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,-32768
DATA 0,0,0,0,0,0,-32767,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,128,0,0,0,0,0
DATA 0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,2048,0,0,0,2,0,0,0,0,0
'title4
DATA 55,82,0,0,0,0,0,16384,0,0,0,48,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,96,0,0,0,0,0,0,0,0,0,0,0,0,0,96,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,96,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0
DATA 0,256,-16157,0,0,0,0,0,0,0,0,0,0,128,0,256,16483,0,0,0,0,0,0,0,0,0
DATA 0,0,0,256,-16157,0,0,0,0,0,0,0,0,0,0,0,0,256,-16191,0,0,0,0,0,0,0
DATA 0,0,0,0,0,256,-16157,0,0,0,0,0,0,0,0,0,0,0,0,768,71,0,0,0,0,0,0,0
DATA 0,0,0,0,0,768,-32569,0,0,0,0,0,0,0,0,0,1282,0,0,1280,-32552,0,0,0
DATA 0,0,0,0,0,0,1280,0,0,1792,-32518,0,0,0,0,0,0,0,0,0,-31488,0,0,1792
DATA 114,0,0,0,0,0,0,0,0,0,2560,0,0,3840,245,0,0,0,0,0,0,0,0,0,2048,0,0
DATA 1280,213,0,0,0,0,0,0,0,0,0,3072,0,0,1792,243,0,0,0,0,0,0,0,0,0,32
DATA 0,0,21760,84,0,0,0,0,0,0,0,0,0,-4859,0,0,-2044,-32766,0,0,0,0,0,3840
DATA 252,0,0,400,0,0,16413,-32512,0,0,0,0,0,-256,252,0,1280,0,128,0,0,1792
DATA 128,0,0,0,0,-32753,-16185,0,4096,10,0,0,29984,12480,64,0,0,0,0,-30708
DATA -8057,0,28928,12288,2,0,-254,6216,64,0,0,0,0,5237,4124,0,2048,768
DATA 136,3328,-1273,24828,192,0,0,0,-32000,-21821,2723,0,4,3072,21,-26624
DATA -8385,-6061,128,0,0,0,1536,1,-10432,0,16568,6696,-32768,16641,-10305
DATA -3868,0,0,0,0,15872,10794,514,0,513,4,209,-32767,-1027,11517,128,0
DATA 0,0,-16384,2305,513,0,62,2562,208,257,-769,245,0,0,0,0,-9213,10784
DATA -32736,96,0,256,2,8960,-1,-22274,0,0,0,0,-1018,3652,-16383,2272,2
DATA 2048,0,257,-1,9462,0,0,0,0,-32754,0,-8191,256,32001,-2187,-4050,512
DATA -30078,8329,0,124,136,0,-28643,64,13326,8440,257,-32536,171,518,5888
DATA 11008,0,-16788,28928,64,25121,32512,-8180,17568,256,1024,23747,26
DATA -32768,-15612,2,-355,-3328,28,17125,-18688,-16242,12,-30720,27136
DATA -7444,22,2184,-13206,16,30653,4416,19,-1342,-8193,20367,62,4,2128
DATA 0,63,20480,8,192,-20351,29729,191,-1088,28667,4095,2076,1028,8256
DATA 25120,55,16384,32,128,29200,3219,223,-1086,28667,3054,8240,1108,0
DATA -14832,20495,0,1025,8,29216,4243,235,-3327,-2561,-31105,8256,-24572
DATA 24,2603,86,6816,640,100,6152,256,212,9249,-4081,-3329,3104,8208,7432
DATA 1089,2096,2080,16413,714,-8509,16631,188,1041,-4081,-8462,1120,-32760
DATA 18952,-32535,4272,2176,-14270,532,32483,1527,16,9248,-4081,-20225
DATA 7520,4120,1801,5195,128,2320,1031,642,-4669,8438,176,-7935,-4081,20605
DATA -22824,16400,-17401,1583,16,1792,-32708,32,-20466,760,80,528,3,24847
DATA 794,-15360,2305,-32688,-116,312,19481,4,0,-7938,128,264,1,-7734,4866
DATA 3712,2112,2096,32708,240,11784,0,0,13759,0,12,33,15904,4096,11777
DATA 32583,241,-349,1488,12320,0,0,-32584,8,12289,1,5760,-13824,1536,32558
DATA 240,-240,-22800,6144,0,0,81,0,28675,3585,15488,10240,16384,3552,0
DATA -12416,-24386,-16270,0,0,17,32,32257,2304,26752,2560,808,20619,132
DATA -31852,-22028,4111,0,0,84,0,-6400,898,-1918,1280,9232,19475,0,2218
DATA 857,33,0,512,236,0,5376,716,-32665,-10240,58,-32654,32,4,-32197,24
DATA 0,0,16385,0,3584,16255,-7937,-32768,16,-32684,0,316,-30323,72,0,0
DATA 0,0,256,-24769,-32577,0,-32768,4,64,24,26688,64,0,0,0,0,0,-1,254,-32768
DATA 1,-32508,192,48,0,8,0,0,0,0,0,-241,222,0,-12288,8192,0,48,0,0,0,0
DATA 0,0,0,-1025,254,-32768,0,0,0,48,1024,8,0,0,0,0,256,-26817,-32579,0
DATA 16384,40,64,280,20528,66,0,0,0,0,0,0,0,0,0,156,0,192,128,120,0,0,0
DATA 0,0,0,0,0,-32768,0,0,256,0,16,0,0,0,0,0,0,0,0,0,0,0,1664,0,48,0,0
DATA 0,0,0,0,0,0,0,0,0,3200,0,16,0,0,0,0,0,0,0,0,0,0,0,4096,0,96,0,0,0
DATA 0,0,0,0,0,0,0,0,8192,0,64,0,0,0,0,0,0,0,0,0,0,0,-16384,0,192,0,0,0
DATA 0,0,0,0,0,0,0,0,-32767,256,128,0,0,0,0,0,0,0,0,0,0,0,2,256,128,0,0
DATA 0,0,0,0,0,0,0,0,0,4,768,0,0,0,0,0,0,0,0,0,0,0,0,24,1536,0,0,0,0,0
DATA 0,0,0,0,0,0,0,16,1024,0,0,0,0,0,0,0,0,0,0,0,0,32,3072,0,0,0,0,0,64
DATA 0,0,0,0,0,0,64,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,6144,0,0,0,0,0,0,0,0
DATA 0,0,0,0,128,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,12288,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,24576,0,0,0,0,0,0,0,0,0,0,0,0,0,24576,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,-16384,0,0,0,0,0,0,0,0,0,0,0,0,0,-32767,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0
DATA 0,0,0,0
'title5
DATA 57,22,0,-241,248,0,0,0,0,0,0,0,0,0,0,0,0,0,768,240,-8185,0,0,-241
DATA 248,0,0,0,0,0,0,0,0,0,15360,0,7680,0,768,-1,-7937,0,0,0,0,0,0,0,0
DATA 0,-16383,0,256,192,16128,-1,-257,0,0,0,0,0,0,0,0,0,6,0,0,48,-255,-1
DATA -1,192,-512,0,0,0,0,0,0,0,24,0,0,12,-249,-1,-1,240,-32255,0,0,0,31744
DATA 0,0,0,32,0,0,2,-241,-1,-1,252,6673,0,15360,0,-7168,0,0,0,64,0,0,1
DATA -225,-1,-1,254,-17631,-12289,-6145,248,17408,0,6144,0,64,0,0,1,-225
DATA -1,-1,254,-16864,30860,18992,136,16640,-30861,-18993,112,128,0,0,-32768
DATA -193,-1,-1,255,-19136,-19677,-25754,40,18432,19676,25753,208,128,0
DATA 0,-32768,-193,-1,-1,255,-31424,-22714,-19634,72,30720,22712,19633
DATA 176,128,0,0,-32768,-193,-1,-1,255,-17088,-20619,-28834,120,16384,20616
DATA 28833,128,128,0,0,-32768,-193,-1,-1,255,-19647,11895,-17572,96,16384
DATA -11896,17571,128,64,0,0,1,-225,-1,-1,254,4641,28728,-14752,32,-7936
DATA -28729,14751,192,64,0,0,1,-225,-1,-1,252,-3295,-8209,-130,226,0,0
DATA 129,0,32,0,0,2,-249,-1,-1,240,24,7424,-32646,12,0,0,129,0,24,0,0,12
DATA -255,-1,-1,192,6,5888,-32658,48,0,2048,145,0,6,0,0,48,16128,-1,-257
DATA 0,-16383,6144,-32271,192,0,1792,14,0,-16383,0,256,192,768,-1,-7937
DATA 0,15360,3840,7839,0,0,0,0,0,15360,0,7680,0,0,-241,248,0,768,240,-8185
DATA 0,0,0,0,0,768,240,-8185,0,0,0,0,0,0,-241,248,0,0,0,0,0,0,-241,248
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0

SUB BYE
SCREEN 0, 0, 0, 0: WIDTH 80, 25: CLS
PRINT "FROGGER!  Written in *QB*.  Matt Bross, 1997"
PRINT "HOMEPAGE - http://www.GeoCities.Com/SoHo/7067/"
PRINT "EMAIL    - oh_bother@GeoCities.Com"
END
END SUB

SUB DELAY (SEC!)
FOR V = 0 TO SEC! * 70: WAIT &H3DA, 8: WAIT &H3DA, 8, 8: NEXT
END SUB

SUB Frogger (TLIVES, ODIF, OT, OD!)
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GRAPHICS ARRAYS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
REM $DYNAMIC
DIM FROG(37), car1(37), car2(37), log1(37), lily(37), water(37), road(37)
DIM exit1(37): RESTORE FroggerGraphics
FOR i = 0 TO 37: READ FROG(i): NEXT: FOR i = 0 TO 37: READ car1(i): NEXT
FOR i = 0 TO 37: READ car2(i): NEXT: FOR i = 0 TO 37: READ log1(i): NEXT
FOR i = 0 TO 37: READ lily(i): NEXT: FOR i = 0 TO 37: READ water(i): NEXT
FOR i = 0 TO 37: READ road(i): NEXT: FOR i = 0 TO 37: READ exit1(i): NEXT
'%%%%%%%%%%%%%%%%%%%%%%%%%%%INFORMATION ARRAYS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DIM FrogLev(23, 15)
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NewGame: LIVES = TLIVES: SCORE = 0: DIF = ODIF: D! = OD!
'%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD HIGH SCORE TABLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OPEN "hiscore.dat" FOR BINARY AS #1
'FOR i = 0 TO 9: GET #1, , HISCORE(i): NEXT
CLOSE
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD LEVEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NextLev: CLS
FOR Y = 0 TO 15: FOR X = 0 TO 23
SELECT CASE Y
  CASE 0: IF INT(RND * DIF) = 0 THEN FrogLev(X, Y) = 8 ELSE FrogLev(X, Y) = 9
  CASE 1 TO 6: FrogLev(X, Y) = 6
IF INT(RND * DIF) = 0 THEN
  IF Y AND 1 THEN FrogLev(X, Y) = 4 ELSE FrogLev(X, Y) = 5
END IF
  CASE 8 TO 14: FrogLev(X, Y) = 7
IF INT(RND * (100 - DIF)) = 0 THEN
  IF Y AND 1 THEN FrogLev(X, Y) = 2 ELSE FrogLev(X, Y) = 3
END IF
END SELECT
NEXT: NEXT

FOR Y = 0 TO 6
  FY = -1: FX = -1: EX = -1
  FOR X = 0 TO 23
    IF FrogLev(X, Y) = 4 AND Y AND 1 THEN FY = 0
    IF FrogLev(X, Y) = 5 THEN FX = 0
    IF FrogLev(X, Y) = 8 THEN EX = 0
  NEXT
  IF Y AND 1 THEN
    IF FY = -1 THEN FrogLev(INT(RND * 23), Y) = 4
  ELSE
    IF FX = -1 AND Y <> 0 THEN
      IF Y = 3 OR Y = 6 THEN EX = 11 ELSE EX = 0
      FrogLev(INT(RND * 11) + EX, Y) = 5
    END IF
  END IF
  IF EX = -1 AND Y = 0 THEN FrogLev(INT(RND * 11), Y) = 8
NEXT
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RESTART POINT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReStart: FX = 11: FY = 15: SEC = OT: ForStep = DIF: SideStep = DIF \ 2
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DRAW LEVEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FOR Y = 0 TO 15: FOR X = 0 TO 23
EX = X * 9 + 50: EY = Y * 9 + 20
SELECT CASE FrogLev(X, Y)
  CASE 2: PUT (EX, EY), car1, PSET
  CASE 3: PUT (EX, EY), car2, PSET
  CASE 4: PUT (EX, EY), log1, PSET
  CASE 5: PUT (EX, EY), lily, PSET
  CASE 6: PUT (EX, EY), water, PSET
  CASE 7: PUT (EX, EY), road, PSET
  CASE 8: PUT (EX, EY), exit1, PSET
  CASE ELSE: LINE (EX, EY)-(EX + 8, EY + 8), 0, BF
END SELECT
NEXT: NEXT
LOCATE 2, 14: PRINT SPACE$(12)
LINE (0, 178)-(45, 186), 0, BF
IF LIVES > 5 THEN SLIVES = 5 ELSE SLIVES = LIVES
FOR X = 0 TO SLIVES - 1: PUT (X * 9, 178), FROG, PSET: NEXT
LOCATE 22, 1: PRINT "LIVES": LOCATE 1, 16: PRINT "FROGGER!"
LOCATE 22, 9: PRINT "SCORE": LOCATE 23, 9: PRINT SCORE
LOCATE 22, 16: PRINT "TIME": LOCATE 23, 16: PRINT SEC
LOCATE 22, 23: PRINT "LEVEL": LOCATE 23, 23: PRINT DIF
LOCATE 22, 31: PRINT "HISCORE": LOCATE 23, 31: PRINT HISCORE(0).SCORE
PUT (149, 155), FROG, PSET: IF LIVES <= 0 THEN GOTO LOSE
DO: LOOP UNTIL INKEY$ <> ""
T& = TIMER MOD 86400: DO: LOOP UNTIL TIMER >= T&: T& = TIMER
'------------------------>BEGIN MAIN LOOP OF FROGGER GAME<-------------------
DEF SEG = 0
DO
'**********************************GET KEY***********************************


'a = INP(&H60): WHILE LEN(INKEY$): WEND
'SELECT CASE a
'  CASE &H48: OFX = FX: OFY = FY: FY = FY - 1
'SCORE = SCORE + ForStep: KeyPress = -1
'  CASE &H50: OFX = FX: OFY = FY: FY = FY + 1
'KeyPress = -1
'  CASE &H4B: OFX = FX: OFY = FY: FX = FX - 1
'SCORE = SCORE + SideStep: KeyPress = -1
'  CASE &H4D: OFX = FX: OFY = FY: FX = FX + 1
'SCORE = SCORE + SideStep: KeyPress = -1
'  CASE &H1: GOSUB ABORTGAME
'  CASE ELSE: KeyPress = 0
'END SELECT

a$ = INKEY$
'a = INP(&H60): WHILE LEN(INKEY$): WEND
SELECT CASE a$
  CASE "8": OFX = FX: OFY = FY: FY = FY - 1
SCORE = SCORE + ForStep: KeyPress = -1
  CASE "2": OFX = FX: OFY = FY: FY = FY + 1
KeyPress = -1
  CASE "4": OFX = FX: OFY = FY: FX = FX - 1
SCORE = SCORE + SideStep: KeyPress = -1
  CASE "6": OFX = FX: OFY = FY: FX = FX + 1
SCORE = SCORE + SideStep: KeyPress = -1
  CASE "q": GOSUB ABORTGAME
  CASE ELSE: KeyPress = 0
END SELECT


'********************************MOVE FROG***********************************
IF KeyPress THEN
LOCATE 23, 9: PRINT SCORE: SOUND 500, .5
'*************************CHECK BOUNDS OF THE FROG***************************
  IF FX < 0 THEN FX = 0
  IF FX > 23 THEN FX = 23
  IF FY < 0 THEN FY = 0
  IF FY > 15 THEN FY = 15
END IF
'********************************DRAW FROG***********************************
IF KeyPress OR FY < 7 THEN PUT (FX * 9 + 50, FY * 9 + 20), FROG, PSET
'******************************ERASE OLD CELL********************************
  IF FX <> OFX OR FY <> OFY THEN
  EX = OFX * 9 + 50: EY = OFY * 9 + 20
  SELECT CASE FrogLev(OFX, OFY)
    CASE 2: PUT (EX, EY), car1, PSET
    CASE 3: PUT (EX, EY), car2, PSET
    CASE 4: PUT (EX, EY), log1, PSET
    CASE 5: PUT (EX, EY), lily, PSET
    CASE 6: PUT (EX, EY), water, PSET
    CASE 7: PUT (EX, EY), road, PSET
    CASE 8: PUT (EX, EY), exit1, PSET
    CASE ELSE: LINE (EX, EY)-(EX + 8, EY + 8), 0, BF
  END SELECT
  END IF

DO: newtimer! = TIMER: LOOP WHILE newtimer! = lasttimer!
lasttimer! = newtimer!

DO: newtimer! = TIMER: LOOP WHILE newtimer! = lasttimer!
lasttimer! = newtimer!


'*****************************CHECK FOR BONUSES******************************
IF FrogLev(FX, FY) = 8 THEN GOTO WIN
IF SCORE AND SCORE MOD (100 * DIF + 1) = 0 THEN GOSUB LIFEUP
'***************************CHECK IF YOU ARE DEAD****************************
SELECT CASE FrogLev(FX, FY)
  CASE 2, 3, 6, 9: GOTO DIE
END SELECT
IF T& <> FIX(TIMER) THEN T& = TIMER: SEC = SEC - 1: LOCATE 23, 16: PRINT SEC
IF SEC <= 0 THEN GOTO DIE
'******************************MOVE OBSTICALES*******************************
BACK = 23: FORTH = 0
FOR Y = 1 TO 14: FOR X = BACK TO FORTH STEP SGN(FORTH - BACK)
SELECT CASE FrogLev(X, Y)
CASE 2
  IF X = 0 THEN C2 = 23 ELSE C2 = X - 1
  SWAP FrogLev(X, Y), FrogLev(C2, Y)
  PUT (C2 * 9 + 50, Y * 9 + 20), car1, PSET
  IF FrogLev(X, Y) <> 2 THEN PUT (X * 9 + 50, Y * 9 + 20), road, PSET
CASE 3
  IF X = 23 THEN C2 = 0 ELSE C2 = X + 1
  SWAP FrogLev(X, Y), FrogLev(C2, Y)
  PUT (C2 * 9 + 50, Y * 9 + 20), car2, PSET
  IF FrogLev(X, Y) <> 3 THEN PUT (X * 9 + 50, Y * 9 + 20), road, PSET
CASE 4
SELECT CASE Y
  CASE 1, 5
    IF X = 23 THEN C2 = 0 ELSE C2 = X + 1
    IF FY = Y AND FX = X THEN OFX = FX: OFY = FY: FX = (FX + 1) MOD 23
    SWAP FrogLev(X, Y), FrogLev(C2, Y)
    PUT (C2 * 9 + 50, Y * 9 + 20), log1, PSET
    IF FrogLev(X, Y) <> 4 THEN PUT (X * 9 + 50, Y * 9 + 20), water, PSET
  CASE 3
    IF X = 0 THEN C2 = 23 ELSE C2 = X - 1
    IF FY = Y AND FX = X THEN OFX = FX: OFY = FY: FX = FX - 1
    SWAP FrogLev(X, Y), FrogLev(C2, Y)
    PUT (C2 * 9 + 50, Y * 9 + 20), log1, PSET
    IF FrogLev(X, Y) <> 4 THEN PUT (X * 9 + 50, Y * 9 + 20), water, PSET
END SELECT
END SELECT
NEXT
IF Y > 7 THEN SWAP BACK, FORTH ELSE IF Y AND 1 THEN SWAP BACK, FORTH
NEXT
SOUND 100, .1

'DELAY D!

LOOP
'--------------------->END MAIN LOOP OF FROGGER GAME<------------------------
DIE: SOUND 500, 5: SOUND 200, 3: SOUND 100, 2
LIVES = LIVES - 1: GOTO ReStart

WIN: PUT ((OFX + 1) * 9 + 50, OFY * 9 + 20), log1, PSET
LOCATE 2, 14: PRINT "LEVEL PASSED": DIF = DIF + 1: GOTO NextLev

LOSE: FOR X = 0 TO 500 STEP 40: SOUND 2000 + X, 1: NEXT
SOUND 200, 4: SOUND 100, 2
LOCATE 2, 15: PRINT "GAME OVER!"
WHILE LEN(INKEY$): WEND: DELAY 1
IF SCORE > HISCORE THEN NewHiScore SCORE
LOCATE 1, 1: PRINT SPACE$(40)
PRINT SPACE$(40)
LOCATE 2, 15: PRINT "PLAY AGAIN?"
promt: a$ = INPUT$(1)
SELECT CASE a$
  CASE "Y", "y": GOTO NewGame
  CASE "N", "n": DEF SEG : EXIT SUB
  CASE ELSE: GOTO promt
END SELECT

ABORTGAME: LOCATE 2, 12: PRINT "ABORT GAME?(Y/N)": a$ = INPUT$(1)
SELECT CASE a$
  CASE "Y", "y": LOCATE 2, 12: PRINT SPACE$(16): GOTO LOSE
  CASE "N", "n": LOCATE 2, 12: PRINT SPACE$(16): RETURN
  CASE ELSE: GOTO ABORTGAME
END SELECT

LIFEUP: SOUND 3000, .9: SOUND 3000, .2: SOUND 4000, .1
SCORE = SCORE + DIF: LIVES = LIVES + 1
IF LIVES > 5 THEN SLIVES = 4 ELSE SLIVES = LIVES - 1
PUT (SLIVES * 9, 178), FROG, PSET: RETURN

END SUB

REM $STATIC
SUB FrogINTRO
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD TITLE IMAGES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CLS : FOR X = 0 TO 15: PALETTE X, 0: NEXT
REDIM title1(1393), title2(1135), title3(1149), title4(1149), title5(353)
RESTORE FroggerIntroGraphics
FOR i = 0 TO 1393: READ title1(i): NEXT
FOR i = 0 TO 1135: READ title2(i): NEXT
FOR i = 0 TO 1149: READ title3(i): NEXT
FOR i = 0 TO 1149: READ title4(i): NEXT
FOR i = 0 TO 353: READ title5(i): NEXT
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SET PALETTE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RESTORE FroggerIntroPalette
FOR X = 0 TO 15: READ i: PALETTE X, i: NEXT
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%SHOW MORPHING TITLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  PUT (131, 60), title1, PSET
DELAY 1: LINE (131, Y)-(188, 144), 0, BF
  PUT (131, 60), title2, PSET
DELAY .05: LINE (131, 60)-(188, 144), 0, BF
  PUT (131, 60), title3, PSET
DELAY .05: LINE (131, 60)-(188, 144), 0, BF
  PUT (131, 60), title4, PSET
DELAY .05: LINE (131, 60)-(188, 144), 0, BF
  PUT (131, 88), title5, PSET
  ERASE title1, title2, title3, title4, title5
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SET STAR PALETTE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  DELAY 1: PALETTE 0, 0: PALETTE 3, 8: PALETTE 5, 7: PALETTE 8, 15
LOCATE 16, 11: PRINT "PRESS SPACE TO START"
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STAR INIT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nstar = 100
REDIM starX(nstar), starY(nstar), starZ(nstar), OSX(nstar), OSY(nstar)
FOR X = 0 TO nstar
  starX(X) = INT(RND * 320) - 160
  starY(X) = INT(RND * 200) - 100
  starZ(X) = INT(RND * 150)
NEXT
'%%%%%%%%%%%%%%%%%%%%%%%%%%REAL(!) 3D STAR SCROLLER%%%%%%%%%%%%%%%%%%%%%%%%%%
DEF SEG = 0
DO
  FOR X = 0 TO nstar
    SELECT CASE POINT(OSX(X), OSY(X))
      CASE 3, 5, 8: PSET (OSX(X), OSY(X)), 0
    END SELECT
  IF starZ(X) <= 0 THEN
    starX(X) = INT(RND * 320) - 160
    starY(X) = INT(RND * 200) - 100
    starZ(X) = INT(RND * 150)
  ELSE
    SX = 50 * starX(X) \ starZ(X) + 160
    SY = 50 * starY(X) \ starZ(X) + 100
    c = starZ(X) \ 50
    SELECT CASE c
      CASE 0: c = 8
      CASE 1: c = 5
      CASE 2: c = 3
    END SELECT
    IF POINT(SX, SY) = 0 THEN PSET (SX, SY), c
    OSX(X) = SX: OSY(X) = SY
    starZ(X) = starZ(X) - 1
  END IF
  NEXT
SELECT CASE INP(&H60)
  CASE &H39: EXIT DO
  CASE &H10: IF SPECIAL = 0 THEN SPECIAL = 1
  CASE &H30: IF SPECIAL = 1 THEN SPECIAL = 2
END SELECT
LOOP
PALETTE: DEF SEG
OptScn SPECIAL
END SUB

SUB NewHiScore (SCORE)
i = 9: DO: i = i - 1: IF i = 0 THEN EXIT DO
IF SCORE > HISCORE(i).SCORE THEN EXIT DO
LOOP

LOCATE 1, 1: PRINT "YOU HAVE A NEW HIGH SCORE"
INPUT "PLEASE GIVE 3 OR LESS INITIALS: ", NAME$
HISCORE(i).PERSON = NAME$: HISCORE(i).SCORE = SCORE
OPEN "hiscore.dat" FOR BINARY AS #1
FOR i = 0 TO 9
 ' PUT #1, , HISCORE(i)
NEXT
CLOSE #1
END SUB

SUB OptScn (SPECIAL)

CLS : LIVES = 5: DIF = 0: D = 0: OT = 40: choose = 1
IF SPECIAL = 2 THEN
DO
COLOR 15
LOCATE 1, 1: PRINT "OPTIONS SCREEN: PRESS ENTER TO EXIT"
IF choose = 1 THEN COLOR 4 ELSE COLOR 15
LOCATE 2, 1: PRINT "LIVES: "; LIVES
IF choose = 2 THEN COLOR 4 ELSE COLOR 15
LOCATE 3, 1: PRINT "DIFFICULTY: "; DIF
IF choose = 3 THEN COLOR 4 ELSE COLOR 15
LOCATE 4, 1: PRINT "TIME: "; OT
IF choose = 4 THEN COLOR 4 ELSE COLOR 15
LOCATE 5, 1: PRINT "DELAY: "; D / 10; " "
DO: a$ = INKEY$: LOOP UNTIL a$ <> ""
SELECT CASE a$
  CASE CHR$(13): EXIT DO
  CASE CHR$(0) + "K"
    SELECT CASE choose
      CASE 1: LIVES = LIVES - 1
      CASE 2: DIF = DIF - 1
      CASE 3: OT = OT - 1
      CASE 4: D = D - 1
    END SELECT
  CASE CHR$(0) + "H"
    IF choose = 0 THEN choose = 4 ELSE choose = choose - 1
  CASE CHR$(0) + "P"
    IF choose = 4 THEN choose = 0 ELSE choose = choose + 1
  CASE CHR$(0) + "M"
     SELECT CASE choose
      CASE 1: LIVES = LIVES + 1
      CASE 2: DIF = DIF + 1
      CASE 3: OT = OT + 1
      CASE 4: D = D + 1
    END SELECT
END SELECT
LOOP
END IF

COLOR 15
Frogger LIVES, DIF, OT, D / 10
END SUB

SUB ShowHiScore
CLS
LOCATE 1, 14: PRINT "HIGH SCORES": PRINT
FOR i = 0 TO 9
  a$ = STR$(i + 1): IF i < 9 THEN a$ = a$ + " "
  a$ = a$ + STR$(HISCORE(i).SCORE)
  b$ = HISCORE(i).PERSON
  LOCATE i + 3, 7: PRINT a$, b$
NEXT
SLEEP
BYE
END SUB
