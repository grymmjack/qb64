'*********************
'* Loads QB64 source,i ncluding $include: files
'* accepts forms:
'*      $include:<any number of spaces>'whateverfile' -- if $ is the first non-blank character on a line, this is handled like an implied apostrophe before
'* also REM      <any number of spaces>$include:'whateverfile'
'* also '$include:<any number of spaces>'whateverfile'
'* provided the $include: files are present, this loads them into a string array provided the file exists
'*********************
 
FUNCTION OpenInclude& (OIFile$, OICodeText() AS STRING, OILinesIn&, Warning$(), WarningCount&)
    IF _FILEEXISTS(OIFile$) THEN
        OIFileIO& = FREEFILE
        IF OIFileIO& > 0 THEN
            OPEN OIFile$ FOR INPUT AS #OIFileIO&
            WHILE NOT EOF(OIFileIO&)
                IF OILinesIn& > UBOUND(OICodeText) THEN
                    units& = 10 - UBOUND(OICodeText) MOD 10
                    NewUbound& = (UBOUND(OICodeText) + units&)
                    REDIM _PRESERVE OICodeText(LBOUND(OICodeText) TO NewUbound&)
                END IF
                LINE INPUT #OIFileIO&, OICodeText(OILinesIn&)
                fx$ = IncludeFile$(OICodeText(OILinesIn&))
                IF fx$ > "" THEN
                    OICodeText(OILinesIn&) = "'* Merged " + fx$ + " *"
                    r& = OpenInclude(fx$, OICodeText(), OILinesIn&, Warning$(), WarningCount&)
                END IF
                OILinesIn& = OILinesIn& + 1
            WEND
            CLOSE #OIFileIO&
            OpenInclude& = 1
            EXIT FUNCTION
        END IF
    ELSE
        Warning$(WarningCount&) = OIFile$
        WarningCount& = WarningCount& + 1
        '**********************
        '* maybe a dialog box for path or store in list of warnings
        '*******************
    END IF
    '* if this returns a 0 value, OpenInclude&() was not successful
    OpenInclude& = 0
END SUB
 
FUNCTION IncludeFile$ (IncludeFileTextX$)
    IncludeFile$ = ""
    '* do not alter the original code text
    TextX$ = LCASE$(LTRIM$(RTRIM$(IncludeFileTextX$)))
    q& = 1
    WHILE q& <= 3
        IF MID$(TextX$, q&, LEN("$include:")) = "$include:" THEN
            TextX$ = LTRIM$(MID$(TextX$, q& + LEN("$include:")))
            insc1& = INSTR(TextX$, "'")
            IF insc1& THEN
                insc2& = INSTR(insc1& + 1, TextX$, "'")
                IF insc2& > insc1& THEN
                    IncludeFile$ = MID$(TextX$, insc1& + 1, insc2& - (insc1& + 1))
                END IF
            END IF
            EXIT FUNCTION
        END IF
        SELECT CASE LCASE$(LEFT$(TextX$, q&))
            CASE "$"
                EXIT WHILE
            CASE "'$"
                EXIT WHILE
            CASE "rem"
                SELECT CASE MID$(TextX$, q& + 1, 1)
                    CASE " "
                        TextX$ = LTRIM$(MID$(TextX$, q& + 2))
                    CASE "$"
                        TextX$ = MID$(TextX$, q& + 1)
                    CASE ELSE
                        EXIT FUNCTION
                END SELECT
                q& = 1
        END SELECT
        q& = q& + 1
    WEND
END FUNCTION
 
FUNCTION RemoveUnreferencedCode (CodeIn() AS STRING, stripRemarks&, RemoveWhiteSpaceLines&)
    RUCCleanedLines& = LBOUND(codeIn)
    FOR RUCq& = LBOUND(codein) TO UBOUND(codein)
        t$ = LCASE$(LTRIM$(CodeIn(RUCq&)))
        T& = LEN(t$)
        DO
            IF T& > 0 THEN
                IF MID$(t$, T&, 1) = CHR$(34) THEN
                    '* skip anything inside quotes -- might miss some
                    '* comments, but better safe than sorry
                    EXIT DO
                END IF
                IF MID$(t$, T&, 1) = "'" THEN
                    t$ = LEFT$(t$, T& - 1)
                    EXIT DO
                ELSE
                    T& = T& - 1
                END IF
            ELSE
                EXIT DO
            END IF
        LOOP
        SELECT CASE LEFT$(t$, 1)
            CASE "'", ""
                _CONTINUE
            CASE ELSE
                IF IsWord&(t$, "rem", 1) THEN
                    SELECT CASE MID$(t$, LEN("rem") + 1, 1)
                        CASE " ", "", CHR$(13)
                        CASE ELSE
                    END SELECT
                    _CONTINUE
                ELSEIF IsWord&(t$, "sub", 1) THEN
                    PRINT RUCCleanedLines&; t$
                ELSEIF IsWord(t$, "function", 1) THEN
                    PRINT RUCCleanedLines&; t$
                END IF
        END SELECT
        CodeIn(RUCCleanedLines&) = CodeIn(RUCq&)
        RUCCleanedLines& = RUCCleanedLines& + 1
    NEXT
    '* clear remaining lines of code that have been processed
    WHILE RUCCleanedLines& <= UBOUND(codein)
        CodeIn(RUCCleanedLines&) = ""
        RUCCleanedLines& = RUCCleanedLines& + 1
    WEND
END FUNCTION
 
FUNCTION IsWord& (t$, word$, position&)
    IF position& > 1 THEN
        SELECT CASE MID$(t$, position& - 1, 1)
            CASE "0" TO "9", "A" TO "Z", "a" TO "z", "_", "%", "$", "&", "#", "!", "~"
                IsWord& = 0
                EXIT FUNCTION
            CASE ELSE
                SELECT CASE MID$(t$, position& + LEN(word$), 1)
                    CASE "0" TO "9", "A" TO "Z", "a" TO "z", "_", "%", "$", "&", "#", "!", "~"
                        IsWord& = 0
                        EXIT FUNCTION
                    CASE ELSE
                END SELECT
        END SELECT
    END IF
    SELECT CASE MID$(t$, position& + LEN(word$), 1)
        CASE "0" TO "9", "A" TO "Z", "a" TO "z", "_", "%", "$", "&", "#", "!", "~"
            IsWord& = 0
            EXIT FUNCTION
        CASE ELSE
    END SELECT
    IF MID$(t$, position&, 1) = word$ THEN
        IsWord& = -1
    END IF
END FUNCTION