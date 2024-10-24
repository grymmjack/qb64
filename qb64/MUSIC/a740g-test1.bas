CONST CH0Verse_1 = " t91 @1 o0 q0 v48 L8 G4B-B-G4B-B-  G4>E-E-<G4>E-E-<  A>CF4<A>CF4<  F4AAGB->D4<"
CONST CH1Verse_1 = " t91 @1 o1 q0 v42 L8 GB->D4<GB->D4<  GB->E-<B-GB->E-<B-  A>CF4<A>CF4<  FA>C<AGB->D4<"
CONST CH2Verse_1 = " t91 @1 o3 q0 v44 L4 GG2G8F8 E-E-2E-8D8 CCCD E-2D2"
CONST CH2Verse_2 = "B-B-2B-8A8 GG2G8F8 CCCD E-2D2"
CONST CH2Verse_3 = "B-B-2B-8A8 GG2G8F8 ACFA G2D2"

CONST Channel_0 = CH0Verse_1 + CH0Verse_1 + CH0Verse_1 + CH0Verse_1
CONST Channel_1 = CH1Verse_1 + CH1Verse_1 + CH1Verse_1 + CH1Verse_1
CONST Channel_2 = CH2Verse_1 + CH2Verse_2 + CH2Verse_1 + CH2Verse_3
CONST Channel_3 = ""

PLAY Channel_0, Channel_1, Channel_2, Channel_3

DIM AS _UNSIGNED _INTEGER64 c1, c2, c3, c4

DO
    c1 = PLAY(1)
    c2 = PLAY(2)
    c3 = PLAY(3)
    c4 = PLAY(4)

    LOCATE , 1: PRINT "v1:"; c1, "v2:"; c2, "v3:"; c3, "v4:"; c4;

    _LIMIT 60
LOOP UNTIL _KEYHIT = 27 OR c1 = 0

END