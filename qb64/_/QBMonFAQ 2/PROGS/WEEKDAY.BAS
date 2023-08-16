'**************************************************************************
' WEEKDAY.BAS = Ermittlung des Wochentags So...Fr zu einem bestimmten Datum
' ===========
' Demo Program for the Week of Day FUNCTION WeekDay%
'
' Demoprogramm fuer die FUNCTION WeeDay%, die den Wochentag
' zu einem vorgegebenen Datum ermittelt
'
' von Thomas Antoni, 27.8.02 - 30.7.05
'***************************************************************************
'
DECLARE FUNCTION WeekDay% (Mon%, Day%, Year%)
'
CLS
INPUT "Gib den Tag ein       (1-31): "; Day%
INPUT "Gib den Monat ein     (1-12): "; Mon%
INPUT "Gib das Jahr ein (1582-2450): "; Year%
SELECT CASE WeekDay%(Mon%, Day%, Year%)
  CASE 0: D$ = "Sonntag"
  CASE 1: D$ = "Montag"
  CASE 2: D$ = "Dienstag"
  CASE 3: D$ = "Mittwoch"
  CASE 4: D$ = "Donnaerstag"
  CASE 5: D$ = "Freitag"
  CASE 6: D$ = "Samstag"
END SELECT
PRINT
PRINT "Der "; Day%; "."; Mon%; "."; Year%; " ist ein "; D$

'
FUNCTION WeekDay% (Mon%, Day%, Year%)
'****************************************************************************
' WeekDay% = Function for Evaluating the Day of the Week
'            Funktion zum Ermitteln des Wochtages zu einem vorgegebenen Datum
' ===========================================================================
'
' English Description
' ~~~~~~~~~~~~~~~~~~~~~~
' Function WeekDay% to calculate the day of the week when given the date in
' integer form: Mon%, Day%, Year% (year: 1582 to 2450)
' Note: Returns (0=Sunday...6=Saturday)  or -1 if an error occurs"
'
' Deutsche Beschreibung
' ~~~~~~~~~~~~~~~~~~~~~~
' An die Funktion wird das Jahr (1582...2450), der Monat und der Tag jeweils
' als Integer-Gr"·en Åbergeben. Die Funktion liefert 0...6 fÅr Sonntag bis
' Samstag zurÅck bzw. -1 wenn ein Fehler auftritt.
' Die Auswertung des RÅckmeldewerts im Hauptprogramm erfolgt normalerweise in
' einem SELECT CASE Block.
'
' Credits  : Dank an Garry Spencer,   gspencer*stim.tec.tn.us   fuer den aus
' ~~~~~~~~~  Garry's Pogramm WEEKDAY.BAS entnommene Function WEEKDAY "to
'            calculate the day of the week when given the date in integer
'            form: Mon%, Day%, Year% (year: 1582 to 2450)
'            Note: Returns (0=Sunday...6=Saturday)  or -1 if an error occurs"
'
' Beispiel 1 : Ausdrucken des Wochentages zum 10.11.99 (war ein Donnerstag):
' ~~~~~~~~~~     CASE SELECT Weekday%(11, 10, 1999)
'                  CASE 0: PRINT "Sonntag"
'                  ...
'                  CASE 6: PRINT "Samstag"
'                END SELECT
'
' Beispiel 2: Den heutigen Wochentag ermitteln:
' ~~~~~~~~~~~    d$ = DATE$
'                tag% = VAL(MID$(d$, 4, 2))
'                monat% = VAL(LEFT$(d$, 2))
'                jahr% = VAL(RIGHT$(d$, 4))
'                SELECT CASE WeekDay%(monat%, tag%, jahr%)
'                  CASE 0: PRINT "Sonntag"
'                  ...
'
' Credits : Thanks to Garry Spencer (gspencer*stim.tec.tn.us) for giving me
' ~~~~~~~~~ the idea for this subroutine. The basic functions have been
'           derived from Garry's Pogramm WEEKDAY.BAS.
'
' Thomas Antoni, 11.11.99- 27.8.02
'      thomas*antonis.de  - www.antonis.de -- www.qbasic.de
'****************************************************************************
DTmp% = 4: Days% = 0: Ofs% = 0: Leap% = 0: WeekDay% = -1
IF Year% < 1582 OR Year% > 2450 OR Mon% < 1 OR Mon% > 12 OR Day% < 1 THEN EXIT FUNCTION
FOR YTmp% = 1582 TO Year%
  DTmp% = (DTmp% + 1 + Leap%) MOD 7
    SELECT CASE 0
      CASE (YTmp% MOD 400): Leap% = 1
      CASE (YTmp% MOD 100): Leap% = 0
      CASE (YTmp% MOD 4): Leap% = 1
      CASE ELSE: Leap% = 0
    END SELECT
NEXT YTmp%
FOR MTmp% = 1 TO Mon%: Ofs% = Ofs% + Days%
  SELECT CASE MTmp%
    CASE 1: Days% = 31
    CASE 2: Days% = 28 + Leap%:
    CASE 3: Days% = 31
    CASE 4: Days% = 30
    CASE 5: Days% = 31
    CASE 6: Days% = 30
    CASE 7: Days% = 31
    CASE 8: Days% = 31
    CASE 9: Days% = 30
    CASE 10: Days% = 31
    CASE 11: Days% = 30
    CASE 12: Days% = 31
  END SELECT
NEXT MTmp%
IF Day% <= Days% THEN WeekDay% = (DTmp% + Ofs% + Day% - 1) MOD 7
END FUNCTION

