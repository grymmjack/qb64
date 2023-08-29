'Smooth image test


Screen _NewImage(800, 600, 32)

Dim h1&, h2&
h1& = _LoadImage("monalisa-sm.png", 32)
w1 = _Width(h1&): h1 = _Height(h1&)
h2& = _CopyImage(h1&, 33)

_PutImage (1, 1)-(401, 401), h1&, 0, (1, 1)-(w1, h1)
Locate 30, 20
Print "Normal"
Sleep
Cls
_PutImage (1, 1)-(401, 401), h2&, 0, (1, 1)-(w1, h1), _Smooth
Locate 30, 20
Print "Smooth"
_Display
Sleep
End