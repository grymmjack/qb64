'****************************************************************************
' DirSound.bas - DirectSound = Subroutine zur Direkt-Ausgabe eines Tons
'                auf den PC-Speaker
' ===========================================================================
' Die Ansteuerung des PC-Speakers erfolgt direkt Åber die I/O-Ports. Dies
' hat gegenueber dem SOUND- und PLAY-Befehl den Vorteil, dass die Soundausgabe
' auch in einem Programm funktioniert, das gerade in einem Windows-Hinter-
' grundfenster laeuft. Bei PLAY und SOUND wird in diesem Falle leider ein
' Dauerpiepsen erzeugt.
'
' Die Subroutine ersetzt den SOUND-Befehl und hat aehnliche Uebergabepara-
' meter wie dieser:
' Es wird ein Ton der Frequenz <herz%> und der Dauer von <sec!> Sekunden
' auf den PC-Speaker ausgegeben. Beim SOUND-Befehl wird demgegenueber die
' Tonlaenge als Anzahl von Systemtakten †a 56 ms statt in sec angegeben.
'
' Credits: Die Idee zu diesem Programm stammt von James Vahn und wurde der
' ~~~~~~~~ ABC-Collection, Snippet 'PC SPEAKER FREQUENCY' entnommen.
'          Thanks a lot, James!
'
' Thomas Antoni, 01.11.99 - 12.02.04
'   thomas*antonis.de --- www.antonis.de --- www.qbasic.de
'****************************************************************************
'
DECLARE SUB DirectSound (herz%, sec!)
DO
  PRINT "Soundausgabe auf den PC-Speaker"
  INPUT "gib die Frequenz in Hz ein  "; herz%
  INPUT "Gib die Tondauer in sec ein "; sec!
  CALL DirectSound(herz%, sec!)
  PRINT
  PRINT "  ... Wiederholung mit bliebiger Taste, Beenden mit Esc"
  DO: taste$ = INKEY$: LOOP WHILE taste$ = "" 'Warten auf Tastenbetaetigung
  IF taste$ = CHR$(27) THEN END
LOOP

'
SUB DirectSound (herz%, sec!)
Divisor& = 1193180 / herz%
LSB% = Divisor& MOD 256
MSB% = Divisor& \ 256
'
Old% = INP(&H61)     '8255 PPI chip. Save the original.
OUT &H43, 182        '8253 Timer chip. 10110110b Channel 2, mode 3
Port% = INP(&H61)    'get the 8255 port contents.
OUT &H61, Port% OR 3 'enable the speaker and use channel 2.
'
OUT &H42, LSB%       'Output Frequency Lo and Hi Byte
OUT &H42, MSB%
'
time! = TIMER        'Wait until sec! elapsed
WHILE TIMER < time! + sec!: WEND
OUT &H61, Old%       'turn it off.
END SUB

