'************************************
' TEILBAR.BAS = Teilbarkeitsprüfung
' ===========
' Dies Programm prüft, ob sich zwei
' Ganzzahlen ohne Rest durcheinander
' teilen lassen
' (c) Thoma Antoni, 21.1.2004
'************************************
INPUT "Zaehler ="; z&
INPUT "Nenner ="; n&
IF z& MOD n& <> 0 THEN PRINT "nicht ";
PRINT "teilbar"

