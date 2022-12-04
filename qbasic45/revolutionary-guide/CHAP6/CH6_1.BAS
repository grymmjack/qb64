REM Creating the sequential FTEL file and writing it onto a disk
REM \CHAP6\CH6_1.BAS

Num% = 3
Names$ = "Ivanov V.P."
Tel$ = "123-45-67"
Mkdir "C:\WROXDATA"
OPEN "C:\WROXDATA\FTEL.DAT" FOR OUTPUT AS #1
WRITE #1, Num%
WRITE #1, Name$, Tel$
CLOSE #1

END