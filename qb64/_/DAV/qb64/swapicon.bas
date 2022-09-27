'=================
'SWAPICON.BAS v1.0
'=================

'Coded by Dav (2010)
'For QB64 V0.91 or higher, or QuickBasic, or Qbasic.

'Swaps QB64's embedded ICON in compiled EXE's with a 32x32x8 BMP.
'Only EXEs compiled with QB64 V0.91 or later will have the ICON
'embedded in it. Previous QB64 versions used an external image.

'SOME LIMITATIONS:
'- This program runs slow because it grabs one byte at a time. 
'  Speed can be increased by loading and scanning in chunks.
'- Only looks for the current QB64 ICON image data.  If a new 
'  ICON is  added someday then this program won't swap it.
'- Scanner only looks until finding/replacing the first BMP ID.
'  This can be fixed easy if you want.


'==================================================================
'  THE BMP MUST BE 32x32, 8-BIT (256 colors) and 2,012 BYTES LONG!
'  THE CORRECT BMP FORMAT IS ASSUMED AND NOT CHECK FOR. YOU DO IT!
'==================================================================

DEFINT A-Z

PRINT
PRINT "============="
PRINT "SWAPICON v1.0"
PRINT "============="
PRINT
PRINT "Swaps embedded ICON in QB64 EXE's with a 32x32x8 BMP."
PRINT "Must use an uncompressed BMP of 2102 bytes in length."
PRINT

INPUT "Name of EXE to use -> ", EXE$

'=== OPEN EXE...

IF EXE$ = "" THEN END
OPEN EXE$ FOR BINARY AS #1
IF LOF(1) = 0 THEN
    PRINT "ERROR: " + EXE$ + " NOT FOUND!"
    CLOSE: KILL EXE$: END
END IF

'=== Deep scan EXE for QB64 ICON...

FOR place& = 1 TO LOF(1)

    '=== grab a byte...

    SEEK #1, place&
    A$ = INPUT$(1, 1)
    PRINT "Scanning: " + STR$(CINT(place& / LOF(1) * 100)) + "%"
    LOCATE CSRLIN - 1, 1

    '=== nibble for a B

    IF A$ = "B" THEN
        A2$ = INPUT$(2, 1)

        '=== If B then nibble for M6 (The BMP ID is BM6)

        IF A2$ = "M6" THEN

            '=== found? Grab entire ICON data

            SEEK #1, place&
            ICON$ = INPUT$(2102, 1)

            '=== Check to see if its QB64's ICON image
            '=== (It has 33 h's at the end of image data)
            '=== If so then replace it with your BMP data.

            IF RIGHT$(ICON$, 33) = STRING$(33, "h") THEN
                PRINT "QB64 Embedded ICON Found!"
                PRINT "Byte Location: "; place&

                '=== Ask for a BMP...

                INPUT "Name of BMP to use -> ", B$
                IF B$ = "" THEN PRINT "No BMP given. Quitting.": EXIT FOR

                '=== Check BMP...

                OPEN B$ FOR BINARY AS #2
                IF LOF(2) = 0 THEN 
                   PRINT "ERROR: File not found."
                   CLOSE 2: KILL B$: EXIT FOR
                END IF
                IF LOF(2) <> 2102 THEN 
                   PRINT "ERROR: Invalid BMP format.": EXIT FOR
                END IF

                '=== Grabs its data and stick it into EXE

                BMP$ = INPUT$(2102, 2): CLOSE #2
                PUT #1, place&, BMP$

                PRINT "BMP ADDED TO EXE!": EXIT FOR

            ELSE

                PRINT
                PRINT "This EXE doesn't seem to contain the default QB64 ICON data."
                PRINT "Perhaps it's not a QB64 EXE, or its already been icon-swapped."
                EXIT FOR         

            END IF

            EXIT FOR

        END IF
    END IF

    IF INKEY$ <> "" THEN PRINT "CANCELLED!": EXIT FOR

NEXT

CLOSE: END