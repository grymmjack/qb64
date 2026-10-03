''
' MID2SND - convert a MIDI file (.mid) or QB64 PLAY music (MML) into a PC
' speaker IFS sound bank
'
' The tune becomes one sound with up to 4 voices, saved the way PCSEDIT
' saves them: the ARP mix (voices taking turns, which DN1PLAY and the games
' can play) under the sound's name, plus NAME~1 ... NAME~4 entries so
' PCSEDIT gets the separate voices back (and plays them together in PWM).
'
'   MID2SND song.mid [out.snd] [options]
'   MID2SND tune.mml [out.snd] [options]      PLAY strings in a text file
'   MID2SND -p "T160 O3 L8 CDEFG" out.snd     a PLAY string right here
'
' A .mml (or .txt / .bas) file holds PLAY strings: PLAY "..." lines copied
' from a program (each string after a comma is another voice), lines
' starting V1: to V4: for one voice, or bare MML for voice 1.
'
'   -v N     voices, 1-4 (default 4; 1 = only the top note, for a game)
'   -t N     transpose N semitones (-t -12 = an octave down)
'   -c LIST  MIDI channels to use, 1-16, like -c 1,2,4 (default: all but
'            the drums on channel 10)
'   -n NAME  sound name, up to 10 letters (default: from the file name)
'   -a       add the sound to out.snd instead of replacing the file
'   -s SECS  stop after SECS seconds
'   -g       no rest between repeated notes of the same pitch
'   -p MML   convert this PLAY string (in quotes) instead of a file
'   -r N     ARP speed: each chord note lasts N steps in the mix (default 3)
'   -i       just list the file's channels, notes and length
'
' The IFS format holds 64 KB. Every step is 2 bytes per voice plus 2 for the
' mix, so 4 voices fit about 46 seconds; 1 voice about 3 minutes.
'
$CONSOLE:ONLY
OPTION _EXPLICIT

'$INCLUDE:'PCSMIDI.BI'

CONST MAX_STEPS = 32000
DIM SHARED arpRate AS LONG

DIM inFile AS STRING, outFile AS STRING, a AS STRING, i AS LONG, nv AS LONG, tr AS LONG
DIM chans AS LONG, nm AS STRING, appendIt AS INTEGER, secs AS DOUBLE, gap AS LONG, infoOnly AS INTEGER
DIM maxSteps AS LONG, k AS LONG, p AS LONG, c AS LONG, t AS STRING, mml AS STRING, ok AS INTEGER, ext AS STRING

CHDIR _STARTDIR$ ' file names are relative to where it was run from, not where it lives
nv = 4: gap = 1: arpRate = 3
i = 1
DO WHILE i <= _COMMANDCOUNT
    a = COMMAND$(i)
    SELECT CASE LCASE$(a)
        CASE "-v": i = i + 1: nv = VAL(COMMAND$(i))
        CASE "-t": i = i + 1: tr = VAL(COMMAND$(i))
        CASE "-n": i = i + 1: nm = COMMAND$(i)
        CASE "-s": i = i + 1: secs = VAL(COMMAND$(i))
        CASE "-a": appendIt = -1
        CASE "-g": gap = 0
        CASE "-i": infoOnly = -1
        CASE "-r": i = i + 1: arpRate = VAL(COMMAND$(i))
        CASE "-p": i = i + 1: mml = COMMAND$(i)
        CASE "-c"
            i = i + 1: t = COMMAND$(i) + ","
            DO WHILE LEN(t)
                p = INSTR(t, ",")
                c = VAL(LEFT$(t, p - 1))
                IF c >= 1 AND c <= 16 THEN chans = chans OR _SHL(1, c - 1)
                t = MID$(t, p + 1)
            LOOP
        CASE "-h", "--help", "/?": usage
        CASE ELSE
            IF LEFT$(a, 1) = "-" THEN PRINT "Unknown option "; a: usage
            IF inFile = "" THEN inFile = a ELSE outFile = a
    END SELECT
    i = i + 1
LOOP
IF inFile = "" AND mml = "" THEN usage
IF nv < 1 OR nv > 4 THEN PRINT "-v takes 1 to 4": SYSTEM 1

IF LEN(mml) THEN
    ' -p: the out file is the only file name given
    IF outFile = "" THEN outFile = inFile
    IF outFile = "" THEN outFile = "play.snd"
    inFile = outFile
    IF nm = "" THEN nm = "PLAY"
    ok = PCSMIDI_LoadMML(mml)
ELSE
    ext = LCASE$(MID$(inFile, _INSTRREV(inFile, ".") + 1))
    IF ext = "mml" OR ext = "txt" OR ext = "bas" THEN ok = PCSMIDI_LoadMMLFile(inFile) ELSE ok = PCSMIDI_Load(inFile)
END IF
IF NOT ok THEN PRINT pcsmidiError: SYSTEM 1

IF infoOnly THEN
    show_info
    SYSTEM
END IF

IF outFile = "" THEN outFile = strip_ext(inFile) + ".snd"
IF nm = "" THEN nm = strip_ext(file_part(inFile))
nm = clean_name(nm)

maxSteps = MAX_STEPS
IF secs > 0 THEN maxSteps = CLNG(secs * PCSMIDI_RATE)
PCSMIDI_Render nv, tr, chans, gap, maxSteps
IF pcsmidiUsed = 0 THEN PRINT "Nothing to convert - no notes on those channels (try -i)": SYSTEM 1

IF LEN(mml) THEN PRINT "PLAY string"; ELSE PRINT file_part(inFile);
PRINT " -> "; file_part(outFile); " as "; nm
PRINT "  "; LTRIM$(STR$(pcsmidiPlaced)); " notes,"; pcsmidiUsed; "voice(s),"; pcsmidiSteps; "steps ("; fmt1(pcsmidiSteps / PCSMIDI_RATE); " s)"
IF pcsmidiDropped THEN PRINT "  "; LTRIM$(STR$(pcsmidiDropped)); " notes left out: more than"; nv; "at once"
IF pcsmidiCut THEN PRINT "  "; LTRIM$(STR$(pcsmidiCut)); " notes past the end were cut"

IF NOT write_bank(outFile, nm, appendIt) THEN SYSTEM 1
SYSTEM


SUB usage
    PRINT "MID2SND - convert a MIDI file or QB64 PLAY music into a PC speaker IFS sound bank"
    PRINT
    PRINT "  MID2SND song.mid [out.snd] [options]"
    PRINT "  MID2SND tune.mml [out.snd] [options]     PLAY strings in a text file"
    PRINT "  MID2SND -p ";CHR$(34);"T160 O3 L8 CDEFG";CHR$(34);" out.snd    a PLAY string"
    PRINT
    PRINT "  -v N     voices, 1-4 (default 4; 1 = only the top note, for a game)"
    PRINT "  -t N     transpose N semitones"
    PRINT "  -c LIST  MIDI channels to use, like -c 1,2,4 (default: all but drums, 10)"
    PRINT "  -n NAME  sound name, up to 10 letters (default: from the file name)"
    PRINT "  -a       add the sound to out.snd instead of replacing it"
    PRINT "  -s SECS  stop after SECS seconds"
    PRINT "  -g       no rest between repeated notes of the same pitch"
    PRINT "  -r N     ARP speed: each chord note lasts N steps in the mix (default 3)"
    PRINT "  -p MML   convert this PLAY string instead of a file"
    PRINT "  -i       list the file's channels, notes and length"
    SYSTEM 1
END SUB


SUB show_info
    DIM c AS LONG, i AS LONG, n AS LONG, lo AS LONG, hi AS LONG, last AS DOUBLE
    PRINT file_part(COMMAND$(1))
    IF LEN(pcsmidiTitle) THEN PRINT "  title: "; pcsmidiTitle
    PRINT "  "; LTRIM$(STR$(pcsmidiTracks)); " track(s) / PLAY voice(s), "; LTRIM$(STR$(pcsmidiCount)); " notes"
    FOR i = 0 TO pcsmidiCount - 1
        IF pcsmidiNote(i).t1 > last THEN last = pcsmidiNote(i).t1
    NEXT
    PRINT "  length "; fmt1(last); " s"
    FOR c = 0 TO 15
        n = 0: lo = 999: hi = -1
        FOR i = 0 TO pcsmidiCount - 1
            IF pcsmidiNote(i).chan = c THEN
                n = n + 1
                IF pcsmidiNote(i).pitch < lo THEN lo = pcsmidiNote(i).pitch
                IF pcsmidiNote(i).pitch > hi THEN hi = pcsmidiNote(i).pitch
            END IF
        NEXT
        IF n THEN
            PRINT "  channel"; c + 1; ":"; n; "notes, "; note_name(lo); " - "; note_name(hi);
            IF c = 9 THEN PRINT "  (drums - left out unless -c 10)" ELSE PRINT
        END IF
    NEXT
    PRINT "  plays up to"; most_at_once; "notes at once (voices fit 4; more are left out)"
END SUB


FUNCTION most_at_once&
    DIM i AS LONG, j AS LONG, n AS LONG, most AS LONG
    ' a note's start: how many others sound then (fine for files this size)
    FOR i = 0 TO pcsmidiCount - 1
        IF pcsmidiNote(i).chan <> 9 THEN
            n = 0
            FOR j = 0 TO pcsmidiCount - 1
                IF pcsmidiNote(j).chan <> 9 THEN
                    IF pcsmidiNote(j).t0 <= pcsmidiNote(i).t0 + 0.001 AND pcsmidiNote(j).t1 > pcsmidiNote(i).t0 + 0.001 THEN n = n + 1
                END IF
            NEXT
            IF n > most THEN most = n
        END IF
    NEXT
    most_at_once = most
END FUNCTION


''
' Save the tune into an IFS bank (adding to the sounds already in it with
' -a). FALSE if it didn't fit or couldn't be written.
'
FUNCTION write_bank% (fileName AS STRING, nm AS STRING, appendIt AS INTEGER)
    DIM oldN AS LONG, en AS LONG, ofs AS LONG, total AS LONG, i AS LONG, k AS LONG
    DIM tbl AS STRING, body AS STRING, ff AS LONG, d AS STRING, q AS LONG, e AS LONG
    DIM names(0 TO 299) AS STRING, pris(0 TO 299) AS LONG, datas(0 TO 299) AS STRING

    ' what is in the bank already
    IF appendIt AND _FILEEXISTS(fileName) THEN
        ff = FREEFILE
        OPEN fileName FOR BINARY AS #ff
        d = SPACE$(LOF(ff))
        GET #ff, 1, d
        CLOSE #ff
        IF LEFT$(d, 4) <> "SND" + CHR$(0) THEN PRINT file_part(fileName); " isn't an IFS bank - can't add to it": EXIT FUNCTION
        oldN = CVI(MID$(d, 7, 2)) AND &HFFFF&
        FOR i = 0 TO oldN - 1
            q = CVI(MID$(d, 17 + i * 16, 2)) AND &HFFFF&
            pris(en) = ASC(d, 17 + i * 16 + 2)
            names(en) = MID$(d, 17 + i * 16 + 4, 12)
            IF INSTR(names(en), CHR$(0)) THEN names(en) = LEFT$(names(en), INSTR(names(en), CHR$(0)) - 1)
            e = q + 1
            DO WHILE e + 1 <= LEN(d)
                IF ASC(d, e) = 255 AND ASC(d, e + 1) = 255 THEN EXIT DO
                e = e + 2
            LOOP
            datas(en) = MID$(d, q + 1, e - q - 1)
            ' a sound of the same name (and its voices) is replaced
            IF names(en) = nm OR LEFT$(names(en), LEN(nm) + 1) = nm + "~" THEN en = en - 1
            en = en + 1
        NEXT
    END IF

    ' the new sound: its ARP mix, then each voice
    names(en) = nm: pris(en) = 10
    IF pcsmidiUsed > 1 THEN datas(en) = PCSMIDI_ArpMix(arpRate) ELSE datas(en) = pcsmidiVoice(1)
    en = en + 1
    IF pcsmidiUsed > 1 THEN
        FOR k = 1 TO pcsmidiUsed
            names(en) = nm + "~" + LTRIM$(STR$(k)): pris(en) = 10: datas(en) = pcsmidiVoice(k)
            en = en + 1
        NEXT
    END IF

    ofs = 16 + en * 16
    FOR i = 0 TO en - 1
        tbl = tbl + u16$(ofs + LEN(body)) + CHR$(pris(i)) + CHR$(8) + LEFT$(names(i) + STRING$(12, 0), 12)
        body = body + datas(i) + CHR$(255) + CHR$(255)
    NEXT
    total = ofs + LEN(body)
    IF total > 65535 THEN
        PRINT "Too big for an IFS bank:"; total; "bytes (64 KB max)."
        PRINT "Try fewer voices (-v), stop it sooner (-s), or a bank of its own (no -a)."
        EXIT FUNCTION
    END IF

    IF _FILEEXISTS(fileName) THEN KILL fileName
    ff = FREEFILE
    OPEN fileName FOR BINARY AS #ff
    d = "SND" + CHR$(0) + u16$(total) + u16$(en) + u16$(0) + STRING$(6, 0) + tbl + body
    PUT #ff, 1, d
    CLOSE #ff
    PRINT "  saved "; file_part(fileName); ":"; en; "entries,"; total; "bytes"
    write_bank = -1
END FUNCTION


FUNCTION u16$ (v AS LONG)
    u16 = CHR$(v AND 255) + CHR$((v \ 256) AND 255)
END FUNCTION


FUNCTION clean_name$ (s AS STRING)
    DIM i AS LONG, c AS STRING, r AS STRING
    FOR i = 1 TO LEN(s)
        c = UCASE$(MID$(s, i, 1))
        IF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_", c) THEN r = r + c
    NEXT
    IF r = "" THEN r = "TUNE"
    clean_name = LEFT$(r, 10) ' room for ~1 ... ~4 in 12 letters
END FUNCTION


FUNCTION file_part$ (f AS STRING)
    DIM i AS LONG
    FOR i = LEN(f) TO 1 STEP -1
        IF MID$(f, i, 1) = "/" OR MID$(f, i, 1) = "\" THEN file_part = MID$(f, i + 1): EXIT FUNCTION
    NEXT
    file_part = f
END FUNCTION


FUNCTION strip_ext$ (f AS STRING)
    DIM i AS LONG
    FOR i = LEN(f) TO 1 STEP -1
        IF MID$(f, i, 1) = "." THEN strip_ext = LEFT$(f, i - 1): EXIT FUNCTION
        IF MID$(f, i, 1) = "/" OR MID$(f, i, 1) = "\" THEN EXIT FOR
    NEXT
    strip_ext = f
END FUNCTION


FUNCTION note_name$ (n AS LONG)
    note_name = _TRIM$(MID$("C C#D D#E F F#G G#A A#B ", (n MOD 12) * 2 + 1, 2)) + LTRIM$(STR$(n \ 12 - 1))
END FUNCTION


FUNCTION fmt1$ (x AS DOUBLE)
    DIM w AS LONG
    w = INT(x * 10 + 0.5)
    fmt1 = LTRIM$(STR$(w \ 10)) + "." + LTRIM$(STR$(w MOD 10))
END FUNCTION

'$INCLUDE:'PCSMIDI.BM'
