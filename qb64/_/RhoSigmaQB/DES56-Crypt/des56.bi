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
'| === des56.bi ===                                                  |
'|                                                                   |
'| == Definitions required for the routines provided in des56.bm.    |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Helper functions defined in des56.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\DES56-Crypt\des56" 'Do not add .h here !!
    FUNCTION EncPass$ ALIAS "rsqbdes56::cryptpass" (pass$, salt$) 'add CHR$(0) to both
    FUNCTION EncFile% ALIAS "rsqbdes56::encryptfile" (file$, pass$) 'add CHR$(0) to both
    FUNCTION DecFile% ALIAS "rsqbdes56::decryptfile" (file$, pass$) 'add CHR$(0) to both
    'The low level wrappers to the DES-56 API functions, you should not
    'use these directly, rather use the QB64 FUNCTIONs provided in the
    'des56.bm include file.
END DECLARE

'--- Error codes returned by FUNCTIONs EncryptFile%() and DecryptFile%()
'-----
CONST DES56_WARN_NOTCRYPTED = -1
CONST DES56_ERROR_NONE = 0
CONST DES56_ERROR_NOACCESS = 1
CONST DES56_ERROR_NOPASS = 2
CONST DES56_ERROR_BADCHUNK = 3
CONST DES56_ERROR_TRUNCATED = 4
CONST DES56_ERROR_WRONGCRC = 5
CONST DES56_ERROR_FILEOP = 6
CONST DES56_ERROR_FILEREAD = 7
CONST DES56_ERROR_FILEWRITE = 8
CONST DES56_ERROR_LOWMEM = 9

