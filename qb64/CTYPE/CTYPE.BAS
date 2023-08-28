DECLARE LIBRARY
FUNCTION isalnum% (BYVAL c AS INTEGER)  'is an alphabet letter(isalpha(c) or isdigit(c))
FUNCTION isalpha% (BYVAL c AS INTEGER)  'is letter (isupper(c) or islower(c))
FUNCTION isdigit% (BYVAL c AS INTEGER)  'is a decimal digit
FUNCTION isgraph% (BYVAL c AS INTEGER)  'is a printing character other than space
FUNCTION islower% (BYVAL c AS INTEGER)  'is a lower-case letter
FUNCTION isprint% (BYVAL c AS INTEGER)  'is printing character. ASCII: &H20 (" ") to &H7E (~)
FUNCTION ispunct% (BYVAL c AS INTEGER)  'is printing character other than space, letter, digit
FUNCTION isspace% (BYVAL c AS INTEGER)  'is space, formfeed, newline, return, tab, vertical tab
FUNCTION isupper% (BYVAL c AS INTEGER)  'is upper-case letter
FUNCTION isxdigit% (BYVAL c AS INTEGER) 'is a hexdecimal digit character(0 thru 9 or A thru F)
FUNCTION isblank% (BYVAL c AS INTEGER)  'is only space or tab
FUNCTION tolower% (BYVAL c AS INTEGER)  'return lower-case equivalent
FUNCTION toupper% (BYVAL c AS INTEGER)  'return upper-case equivalent
END DECLARE

PRINT isdigit%(ASC("a"))