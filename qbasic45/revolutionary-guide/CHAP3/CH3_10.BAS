REM Demonstrates PSET and PRESET
REM \CHAP3\CH3_10.BAS

CLS : SCREEN 9                  
PSET (0,0), 14             'Draws a yellow point in the upper                              
                           'left corner of the screen
f$=INPUT$(1)
PRESET (0,0)              'Erases the previously constructed point

END