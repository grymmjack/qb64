'**********************************************************
' KEYSCAN.BAS = Tastenbetaetigungen erfassen ueber &H60
' ============
' Dies QBasic-Programm liest in einer Dauerschleife das
' Keyboard-Status-Register &H60 aus, um das Druecken
' und Loslassen von Tasten zu erfassen. Dort werden die
' Tasten nicht im ASCII-Code, sondern im so genannten
' Scancode dargestellt. Die Scancodes der einzelnen
' Tasten sind in der QBasic-Hilfe unter "Inhalt |
' Tastatur-Abfragecodes" aufgelistet
'
' Das Statuswort &H60 enthaelt immer eine Information ueber
' die zuletzt erfolgte Tastenbetaetigung, also entweder
' ueber das zuletzt erfolgte Druecken oder Loslassen einer
' Taste. Beim Druecken wird der Scancode der betreffenden
' Taste angezeigt, beim Loslassen der Scancode+128.
'
' Beispiel: Taste "U" gedrueckt  : &H60 = 22
'           Taste "U" losgelassen: &H60 = 150 (=22+128)
'         
' Der Inhalt von &H60 bleibt so lange erhalten bis eine
' andere Taste gedrueckt oder losgelassen wird. Es kann
' also u.U. stundenlang der Wert von der letzten
' Tastenbetaetigung anstehen bleiben.
'
' Das Programm beendet sich bei Betaetigung der Esc-
' Taste (Scancode = 1)
'
' (c) Thomas Antoni, Nimes, 24.8.2003 - 25.6.2003
'**********************************************************
'
CLS
DEF SEG = 0
oldkey% = 256
DO
POKE &H41A, PEEK(&H41C)
keycode% = INP(&H60)
PRINT keycode%;
LOOP UNTIL keycode% = 1 'Ende mit Esc (Scancode 1)
DEF SEG
END

