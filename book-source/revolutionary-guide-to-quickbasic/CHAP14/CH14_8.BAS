REM Pie Chart with various hatching patterns
REM \CHAP14\CH14_8.BAS
 
DECLARE SUB AssignTilingPatterns (tile$())
DECLARE SUB CountAndTotalData (count!, total!)
DECLARE SUB DrawChart (count!, total!, tile$(), scale!)
DECLARE SUB DisplayLegend (count!, tile$(), scale!)
scale = 1
DIM tile$(1 TO 10)
CALL AssignTilingPatterns(tile$())
CALL CountAndTotalData(itemCount, sumOfData)
CALL DrawChart(itemCount, sumOfData, tile$(), scale)
CALL DisplayLegend(itemCount, tile$(), scale)
WHILE INKEY$ = "": WEND
 
'Data: number of people (in millions) that speak language (approx)
DATA 182, 176, 979, 425, 119, 305, 169, 290, 301, 2005, -1
'Data: the major languages
DATA Arabic, Bengali, Chinese, English, French
DATA Hindi, Portuguese, Russian, Spanish, other
'Data: title for pie chart
DATA Principal Languages of the World
 
END

SUB AssignTilingPatterns (tile$())
  tile$(1) = CHR$(136) + CHR$(136) + CHR$(170)
  tile$(2) = CHR$(85) + CHR$(0)
  tile$(3) = CHR$(128) + CHR$(32) + CHR$(8) + CHR$(2)
  tile$(4) = CHR$(3) + CHR$(12) + CHR$(48) + CHR$(192)
  tile$(5) = CHR$(170) + CHR$(170) + CHR$(0) + CHR$(0)
  tile$(6) = CHR$(17)
  tile$(7) = CHR$(168) + CHR$(168) + CHR$(0)
  tile$(8) = CHR$(1) + CHR$(16)
  tile$(9) = CHR$(255)
  tile$(10) = CHR$(5)
END SUB

SUB CountAndTotalData (count, total)
  count = 0
  total = 0
  READ itemValue
  DO UNTIL itemValue < 0
      total = total + itemValue
      count = count + 1
      READ itemValue
  LOOP
END SUB

SUB DisplayLegend (count, tile$(), scale)
  heightInRows = 25: widthInColumns = 40
  WINDOW SCREEN (0, 0)-(widthInColumns, heightInRows)
  boxWidth = 2: boxHt = 1
  legendTop = (heightInRows - (boxHt + 1) * count) \ 2
  leftEdge = widthInColumns * (scale / 2) + 2
  FOR i = 1 TO count
      READ itemName$
      boxBottom = legendTop + (boxHt + 1) * i
      boxTop = boxBottom - boxHt
      rtEdge = leftEdge + boxWidth
      LINE (leftEdge, boxTop)-(rtEdge, boxBottom), , B
      PAINT (leftEdge + boxWidth / 2, boxBottom - boxHt / 2), tile$(i)
      LOCATE boxBottom, leftEdge + boxWidth + 2: PRINT itemName$
  NEXT i
  READ title$
  LOCATE heightInRows - 1, (widthInColumns - LEN(title$)) / 2
  PRINT title$;
END SUB

SUB DrawChart (count, total, tile$(), scale)
  windowWidth = 4: windowHeight = 3
  SCREEN 1, 0: COLOR , 0
  WINDOW (0, 0)-(windowWidth, windowHeight)
  twoPi = 8 * ATN(1)                                                            '2*pi
  radius = scale * windowWidth / 4
  xcenter = radius: ycenter = windowHeight / 2
  startSector = .00001
  RESTORE                                                       'use first data statement again
  FOR index% = 1 TO count
      READ itemValue
      endSector = startSector + twoPi * (itemValue / total)
      IF endSector > 6.283 THEN endSector = 6.283
      CIRCLE (xcenter, ycenter), radius, , -startSector, -endSector
      theta = (startSector + endSector) / 2
      x = xcenter + radius * COS(theta) / 2
      y = ycenter + radius * SIN(theta) / 2
      PAINT (x, y), tile$(index%)
      startSector = endSector
  NEXT index%
  READ itemValue                                                'read the sentinel value
END SUB

