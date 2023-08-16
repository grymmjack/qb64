'***************************************************************************
' SCREENS.BAS = QBasic-Programm zum Testen der Bildschirmmodi
' ===========
'
' Mit Hilfe dieses Programms kann man ermitteln, welche Screen-Modi mit einer
' modernen Grfaikkarte unter Windows 3.1/ 95 im Voll-/Teilbild betreibbar
' sind:
'                 Vollbild    Teilbild
'
' - SCREEN 0...2:    ja         ja
'
' - SCREEN 3...6:     -         -  (nicht nutzbar: Olivetti, Herkules usw.)
'
' - SCREEN 7..13:    ja         nur, wenn nach der Windos-Fehlermeldung
'                               [Alt+Enter] bet„tigt wird (kann eventuell
'                               durch spezielle PIF-Datei vermieden werden.
'
'
'   \         (c) Thomas Antoni, 28.09.99
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de  
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'***************************************************************************
DO
  INPUT "Welcher SREEN-Modus soll aktiviert werden:"; mode%
  SCREEN mode%
  CLS
  PRINT "SCREEN-Modus"; mode%
  FOR i% = 1 TO 10: PRINT "Dies ist SCREEN "; mode%: NEXT i%
  PRINT "Wiederholen...[Taste]   Beenden...[Esc]"
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
  CLS
LOOP WHILE taste$ <> CHR$(27)
SCREEN 0
CLS
END

