'*********************************************************
' WORDWRAP.BAS - Text mit korrektem Zeilenumbruch anzeigen
' ============
' Es wird eine rekursive Technik verwendet: Die Subroutine
' DT() ruft sich solange selber auf, bis der gesamte Text
' abgearbeitet ist.
'
' Von ant, ergaenzt von Thomas Antoni, 27.5.2003
'*********************************************************
DECLARE SUB DT (TXT$)
CLS
PRINT "Gib einen mehrzeiligen Text ein"
INPUT t$
PRINT
PRINT "Der umgebrochene Text sieht so aus:"
CALL DT(t$)

SUB DT (TXT$)
IF LEN(TXT$) > 80 THEN
  FOR A% = 0 TO 79 'Erste Zeile von hinten nach vorne durchlaufen lassen
    IF MID$(TXT$, 80 - A%, 1) = " " THEN
     'Ist das aktuelle Zeichen ein Leerzeichen?
     '(evtl. andere Trennzeichen abfragen z.B. OR ..."-")
      PRINT LEFT$(TXT$, 80 - A%) 'Ausgabe
      TXT$ = RIGHT$(TXT$, LEN(TXT$) - (80 - A%)) 'Neues TXT$ fuer naechste Zeile
      EXIT FOR
    END IF
  NEXT A%
IF A% = 80 THEN 'Ist die Schleife ohne einen Leerzeile zu finden durchgelaufen?
  PRINT LEFT$(TXT$, 80) 'Einfach ersten 80 Zeichen ausgeben...
  TXT$ = RIGHT$(TXT$, LEN(TXT$) - 80) '...und abschneiden
END IF
END IF
IF LEN(TXT$) < 81 THEN 'Passt TXT$ in eine Zeile?
PRINT TXT$ 'Ausgabe
TXT$ = "" 'TXT$ ganz verarbeitet
END IF
IF TXT$ <> "" THEN CALL DT(TXT$) 'neuer Aufruf (rekursiv)
END SUB

