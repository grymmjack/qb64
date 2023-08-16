'**************************************************************************
' CryptMe.bas = Text Encryption and Decryption with Password Protection
' ===========   Textverschluesselung u.-Entschluesselung mit Passwortschutz
'
' Deutsche Beschreibung
' ---------------------
' (von Thomas Antoni)
' Dieses Q(uick)Basic-Programm verschluesselt und entschluesselt einen
' beliebigen Text mit Hilfe eines frei waehlbaren Passworts. Es kommt
' ein sehr interessanter Verschluesselungsalgorithmus zur Anwendung,
' der mit Zufalszahlen arbeitet und die QBasic-Befehle RND und RANDOMIZE
' verwendet.
'
' Das Ergebnis der Verschluesselung ist jedesmal ein anderes. Trotzdem
' laesst sich der verschluesselte Text immer mit demselben Passwort
' entschluesseln.
'
' English Description
' ---------------------
' Recent discussions of encryption schemes led me to fool around
' with this idea of mine. Here's an encryption method based on QBs
' RND/RANDOMIZE statements.
'
' This encryption/decryption system uses the property of
' the QB RND function to return the same set of pseudo-
' random numbers for a given seed. While it's present form
' produces an encrypted string using the entire ASCII chart
' the routines could be altered to produce encrypted strings
' suitable for message posting. The original concept of this
' encryption system was designed for games, user configuration
' files and the like however.
'
' (c) by ANDY THOMAS, Sept 8, 1993
'****************************************************************************
DECLARE SUB Encrypt (Base$, PassWord$)
DECLARE SUB Decrypt (Base$, PassWord$)
'
'-------- Text and passoword input
Base$ = "This is a test of the Andy Thomas encryption system."
PassWord$ = "AndyThomas"
CLS
PRINT "Text to be encrypted:"
PRINT Base$                  ' print original string
PRINT
'
'-------- 1st Enrcyption and decryption
Encrypt Base$, PassWord$     ' Encrypt string with password
'
PRINT "Encrypted text (1st Encryption):"
FOR I = 1 TO LEN(Base$)      ' print encrypted characters
  IF ASC(MID$(Base$, I, 1)) > 32 THEN
    PRINT MID$(Base$, I, 1); ' print encrypted char.
  ELSE
    PRINT CHR$(249);         ' or a dot if not printable
  END IF
NEXT I
'
Decrypt Base$, PassWord$     ' decrypt string
PRINT : PRINT
PRINT "Decrypted text:"
PRINT Base$           ' print restored string
'
'-------- 2nd Encryption and decryption
Encrypt Base$, PassWord$     ' encrypt string again
PRINT
PRINT "Encrypted text (2nd Encryption)"
FOR I = 1 TO LEN(Base$)      ' print encrypted characters
  IF ASC(MID$(Base$, I, 1)) > 32 THEN
    PRINT MID$(Base$, I, 1); ' print encrypted char.
  ELSE
    PRINT CHR$(249);         ' or a dot if not printable
  END IF
NEXT I
Decrypt Base$, PassWord$     ' decrypt string again
PRINT : PRINT
PRINT "Decrypted text:"
PRINT Base$           ' print restored string
PRINT : PRINT
PRINT "Notice this system creates a totally unique"
PRINT "series with every usage. Even given the same"
PRINT "string to encrypt and the same password."
SLEEP
END

DEFINT A-Z
'
'
SUB Decrypt (Base$, PassWord$)

' RND/RANDOMIZE Decryption SUB
' by Andy Thomas   9/93
'
BaseLen = LEN(Base$) - 4 ' true length of the encrypted string
'
' we must extract the RNDptr, and RandomizeValue Words from
' the encrypted string in the opposite order they were inserted.
PlacePtrRandomize! = (ASC(LEFT$(Base$, 1)) * 256!) + ASC(RIGHT$(Base$, 1))
Junk = RND(-1)
RANDOMIZE PlacePtrRandomize!
PlacePtr1 = INT((BaseLen - 3) * RND + 3)
PlacePtr2 = INT((BaseLen - 3) * RND + 3)
'
MsdRNDptr = ASC(MID$(Base$, PlacePtr1 + 1, 1))
Base$ = LEFT$(Base$, PlacePtr1) + MID$(Base$, PlacePtr1 + 2, BaseLen)
'
LsdRNDptr = ASC(MID$(Base$, PlacePtr2 + 1, 1))
Base$ = LEFT$(Base$, PlacePtr2) + MID$(Base$, PlacePtr2 + 2, BaseLen)
'
RNDptr = (MsdRNDptr * 256) + LsdRNDptr
MsdRandomizeValue = ASC(MID$(Base$, RNDptr + 1, 1))
LsdRandomizeValue = ASC(MID$(Base$, RNDptr + 2, 1))
'
RandomizeValue = (MsdRandomizeValue * 256) + LsdRandomizeValue
Base$ = LEFT$(Base$, RNDptr) + MID$(Base$, RNDptr + 3, BaseLen)
'
Junk = RND(-1)
RANDOMIZE RandomizeValue
'
IF PassWord$ <> "" THEN       ' scroll for password
  FOR I = 1 TO LEN(PassWord$)
    PassValue = PassValue + (ASC(MID$(PassWord$, I, 1)) XOR I)
  NEXT I
  FOR I = 1 TO PassValue
    Junk = RND
  NEXT I
END IF
'
' decrypt the string
FOR I = 1 TO BaseLen
 RNDvalue = INT(255 * RND + 1)   ' get the next RND number
 ' the following could be optimized, this shows what's happening
 ' well however. Each character in Base$ is decrypted by XORing
 ' it with the random number selection. Exactly the same way
 ' it was encrypted.
 SELECT CASE I
  CASE 1         ' first character encrypted
    Base$ = CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue) + MID$(Base$, I + 1, BaseLen)
  CASE BaseLen   ' last character encrypted
    Base$ = LEFT$(Base$, I - 1) + CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue)
  CASE ELSE      ' in between characters encrypted
    Base$ = LEFT$(Base$, I - 1) + CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue) + MID$(Base$, I + 1, BaseLen)
 END SELECT
NEXT I
END SUB

'
'
SUB Encrypt (Base$, PassWord$)
'
' RND/RANDOMIZE Encryption SUB
' by Andy Thomas   9/93
'
BaseLen = LEN(Base$)      ' get length of string
'
RANDOMIZE TIMER
RNDptr = INT(BaseLen * RND + 1)    ' random ptr value
RandomizeValue = INT(32767 * RND)  ' random randomize value
'
' compute byte Word from RandomizeValue and RNDptr
' these two Words will be saved within the encrypted string
' increasing it's size by four bytes.
MsdRandomizeValue = ((RandomizeValue AND &HFF00) \ 256) AND &HFF
LsdRandomizeValue = RandomizeValue AND 255
MsdRNDptr = ((RNDptr AND &HFF00) \ 256) AND &HFF
LsdRNDptr = RNDptr AND 255
'
Junk = RND(-1)              ' Junk value, sets up RND correctly
RANDOMIZE RandomizeValue    ' Seed RND with Randomizevalue
'
' if a password exists, compute a unique number from that
' password and scroll through the RND function that number
' of Random numbers. This creates a unique starting point
' for the encrypted string.
IF PassWord$ <> "" THEN
  FOR I = 1 TO LEN(PassWord$)
    PassValue& = PassValue& + (ASC(MID$(PassWord$, I, 1)) XOR I)
  NEXT I
  FOR L& = 1 TO PassValue&
    Junk = RND
  NEXT L&
END IF
'
' Now actually encrypt the string
FOR I = 1 TO BaseLen
 RNDvalue = INT(255 * RND + 1)   ' get the next RND number
 ' the following could be optimized, this shows what's happening
 ' well however. Each character in Base$ is encrypted by XORing
 ' it with the random number selection.
 SELECT CASE I
  CASE 1         ' first character encrypted
    Base$ = CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue) + MID$(Base$, I + 1, BaseLen)
  CASE BaseLen   ' last character encrypted
    Base$ = LEFT$(Base$, I - 1) + CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue)
  CASE ELSE      ' in between characters encrypted
    Base$ = LEFT$(Base$, I - 1) + CHR$(ASC(MID$(Base$, I, 1)) XOR RNDvalue) + MID$(Base$, I + 1, BaseLen)
 END SELECT
NEXT I
'
' Now insert the Randomize Word into the string at location_
' RNDptr
Base$ = LEFT$(Base$, RNDptr) + CHR$(MsdRandomizeValue) + CHR$(LsdRandomizeValue) + MID$(Base$, RNDptr + 1, BaseLen)
'
' Now insert the RNDptr into the string
' to hide the location of the RNDptr I use the first and last
' characters in the encrypted string as a word for a single
' precision Randomize Seed.
PlacePtrRandomize! = (ASC(LEFT$(Base$, 1)) * 256!) + ASC(RIGHT$(Base$, 1))
Junk = RND(-1)
RANDOMIZE PlacePtrRandomize!
' then pick two random locations within the encrypted string
' to insert the RNDptr word--each byte separately.
' the RNDptr location can be neither within the first three
' or the last three characters of the string.
PlacePtr1 = INT((BaseLen - 3) * RND + 3)
PlacePtr2 = INT((BaseLen - 3) * RND + 3)
'
' insert the RNDptr word.
Base$ = LEFT$(Base$, PlacePtr2) + CHR$(LsdRNDptr) + MID$(Base$, PlacePtr2 + 1, BaseLen)
Base$ = LEFT$(Base$, PlacePtr1) + CHR$(MsdRNDptr) + MID$(Base$, PlacePtr1 + 1, BaseLen)
END SUB

