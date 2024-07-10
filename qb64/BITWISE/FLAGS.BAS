''
' Using bitwise operators to set flags on a single byte.
' This example uses a player in an imaginary game context.
' 
' TL;DR on bitwise operators and bit flipping:
'
' To RESET all flags use    = 0         e.g. status = 0
' To SET a flag use         OR          e.g. status = status OR flag
' To CLEAR a flag use       AND NOT     e.g. status = status AND NOT(flag)
' To TOGGLE a flag us       XOR         e.g. status = status XOR flag
' To CHECK if flag is set   AND         e.g. if (status AND flag)
'
' Where status is the status byte, and flag val is a power of 2 (binary place)
' from 0 to 7 (8 bits to a byte)
'
' SUB                           DESCRIPTION
' ResetAllFlags status          Resets all flags to 0
' ClearFlag status, flag        Clears a flag - sets bit to 0
' SetFlag status, flag          Sets a flag - sets bit to 1
' ToggleFlag status, flag       Toggles a flag - sets bit to 1 if 0 or 0 if 1
' ShowPlayerFlags status        Shows the player flags in columns
' ShowFlagValues                Shows the flag values in columns
'
' FUNCTION                      DESCRIPTION
' FlagValue$(flag)              Returns a flag numeric value
' FlagStatus$(status, flag)     Returns an "X" or "-"" if flag is set or clear
' FlagsAsBinary$(status)        Returns binary representation of flags
' IsFlagSet(status, flag)       Returns 1 if flag is set or 0 if not set (clear)
' 
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
SCREEN _NEWIMAGE(1200, 320, 256)

CONST ALIVE     = 2^0~%%
CONST WEAPON    = 2^1~%%
CONST ARMOR     = 2^2~%%
CONST AMMO      = 2^3~%%
CONST STANDING  = 2^4~%%
CONST WALKING   = 2^5~%%
CONST RUNNING   = 2^6~%%
CONST ATTACKING = 2^7~%%
ShowFlagValues

' Initialize status
DIM PLAYER_STATUS AS _UNSIGNED _BYTE
PLAYER_STATUS~%% = 0

PRINT "RESET (0)";
ResetAllFlags PLAYER_STATUS~%%
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET ALIVE (OR" + STR$(ALIVE) + ")";
SetFlag PLAYER_STATUS~%%, ALIVE
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET ATTACKING (OR" + STR$(ATTACKING) + ")";
SetFlag PLAYER_STATUS~%%, ATTACKING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "CLEAR ATTACKING (AND NOT" + STR$(ATTACKING) + ")";
ClearFlag PLAYER_STATUS~%%, ATTACKING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "RESET (0)";
ResetAllFlags PLAYER_STATUS~%%
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET ALIVE (OR" + STR$(ALIVE) + ")";
SetFlag PLAYER_STATUS~%%, ALIVE
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET RUNNING (OR" + STR$(RUNNING) + ")";
SetFlag PLAYER_STATUS~%%, RUNNING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET ATTACKING (OR" + STR$(ATTACKING) + ")";
SetFlag PLAYER_STATUS~%%, ATTACKING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "SET WEAPON (OR" + STR$(WEAPON) + ")";
SetFlag PLAYER_STATUS~%%, WEAPON
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "CLEAR ATTACKING (AND NOT" + STR$(ATTACKING) + ")";
ClearFlag PLAYER_STATUS~%%, ATTACKING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "CLEAR RUNNING (AND NOT" + STR$(RUNNING) + ")";
ClearFlag PLAYER_STATUS~%%, RUNNING
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "TOGGLE WEAPON (XOR" + STR$(WEAPON) + ")";
ToggleFlag PLAYER_STATUS~%%, WEAPON
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "TOGGLE ALIVE (XOR" + STR$(ALIVE) + ")";
ToggleFlag PLAYER_STATUS~%%, ALIVE
ShowPlayerFlags PLAYER_STATUS~%%

PRINT "TOGGLE ALIVE (XOR" + STR$(ALIVE) + ")";
ToggleFlag PLAYER_STATUS~%%, ALIVE
ShowPlayerFlags PLAYER_STATUS~%%



SUB ResetAllFlags(status~%%)
    status~%% = 0
END SUB


SUB ClearFlag(status~%%, flag~%%)
    status~%% = status~%% AND NOT(flag~%%)
END SUB


SUB SetFlag(status~%%, flag~%%)
    status~%% = status~%% OR flag~%%
END SUB


SUB ToggleFlag(status~%%, flag~%%)
    status~%% = status~%% XOR flag~%%
END SUB


FUNCTION FlagValue$(flag~%%)
    FlagValue = MID$(STR$(flag~%%), 2)
END FUNCTION


FUNCTION FlagStatus$(status~%%, flag~%%)
    IF IsFlagSet(status~%%, flag~%%) THEN
        FlagStatus$ = "X"
    ELSE
        FlagStatus$ = "-"
    END IF
END FUNCTION


FUNCTION FlagsAsBinary$(status~%%)
    DIM bin AS STRING
    DIM i AS INTEGER
    bin$ = ""
    FOR i% = 0 TO 7
        IF ABS((status~%% AND 2^i%) > 0) THEN
            bin$ = bin$ + "1"
        ELSE
            bin$ = bin$ + "0"
        END IF
    NEXT i%
    FlagsAsBinary$ = bin$
END FUNCTION


FUNCTION IsFlagSet%(status~%%, flag~%%)
    IsFlagSet% = ABS((status~%% AND flag~%%) > 0)
END FUNCTION


SUB ShowPlayerFlags(status~%%)
    PRINT TAB(40);  FlagStatus$(status~%%, ALIVE);
    PRINT TAB(50);  FlagStatus$(status~%%, WEAPON);
    PRINT TAB(60);  FlagStatus$(status~%%, ARMOR);
    PRINT TAB(70);  FlagStatus$(status~%%, AMMO);
    PRINT TAB(80);  FlagStatus$(status~%%, STANDING);
    PRINT TAB(90);  FlagStatus$(status~%%, WALKING);
    PRINT TAB(100); FlagStatus$(status~%%, RUNNING);
    PRINT TAB(110); FlagStatus$(status~%%, ATTACKING);
    PRINT TAB(120); FlagsAsBinary$(status~%%)
END SUB


SUB ShowFlagValues()
    PRINT TAB(32);  "FLAGS:"; 
    PRINT TAB(40);  "ALIVE";
    PRINT TAB(50);  "WEAPON";
    PRINT TAB(60);  "ARMOR";
    PRINT TAB(70);  "AMMO";
    PRINT TAB(80);  "STANDING";
    PRINT TAB(90);  "WALKING";
    PRINT TAB(100); "RUNNING";
    PRINT TAB(110); "ATTACKING"
    PRINT TAB(31);  "VALUES: "; 
    PRINT TAB(40);  FlagValue$(ALIVE);
    PRINT TAB(50);  FlagValue$(WEAPON);
    PRINT TAB(60);  FlagValue$(ARMOR);
    PRINT TAB(70);  FlagValue$(AMMO);
    PRINT TAB(80);  FlagValue$(STANDING);
    PRINT TAB(90);  FlagValue$(WALKING);
    PRINT TAB(100); FlagValue$(RUNNING);
    PRINT TAB(110); FlagValue$(ATTACKING)
    PRINT TAB(120); "STATUS IN BINARY"
END SUB
