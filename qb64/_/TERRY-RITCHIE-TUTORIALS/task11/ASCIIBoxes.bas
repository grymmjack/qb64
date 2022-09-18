'----------------------------
'- Main Program Begins Here -
'----------------------------

PRINT
PRINT " An ASCII box drawing demo"
PRINT " -------------------------"
PRINT
PRINT CHR$(218); STRING$(17, 196); CHR$(191)
PRINT CHR$(179); " Single Line Box "; CHR$(179)
PRINT CHR$(192); STRING$(17, 196); CHR$(217)
PRINT
PRINT CHR$(201); STRING$(17, 205); CHR$(187)
PRINT CHR$(186); " Double Line Box "; CHR$(186)
PRINT CHR$(200); STRING$(17, 205); CHR$(188)

