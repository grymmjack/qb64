DIM SHARED DUMP_NL AS STRING
$IF WIN THEN
    DUMP_NL$ = CHR$(13)
$ELSE
    DUMP_NL$ = CHR$(10)
$END IF

DECLARE FUNCTION dump_string$ (s$, label$)
DECLARE FUNCTION dump_string_array$ (arr$(), label$)
DECLARE FUNCTION dump_integer_array$ (arr%(), label$)
DECLARE FUNCTION dump_single_array$ (arr!(), label$)
DECLARE FUNCTION dump_long_array$ (arr&(), label$)
DECLARE FUNCTION dump_double_array$ (arr#(), label$)