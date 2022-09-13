'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |  Sources & Documents placed in the Public Domain. |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === Base64-HowTo.bas ===                                          |
'|                                                                   |
'| == This example shows the usage of the base64.bi/.bm functions    |
'| == to encode string message data into Base64 and vice versa.      |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Make the required .bi includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\B64-Coding\base64.bi'

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\B64-Coding\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- Read the file GPL-2.0.txt from the B64-Coding\license folder into
'--- a string and then pass it to the FUNCTION Base64Encode$(). Write
'--- the encoded text into GPL-2.0-base64.txt in the same folder. Then
'--- decode again and write it as GPL-2.0-original.txt
'-----
file$ = "license\GPL-2.0"
OPEN root$ + file$ + ".txt" FOR BINARY AS #1
a$ = SPACE$(LOF(1))
GET #1, , a$
CLOSE #1
b$ = Base64Encode$(a$, 64, 0, 0) 'wrap output each 64 chars, no padding, no line mode
OPEN root$ + file$ + "-base64.txt" FOR BINARY AS #1
PUT #1, , b$
CLOSE #1
c$ = Base64Decode$(b$, -1, 0) 'force strict mode, no line mode
OPEN root$ + file$ + "-original.txt" FOR BINARY AS #1
PUT #1, , c$
CLOSE #1
PRINT
PRINT "loading a whole file into a string and Base64 encode, write out,"
PRINT "then decode again and write into another file ..."
PRINT " Original file name: "; file$ + ".txt"
PRINT "Base64 encoded file: "; file$ + "-base64.txt"
PRINT "  Decoded file name: "; file$ + "-original.txt"

'--- Here's a quick try with a simple predefined literal string.
'-----
a$ = "qb64phoenix.com" + CHR$(10) + "Hello" + CHR$(10) + "World!"
PRINT
PRINT "Original multiline string:"
PRINT a$
PRINT
PRINT "Base64 without LineMode:"
PRINT Base64Encode$(a$, 0, 0, 0) 'no line mode
PRINT
PRINT "Base64 using LineMode:"
PRINT Base64Encode$(a$, 0, 0, -1) 'use line mode

'--- Make your best guess what happens here.
'-----
END

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\B64-Coding\base64.bm'

