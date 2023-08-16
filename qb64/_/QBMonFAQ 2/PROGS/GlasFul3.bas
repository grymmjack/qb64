'****************************************************************
' GLASFUL3.BAS = Animiertes Befuellen eines Glases
' ============
' Dieses QBasic-Programm steuert das an der Parallelschnittstelle
' h‰ngende "multiface" Interface an und Befuellt ein Glases mit
' Apfelsaftschorle, wobei die Glasgroesse und das Mischungsver-
' haeltnis waehlbar sind. Der F¸llvorgang wird als animierte
' Grtafik auf dem Bildschirm angezeigt-
'
' (c) Skilltropnic, 28.12.2004
'*****************************************************************
'
10 t25 = 1 'Zeitkonstante fuer 25ml Saft oder Sprudel
20 SCREEN 12
22 KEY(1) ON
23 ON KEY(1) GOSUB 2000                                   'Notaus
'
30 '********************** Auswahlmenue *************************
40 CLS : LOCATE 30, 1: PRINT "Notaus mit F1": LOCATE 1, 1
50 PRINT "Waehlen sie bitte."
60 PRINT
70 PRINT "(1) kleine Apfelsaftschorle"
80 PRINT "(2) grosse Apfelsaftschorle"
90 taste$ = INKEY$
100 IF taste$ = "" THEN 90
110 gr = ASC(taste$) - 48
120 IF gr < 1 OR gr > 2 THEN 90
130 IF gr = 2 THEN gr = 1.5
140 CLS : LOCATE 30, 1: PRINT "Notaus mit F1": LOCATE 1, 1
150 PRINT "Sie haben sich fueÅr eine ";
160 IF gr = 1 THEN PRINT "kleine";  ELSE PRINT "grosse";
170 PRINT " Apfelsaftschorle entschieden."
180 PRINT : PRINT "Waehlen sie nun das Mischungsverhaeltnis:"
190 PRINT
200 PRINT "     Saft   Sprudel"
210 PRINT "--------------------"
220 PRINT "(1)  75%      25%"
230 PRINT "(2)  50%      50%"
240 PRINT "(3)  25%      75%"
250 PRINT "(0)  Zurueck"
260 taste$ = INKEY$
270 IF taste$ = "" THEN 260
280 mv = ASC(taste$) - 48
290 IF mv < 0 OR mv > 3 THEN 260
300 IF mv = 0 THEN 20
'
1000 '********************* Befuellen **************************
1010 CLS : LOCATE 30, 1: PRINT "Notaus mit F1": LOCATE 1, 1
1020 PRINT "Bitte warten..."
1030 LINE (99, 100)-(201, 261), 15, B                     'Glas zeichnen
1040 LINE (100, 100)-(200, 100), 0
1050 tsaft = t25 * (4 - mv) * 2 * gr
1060 tlimo = t25 * mv * 2 * gr
1070 IF tsaft > tlimo THEN tmax = tsaft ELSE tmax = tlimo
1080 ein = 1                                              'Saft an
1090 ein = 8                                              'Limo an
1100 tstart = TIMER
1110 dt = TIMER - tstart
1120 IF dt >= tsaft THEN aus = 1                          'Saft aus
1130 IF dt >= tlimo THEN aus = 8                          'Limo aus
1140 hoehe = 260 - 100 * gr * dt / tmax                   'Saftgrafik steigt
1150 LINE (100, 260)-(200, hoehe), 14, BF
1160 IF dt < tsaft OR dt < tlimo THEN 1110
1170 LOCATE 1, 1
1180 PRINT "Fertig. Bitte entnehmen sie den Becher."
1190 SLEEP 3                                              '3 Sek. warten
1200 GOTO 30                                              'zurueck z. Anfang
'
2000 '********************** Notaus *****************************
2010 aus = 1
2020 aus = 8
2030 END
 

