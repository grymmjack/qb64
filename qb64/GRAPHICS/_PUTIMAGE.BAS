SCREEN 13      'program screen can use 256 colors
COLOR , 1
CLS
a& = _NEWIMAGE(50,50,13)        'create 2 screen page handles a& and b&
b& = _NEWIMAGE(50,50,13)
_DEST a&                          'set destination image to handle a&
PSET (10, 10), 15               'draw a dot on the current destination handle a&
_DEST b&                          'set destination image to handle b&
CIRCLE (10, 10), 50, 15         'draw a circle on the current destination handle b&
_CLEARCOLOR 0                     'make page b color 0 (black) transparent
_PUTIMAGE , b&, a&                'put circle on image b to image a& (a PSET dot)
_PUTIMAGE , a&, 0                 'put what is on image a& to the screen (handle 0) 
