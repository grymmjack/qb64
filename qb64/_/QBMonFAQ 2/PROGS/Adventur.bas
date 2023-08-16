'*************************************************************
' Adventur.bas - Beginn eines Textadventures
' ============
' (c) Tobias Doerffel ("todo"; todosoft*gmx.de),  29.4.02
' 
'*************************************************************
SelectWhereToSail:
PRINT "You are on the atlantic. Where do you want to sail to?"
PRINT "1 - America"
PRINT "2 - Europe"
INPUT ""; Choice%
IF Choice% = 1 THEN
  GOTO SailToAmerica
ELSEIF Choice% = 2 THEN
  GOTO SailToEurope
ELSE
PRINT "Not allowed choice!"
GOTO SelectWhereToSail
END IF
SailToAmerica: PRINT "Where to go in America?"
PRINT "1 - NewYork"
PRINT "2 - Los Angeles"
INPUT Choice%
END
SailToEurope: PRINT "Where to go in Europe?"
PRINT "1 - Rome"
PRINT "2 - Paris"
INPUT Choice%
END

