REM Accessing VRAM in graphics mode
REM \CHAP8\CH8_4.BAS

SCREEN 7            'Setting screen mode 7 of the EGA video adapter
DEF SEG = &HA000    'Setting the initial address of the video 
RAM OUT &H3CE, 7    'Addressing the bit mask register
OUT &H3CF, 128      'Masking all bits except 7th one
OUT &H3C4, 2        'Addressing the map mask register
OUT &H3C5, 4        'Setting red color
POKE 0, 1           'Drawing a point


