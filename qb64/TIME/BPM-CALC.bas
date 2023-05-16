DIM AS INTEGER _
    timeNumerator, _
    timeDenomenator, _
    bars, _
    wholeNotes, _
    halfNotes, _
    quarterNotes, _
    eighthNotes, _
    sixteenthNotes, _
    thirtysecondNotes

DIM AS SINGLE _
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

INPUT "Enter time signature numerator: ", I$
timeNumerator% = VAL(I$)

INPUT "Enter time signature denominator: ", I$
timeDenomenator% = VAL(I$)

bars%              = _CEIL(BPM! / timeDenomenator%)
wholeNotes%        = timeNumerator% * bars%
halfNotes%         = timeNumerator% * 2  * bars%
quarterNotes%      = timeNumerator% * 4  * bars%
eighthNotes%       = timeNumerator% * 8  * bars%
sixteenthNotes%    = timeNumerator% * 16 * bars%
thirtysecondNotes% = timeNumerator% * 32 * bars%

bar!               = BPM! / bars%
wholeNote!         = BPM! / wholeNotes%
halfNote!          = BPM! / halfNotes%
quarterNote!       = BPM! / quarterNotes%
eighthNote!        = BPM! / eighthNotes%
sixteenthNote!     = BPM! / sixteenthNotes%
thirtysecondNote!  = BPM! / thirtysecondNotes%

PRINT
PRINT _TRIM$(STR$(BPM!)); " BPM "; 
PRINT _TRIM$(STR$(timeNumerator%)); "/"; _TRIM$(STR$(timeDenomenator%)); 
PRINT " Calculations:"
PRINT STRING$(50, "-")
PRINT "UNIT", " COUNT", " DURATION (Secs)"
PRINT STRING$(50, "-")
PRINT "Bar", bars%, bar!
PRINT "1/1 ", wholeNotes%, wholeNote!
PRINT "1/2 ", halfNotes%, halfNote!
PRINT "1/4 ", quarterNotes%, quarterNote!
PRINT "1/8 ", eighthNotes%, eighthNote!
PRINT "1/16", sixteenthNotes%, sixteenthNote!
PRINT "1/32", thirtysecondNotes%, thirtysecondNote!

