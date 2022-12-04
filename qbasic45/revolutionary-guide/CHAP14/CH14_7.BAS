REM Pie Chart Creator
REM \CHAP14\CH14_7.BAS
 
 CONST PI = 3.1416        'Value of pie
    CLS

'Define Table
 NoOfQtrs = 4             'Number of quarters
 DIM QtrTbl(NoOfQtrs)     'Table of quarterly sales

ControlModule:
  GOSUB LoadTable
  GOSUB SetUpGraphicsArea
  GOSUB DrawGraph
  GOSUB ReturnTextScreen
END

LoadTable:
  TotSales = 0
  FOR Q = 1 TO NoOfQtrs
      FOR Month = 1 TO 3
          PRINT Q, Month
          READ Sales
          QtrTbl(Q) = QtrTbl(Q) + Sales
      NEXT Month
      TotSales = TotSales + QtrTbl(Q)
  NEXT Q
RETURN

SetUpGraphicsArea:
  SCREEN 1
  PALETTE 1, 0
  COLOR 1, 3
  CLS 0
  LOCATE 1, 10
  PRINT "Quarterly Sales 1994"
RETURN

DrawGraph:
  PStart = 0
  FOR Q = 1 TO NoOfQtrs
      Percent = QtrTbl(Q) / TotSales
      Percent = Percent * 360 / 57.3
      PEnd = Percent + PStart
      CIRCLE (160, 100), 75, , PStart, -PEnd
      GOSUB LabelQuarter
      PStart = PEnd
  NEXT Q
  P$ = INPUT$(1)
RETURN

ReturnTextScreen:
  SCREEN 0
  WIDTH 80
RETURN

LabelQuarter:
  Angle = (PStart + PEnd) / 2
  x = 160 + 40 * COS(Angle)
  Y = 100 - 40 * SIN(Angle)
  LOCATE INT(Y / 8), INT(x / 8)
  PRINT Q
RETURN

DATA 120,132,140
DATA 154,160,159
DATA 186,190,197
DATA 195,198,220


