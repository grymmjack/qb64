SCREEN _NEWIMAGE(640, 480, 32)
my_hardware_handle = _COPYIMAGE(_SCREENIMAGE, 33) 'take a screenshot and use it as our texture
_MAPTRIANGLE (0, 0)-(500, 0)-(250, 500), my_hardware_handle TO _ 
    (-1, 0, -1)-(1, 0, -1)-(0, 5, -10), , _SMOOTH
_DISPLAY
DO: _LIMIT 30: LOOP UNTIL INKEY$ <> "