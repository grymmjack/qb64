CONST FALSE = 0 : CONST TRUE = NOT FALSE

DIM I AS STRING

DIM SHARED AS INTEGER _
    timeNumerator, _
    timeDenominator

DIM SHARED AS SINGLE _
    BPM, _
    bar, _
    wholeNote, _
    halfNote, _
    quarterNote, _
    eighthNote, _
    sixteenthNote, _
    thirtysecondNote

INPUT "Enter BPM: ", I$
BPM! = VAL(I$)

INPUT "Enter time signature numerator:   ", I$
timeNumerator% = VAL(I$)

INPUT "Enter time signature denominator: ", I$
timeDenominator% = VAL(I$)

bar!               = (60 / BPM!) * 4
wholeNote!         = (60 / BPM!) * 4
halfNote!          = (60 / BPM!) * 2
quarterNote!       = 60 / BPM!      
eighthNote!        = (60 / BPM!) / 2
sixteenthNote!     = (60 / BPM!) / 4
thirtysecondNote!  = (60 / BPM!) / 8

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

PRINT
PRINT "PRESS [SPACE] TO START / STOP METRONOME - [ESC] = QUIT"
PRINT

DIM SHARED AS INTEGER metronomePlaying, myTimer
metronomePlaying% = FALSE

myTimer% = _FREETIMER
ON TIMER(myTimer%, 0.001) clickMetronome
TIMER(myTimer%) ON

DO:
    _DELAY .001
    K$ = INKEY$
    IF K$ = CHR$(32) THEN toggleMetronome
    _KEYCLEAR 1
LOOP UNTIL K$ = CHR$(27)

TIMER(myTimer%) OFF
TIMER(myTimer%) FREE

SUB toggleMetronome
    metronomePlaying% = NOT metronomePlaying% 
END SUB

SUB clickMetronome
    STATIC ticks AS INTEGER
    STATIC bar AS INTEGER
    DIM click AS STRING
    DIM clickBar AS STRING
    click$ = "MB T=" + VARPTR$(BPM!) + " L64 O6 C"
    clickBar$ = "MB T=" + VARPTR$(BPM!) + " L16 O5 G"
    ticks% = ticks% + 1
    ' PRINT "clickMetronome - ", _TRIM$(STR$(metronomePlaying%)), _TRIM$(STR$(ticks%)), _TRIM$(STR$(quarterNote!))
    IF metronomePlaying% = TRUE THEN 
        IF bar% >= timeDenominator% THEN
            bar% = 0
            PLAY clickBar$
        ELSEIF ticks% >= (eighthNote! * 1000) THEN
            ticks% = 0
            bar% = bar% + 1
            PLAY click$
        END IF
    END IF
END SUB