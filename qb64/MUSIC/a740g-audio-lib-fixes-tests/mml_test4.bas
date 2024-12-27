_DEFINE A-Z AS LONG
OPTION _EXPLICIT

CONST LOOPS = 3

CONST CH0Verse_1 = "t140 w1 o0 ^75_100 v40 w1 ^75_100 o0 dd2 w8 ^100_80 o4 c"
CONST CH0Verse_2 = "w4 ^75_100 o0 d2 w8 ^100_80 o4 cd"

CONST CH1Verse_1 = "t140 w1 o2 /1^100_99 v40 l1 gba /1\20^25_79 l4 gab2"
CONST CH1Verse_2 = "v40 /9^100\1 l1 gba \2 l4 gab2"


CONST CH2Verse_1 = "t140 w2 o3 q20 v42 r1r1"
CONST CH2Verse_2 = "cd>d<e"
CONST CH2Verse_3 = "cd>d2<"


CONST CH3Verse_1 = "t140 w9 y15 o3 _100 v17 l8 d"

CONST Channel_0 = CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_2 + CH0Verse_2 + CH0Verse_2 + CH0Verse_2
CONST Channel_1 = CH1Verse_1 + CH1Verse_1 + CH1Verse_2
CONST Channel_2 = CH2Verse_1 + CH2Verse_1 + CH2Verse_1 + CH2Verse_1 + CH2Verse_2 + CH2Verse_2 + CH2Verse_2 + CH2Verse_3
CONST Channel_3 = CH3Verse_1

PLAY RepeatVerse(Channel_0, LOOPS), RepeatVerse(Channel_1, LOOPS), RepeatVerse(Channel_2, LOOPS), RepeatVerse(Channel_3, 96 * LOOPS)

DO
    _LIMIT 60
    LOCATE 1, 1
LOOP WHILE _KEYHIT <> 27 _ANDALSO DisplayVoiceStats

END

FUNCTION DisplayVoiceStats%%
    DIM voiceFrames(0 TO 3) AS _INTEGER64
    DIM i AS LONG

    FOR i = 0 TO 3
        voiceFrames(i) = PLAY(i)
        PRINT "Voice"; i; ":"; voiceFrames(i); "seconds left"; SPC(10)
    NEXT i

    DisplayVoiceStats = voiceFrames(0) > 0 _ORELSE voiceFrames(1) > 0 _ORELSE voiceFrames(2) > 0 _ORELSE voiceFrames(3) > 0
END FUNCTION

FUNCTION RepeatVerse$ (verse AS STRING, count AS _UNSIGNED LONG)
    DIM buffer AS STRING

    DIM i AS _UNSIGNED LONG

    WHILE i < count
        buffer = buffer + verse
        i = i + 1
    WEND

    RepeatVerse = buffer
END FUNCTION
