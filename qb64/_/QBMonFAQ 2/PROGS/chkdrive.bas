'****************************************************************************
' CHKDRIVE.BAS = Die vorhandenen PC-Laufwerke ermitteln/anzeigen
' ============   Checks the available drives and displays their drive letters
'
' Dieses Q(uick)Basic-Programm ermittelt, welche Laufwerke in dem PC
' vorhanden sind und zeigt die Laufwerksbuchstaben an. Das Disketten-
' Laufwerk A: wird nur erkannt, wenn eine Diskette eingelegt ist.
' Das Diskettenlaufwerk B: wird uebersprungen, weil DOS einen stoerenden
' Anwenderdialog einblendet, wenn Laufwerk B: vorhanden ist, aber keine
' Diskette eingelegt ist.
' Das Programm ist unter Windows 95 getestet. Unter Windows NT4
' funktioniert es nicht.
'
' Based on a piece of code which I recieved from NetZman
'   ( netzman*gmx.at - http://netzman.exit.mytoday.de/ )
'
' Hint: SHELL "fdisk /status" would also do the job, but cannot
'       detect floppy drives
'
' (c) Thomas Antoni, 17.01.2001 - 10.2.2006
'***************************************************************************
'
ON ERROR GOTO ErrorHandler
CLS : PRINT "The following Drives are available:"
FOR i% = 65 TO 90              'ASCII codes for Drive Letters "A" to "Z"
  IF i% <> 66 THEN             'Skip Floppy "B:\", doesn't work on my PC
    CHDIR CHR$(i%) + ":\"
    PRINT CHR$(i%) + ":"
  END IF
NextDrive:
NEXT i%
END
'
ErrorHandler:              'Drive not existing or no storage medium inserted
i% = i% + 1                'skip the current drive & goto next one
RESUME NextDrive

