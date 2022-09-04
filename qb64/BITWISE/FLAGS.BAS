''
' Using bitwise operators to set flags on a single byte
' 
' To RESET all flags use  = 0
' To SET a flag use       OR
' To CLEAR a flag use     XOR
' To CHECK if flag is set AND
'
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 32)

CONST ALIVE     = 2^0
CONST WEAPON    = 2^1
CONST ARMOR     = 2^2
CONST AMMO      = 2^3
CONST STANDING  = 2^4
CONST WALKING   = 2^5
CONST RUNNING   = 2^6
CONST ATTACKING = 2^7
ShowFlagValues

' Initialize status
PLAYER_STATUS = 0

PRINT "RESET (0)";
ResetFlags PLAYER_STATUS
ShowPlayerFlags PLAYER_STATUS

PRINT "SET ALIVE (OR" + STR$(ALIVE) + ")";
SetFlag PLAYER_STATUS, ALIVE
ShowPlayerFlags PLAYER_STATUS

PRINT "SET ATTACKING (OR" + STR$(ATTACKING) + ")";
SetFlag PLAYER_STATUS, ATTACKING
ShowPlayerFlags PLAYER_STATUS

PRINT "CLEAR ATTACKING (XOR" + STR$(ATTACKING) + ")";
ClearFlag PLAYER_STATUS, ATTACKING
ShowPlayerFlags PLAYER_STATUS

PRINT "RESET (0)";
ResetFlags PLAYER_STATUS
ShowPlayerFlags PLAYER_STATUS

SUB ResetFlags(status)
    status = 0
END SUB

SUB ClearFlag(status, flag)
    status = status XOR flag
END SUB

SUB SetFlag(status, flag)
    status = status OR flag
END SUB

FUNCTION FlagValue$(flag)
    FlagValue = MID$(STR$(flag), 2)
END FUNCTION

FUNCTION FlagStatus$(status, flag)
    IF IsFlagSet(status, flag) THEN
        FlagStatus$ = "X"
    ELSE
        FlagStatus$ = "-"
    END IF
END FUNCTION

FUNCTION FlagsAsBinary$(status)
    binary$ = ""
    FOR i = 0 TO 7
        IF ABS((status AND 2^i) > 0) THEN
            binary$ = binary$ + "1"
        ELSE
            binary$ = binary$ + "0"
        END IF
    NEXT i
    FlagsAsBinary$ = binary$
END FUNCTION

FUNCTION IsFlagSet(status, flag)
    IsFlagSet = ABS((status AND flag) > 0)
END FUNCTION

SUB ShowPlayerFlags(status)
    PRINT TAB(30); FlagStatus$(status, ALIVE);
    PRINT TAB(40); FlagStatus$(status, WEAPON);
    PRINT TAB(50); FlagStatus$(status, ARMOR);
    PRINT TAB(60); FlagStatus$(status, AMMO);
    PRINT TAB(70); FlagStatus$(status, STANDING);
    PRINT TAB(80); FlagStatus$(status, WALKING);
    PRINT TAB(90); FlagStatus$(status, RUNNING);
    PRINT TAB(100); FlagStatus$(status, ATTACKING);
    PRINT TAB(110); FlagsAsBinary$(status)
END SUB

SUB ShowFlagValues()
    PRINT TAB(22); "FLAGS:"; 
    PRINT TAB(30); "ALIVE";
    PRINT TAB(40); "WEAPON";
    PRINT TAB(50); "ARMOR";
    PRINT TAB(60); "AMMO";
    PRINT TAB(70); "STANDING";
    PRINT TAB(80); "WALKING";
    PRINT TAB(90); "RUNNING";
    PRINT TAB(100); "ATTACKING"
    PRINT TAB(21); "VALUES: "; 
    PRINT TAB(30); FlagValue$(ALIVE);
    PRINT TAB(40); FlagValue$(WEAPON);
    PRINT TAB(50); FlagValue$(ARMOR);
    PRINT TAB(60); FlagValue$(AMMO);
    PRINT TAB(70); FlagValue$(STANDING);
    PRINT TAB(80); FlagValue$(WALKING);
    PRINT TAB(90); FlagValue$(RUNNING);
    PRINT TAB(100); FlagValue$(ATTACKING)
    PRINT TAB(110); "STATUS IN BINARY"
END SUB

