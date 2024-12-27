DEFLNG A-Z
OPTION _EXPLICIT

DIM SHARED AS SINGLE gainLeft, gainRight

DIM k AS LONG, panPos AS SINGLE

DO
    k = _KEYHIT

    SELECT CASE k
        CASE 19200
            IF panPos > -1.0! THEN panPos = panPos - 0.05!

        CASE 19712
            IF panPos < 1.0! THEN panPos = panPos + 0.05!
    END SELECT

    CalculateChannelGain panPos

    LOCATE , 1: PRINT USING "L gain = ##.## | Pan pos = ##.## | R gain = ##.##"; gainLeft; panPos; gainRight;
    _LIMIT 60
LOOP UNTIL k = 27

END

SUB CalculateChannelGain (panPosition AS SINGLE)
    IF panPosition < -1.0! THEN panPosition = -1.0!
    IF panPosition > 1.0! THEN panPosition = 1.0!

    DIM panMapped AS SINGLE: panMapped = (panPosition + 1.0!) * _PI(0.25!)

    gainLeft = COS(panMapped)
    gainRight = SIN(panMapped)
END SUB