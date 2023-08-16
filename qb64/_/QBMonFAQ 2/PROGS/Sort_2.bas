'********************************************************
' Sort_2.bas = Sorts two numbers using the SWAP statement
' ==========
' Dieses programm sortiert zwei eingegebene Zahlen mit
' Hilfe des SWAP-Befehls. Der SWAP-Befehl vertuascht den
' Inhalt von 2 Variablen.
'
' (c) Randy Cicale
'********************************************************
PRINT "This program will sort two numbers"
INPUT "first number..........."; num1
INPUT "second number.........."; num2
IF num1 > num2 THEN
    SWAP num1, num2
END IF
PRINT "The ordered numbers are:"; num1; num2
END

