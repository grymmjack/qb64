'*****************************************************************
' ZINSEN1.BAS = Kapitalwachstum mit Zinseszins berechnen
' ===========
' Dieses QBasic-Programm berechnet, auf welchen Betrag
' ein angelegtes Anfangskapital anwaechst, wenn es fuer
' n Jahre zu einem Zinssatz von z% angelegt wird. Dabei
' wird der Zinseszins beruecksichtigt.
'
' (c) Thomas Antoni, 30.3.2004
'*****************************************************************
CLS
DO
INPUT " Anfangskapital (0 fuer beenden)...:"; Anfangskapital
IF Anfangskapital = 0 THEN END
INPUT " Zinssatz..........................:"; Zinssatz
INPUT " Anlagedauer in Jahren.............:"; Jahre
Endkapital = Anfangskapital * (1 + Zinssatz / 100) ^ Jahre
PRINT " Das Endkapital betraegt...........:"; Endkapital; " Euro"
PRINT
LOOP

