'*******************************************************************
' WEEKDAY2.BAS = Calulates the day of week for a given date
' ============   Berechnet den Wochentag zu einem beliebigen Datum
'
' (c) DOUGLAS LUSHER, 1993
'******************************************************************
'
DECLARE FUNCTION DOW% (InDate$)
'
CLS
'
SELECT CASE DOW%(DATE$)
  CASE 0: D$ = "Saturday / Samstag"
  CASE 1: D$ = "Sunday / Sonntag"
  CASE 2: D$ = "Monday / Montag"
  CASE 3: D$ = "Tuesday / Dienstag"
  CASE 4: D$ = "Wednesday / Mittwoch"
  CASE 5: D$ = "Thursday / Donnerstag"
  CASE 6: D$ = "Friday / Freitag"
END SELECT
'
PRINT "Today is "; D$; " , "; DATE$
SLEEP
END

'
'
FUNCTION DOW% (InDate$)
'returns a value representing the day of the week (0 = Saturday, 1 = Sunday,
'2 = Monday, etc) for the date string supplied in the form "MM-DD-YYYY"
'
Month% = (ASC(MID$(InDate$, 1)) - 48) * 10
Month% = Month% + (ASC(MID$(InDate$, 2)) - 48)
Day% = (ASC(MID$(InDate$, 4)) - 48) * 10
Day% = Day% + (ASC(MID$(InDate$, 5)) - 48)
Year% = (ASC(MID$(InDate$, 7)) - 48) * 1000
Year% = Year% + (ASC(MID$(InDate$, 8)) - 48) * 100
Year% = Year% + (ASC(MID$(InDate$, 9)) - 48) * 10
Year% = Year% + (ASC(MID$(InDate$, 10)) - 48)
Year% = Year% + (Month% < 3)
Temp& = (Year% * 365&) + (Year% \ 4) - (Year% \ 100) + (Year% \ 400)
'
SELECT CASE Month%
  CASE 1: Temp& = Temp& + 365
  CASE 2: Temp& = Temp& + 396
  CASE 3: Temp& = Temp& + 59
  CASE 4: Temp& = Temp& + 90
  CASE 5: Temp& = Temp& + 120
  CASE 6: Temp& = Temp& + 151
  CASE 7: Temp& = Temp& + 181
  CASE 8: Temp& = Temp& + 212
  CASE 9: Temp& = Temp& + 243
  CASE 10: Temp& = Temp& + 273
  CASE 11: Temp& = Temp& + 304
  CASE 12: Temp& = Temp& + 334
END SELECT
'
DOW% = (Temp& + Day%) MOD 7
END FUNCTION
