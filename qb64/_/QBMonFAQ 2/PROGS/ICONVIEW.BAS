'***********************************************************
' ICONVIEW.BAS = Icon Viewer, Displays Windows & OS/2 Icons
' ============
' Procedure to display WINDOWS or OS/2 ICON files
' Modified from Pascal code to support OS/2 Icons.
' 100% Public Domain.
'
' by William Yu, Dec 2, 1996
'***********************************************************
DEFINT A-Z
DECLARE SUB LoadIcon (XX, YY, IconName$, OS2)
CONST False = 0
CONST True = NOT False
SCREEN 12
PRINT "Please enter the pathname of the icon to display"
INPUT "   (with trailing \)"; pathname$
PRINT "Please enter the icon's filename"
INPUT "   (with trailing .ICO)"; filename$
CALL LoadIcon(100, 100, pathname$ + filename$, False)
END

'
SUB LoadIcon (XX, YY, IconName$, OS2)
  x = XX
  y = YY
  Icon = FREEFILE
  OPEN IconName$ FOR BINARY AS Icon
  IF LOF(Icon) <> 0 THEN
    ch$ = " "
    FOR p = 1 TO LOF(Icon)
      GET #1, , ch$
      q = ASC(ch$)
      IF OS2 THEN Addon = 250 ELSE Addon = 0
      IF (p > 126 + Addon) AND (p < 639 + Addon) THEN
        r = q \ 16
        rr = q - (r \ 16)
        PSET (x, y), r
        PSET (x + 1, y), r
        'PSET (x + 1, y), rr
        x = x + 2
        IF x = XX + 32 THEN x = XX: y = y - 1
      END IF
    NEXT p
    CLOSE Icon
  ELSE
    CLOSE Icon
    KILL IconName$
    PRINT IconName$ + " file not found."
  END IF
END SUB

