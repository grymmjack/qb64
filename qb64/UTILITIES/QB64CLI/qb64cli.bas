' QB64CLI
'
' OBJECTS
' project
'
' COMMANDS ( [optional] <default> )
' new, update, flatten, debug, release
'
' - new     - generates a new project
' - update  - updates existing project or creates new if it does not exist
' - flatten - outputs a single .bas file with all includes, udts, in one file
' - debug   - toggles debugging on/off
'   - on: bool - turn on debugging
'   - off: bool - turn off debugging
'   - deep: bool - turn on/off debugging in every file
'
' - release - prepares for release
'   - no-debug: bool    - removes $DEBUG
'   - no-console: bool  - removes $CONSOLE
'   - zip: bool         - zips contents
'
' - NEW
'     - qb64cli new
'         - PROJECT: string
'             - description: string
'             - [gen]: string 
'               - (<file>, scaffold)
'             - [type]:
'               - (cli, <textmode>, graphics)
'             - [udts]: string ([type]...,type,type)
'             - udts-init: bool
'             - inc-all: bool
'             - inc-common: bool
'             - inc-gjlib: bool
'             - explicits: bool
'             - readmes: bool
'             - debug: bool
'             - debug-gjlib: bool
'             - author-name: string
'             - author-email: string
'             - uppercase-filesys: bool
'             - uppercase-keywords: bool
'
' ex (kitchensink):
' qb64cli new project \
'   my-cli \
'   --description just a demonstration of a possible cli
'   --gen file \
'   --type cli \
'   --udts cmd, help, exec \
'   --udts-init \
'   --inc-all
'   --inc-common
'   --inc-gjlib
'   --explicits
'   --readmes
'   --author-name grymmjack
'   --author-email grymmjack@gmail.com
'   --uppercase
' ------------------------------------
' generates:
' MY-CLI\
'   MY-CLI.BAS  <- main code point/exe
'   _CMD.BI     <- BI = include header
'   _HELP.BI
'   _EXEC.BI
'   _CMD.BM
'   _HELP.BM    <- BM = include module
'   _EXEC.BM
'   _ALL.BI
'   _ALL.BM
'   README.MD
' 
' ex (fast):
' qb64cli new project whatever
' ----------------------------
' generates: 
'   whatever.bas: SCREEN 0 : CLS
'


$DEBUG
$CONSOLE:ONLY

IF _COMMANDCOUNT = 0 THEN
    PRINT
    PRINT "INCDEC: Increments or decrements a number in a text file."
    PRINT
    PRINT "USAGE: INCDEC FILENAME [INC]|DEC {AMOUNT}"
    PRINT
    PRINT "WHERE:"
    PRINT "  FILENAME       the absolute path to text file"
    PRINT
    PRINT "  [INC]|DEC      operation to perform:"
    PRINT "                     INC(rement): Add to existing number"
    PRINT "                     DEC(rement): Subtract from existing number"
    PRINT
    PRINT "  {AMOUNT}       (optional) is the amount to (inc|dec)rement"
    PRINT
    PRINT "EXAMPLES:"
    PRINT
    PRINT "INCDEC C:\PATH_TO\number.txt DEC 1"
    PRINT "INCDEC C:\PATH_TO\number.txt INC 10"
    PRINT
    PRINT "NOTES:"
    PRINT "If the file does not exist, the program does nothing."
    PRINT "If the file exists but is empty the new number will be 1."
    PRINT "If the decrement operation would be negative or 0, number will be 1."
    PRINT


ELSE
