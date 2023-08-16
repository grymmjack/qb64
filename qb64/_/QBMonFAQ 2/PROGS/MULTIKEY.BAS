'************************************************************
' MULTIKEY.BAS = Erfassen von Mehrfachtastenbetaetigungen
' ============
' Dies QBasic-Programm liest das Keyboard-Statusregister
' &H60 aus, um das Druecken und Loslassen von Tasten zu
' erfassen. Dort werden die Tasten nicht im ASCII-Code,
' sondern im so genannten Scancode dargestellt. Die
' Scancodes der einzelnen Tasten sind in der QBasic-Hilfe
' unter "Inhalt | Tastatur-Abfragecodes" aufgelistet.
'
' Beim Druecken wird der Scancode der betreffenden
' Taste angezeigt, beim Loslassen der Scancode+128. Bei
' einige Tasten, z.B. SHIF-TRechts/Links, Del, Ins, Home
' End, Pgp, PgDn gibt es leider Abweichungen von der
' Differenz von 128 zwischen gedrueckter und losgelassener
' Taste. Die Abweichung bei Shift-Links/Rechts ist in diesem
' Programm abgefangen. Die anderen jedoch nicht.
'
' Das Programm traegt bis zu 4 gleichzeitig gedrueckte Tasten
' in den Tastenpuffer keybuffer%() mit ihrem Tastencode ein.
' Losgelassene Tasten werden durch ueberschreiben mit "0"
' aus dem Tastenpuffer geloescht. Bei jeder Ver‰nderung des
' Statusworts &H60 wird der gesamte Tastenpufferinhalt
' auf dem Bildschirm angezeigt. Hier koennte auch Deine
' spezielle Abfrage-Routine stehen.
'
' Mit der Esc-Taste (Tastencode = 1) wird das Programm
' beendet.
'
' (c) Thomas Antoni, 24.8.2003 - 25.8.2003
'************************************************************
'
DIM keybuffer%(1 TO 4)
CLS
DEF SEG = 0
oldkey% = 256
DO
'
'--- Tastencode aus Statuswort lesen ----------------------
POKE &H41A, PEEK(&H41C)
keycode% = INP(&H60)
IF keycode% <> oldkey% THEN 'neuer Tastenstatus
  oldkey% = keycode% 'Tastencode merken
'
'--- "Taste losgelassen" erkannt ----------------------------
  IF keycode% > 128 AND keycode% <> 250 THEN 'Taste losgelassen
    IF keycode% = 170 OR keycode% = 182 THEN
      keyoff% = 250
        'Sonderbehandlung fuer Shift-Links bzw. -Rechts-Taste
        'Taste gedrueckt=170 bzw. 182, losgelassen=250
    ELSE
      keyoff% = keycode% - 128  'Scancode d.losgelassenen Taste
    END IF
    FOR i% = 1 TO 4
      IF keybuffer%(i%) = keyoff% THEN
        keybuffer%(i%) = 0  'Taste im Puffer loeschen
      END IF
     NEXT i%
 
'
'---- "Taste gedrueckt" erkannt
  ELSE 'Taste gedrueckt
    FOR i% = 1 TO 4
      IF keybuffer%(i%) = 0 THEN
         keybuffer%(i%) = keycode%
           'Taste im Puffer am ersten freien Platz eintragen
         EXIT FOR 'Schleife abbrechen
      END IF
    NEXT i%
  END IF
'
'---- Code der gerade gedrueckten max. 4 Tasten anzeigen ----
'---- (Anzeige 0 0 0 0, wenn keine Taste gedrÅckt -----------
FOR i% = 1 TO 4
  PRINT keybuffer%(i%);
NEXT i%
PRINT "" 'Zeilenvorschub
END IF
LOOP UNTIL keycode% = 1 'Ende mit Esc
DEF SEG
END

