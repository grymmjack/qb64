'************************************************************************
' PAINTMUS.BAS = Texturieren (Ausmalen) eines Dreiecks mit einem Muster
' ============
' Dieses GW-BASIC - Programm demonstriert, wie man Dreiecke texturiert,
' d.h. mit einem Muster ausmalt. Das Programm ist auch unter Q(uick)Basic
' ablauffaehig.
' Zunaechst wird ein Rechteck von Hand mit einer kleinen Zeichenroutine
' ausgemalt. Dazu waehlt man nacheinander mit den Cursortasten den
' auszumalenden Bereich und waehlt jeweils mit den Buchstabentasten
' die dortige Farbe. Nach dem Anmalen dieser "Kachel" drueckt man die
' Esc-Taste. Anschliessend erscheint das mit diesen Kacheln texturierte
' Dreieck.
'
' (c) Andreas Meile ("Dreael") - www.dreael.ch
'*************************************************************************
100 SCREEN 9: CLS : KEY OFF
110 DIM CU%(15)
120 LOCATE 20, 1: PRINT CHR$(4);
130 GET (0, 269)-(6, 275), CU%
140 LOCATE 2, 12
150 FOR I% = 65 TO 80: PRINT CHR$(I%); : NEXT I%
160 FOR I% = 0 TO 15: LINE (88 + 8 * I%, 28)-STEP(7, 20), I%, BF: NEXT I%
170 X% = 0: Y% = 0: YS% = 8: F% = 15
180 IF Y% >= YS% THEN Y% = YS% - 1
190 LINE (0, 4 + YS% * 8)-(71, 349), 0, BF
200 LINE (0, 0)-(71, 7 + YS% * 8), , B
210 LINE (2, 2)-(69, 5 + YS% * 8), , B
220 PUT (8 * X% + 4, 8 * Y% + 4), CU%
230 T$ = "": WHILE T$ = "": T$ = INKEY$: WEND
240 PUT (8 * X% + 4, 8 * Y% + 4), CU%
250 IF T$ = CHR$(0) + "H" THEN Y% = (Y% + YS% - 1) MOD YS%
260 IF T$ = CHR$(0) + "P" THEN Y% = (Y% + 1) MOD YS%
270 IF T$ = CHR$(0) + "K" THEN X% = X% - 1 AND 7
280 IF T$ = CHR$(0) + "M" THEN X% = X% + 1 AND 7
290 IF T$ > "@" AND T$ < "Q" OR T$ > "`" AND T$ < "q" THEN LINE (8 * X% + 4, 8 * Y% + 4)-STEP(7, 7), ASC(T$) - 1 AND 15, BF
300 IF T$ = "+" AND YS% < 63 THEN YS% = YS% + 1: GOTO 180
310 IF T$ = "-" AND YS% > 1 THEN YS% = YS% - 1: GOTO 180
320 IF T$ <> CHR$(27) THEN 220
330 FM$ = ""
340 FOR Y% = 1 TO YS%
350 H% = 1
360 FOR BP% = 1 TO 4
370 W% = 0
380 FOR X% = 1 TO 8
390 W% = 2 * W% + (POINT(8 * X%, 8 * Y%) AND H%)
400 NEXT X%
410 FM$ = FM$ + CHR$(W% \ H%)
420 H% = 2 * H%
430 NEXT BP%
440 NEXT Y%
450 CLS
460 LINE (100, 40)-(300, 60), 13
470 LINE -(180, 300), 13
480 LINE -(100, 40), 13
490 PAINT (180, 200), FM$, 13
500 LINE (300, 100)-(500, 200), 3, B, &H8888

