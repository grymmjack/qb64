REM Creating a random access file FILEDAT.DAT
REM \CHAP6\CH6_6.BAS

OPEN "FILEDAT.DAT" FOR RANDOM AS #1 LEN = 32
FIELD #1, 2 AS Num$, 15 AS Name$, 15 AS Tel$
LSET Num$ = MKI$(3)
LSET Name$ = "Ivanov V.P."
RSET Tel$ = "123-45-67"
PUT #1, 1
CLOSE #1

'Reading the random access file FILEDAT.DAT
'and retrieving the information it contains
CLS
OPEN "FILEDAT.DAT" FOR RANDOM AS #1 LEN = 32
FIELD #1, 2 AS Num$, 15 AS Name$, 15 AS Tel$
GET #1, 1
Num% = CVI(Num$)
PRINT Num%; "|" + Name$ + "|" + Tel$ + "|"
CLOSE #1

END   