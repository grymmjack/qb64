'**********************************************
' STACKFLO.BAS - Erzeugt einen Stack-Ueberlauf
' ============
' Dieses QBasic-Programm demonstriert, wie es
' zu der gefuerchten Fehlermeldung "Stapelplatz
' reicht nicht" kommt. Auf dem Stapelspeicher
' (engl. "Stack") wird bei einem SUB-Aufrauf
' die Ruecksprungadresse abgelegt. Bei einem
' RETURN wird sie von dort gelesen und wieder
' geloescht. Bei Schachtelung von SUBS, also
' wenn SUBs wieder sich selbst oder andere
' SUBS aufrufen, wird die neue Adresse oben
' auf den Stack draufgelegt (wie Holzstuecke
' auf einen Holzstapel). Wenn es durch einen
' Programmierfehler mehr SUB/FUNCTION-Aufrufe
' als RETURNs gibt, laeuft der Stack "gegen
' die Decke" und sprengt den zugelassenen
' Speicherbereich.
'
' Genau diesen Flall simuliert das vorliegende
' Programm.
'
' (c) Thomas Antoni, 24.8.02 - 26.2.2004
'**********************************************
DECLARE SUB testsub ()
CALL testsub
END

'
SUB testsub
DO
  CALL testsub
  'Die SUB ruft sich selbst endlos wieder auf
  'und schreibt die Ruecksprungadresse auf den
  'Stackspeicher ohne diesen jemals durch ein
  'RETRURN wieder zu leeren
LOOP
END SUB

