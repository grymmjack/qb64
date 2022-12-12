REM Demonstration of simple direct access of VRAM
REM \CHAP8\CH8_1.BAS

CLS                  'Clear screen
DEF SEG = &HB800     'Set initial address of VRAM
POKE 0, 72           'Output of H character onto the screen
POKE 2, 69           'Output of E character onto the screen
POKE 4, 76           'Output of L character onto the screen 
POKE 6, 76           'Output of L character onto the screen 
POKE 8, 79           'Output of O character onto the screen 
POKE 10, 33          'Output of the exclamation mark onto the screen
