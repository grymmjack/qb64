'************************************************************
' ELISA.BAS = Ein Computer-Gespraechspartner
' =========
' Ein kleiner Ansatz fuer kuenstliche Intelligenz
' mit Q(uick)Basic
'************************************************************
CLS
1 PRINT TAB(26); "Elisa"
2 PRINT : PRINT : PRINT
100 DIM S(36), R(36), N(36)
110 N1 = 36: N2 = 14: N3 = 112
120 FOR X = 1 TO N1 + N2 + N3: READ Z$: NEXT X
130 FOR X = 1 TO N1
140 READ S(X), L: R(X) = S(X): N(X) = S(X) + L - 1
150 NEXT X
160 PRINT "Hallo! ich hei�e Elisa. Kann ich dir helfen?"
170 REM
200 INPUT I$
201 I$ = " " + I$ + " "
220 FOR L = 1 TO LEN(I$)
230 IF MID$(I$, L, 1) = "'" THEN I$ = LEFT$(I$, L - 1) + RIGHT$(I$, LEN(I$) - L): GOTO 230
240 IF L + 4 <= LEN(I$) THEN IF MID$(I$, L, 8) = "S" THEN PRINT "H�R AUF...": GOTO 2570
250 NEXT L
260 IF I$ = P$ THEN PRINT "BITTE WIEDERHOL DICH NICHT IMMER!": GOTO 170
270 REM
280 REM
290 RESTORE
295 S = 0
300 FOR K = 1 TO N1
310 READ K$
315 IF S > 0 THEN 360
320 FOR L = 1 TO LEN(I$) - LEN(K$) + 1
340 IF MID$(I$, L, LEN(K$)) = K$ THEN S = K: T = L: F$ = K$
350 NEXT L
360 NEXT K
365 IF S > 0 THEN K = S: L = T: GOTO 390
370 K = 36: GOTO 570
380 REM
390 REM
400 REM
420 RESTORE: FOR X = 1 TO N1: READ Z$: NEXT X
430 C$ = " " + RIGHT$(I$, LEN(I$) - LEN(F$) - L + 1) + " "
440 FOR X = 1 TO N2 / 2
450 READ S$, R$
460 FOR L = 1 TO LEN(C$)
470 IF L + LEN(S$) > LEN(C$) THEN 510
480 IF MID$(C$, L, LEN(S$)) <> S$ THEN 510
490 C$ = LEFT$(C$, L - 1) + RIGHT$(C$, LEN(C$) - L - LEN(S$) + 1)
495 L = L + LEN(R$)
500 GOTO 540
510 IF L + LEN(R$) > LEN(C$) THEN 540
520 IF MID$(C$, L, LEN(R$)) <> R$ THEN 540
530 C$ = LEFT$(C$, L - 1) + R$ + RIGHT$(C$, LEN(C$) - L - LEN(R$) + 1)
535 L = L + LEN(S$)
540 NEXT L
550 NEXT X
555 IF MID$(C$, 2, 1) = " " THEN C$ = RIGHT$(C$, LEN(C$) - 1)
556 FOR L = 1 TO LEN(C$)
557 IF MID$(C$, L, 1) = "!" THEN C$ = LEFT$(C$, L - 1) + RIGHT$(C$, LEN(C$) - L): GOTO 557
558 NEXT L
560 REM
570 REM
580 REM
590 RESTORE: FOR X = 1 TO N1 + N2: READ Z$: NEXT X
600 FOR X = 1 TO R(K): READ F$: NEXT X
610 R(K) = R(K) + 1: IF R(K) > N(K) THEN R(K) = S(K)
620 IF RIGHT$(F$, 1) <> "*" THEN PRINT F$: P$ = I$: GOTO 170
630 PRINT LEFT$(F$, LEN(F$) - 1); C$
640 P$ = I$: GOTO 170
1000 REM
1010 REM
1020 REM
1030 REM
1040 REM
1050 DATA "KANST DU","KANN ICH","DU BIST","ARSCH","ICH NICHT","ICH F�HLE"
1060 DATA "WARUM TUST DU NICHT","WARUM KANN ICH NICHT","BIST DU","ICH KANN NICHT","ICH BIN","FICK"
1070 DATA "DU","ICH M�CHTE","WAS","WIE","WER","WO","WANN","WARUM"
1080 DATA "NAMEN","GRUND","LEID","TRAUM","HALLO","HI ","VIELLEICHT"
1090 DATA " NEIN","DEIN","IMMER","DENKEN","GLEICH","JA","FREUND"
1100 DATA "COMPUTER","KEIN SCHL�SSELWORT"
1200 REM
1210 REM
1220 REM
1230 DATA " SIND "," BIN ","WAREN ","WAR "," DU "," ICH ","DEIN ","MEIN "
1235 DATA " ICH HABE "," DU HAST "," ICH BIN "," DU BIST "
1240 DATA " MIR "," !DU "
1300 REM
1310 REM
1320 REM
1330 DATA "GLAUBST DU NICHT DAS ICH KANN*"
1340 DATA "VIELLEICHT M�CHTEST DU F�HIG SEIN*"
1350 DATA "DU M�CHTEST DAS ICH KANN*"
1360 DATA "VIELEICHT M�CHTEST DU NICHT*"
1365 DATA "WILLST DU IN DER LAGE SEIN*"
1370 DATA "WARUM GLAUBST DU ICH BIN*"
1380 DATA "GAF�LLT ES DIR ZU GLAUBEN DAS ICH BIN*"
1390 DATA "VIELLEICHT W�REST DU GERNE*"
1400 DATA "DU W�NSCHT DIR MANCHMAL ZU SEIN*"
1410 DATA "BIST DU WIRKLICH NICHT*"
1420 DATA "WARUM TUST DU NICHT*"
1430 DATA "MOECHTEST DU GERNE IN DER LAGE SEIN*"
1440 DATA "BELASTET DAS DICH?"
1450 DATA "ERZ�HLE MIR MEHR VON DIESE GEF�HLEN."
1460 DATA "F�HLST DU DICH OFT SO*"
1470 DATA "GEF�LLT ES DIR ZU F�HLEN*"
1480 DATA "GLAUBST DU WIRKLICH ICH KANN NICHT*"
1490 DATA "VIELLEICHT WERDE ICH EINES TAGES*"
1500 DATA "M�CHTEST DU DAS ICH*"
1510 DATA "GLAUBST DU DASSDU F�HIG SEIN SOLLTEST*"
1520 DATA "WARUM KANNST DU NICHT*"
1530 DATA "WARUM INTERESSIERT ES DICH OB ICH*"
1540 DATA "W�RDEST DU VORZIEHEN ICH W�RE NICHT*"
1550 DATA "VIELEICHT BIN ICH DEINER VORSTELLUNG*"
1560 DATA "WIE WEI�T DU DASS ICH NICHT KANN*"
1570 DATA "HAST DU VERSUCHT?"
1580 DATA "VIELLEICHT KANNST DU JETZT*"
1590 DATA "BIST DU ZU MIR GEKOMMEN WEIL DU*"
1600 DATA "WIE LANGE WARST DU*"
1610 DATA "GLAUBST DU ES IST NORMAL*"
1620 DATA "GEF�LLT ES DIR*"
1630 DATA "WIR SRACHEN VON DIR-- NICHT VON MIR."
1640 DATA "OH, ICH*"
1650 DATA "DU REDEST WIRKLICH NICHT �BER MICH ODER?"
1660 DATA "WAS W�RDE ES DIR BEDEUTEN WENN DU*"
1670 DATA "WARUM M�CHTEST DU*"
1680 DATA "ANGENOMMEN DU H�TTEST BALD*"
1690 DATA "ANGENOMMEN DU W�RDEST NIE*"
1700 DATA "ICH M�CHTE MANCHMAL AUCH*"
1710 DATA "WARUM FRAGST DU?"
1720 DATA "INTERESIERT DICH DIESE FRAGE?"
1730 DATA "WELCHE ANTWORT W�RDE DIR AM BESTEN GEFALLEN?"
1740 DATA "WAS GLAUBST DU?"
1750 DATA "BEFASST DU DICH OFT MIT SOLCHEN FRAGEN?"
1760 DATA "WAS M�CHTEST DU DENN WIRKLICH WISSEN?"
1770 DATA "HAST DU SCHON JEMAND ANDERS GEFRAGT?"
1780 DATA "HAST DU SOLCHE FRAGEN SCHONMAL GESTWELLT?"
1790 DATA "WAS F�LLT DIR BEI DIESER FRAGE NOCH EIN?"
1800 DATA "NAMEN INTERESSIEREN MICH NICHT."
1810 DATA "ICH MACHE MIR NICHTS AUS NAMEN -- BITTE FAHRE FORT."
1820 DATA "IST DAS DER WIRKLICHE GRUND?"
1830 DATA "KANNST DU DIR EINEN ANDEREN GRUND DENKEN?"
1840 DATA "ERKL�RT DIESER GRUND AUCH ETWAS ANDERES?"
1850 DATA "WELCHE ANDEREN GR�NDE K�NNTE ES NOCH GEBEN?"
1860 DATA "DU BRAUCHST DICH NICHT ZU ENTSCHULDIGEN?"
1870 DATA "ENTSCHULDIGUNGEN SIND NICHT N�TIG."
1880 DATA "WAS F�HLST DU WENN DU DICH ENZSCHULDIGST?"
1890 DATA "SEI NICHT SO ABWEHREND!"
1900 DATA "WAS SAGT DIR DIESER TRAUM?"
1910 DATA "TR�UMST DU OFT?"
1920 DATA "WELCHE PERSOHNEN ERSCHEINEN IN DEINEN TR�UMEN?"
1930 DATA "WIRST DU VON DEINEN TR�UMEN GEST�RT?"
1940 DATA "GUTEN TAG.... ERKL�RE BITTE DEINE PROBLEME."
1950 DATA "DU SCHEINST NICHT SEHR SICHER ZU SEIN."
1960 DATA "WARUM DER UNSICHERE TON?"
1970 DATA "KANNST DU NICHT POSITIVER EINGESTELLT SEIN?"
1980 DATA "DU BIST NICHT SICHER?"
1990 DATA "DU WEI�T NICHT?"
2000 DATA "SAGST DU NEIN NUR UM ABLEHNEND ZU SEIN?"
2010 DATA "DU BIST ETWAS ABLEHNEND."
2020 DATA "WARUM NICHT?"
2030 DATA "BIST DU SICHER?"
2040 DATA "WARUM NEIN?"
2050 DATA "WARUM BIST DU BESORGT UM MEIN*"
2060 DATA "WIE IST DEIN EIGENES*"
2070 DATA "KANNST DU DIR EIN BEISPIEL DENKEN?"
2080 DATA "WANN?"
2090 DATA "WORAN DENKST DU GERADE?"
2100 DATA "WIRKLICH IMMER?"
2110 DATA "GLAUBST DU DAS WIRKLICH?"
2120 DATA "ABER DU BIST NICHT SICHER DASS DU*"
2130 DATA "ZWEIFELST DU DARAN DASS DU*"
2140 DATA "AUF WELCHE ART?"
2150 DATA "WELCHE �HNLICHKEIT SIEHST DU?"
2160 DATA "WAS SAGT DIR DIESE �HNLIGKEIT?"
2170 DATA "WELCHE ANDEREN VERBINDUNGEN SIEHST DU?"
2180 DATA "IST DA WIRKLICH EINE VERBINDUNG?"
2190 DATA "WIE?"
2200 DATA "DU SCHEINST SEHR POSITIV ZU SEIN?"
2210 DATA "BIST DU SICHER?"
2220 DATA "SO SO."
2230 DATA "ICH VERSTEHE."
2240 DATA "WARUM KOMMST DU ZUM THEMA FREUNDE?"
2250 DATA "BIST DU UM DEINE FREUNDE BESORGT?"
2260 DATA "NECKEN DICH DEINE FREUNDE?"
2270 DATA "BIST DU SICHER DASS DU FREUNDE HAST?"
2280 DATA "BELASREST DU DEINE FREUNDE?"
2290 DATA "VIELEICHT BESORGT DICH DEINE LIEBE F�R FREUNDE?"
2300 DATA "HAST DU VOR COMPUTERN ANGST?"
2310 DATA "SPRICHST DU VON MIR SPEZIELL?"
2320 DATA "F�RCHTEST DU DICH FOR MASCHINEN?"
2330 DATA "WARUM F�HRST DU COMPUTER AN?"
2340 DATA "WAS GLAUBST DU WAS MASCHIENEN DEIN PROBLEM ANGEHT?"
2350 DATA "GLAUBST DU NICHT DASS COMPUTER LEUTEN HELFEN K�NNEN?"
2360 DATA "WAS BESORGT DICH BESONDERS AN MASCHIENEN?"
2370 DATA "SAGE MIR OB DU WIRKLICH PSYCHISCHE PROBLEME HAST?"
2380 DATA "WAS SAGT DAS DIR?"
2390 DATA "SO SO."
2400 DATA "ICH WEI� NICHT OB ICH DICH GANZ VERSTANDEN HABE."
2410 DATA "ERKL�RE DEINE PROBLEME BITTE ETWAS BESSER."
2420 DATA "KANNST DU DASS ETWAS N�HER AUSF�HREN?"
2430 DATA "DAS IST ZIEMLICH INTERESSANT."
2500 REM
2510 REM
2520 REM
2530 DATA 1,3,4,2,6,4,6,4,10,4,14,3,17,3,20,2,22,3,25,3
2540 DATA 28,4,28,4,23,3,35,5,40,9,40,9,40,9,40,9,40,9,40,9
2550 DATA 49,2,51,4,55,4,59,4,63,1,63,1,64,5,69,5,74,2,76,4
2560 DATA 80,3,83,7,90,3,93,6,99,7,106,6
2570 END

