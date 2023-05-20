CONST FALSE = 0 : CONST TRUE = NOT FALSE

DIM AS SINGLE _
    bpm, _
    nextNote, _
    noteDivider, _
    curTime, _
    wholeNote, _
    halfNote, _
    quarterNote, _
    eighthNote, _
    sixteenthNote, _
    thirtysecondNote, _
    sixtyfourthNote

DIM AS INTEGER _
    numerator, _
    denomoniator

DIM count AS LONG
DIM AS STRING I, tmph, tmpl
DIM metronomePlaying AS INTEGER
metronomePlaying% = FALSE

bpm!         = 120
numerator%   = 3
denominator% = 4

INPUT "Enter BPM: ", I$
bpm! = VAL(I$)

INPUT "Enter time signature numerator:   ", I$
numerator% = VAL(I$)

INPUT "Enter time signature denominator: ", I$
denominator% = VAL(I$)

IF numerator% > denominator% THEN
    PRINT "Illegal time signature - improper fraction: "; _TRIM$(STR$(numerator%)); "/"; _TRIM$(STR$(denominator%)); " - ABORTING"
    SYSTEM
END IF

wholeNote!        = (60 / bpm) * 4
halfNote!         = (60 / bpm) * 2
quarterNote!      = (60 / bpm)
eighthNote!       = (60 / bpm) / 2
sixteenthNote!    = (60 / bpm) / 4
thirtysecondNote! = (60 / bpm) / 8
sixtyfourthNote!  = (60 / bpm) / 16

SELECT CASE denominator%
    CASE 1:
        noteDivider! = wholeNote!
    CASE 2:
        noteDivider! = halfNote!
    CASE 4:
        noteDivider! = quarterNote!
    CASE 8:
        noteDivider! = eighthNote!
    CASE 16:
        noteDivider! = sixteenthNote!
    CASE 32:
        noteDivider! = thirtysecondNote!
    CASE 64:
        noteDivider! = sixtyfourthNote!
END SELECT

nextNote! = TIMER(.001)
count& = 0

tmph$ = "&   &  &"
tmpl$ = "\   \ #,.##### #####,"
PRINT
PRINT USING tmph$; "UNIT"; "SECONDS"; "MS    "
PRINT USING tmph$; "----"; "-------"; "-----"
PRINT USING tmpl$; "Bar"; wholeNote!; wholeNote! * 1000
PRINT USING tmpl$; "1/1"; wholeNote!; wholeNote! * 1000
PRINT USING tmpl$; "1/2"; halfNote!; halfNote! * 1000
PRINT USING tmpl$; "1/4"; quarterNote!; quarterNote! * 1000
PRINT USING tmpl$; "1/8"; eighthNote!; eighthNote! * 1000
PRINT USING tmpl$; "1/16"; sixteenthNote!; sixteenthNote! * 1000
PRINT USING tmpl$; "1/32"; thirtysecondNote!; thirtysecondNote! * 1000
PRINT USING tmpl$; "1/64"; sixtyfourthNote!; sixtyfourthNote! * 1000

PRINT
PRINT "PRESS [SPACE] TO START / STOP METRONOME - [ESC] = QUIT"
PRINT

DO
    K$ = INKEY$
    IF K$ = CHR$(32) THEN 
        count& = 0
        metronomePlaying% = NOT metronomePlaying%
    END IF

    curTime = TIMER(.001)

    IF curTime >= nextNote THEN
        IF metronomePlaying% = TRUE THEN
            IF count = 0 THEN ' bar
                PLAY "MB L64 O6 G"
            ELSE ' beat
                PLAY "MB L64 O6 C"
            END IF
        END IF
        count = (count + 1) MOD numerator%

        nextNote = nextNote + noteDivider!
    ELSE
        DIM diffTime AS SINGLE
        diffTime = nextNote - curTime
        IF metronomePlaying% = TRUE THEN
            PRINT count; nextNote; curTime; diffTime
        END IF

        IF diffTime > 0 THEN
            _DELAY diffTime
        END IF
    END IF
LOOP UNTIL K$ = CHR$(27)
