'****************************************************************************
' TAGDIFF.BAS = Ermittelt die Zeitdifferenz zwischen 2 Zeitpunkten in Tagen
' ============
' Dieses QBasic-Programm ermittelt die Zeitdifferenz zwischen zwei
' Zeitpunkten. Die Zeitpunkte werden jeweils durch ihr Datum im Format
' "MM.TT.JJJJ" und ihre Uhrzeit im Format "hh:mm:ss" eingegeben.
' Die FUNCTION ZeitDiff# ermittelt die Zeitdifferenz in Sekunden zwischen
' dem frueheren Zeitpunkt 1 und dem spaeteren Zeitpunkt 2.
' Die Zeitdifferenz wird in Sekunden sowie in Tagen/Stunden/Minuten/Sekunden
' angezeigt.
' Die Funktion ZeitDiff# berechnet die Zeitdifferenz immer korrekt, selbst
' wenn dazwischen Schaltjahre oder Jahrhunderte liegen.
'
' Achtung: Es gibt keine Plausibilitaetskontrollen fuer die Eingaben. Daher
'          beendet sich das Programm bei Fehleingaben!
'
' (c) stef, mit Erweiterungen von Thomas Antoni, 18.4.2005 - 8.12.2005
'****************************************************************************
'
DECLARE FUNCTION ZeitDiff# (Datum1 AS STRING, Zeit1 AS STRING, Datum2 AS STRING, Zeit2 AS STRING)
DO: WIDTH 80, 25
CLS
PRINT "            Zeitdifferenz-Rechner"
PRINT "------------------------------------------------"
PRINT ">>> Bitte alle Eingaben formatgetreu machen. <<<"
PRINT ">>> Gegebenenfalls eine Null voranstellen!   <<<"
PRINT
PRINT "Gib den ersten (frueheren) Zeitpunkt ein"
INPUT ".... Datum   MM.TT.JJJJ : ", Datum1$
INPUT ".... Uhrzeit hh:mm:ss   : ", Zeit1$
PRINT
PRINT "Gib den zweiten (spaeteren) Zeitpunkt ein"
INPUT ".... Datum   MM.TT.JJJJ : ", Datum2$
INPUT ".... Uhrzeit hh:mm:ss   : ", Zeit2$
PRINT
SecDiff# = ZeitDiff#(Datum1$, Zeit1$, Datum2$, Zeit2$)
'
Tage# = INT(SecDiff# / 86400)    '1 Tag hat 86400 Sekunden)
Stunden# = INT((SecDiff# - Tage# * 86400) / 3600)
Minuten# = INT((SecDiff# - Tage# * 86400 - Stunden# * 3600) / 60)
Sekunden# = SecDiff# - Tage# * 86400 - Stunden# * 3600 - Minuten# * 60
'
PRINT "Die Zeitdifferenz betraegt ";
PRINT SecDiff#; " Sekunden"
PRINT
PRINT "Das sind ..."
PRINT Tage#, "Tage"
PRINT Stunden#, "Stunden"
PRINT Minuten#, "Minuten"
PRINT Sekunden#, "Sekunden"
PRINT
PRINT "Neue Berechnung....[Beliebige Taste]  Beenden....[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
LOOP
'
FUNCTION ZeitDiff# (Datum1 AS STRING, Zeit1 AS STRING, Datum2 AS STRING, Zeit2 AS STRING)
'Errechnet die Zeitdifferenz zwischen zwei Zeitpunkten in Sekunden
'Parameter: Datum1 -> TT.MM.JJJJ
'           Zeit1  -> hh:mm:ss
'           Datum2 -> TT.MM.JJJJ
'           Zeit2  -> hh:mm:ss
   DIM Sek1 AS LONG              'Sekunden seit Tagesbeginn
   DIM Sek2 AS LONG
   '
   DIM Tag1 AS INTEGER           'ganze Tage seit Monatsbeginn
   DIM Tag2 AS INTEGER
   '
   DIM Monat(1 TO 12) AS INTEGER 'Tage bis zum Monatsbeginn im Jahr
   DIM Monat1 AS INTEGER         'Monatsnummer
   DIM Monat2 AS INTEGER
   '
   DIM Jahr1 AS INTEGER          'Jahreszahl
   DIM Jahr2 AS INTEGER
   '
   DIM Schalttag1 AS INTEGER     'Anzahl Schalttage seit dem Jahre 1
   DIM Schalttag2 AS INTEGER
   '
   '----- Zaehlen der Sekunden seit Tagesbeginn ------
   Sek1 = VAL(MID$(Zeit1, 7))                'Sekunden
   Sek2 = VAL(MID$(Zeit2, 7))
   '
   Sek1 = Sek1 + VAL(MID$(Zeit1, 4, 2)) * 60 'Minuten
   Sek2 = Sek2 + VAL(MID$(Zeit2, 4, 2)) * 60

   Sek1 = Sek1 + VAL(LEFT$(Zeit1, 2)) * 3600 'Stunden
   Sek2 = Sek2 + VAL(LEFT$(Zeit2, 2)) * 3600
   '
   '----- Speichern der Tage vor einem Monat ---------
   Monat(1) = 0:       Monat(7) = 181
   Monat(2) = 31:      Monat(8) = 212
   Monat(3) = 59:      Monat(9) = 243
   Monat(4) = 90:      Monat(10) = 273
   Monat(5) = 120:     Monat(11) = 304
   Monat(6) = 151:     Monat(12) = 334
   '
   '----- Berechnen der ganzen Tage seit Jahresbeginn -----
   Tag1 = VAL(LEFT$(Datum1, 2)) - 1
   Monat1 = VAL(MID$(Datum1, 4, 2))
   Tag1 = Tag1 + Monat(Monat1)
   '
   Tag2 = VAL(LEFT$(Datum2, 2)) - 1
   Monat2 = VAL(MID$(Datum2, 4, 2))
   Tag2 = Tag2 + Monat(Monat2)
   '
   '----- Jahreszahl ermitteln -----
   Jahr1 = VAL(MID$(Datum1, 7))
   Jahr2 = VAL(MID$(Datum2, 7))
   '
   '----- Ermitteln ob im aktuelle Jahr ein Schalttag war ---
   IF Monat1 > 2 THEN
      IF (Jahr1 MOD 4 = 0 AND Jahr1 MOD 100 <> 0) OR Jahr1 MOD 400 = 0 THEN
         Schalttag1 = 1
      END IF
   END IF
   IF Monat2 > 2 THEN
      IF (Jahr2 MOD 4 = 0 AND Jahr2 MOD 100 <> 0) OR Jahr2 MOD 400 = 0 THEN
         Schalttag2 = 1
      END IF
   END IF
   '
   '----- Erechnen der Schalttage seit dem Jahre 1 -----
   Jahr1 = Jahr1 - 1
   Jahr2 = Jahr2 - 1
   Schalttag1 = Schalttag1 + Jahr1 \ 4 - Jahr1 \ 100 + Jahr1 \ 400
   Schalttag2 = Schalttag2 + Jahr2 \ 4 - Jahr2 \ 100 + Jahr2 \ 400
   '
   '----- Berechnen der Zeitdifferenz -----
   ZeitDiff = Sek2 - Sek1 + (Tag2 - Tag1 + Schalttag2 - Schalttag1) * 86400 + (Jahr2 - Jahr1) * 31536000#
END FUNCTION

