'*************************************************
' UMLAUTE.BAS = Umlaute in "ae", oe" usw. wandeln
' ===========
' Dieses QBasic-Programm wandelt die Umlaute eines
' DOS-ASCII-Textes in "ae", "oe", "ss" usw. um.
' Hiermit werden diese Zeichen sowohl
' unter DOS auch unter Windows lesbar.
'
' (c) Timo und Thomas Antoni, 18.5.03 - 3.12.03
'*************************************************
INPUT "Gib einen Text mit Umlauten ein"; a$
FOR a = 1 TO LEN(a$)
  h$ = MID$(a$, a, 1)
  SELECT CASE h$
    CASE CHR$(132): h$ = "ae"
    CASE CHR$(142): h$ = "Ae"
    CASE CHR$(148): h$ = "oe"
    CASE CHR$(153): h$ = "Oe"
    CASE CHR$(129): h$ = "ue"
    CASE CHR$(154): h$ = "Ue"
    CASE CHR$(225): h$ = "ss"
  END SELECT
  k$ = k$ + h$
NEXT a
PRINT k$

