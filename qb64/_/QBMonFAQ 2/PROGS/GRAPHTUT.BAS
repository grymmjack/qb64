'****************************************************************************
' GRAPHTUT.BAS - Interactive Graphics Tutorial for QBasic
' ============
' To do graphics, you must have the screen in a mode for graphics.
' You basically have few different commands to use:
' - SCREEN  - changes the screen mode
' - LINE    - draws a line
' - CIRCLE  - draws a circle (or an ellipse or a circle/ellipse arc)
' - PSET    - sets a pixel
' - PAINT   - paints an area with color
'
' By Chris with some extensions by Thomas Antoni
'  - E-mail: chris*isg-com.com
'  - Homepage-URL: www.isg-com.com/home/webprivate/chris/index.html
'****************************************************************************
'
'------------Lines---------------
'When making a line you need to put in the X coordinate where you want the
'line to start, and the Y coordinate where you want it to start....Remember
'X is always be for Y, unless using the command LOCATE. The second set of
'numbers is the ending points. Let's say x = 50, and y = 100:
'ie. LINE (x,y)-(x + 10, y), c
'The c = the color that you want to use. after the c you can add a ", B"
'which turns the line into a box. Or you can put a ", BF" at the end,
'That makes a box, and fills it in with the same color.
'Let's try one.

CLS                             'Clears the Screen
SCREEN 13                       'Sets the screen to graphics
CLS                             'Clears the Screen
LINE (10, 10)-(100, 10), 4      'Draws a red line from x,y = 10,10 to 100,10
LINE (10, 20)-(100, 50), 15, B  'Makes a Box with white lines (color 15)
LINE (10, 60)-(100, 100), 1, BF 'Makes a box, Filled with blue (color 1)
'
LOCATE 20
PRINT "LINE (10, 10)-(100, 10), 4"
PRINT "LINE (10, 20)-(100, 50), 15, B "
PRINT "LINE (10, 60)-(100, 100), 1, BF"
PRINT "press any key"
SLEEP

'------------CIRCLES-----------
'Circles are pretty easy.
'You just type CIRCLE (x coordinate, y coordinate), (radius)
'Like this: (x = 10, y = 10)
'ie. CIRCLE (x, y), (10)......the center of the circle is at x,y
'Lets try one.

SCREEN 13                        'Set the graphics
CLS                              'Clears the screen
CIRCLE (30, 40), 20, 4           'Draws a circle around the center point
                                 '30,40 with a radius of 20 pixels and the
                                 'border line color red (4)
PAINT (30, 40), 4, 4             'To fill in the circle, we use the simply
                                 'command PAINT
                                 'The 4 is the color to fill with (red) and
                                 'the second 4 is the color of the borderline
                                 'to fill to (red)
'
LOCATE 20
PRINT "red-filled circle made with..."
PRINT "CIRCLE (30, 40), 20, 4"
PRINT "PAINT (30, 40), 4, 4"
PRINT "press any key"
SLEEP

'-------------PSET----------------
'PSETing is the simplest. It just places a pixel on the screen where ever you
'tell it to.
'ie. PSET (50,50),1
'The 50,50 is the place to put the pixel. The 1 is the color (blue)
'Lets try one:

SCREEN 13                         'Sets the graphics
CLS                               'Clears the screen
PSET (20, 20), 9                  'Puts a pixel (dot) at 20,20 and makes it
                                  'light blue (9)
'
LOCATE 20
PRINT "Blue Pixel made with PSET (20, 20), 1"
END                               'This ends the tutorial, but keep reading!

'----List of other need-to-knows-------
' screen           screen type          size      how many colors
'
'SCREEN 13       Graphics screen       320X200         256
'SCREEN 12       Graphics screen       320X240          16 out of 256
'SCREEN 0        Text screen           640X480          16
'SCREEN 9        Graphics screen       640X480          16

'Colors
'0 = black       4 = red           8 = grey             12 = light red
'1 = blue        5 = magenta       9 = light blue       13 = light magenta
'2 = green       6 = brown        10 = light green      14 = yellow
'3 = cyan        7 = white        11 = light cyan       15 = bright white

'Thanks for downloading my tutorial, I hoped it helped you with you graphics.
'If this didn't help e-mail me and I will help you to the best of my ability.

