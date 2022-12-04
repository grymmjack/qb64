REM Creating a bar chart using pseudo-graphics
REM \CHAP14\CH14_2.BAS
  
CLS

'Define double DATA
DATA Jan,15,  Feb,17,  Mar,24,  Apr,26,  May,29,  Jun,31
DATA Jul,27,  Aug,30,  Sep,32,  Oct,36,  Nov,40,  Dec,45
PRINT "Bar-chart showing production for 1994"
PRINT

'Reading and printing DATA
FOR I = 1 TO 12
    READ M$                      					'Read the data statements
    READ Y                       					'in on-the-fly
    PRINT M$; " ";
    FOR J = 1 TO Y               				'Draw a line of square boxes
        PRINT CHR$(&HFE);          			'corresponding to production
    NEXT J                       					'amount of that month
    PRINT
NEXT I

'Printing horizontal axis
PRINT "   |_________|_________|_________|_________|_________|"
PRINT "   0         10        20        30        40        50"

END 
