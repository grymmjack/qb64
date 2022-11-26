DECLARE FUNCTION device_info$ ()

PRINT device_info$

''
' Get devices as a big string
'
' @return STRING of devices and button information
'
FUNCTION device_info$ ()
    nl$ = CHR$(10) ' For some reason CHR$(13) won't combine strings
    out$ = ""
    device_count = _DEVICES
    FOR i% = 1 TO device_count
        device_name$ = _DEVICE$(i%)
        num_buttons% = _LASTBUTTON(i%)
        num_buttons$ = _TRIM$(STR$(num_buttons%))
        out$ = out$ + "DEVICE: " + device_name$ + " #BTN: " + num_buttons$ + nl$
    NEXT i%
    device_info$ = out$
END FUNCTION