FOR y = 0 to 10
    _LIMIT 1
    old_s = s
    s = TIMER
    FOR i = 0 to 10
        IF i MOD 2 = 0 THEN PRINT i
    NEXT i
    PRINT y;"=";s,"DIFF=";s-old_s
NEXT y
