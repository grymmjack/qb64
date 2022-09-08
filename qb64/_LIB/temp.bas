'$INCLUDE:'DUMP.BI'

DIM words$(2)
words$(0) = "foo" : words$(1) = "bar" : words$(2) = "baz"
PRINT dump_string_array(words$(), "words")

'$INCLUDE:'DUMP.BM'
