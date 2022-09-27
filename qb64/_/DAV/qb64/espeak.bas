'========================================================================
'ESPEAK.BAS - simple Text To Speech (TTS) method using the eSpeak program
'========================================================================

'Coded by Dav for QB64

'This is a quick & easy way to add Text To Speech to any QB64 program
'using the FREE eSpeak program to secretly do all the speech synthesis.

'The eSpeak package can be downloaded from sourceforge, just google it.
'Make sure to get the package that includes the command_line tool.
'That's the program we'll be using with this QB64 code. eSpeak.exe is a
'stand-alone, portable EXE that does a good job with 'Text to Speech".
'It will run in the background and do all the hard work for you.

'All you need is espeak.exe and the espeak-data folder for it to work.
'Place those in your QB64 folder if you wish and call espeak from there.

'This program uses a WinExec API to call/run espeak.exe in hidden mode
'so that it's not noticed by the user.  They will hear it, but not see it.
'Focus will remain on your QB64 program.
'========================================================================

DECLARE LIBRARY
    FUNCTION WinExec (lpCmdLine AS STRING, BYVAL nCmdShow AS LONG)
END DECLARE

DECLARE SUB eSpeak (lines$)

DIM SHARED eSpeak_exe$
eSpeak_exe$ = "espeak\espeak.exe -v en "  '<<<==== change path to yours


A$ = "Hello. Enter anything, and I will say it.  Enter goodbye to quit."

PRINT A$: eSpeak A$

DO
    INPUT ">", A$
    IF A$ <> "" THEN eSpeak A$
LOOP UNTIL UCASE$(A$) = "GOODBYE"

PRINT "GOODBYE!"

END

SUB eSpeak (lines$)
Filename$ = eSpeak_exe$ + CHR$(34) + lines$ + CHR$(34)
x = WinExec(Filename$ + CHR$(0), 0)
END SUB
