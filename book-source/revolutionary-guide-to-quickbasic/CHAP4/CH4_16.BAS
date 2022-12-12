REM Demonstration of CD control 
REM \CHAP\CH4_16.BAS

CLS
PRINT "Insert compact disk, press any key,"
PRINT "run CD-Player and press Power (off)"
F$ = INPUT$(1)
SHELL "C:\CDROM\gsaudio.exe"
PRINT "10 Seconds Play!"
SLEEP 10
SHELL "C:\CDROM\eject.exe"
CLS
PRINT "END"

END     
 