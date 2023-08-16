'***********************************************************************
' ENCRYPT.BAS - Encrypting text
' ===========   Verschluesselungsroutine
'
' This is a BASIC version of the QuickPak Encrypt2 routine. Note that you
' use the same subroutine both to encrypt and decrypt. That is, to decrypt
' a previously encrypted string, simply encrypt it again.
'
' Die SUBroutine "Encrypt" leistet sowohl das Verschluesseln als auch
' das Entschluesseln. Wenn Du also einen mit Encrypt verschluesselten
' Text wieder entschluesseln willst, das wende einfach die SUB erneut
' an.
'
' (c) 1993 Ethan Winer
'***********************************************************************
DEFINT A-Z
DECLARE SUB AnyPrint (Work$)
 'allows printing the low-ASCII encrypted text
DECLARE SUB Encrypt (Secret$, PassWord$)
 'encrypts the text
'
Secret$ = "This is the string that will be encrypted."
PassWord$ = "password"
'
CLS
CALL Encrypt(Secret$, PassWord$)        'encrypt the string
PRINT " After encrypting it once: ";    'show the result
CALL AnyPrint(Secret$)
PRINT
'
CALL Encrypt(Secret$, PassWord$)        'a second encryption decrypts it
PRINT "After a second encryption: ";
CALL AnyPrint(Secret$)

'
SUB AnyPrint (Work$) STATIC     'prints any text including control characters
  DEF SEG = 0                   'see what kind of display it is
  VideoSeg = &HB800             'assume color
  IF PEEK(&H463) = &HB4 THEN VideoSeg = &HB000  'no, it's mono
  DEF SEG = VideoSeg            'either way, set the appropriate segment
  
  Row = CSRLIN - 1              'see where the cursor is now located
  Col = POS(0) - 1              '(-1 because video memory is zero-based)
  Address = Row * 160 + Col * 2 'this is where we'll start printing

  FOR X = 1 TO LEN(Work$)       'poke the characters into video RAM
    Char = ASC(MID$(Work$, X))
    POKE Address + (X - 1) * 2, Char
  NEXT
END SUB

'
SUB Encrypt (Secret$, PassWord$) STATIC
  L = LEN(PassWord$)
  FOR X = 1 TO LEN(Secret$)
    Char = ASC(MID$(PassWord$, (X MOD L) - L * ((X MOD L) = 0), 1))
    MID$(Secret$, X, 1) = CHR$(ASC(MID$(Secret$, X, 1)) XOR Char)
  NEXT
END SUB

