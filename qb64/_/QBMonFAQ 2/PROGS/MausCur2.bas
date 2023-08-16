'***********************************************************************
' MAUSCUR2.BAS = Mausroutine mit veraenderbarem Mauszeiger
' ============
' Dieses Q(uick)Basic-Programm enthaelt eine Mausroutine mit
' selbstgemaltem Mauszeiger.
' Ich weiss leider nicht mehr, woher ich die Maus-Routine hab. Die
' lagert schon seit den fruehen 90ern in meinem Archiv. Die Routine zur
' Darstellung seines eigenen Mauscursors sollte jedoch bei jeder
' Mausroutine, die die Moeglichkeit bietet, den Standartmauscursor
' auszublenden, funktionieren.
'
' Dieses Programm ist unter QBasic und QuickBASIC ablauffaehig. Weil
' der Befehl CALL ABSOLUTE verwendet wird, muss QuickBASIC mit
' der Option /L aufgerufen werden, also z.B. mit
'   QB.EXE /l MAUSCUR".BAS
'
' HaveFun - BufferUnderrun
'
' (c) BufferUnderrun, 11.1999
'************************************************************************
'
ECLARE SUB INTERRUPT1 (Nr%, iax%, ibx%, icx%, idx%)
DECLARE SUB InitInterrupt ()
DIM SHARED InterFeld(0 TO 34) AS INTEGER
DIM SHARED KNOPF AS INTEGER  'Datenfeld fuer Register bx nach dem Interrupt.
DIM SHARED x AS INTEGER  '    "      "      "    cx  "    "      "
DIM SHARED y AS INTEGER  '    "      "      "    dx  "    "      "
CALL InitInterrupt
SCREEN 9

'CALL INTERRUPT1(&H33, &H7, 0, 100, 200)  'kann benutzt werden um den
'CALL INTERRUPT1(&H33, &H8, 0, 100, 200)  'Aktionsbereich einzugrenzen
CALL INTERRUPT1(&H33, &H3, 0, 0, 0)

'*** Zeichne popligen Mauscursor ***
LINE (314, 169)-(322, 177), 4, B  'Hübscher ist es natürlich, einen mit BSAVE
CIRCLE (318, 173), 3, 9           'als Datei gespeicherten Cursor zu verwenden
CIRCLE (318, 173), 1, 10          'oder mit Hilfe eines Sprite-Editors einen
DIM cursor(1 TO 64)               'netten Cursor zu erstellen.
GET (314, 169)-(322, 177), cursor
'*** Fertig ***                               

CLS
BeginFlag = 1

DO
CALL INTERRUPT1(&H33, &H3, 0, 0, 0)
IF BeginFlag = 1 THEN
   BeginFlag = 0
   PUT (0, 0), cursor, XOR  'Damit kein Cursorabbild in der oberen Ecke bleibt
END IF

IF x = xalt AND y = yalt THEN
 GOTO Weiter
ELSE
 IF x > 631 THEN x = 631
 IF y > 341 THEN y = 341
 PUT (xalt, yalt), cursor, XOR
 PUT (x, y), cursor, XOR
END IF
Weiter:

'   .
'   .
'   .

xalt = x: yalt = y
LOOP UNTIL INKEY$ = CHR$(27)

'
SUB InitInterrupt

PoiSeg% = VARSEG(KNOPF)       'Segment und Offset der Variable
PoiPos% = VARPTR(KNOPF)       'OutregBx bestimmen.

bxSLow% = (PoiSeg% MOD 256)      'Segment in Highbyte und Lowbyte
bxSHigh% = INT(PoiSeg% / 256)    'umrechnen.

bxPLow% = (PoiPos% MOD 256)      'Offset in Highbyte und Lowbyte
bxPHigh% = INT(PoiPos% / 256)    'umrechnen.


PoiSeg% = VARSEG(x)       'Segment und Offset der Variable
PoiPos% = VARPTR(x)       'X bestimmen.

cxSLow% = (PoiSeg% MOD 256)      'Segment in Highbyte und Lowbyte
cxSHigh% = INT(PoiSeg% / 256)    'umrechnen.

cxPLow% = (PoiPos% MOD 256)      'Offset in Highbyte und Lowbyte
cxPHigh% = INT(PoiPos% / 256)    'umrechnen.

PoiSeg% = VARSEG(y)       'Segment und Offset der Variable
PoiPos% = VARPTR(y)       'Y bestimmen.

dxSLow% = (PoiSeg% MOD 256)      'Segment in Highbyte und Lowbyte
dxSHigh% = INT(PoiSeg% / 256)    'umrechnen.

dxPLow% = (PoiPos% MOD 256)      'Offset in Highbyte und Lowbyte
dxPHigh% = INT(PoiPos% / 256)    'umrechnen.


DEF SEG = VARSEG(InterFeld(0))   'In die Variable InterFeld wird der
   Poi% = VARPTR(InterFeld(0))   'Maschinencode direkt eingetragen.

REM *** Maschinencode ****** entsprechender Assemblercode ***

   POKE Poi%, &HB8           'mov ax, dummy (Inhalt von ax wird
   POKE Poi% + 1, &H0        '               später mittels Poke
   POKE Poi% + 2, &H0        '               eingefügt.)

   POKE Poi% + 3, &HBB       'mov bx, dummy
   POKE Poi% + 4, &H0
   POKE Poi% + 5, &H0

   POKE Poi% + 6, &HB9       'mov cx, dummy
   POKE Poi% + 7, &H0
   POKE Poi% + 8, &H0

   POKE Poi% + 9, &HBA       'mov dx, dummy
   POKE Poi% + 10, &H0
   POKE Poi% + 11, &H0

   POKE Poi% + 12, &HCD       'int dummy (Interruptnummer mit Poke
   POKE Poi% + 13, &H0        '           einfügen.)

   POKE Poi% + 14, &H6        'push es
   POKE Poi% + 15, &H56       'push si

   POKE Poi% + 16, &HB8       'mov ax, Segment von X
   POKE Poi% + 17, cxSLow%
   POKE Poi% + 18, cxSHigh%

   POKE Poi% + 19, &H8E      'mov es, ax
   POKE Poi% + 20, &HC0

   POKE Poi% + 21, &HB8      'mov ax, Pointer auf X
   POKE Poi% + 22, cxPLow%
   POKE Poi% + 23, cxPHigh%

   POKE Poi% + 24, &H8B      'mov si, ax
   POKE Poi% + 25, &HF0

   POKE Poi% + 26, &H26      'mov es:[si], cl
   POKE Poi% + 27, &H88
   POKE Poi% + 28, &HC

   POKE Poi% + 29, &H26      'mov es:[si+1], ch
   POKE Poi% + 30, &H88
   POKE Poi% + 31, &H6C
   POKE Poi% + 32, &H1

   POKE Poi% + 33, &HB8       'mov ax, Segment von Y
   POKE Poi% + 34, dxSLow%
   POKE Poi% + 35, dxSHigh%

   POKE Poi% + 36, &H8E      'mov es, ax
   POKE Poi% + 37, &HC0

   POKE Poi% + 38, &HB8      'mov ax, Pointer auf Y
   POKE Poi% + 39, dxPLow%
   POKE Poi% + 40, dxPHigh%

   POKE Poi% + 41, &H8B      'mov si, ax
   POKE Poi% + 42, &HF0

   POKE Poi% + 43, &H26      'mov es:[si], dl
   POKE Poi% + 44, &H88
   POKE Poi% + 45, &H14

   POKE Poi% + 46, &H26      'mov es:[si+1], dh
   POKE Poi% + 47, &H88
   POKE Poi% + 48, &H74
   POKE Poi% + 49, &H1

   POKE Poi% + 50, &HB8       'mov ax, Segment von KNOPF
   POKE Poi% + 51, bxSLow%
   POKE Poi% + 52, bxSHigh%

   POKE Poi% + 53, &H8E      'mov es, ax
   POKE Poi% + 54, &HC0

   POKE Poi% + 55, &HB8      'mov ax, Pointer auf KNOPF
   POKE Poi% + 56, bxPLow%
   POKE Poi% + 57, bxPHigh%

   POKE Poi% + 58, &H8B      'mov si, ax
   POKE Poi% + 59, &HF0

   POKE Poi% + 60, &H26      'mov es:[si], bl
   POKE Poi% + 61, &H88
   POKE Poi% + 62, &H1C

   POKE Poi% + 63, &H26      'mov es:[si+1], bh
   POKE Poi% + 64, &H88
   POKE Poi% + 65, &H7C
   POKE Poi% + 66, &H1

   POKE Poi% + 67, &H5E      'pop si
   POKE Poi% + 68, &H7       'pop es
   POKE Poi% + 69, &HCB      'ret
DEF SEG

END SUB

'
SUB INTERRUPT1 (Nr%, iax%, ibx%, icx%, idx%)

REM ******* DIESE SUB MÖGLICHST 1 ZU 1 IN ANDERE PROGRAMME ÜBERTRAGEN

ah% = INT(iax% / 256)  'Die an INTERRUPT übergebenen Registerwerte werden
bh% = INT(ibx% / 256)  'in ihre Highbyte und Lowbyte aufgeteilt.
ch% = INT(icx% / 256)
dh% = INT(idx% / 256)

al% = (iax% MOD 256)
bl% = (ibx% MOD 256)
cl% = (icx% MOD 256)
dl% = (idx% MOD 256)

DEF SEG = VARSEG(InterFeld(0))  'Segmentzeiger auf InterFeld
   Poi% = VARPTR(InterFeld(0))  'Pointer auf InterFeld

   POKE Poi% + 1, al%           'Die Werte für die Inreg-Register
   POKE Poi% + 2, ah%           'und die Interruptnummer werden in die
                                'Stellen der Assemblerroutine eingetragen,
   POKE Poi% + 4, bl%           'die bei der Initialisierung mit Dummywerten
   POKE Poi% + 5, bh%           '(0) freigehalten wurden.

   POKE Poi% + 7, cl%
   POKE Poi% + 8, ch%

   POKE Poi% + 10, dl%
   POKE Poi% + 11, dh%

   POKE Poi% + 13, Nr%
   CALL ABSOLUTE(Poi%)          'Hier verzweigt das Programm zur Maschinen-
                                'routine, die jetzt mit sinnvollen Werten
                                'für die Inreg-Register und der
                                'Interruptnummer versehen worden ist.
DEF SEG

END SUB

