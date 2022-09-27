'================
'SDL_GetTicks.BAS
'================
'Coded by Dav for QB64, 3/31/2011

'This demo calls a built-in SDL function to show how long a QB64 program
'has been running.  When a QB64 program is started, the SDL library is then
'initialized.  SDL tracks how long since being initialized and stores that
'value in milliseconds which can be retrieved by calling SDL_GetTicks.

'The example below converts SDL_GetTicks into hour, minutes, seconds.


DECLARE LIBRARY
    FUNCTION SDL_GetTicks ()
END DECLARE


DO
    LOCATE 12, 12
    PRINT "This program has been running for: ";

    Milly = SDL_GetTicks

    Hours$ = LTRIM$(STR$(Milly \ 3600000))
    IF LEN(Hours$) = 1 THEN Hours$ = "0" + Hours$

    Minutes$ = LTRIM$(STR$((Milly MOD 3600000) \ 60000))
    IF LEN(Minutes$) = 1 THEN Minutes$ = "0" + Minutes$

    Seconds$ = LTRIM$(STR$(((Milly MOD 3600000) MOD 60000) \ 1000))
    IF LEN(Seconds$) = 1 THEN Seconds$ = "0" + Seconds$

    RunTime$ = Hours$ + ":" + Minutes$ + ":" + Seconds$

    PRINT RunTime$

LOOP UNTIL INKEY$ <> ""

SYSTEM
