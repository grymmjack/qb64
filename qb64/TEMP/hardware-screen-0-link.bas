screen 0
Palette 7, 63: Color 0, 7: Cls
a$ = "https://qb64phoenix.com"
j = Len(a$)
Color 1: Print a$: Color 0
Print "Pete's tremendous while Steve's just amazing!"
CRed = 0: CGrn = 0: CBlu = 155
t = _NewImage((j + 1) * 8, 2 * 16, 32)
_Dest t
Line (0, _FontHeight * 1 - 3)-(j * _FontWidth, _FontHeight * 1 - 3), _RGB32(CRed, CGrn, CBlu), B
lin = _CopyImage(t, 33)
_FreeImage t
_Dest 0
Do
    _Limit 10
    _PutImage ((1 - 1) * 8, (1 - 1) * 16), lin
    _Display
Loop