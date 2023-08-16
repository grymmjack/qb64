'***********************************************************
' VERSCHLU.BAS = Einfache Ver- und Entschluesselung von Text
' ============
' Jedes Textzeichen wird verschluesselt, indem die Konstante
' "4" zu seinem ASDCII-Code hinzuaddiert wird.
'
' (c) Thomas Antoni, 11.12.02 - 21.5.04
'***********************************************************
INPUT "gib einen Text ein: ", t$
'
'--- Text verschluesseln ---
FOR i% = 1 TO LEN(t$)
  tv$ = tv$ + CHR$(ASC(MID$(t$, i%, 1)) + 4)
    'verschluesselter Text mit um 4 verschobenen ASCII-Codes
NEXT i%
'
PRINT tv$ 'verschluesselten Text anzeigen
'
'--- Text wieder entschluesseln ---
FOR i% = 1 TO LEN(t$)
  te$ = te$ + CHR$(ASC(MID$(tv$, i%, 1)) - 4)
    'entschluesselter Text mit um 4 reduzierten ASCII-Codes
NEXT i%
'
PRINT te$  'entschluesselten text anzeigen
SLEEP
END

