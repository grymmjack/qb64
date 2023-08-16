'************************************************************************
' AMPLib.BAS = Libary zum Ausschalten des ATX-Netzteils und zum
' ==========     Auslesen des Laptop-Akkustandes
'
' Diese Bibliothek ist dafür gedacht, mit der Sprache QuickBasic
' ab der Version 4.5 aus DOS und auch aus Windows heraus
' das APM (Advanced Power Management) BIOS anzusteuern.
' Unter DOS stehen die Chancen manchmal schlechter, da kein
' Treiber geladen ist; meistens funktioniert aber alles tadellos.
' 
' Die Ausschaltfunktion kann unter Umständen gefährlich werden,
' da ja sofort nach Aufruf das Netzteil den Strom abschaltet.
' Es funktioniert übrigens auch mit den Netzteilen der Siemens
' PCD-5L- und den SCENIC Pro C5-Computern. Alle ATX-Netzteile sollten
' darauf ansprechen. Bei Laptops kann es evtl. Probleme geben...
' 
' Dieses Programm ist Freeware! Sie dürfen es kopieren
' und weitergeben, so oft Sie möchten. Wenn es Sorcecodes
' etc. enthält, und Sie verwenden diese in Ihren Programmen,
' seien Sie bitte fair und nennen den Autor! Der Autor
' übernimmt keine Garantie, dass das Programm und seine Teile
' auch fehlerfrei funktionieren! Außerdem wird absolut keine 
' Haftung für Schäden übernommen, die durch das Programm oder
' von Teilen des Programmes evtl. ausgehen können!
'
' Weil das Programm den INTERRUPTX-Befehl verwendet, ist es nur unter
' QuickBASIC, nicht jedoch unter QBasic ablauffaehig. Aus demselben
' Grund muss QuickBASIC mit der Option "/L" aufgerufen werden,
' also z.B. mit "QB.EXE /L AMPLIB.BAS" .
'
' Autor   : Stefan Riepl
' E-Mail  : quark48*web.de
' Webseite: www.wurst-salat.co9.de
'
' Kritik, Verbesserungsvorschläge usw. an den Autor
'
' Obligatorisches:
' Ich/wir hafte/n nicht für Schäden, die durch die Benutzung dieses
' Programmes oder von Teilen des Programmes entstehen können!
' Wenn ihr/du etwas aus diesem Programm in deinen Programm(en)
' verwendest, bitte erwähne mich! Damit die Arbeit nicht umsonst war ;)
'
' ***********************************************************************
'
DECLARE FUNCTION APM.GetBatteryPower% ()
DECLARE FUNCTION APM.Connect% ()
DECLARE SUB GetHiLo (Integ%, Hi%, Lo%)
'$INCLUDE: 'Qb.bi'
'
CLS
PRINT "APM-Libary"
PRINT "Version 1.0"
PRINT "By Stefan Riepl 2004-2005"
PRINT "*****************************"
PRINT
PRINT "Verbinde mit APM-BIOS..."
i% = APM.Connect%
PRINT "Ihre Batterie/ihr Akku ist zu"; APM.GetBatteryPower; "% noch voll"
'
FUNCTION APM.Connect%
DIM Reg AS RegTypeX
Reg.ax = &H5301
Reg.bx = &H0
CALL InterruptX(&H15, Reg, Reg)
PRINT "OK."
APM.Connect% = Reg.ax
END FUNCTION
'
FUNCTION APM.GetBatteryPower%
DIM Reg AS RegTypeX
Reg.ax = &H530A
Reg.bx = &H1
CALL InterruptX(&H15, Reg, Reg)
T$ = HEX$(Reg.cx)
IF LEN(T$) < 4 THEN T$ = STRING$(4 - LEN(T$), "0") + T$
H% = VAL("&H" + LEFT$(T$, 2))
L% = VAL("&H" + RIGHT$(T$, 2))
APM.GetBatteryPower% = L%
END FUNCTION
'
SUB APM.PowerOff
' Schaltet das Netzteil bei ATX-Computern sofort aus;
' ich glaube, dass das auch bei Laptops funktioniert.
DIM Reg AS RegTypeX
Reg.ax = &H5301
Reg.bx = 0
CALL InterruptX(&H15, Reg, Reg)
Reg.ax = &H530E
Reg.bx = 0
Reg.cx = &H102
CALL InterruptX(&H15, Reg, Reg)
Reg.ax = &H5307
Reg.bx = 1
Reg.cx = 3
CALL InterruptX(&H15, Reg, Reg)
END SUB
'
SUB GetHiLo (Integ%, Hi%, Lo%)
i$ = HEX$(Integ%)
IF LEN(i$) < 4 THEN
i$ = STRING$(4 - LEN(i$), "0") + i$
END IF
Hi% = VAL(MID$(i$, 1, 2))
Lo% = VAL(MID$(i$, 3, 2))
END SUB