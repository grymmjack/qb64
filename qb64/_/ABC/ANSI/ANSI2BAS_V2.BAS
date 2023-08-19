' $SCREENHIDE
$CONSOLE
' _DEST _CONSOLE
DEFINT A-Z
DECLARE SUB ReadANSI (T$)
DECLARE SUB SaveANSI (F$)
 
' * FREEWARE Submission to better ANSI to BASIC
' * Written by David A. Wicker (david@fastlane.net)
 
' * Reason: other could not handle complex ANSI pictures
'           my version is quite a bit smaller and produces smaller
'           Q-Basic 4.5 merge source.
            
' * NOTE!  Does not handle FLASHING (but neither did other) :)
 
DEF SEG = &HB800
 
Again:
  CLS
  LOCATE 12
  PRINT "* ANSI TO BASIC MERGE CONVERTOR WRITTEN BY DAVID A. WICKER *"
  PRINT
  DO
    INPUT "(C)onvert ANSI / (S)ee Sample / (E)xit :", T$
  LOOP UNTIL T$ = "C" OR T$ = "S" OR T$ = "E"
  IF T$ = "E" THEN END
 
  IF T$ = "S" THEN
    RESTORE SampleANSI
    T$ = ""
    FOR I = 1 TO 96
      READ A$
      T$ = T$ + A$
    NEXT
    ReadANSI T$
Pause:
    LOCATE 24, 1
    PRINT "Press any key to continue:";
    DO: LOOP UNTIL INKEY$ > ""
    GOTO Again
  END IF
 
  IF T$ = "C" THEN
GetName:
    PRINT
    INPUT "Path and Name of ANSI picture: I.E. \ansi\test.ans: ", F$
    IF F$ = "" THEN GOTO Again
    ON ERROR GOTO NotFound
    OPEN "I", 1, F$
    CLOSE
    SaveANSI F$
    PRINT "ANSI.INS saved on current path."
    PRINT "Use Q-Basic 4.5 (F)ile & (M)erge to extract"
    GOTO Pause
  END IF
 
END
 
NotFound:
  PRINT "* ERROR *  ANSI FILE NOT FOUND!"
  RESUME GetName
 
SampleANSI:
DATA "Ý&Û$ß$Û$ß$Û$ $Ý&Û$ß$ß$Û$ $Ý&Û$ß$ß$Û$ $Ý&"
DATA "Û$ $Ý&Û$ß$ß$Û$ $ $ $ßcßc c c c cÜrÜrÜrÜr"
DATA "Ür r r r rßcßc * * * * * * * * * * * *H1"
DATA "e1y1 1K1i1d1s1.1.1.1 * * * * * * * * * *"
DATA "Ý&Û$ $ $ $Û$ $Ý&Û$Ü$Ü$Û$ $Ý&Û$Ü$Ü$Û$ $Ý&"
DATA "Û$ $Ý&Û$ $ $Û$ $ßc c c c c c cÛrßr rßr r"
DATA "ßrÛr r r r r r rßc * * * * * * * * *¿/ /"
DATA "¿/ * * * * * * * * * * * * * * * * * * *"
DATA "Ý&Û$ $ $ $Û$ $Ý&Û$Ü2Û2Û$Ü2Ý&Û$ $ß$Ü$ $Ý&"
DATA "Û$ $Ý&Û$Ü$Ü$ßd d d d d d d dÛrÛr rÛr rÛr"
DATA " rÛrÛr r r r r r rßc * * * * * * * *³///"
DATA "¿/Ú/Ä/¿/Ú/Ä/¿/Ú/Ä/¿/ * * * * * * * * * *"
DATA "°C±C²C *°C±C²C *ß2Û2Û2Û2Û2Û2Ü2 2°C±C²C *"
DATA "°C±C²C *°C cÛ'ß'ß'ß' 'Ü'Ü'Ü'Ü'Ü'Ü'Ü'Ü'Ü'"
DATA "Ü'Ü'Ü'Ü'Ü' 'ÜcÜcÜc c c * * * * * * *Ù/ /"
DATA "Ù/À/Ä/Ä/À/Ä/Ä/Ã/Ä/Ù/ * * * * * * * * * *"
DATA " / / /Ü2Û2Û2Ü2 2 2 2Û2Û2Û2Û2Û2Û2Ü2 * * *"
DATA " * * * * rÛ' 'Ü'Û'Û'Û'Û'ß'ß'ß'ß'ß�ß�ß�ß�"
DATA "ß'ß'ß'ß'Û�Û�Û�Û�Ü' ' g g * * * * * * * *"
DATA " * * * * * * *Ù/ * * * * * * * * * * * *"
DATA " / /Û2Û2Û2Û2Û2Û2Ü2 2°Cß2Û2Û2Û2Û2Û2Û2Ü2±C"
DATA "²C *°C±CÜc *Û'Û'Ý'²�²� *ß� � �ß� * � � *"
DATA "ß� � �ß� *²�²�Þ'Û'Û' 'Üc * * * * *Ú/Ä/¿/"
DATA " / / /./Ú/./ * * * * * * * * * * * * * *"
DATA " / / /ß2Û2Û2Û2Û2Û2Û2Ü2 2 2Û2Û2Û2Û2Û2Û2Û2"
DATA "Ü2 2 2 rßcÛ'Ý'²�²� � � �ß)ß)ß) � � � � �"
DATA " �Ü�Ü�Ü� � � �²�²�Þ'Û'ßc c * * * *À/Ä/¿/"
DATA "Ú/Â/¿/¿/³/¿/Â/Ä/¿/Ú/Ä/¿/ * * * * * * * *"
DATA " / /²C *°Cß2Û2Û2Û2Û2Û2Û2Ü2 2ß2Û2Û2ß2ß2 2"
DATA "Ü2Ü2Ü2 2ÜcÝ'²�²� � � �Ý)Û2Û2Û2Ý� � � � �"
DATA "Þ�Û2Û2Û2Ý� � � �²�²�Þ'Üc * * * * *À/Ä/Ù/"
DATA "Ù/ /Ù/Ù/Ù/Ù/Ù/ /Ù/À/Ä/´/ * * * * * * * *"
DATA " * * * * * * * *ß2Û2Û2Û2ß2ß2Û2Ü2Ý2Ü2Û2Û2"
DATA "Û2Û2Û2Û2 2²�²� � � �Þ2Û2Û2Û2ßBßBÝ� � �Þ�"
DATA "ßBßBÛ2Û2Û2Ý2Û)Û)Û)²�²� * * * * * * * * *"
DATA " * * * * * * * * * *Ä/Ù/ * * * * * * * *"
DATA " / /°C±C²C *°C±C²CÜ2Ü2Ü2Û2Û2Ü2ß2 2Û2Û2Û2"
DATA "ß2 2ß�ß�ß� *²�²� �Þ�Û2Û2ßB Bß$ 4 * � � *"
DATA " 4ß$ 4ßBÛ2Û2Ý� �²�²� *ß�ß�ß� * * * * * *"
DATA "a1n1d1 1S1n1u1f1f1 * * * * * * * * * * *"
DATA " * * * * * * * *Û2Û2Û2Û2Û2Û2Û2Û2Ü2 2ß2 2"
DATA " � � � � � �Þ�²�²� �Ý)Û2 B *þ2Þ$Ý� � �Þ�"
DATA "Ý$þ2 2 BÛ2Þ) �²�²�Ý� � � � � � � * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * *°C±C²C * *ß2Ü2Ü2ß2Û2ß2ß2Ü2Û2Û2 �"
DATA " � � � �\� � � *Ü� � � �ß�ß�ß�Þ) � � � �"
DATA "Ý)ß�ß�ß� � � �Ü� * � �/� � � � � � *t1h1"
DATA "o1s1e1 1S1n1i1f1i1t1s1 * * * * * * * * *"
DATA " * * * * * * * *Û2Û2Û2Û2Û2Ü2ß2Û2Û2Û2ß2Û2"
DATA " � � � �/� � �ß� * *Ü� � � �Þ) � � � � �"
DATA " �Ý) � � �Ü� * *ß� � �\� � � � � * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * *°C±Cß2Û2Û2Û2Ü2Ü2Û2Û2ß2Ü2Û2Û2"
DATA "Û2 2ß)ß) � �Ý� �ß� * * * * * *ß)Û)Û)Û)Û)"
DATA "ß) * * * * * *ß� �Þ� � �Ü�Ü� * * * *°C±C"
DATA "²C *°C±C²C *°C±C²C *°C±C²C * * * * * * *"
DATA "Ü'Ü'Ü'Ü' * * * * * *ß2ß2ß2ß2ß2 2ß2Û2Û2ß2"
DATA "Ü'Û'Û'Û'Û'Ü' � � �ß� * * * * * * * * * *"
DATA " * * * * * *ß� � � �Ü' g gÜ'Ü'Ü'Û'Û'Û' g"
DATA " g g gÜ' * * * * * * * * * * * * * * * *"
DATA "Þ2Û2Ý2Ý2 2 2 2 2°C±C²C *°C±C²C *°C±C²C c"
DATA " c c c c c cÜ' � � � � �ß�ß� *Û'Ü'Ü'Ü'Ü'"
DATA "Û' 'ß�ß� � � � � �Ü' g g g g g g g g g g"
DATA " g g g g g * * *°C±C²C *°C±C²C * * * * *"
DATA "Ü'Ü'Ü'Ü' * * * * * * * * * * * * * * * *"
DATA " g g g g g g gÜ$ß) � � � � � �ß�ß'ß'ß'ß'"
DATA "ß� � � � � � �ß)Ü$ d d d d d d d * d d d"
DATA " d d d d d d * * * * * * * * * * * * * *"
DATA "Þ2Û2Ý2Ý2 * * * * * *°C±C²C *°C±C²C *°C±C"
DATA "²Cß' g g g g gÛ$Û$Ü$ß)ß)ß)Þ) � � � � � �"
DATA " � �Ý)ß)ß)ß)Ü$Û$Û$ d d d d d d * d d d d"
DATA " d d d d d d d±C²C *°C±C²C * * * * * * *"
DATA "Ü'Ü'Ü'Ü' * * * * * * * * * * * * * * * *"
DATA " * * * g g gÛ$Û$Û$Û$ d d dÜ'Ü'ß)ß)ß)ß)ß)"
DATA "ß)Ü'Ü' g g gÛ$Û$Û$Û$ d d d *Ü' g g g g g"
DATA " g g g g g g * * * * * * * * * * * * * *"
DATA "Þ2Û2Ý2Ý2 2 2 2 2°C±C²C *°C±C²C *°C±C²C *"
DATA "°C±C²C * cÛ$Û$Û$Û$Û$Û$ d d d d d d d d d"
DATA " d d d d dÛ$Û$Û$Û$Û$Û$ d *Û2 2ß'ß'ß'ß'ß'"
DATA "ß'ß'ß'ß'ß'Ü2 2 2°C±C²C *°C±C²C * * * * *"
DATA "Ü'Ü'Ü'Ü' * * * * * * * * * * * * * * * *"
DATA " * * * *ß' gÛ$Û$ÛqÛqÛ$Û$ dÛ$Û$Û$Û$Û$Û$Û$"
DATA "Û$Û$Û$ dÛ$Û$ÛAÛAÛ$Û$ dß' ' 'Û2Û2Û2Û2Û2Û2"
DATA "Û2Û2Û2Û2Û2ß2 * * * * * * * * * * * * * *"
DATA "Þ2Û2Ý2Ý2 2 2°C±C²C *°C±C²C *°C±C²C *°C±C"
DATA "²C *°C±C²C * *ß$ 4 4ß$ß3 3 3 3 3 3 3 3 3"
DATA " 3 3 3 3ß3ß$ 4 4ß$ $ $ $ $Û2Û2Û2ß2Û2Û2ß2"
DATA "Û2Û2ß2Û2Û2Û2°C±C²C *°C±C²C * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
DATA " * * * * * * * * * * * * * * * * * * * *"
 
DEFINT A-Z
SUB ReadANSI (T$)
  FOR I = 0 TO 23
    FOR J = 0 TO 79
      N = I * 160 + J * 2
      A = ASC(MID$(T$, N + 1, 1))
      IF A = 255 THEN A = 34
      POKE N, A
      B = ASC(MID$(T$, N + 2, 1))
      POKE N + 1, B - 35
    NEXT
  NEXT
END SUB
 
DEFINT A-Z
SUB SaveANSI (F$)
  Q$ = CHR$(34)
  SHELL "TYPE " + F$
  OPEN "O", 1, "ANSI.INS"
  FOR I = 0 TO 24
    FOR J = 0 TO 79
      IF J = 0 OR J = 20 OR J = 40 OR J = 60 THEN
        IF I > 0 OR J > 0 THEN PRINT #1, Q$
        PRINT #1, "DATA " + Q$;
      END IF
      N = I * 160 + J * 2
      A = PEEK(N)
      IF A < 32 THEN A = 32
      IF A = 255 THEN A = 32
      IF A = 34 THEN A = 255
      B = PEEK(N + 1)
      B = B MOD 128
      PRINT #1, CHR$(A); CHR$(B + 35);
    NEXT
  NEXT
  PRINT #1, Q$
  CLOSE
END SUB