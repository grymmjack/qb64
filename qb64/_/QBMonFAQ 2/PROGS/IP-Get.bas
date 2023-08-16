'************************************************************
' IP-Get.bas = Ermitteln und Anzeigen der eigenen IP-Adresse
' ==========
' Anmerkung von Thomas Antoni:
'  Das Programm funktioniert nicht unter meinem
'  Windows 95, da dort das Tool ipconfig.exe fehlt!
'
' (c) Ch@rly (Karl Pircher; karlpircher*hotmail.com) 6.3.02
'************************************************************
DEFINT A-Z
DIM file AS STRING
CLS
file = "c:\tmp\ip.txt"
cmd$ = "ipconfig > " + file
SHELL cmd$
kanal = FREEFILE
OPEN file FOR INPUT AS #kanal
DO
   LINE INPUT #kanal, a$
   s = INSTR(UCASE$(a$), "IP-ADRESSE")
   IF s <> 0 THEN
      EXIT DO
   END IF
LOOP WHILE NOT EOF(kanal)
CLOSE #kanal
PRINT "Zeile: "; a$
s = INSTR(a$, ":")
PRINT "IP Adresse: "; MID$(a$, s + 1)
KILL file


