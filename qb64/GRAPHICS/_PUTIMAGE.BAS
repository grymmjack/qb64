DEFLNG A-Z
dest_handle = _NEWIMAGE(640, 480, 32)
SCREEN dest_handle  '32 bit Screen 12 dimensions
source_handle = _LOADIMAGE("nyan-cat-export.gif", 32)
dx1 = 0: dy1 = 0
dx2 = _WIDTH(source_handle) - 1: dy2 = _HEIGHT(source_handle) - 1 'image dimensions - 1
LOCATE 29, 33: PRINT "Press any Key!";
'normal image coordinate values based on the dimensions of the image:
_PUTIMAGE (dx1, dy1)-(dx2, dy2), source_handle, dest_handle
LOCATE 20, 34: PRINT "Normal layout"
LOCATE 24, 10: PRINT "_PUTIMAGE (dx1, dy1)-(dx2, dy2), source_handle, dest_handle"
K$ = INPUT$(1)
'to flip the image on the x axis, swap the dx coordinate values:
_PUTIMAGE (dx2, dy1)-(dx1, dy2), source_handle, dest_handle
LOCATE 20, 34: PRINT "Flip by X axis"
LOCATE 24, 10: PRINT "_PUTIMAGE (dx2, dy1)-(dx1, dy2), source_handle, dest_handle"
K$ = INPUT$(1)
'to flip image on y axis, swap the dy coordinate values:
_PUTIMAGE (dx1, dy2)-(dx2, dy1), source_handle, dest_handle
LOCATE 20, 34: PRINT "Flip by Y axis"
LOCATE 24, 10: PRINT "_PUTIMAGE (dx1, dy2)-(dx2, dy1), source_handle, dest_handle "
K$ = INPUT$(1)
'to flip both, swap both the dx and dy coordinate values:
_PUTIMAGE (dx2, dy2)-(dx1, dy1), source_handle, dest_handle
LOCATE 20, 34: PRINT "Flip on both axis"
LOCATE 24, 10: PRINT "_PUTIMAGE (dx2, dy2)-(dx1, dy1), source_handle, dest_handle"
K$ = INPUT$(1)
'to enlarge, double the second set of values plus any offset of the first coordinates:
_PUTIMAGE (dx1, dy1)-((2 * dx2) + dx1, (2 * dy2) + dy1), source_handle, dest_handle
LOCATE 20, 34: PRINT "Double image size"
LOCATE 24, 2: 
PRINT "_PUTIMAGE (dx1, dy1)-((2 * dx2) + dx1, (2 * dy2) + dy1), s_handle, d_handle 
END 