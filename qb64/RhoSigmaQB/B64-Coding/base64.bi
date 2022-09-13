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
'| === base64.bi ===                                                 |
'|                                                                   |
'| == Definitions required for the routines provided in base64.bm.   |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Helper functions defined in base64.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\B64-Coding\base64" 'Do not add .h here !!
    FUNCTION B64Enc& ALIAS "rsqbbase64::base64Encode" (resultString$, asciiString$, BYVAL asciiStringLength&, BYVAL wrapLength&, BYVAL padFlag&, BYVAL byLineFlag&)
    FUNCTION B64Dec& ALIAS "rsqbbase64::base64Decode" (resultString$, encodedString$, BYVAL encodedStringLength&, BYVAL strictFlag&, BYVAL whitespaceReset&)
    'The low level wrappers to Base64, you should not use this directly,
    'rather use the QB64 FUNCTIONs provided in the base64.bm include.
END DECLARE

'--- Possible Base64 decoding errors
'-----
CONST B64DEC_ERROR_DAP = -1 'Data after pad character
CONST B64DEC_ERROR_PCW = -2 'Pad character in wrong place
CONST B64DEC_ERROR_SSB = -3 'Single symbol block not valid
CONST B64DEC_ERROR_BCI = -4 'Bad character in input string

