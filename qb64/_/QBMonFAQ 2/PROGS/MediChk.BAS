'***************************************************************
' MEDICHK.BAS = Prueft ob eine Diskette/CD/DVD im Laufwerk liegt
' ===========
'
' Dieses Q(uick)Basic-Programm prueft, ob ein Wechselmedium in
' das Disketten-, CD-, oder DVD-Laufwerk eingelegt ist und
' zeigt eine entsprechenden Meldung an.
'
' (c) Sebastian Steiner (sebastian_steiner*gmx.de), 23.3.2006
'***************************************************************
'
ON ERROR GOTO ErrorHandler
CLS
INPUT "Welches Laufwerk testen? [A,D,E,F]", x$
'--- Liste evtl. gemaess chkdrive.bas vorher ermitteln
PRINT
CHDIR UCASE$(x$) + ":\"
PRINT "Laufwerk verfuegbar, Medium eingelegt."
SLEEP
END
'
ErrorHandler:
IF ERR = 71 THEN
 PRINT "Laufwerk nicht verfuegbar, kein Medium eingelegt!"
 SLEEP: END
ELSE
 PRINT "Irgendein anderer Fehler."
 SLEEP: END
END IF

