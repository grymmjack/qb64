' DRAW-COLOR-CYCLE.BAS - palette color cycling
' Exported by DRAW 2.5.1 (https://github.com/grymmjack/DRAW) on 10-10-2026
' 320x200, 32 colors, 2 cycle range(s):
'   1: 7-10 FWD 8.0/s
'   2: 11-20 PING 9.0/s
' Keys: SPACE pause/resume, + / - speed, R restart, ESC quit
'
' How it works: the art is drawn from a 32-bit image, then an 8-bit overlay
' holding only the cycling pixels is drawn on top (overlay index 0 is clear).
' Each step the overlay's palette entries are rotated with _PALETTECOLOR -
' the pixels never change, only the colors they point at. Speeds use the
' DeluxePaint CRNG unit: 16384 = 60 steps per second.
' Compile: qb64pe -x DRAW-COLOR-CYCLE.BAS

OPTION _EXPLICIT
OPTION _EXPLICITARRAY
CONST CRNG_UNIT = 16384

' --- unpack the DATA blob (deflate + base64) ---
DIM blob AS STRING, b64 AS STRING, chunk AS STRING
DO
    READ chunk
    IF chunk = "*" THEN EXIT DO
    b64 = b64 + chunk
LOOP
blob = _INFLATE$(_BASE64DECODE$(b64))
IF LEFT$(blob, 4) <> "DCYC" THEN PRINT "Bad cycling data": END

DIM p AS LONG, i AS INTEGER, j AS INTEGER, rate AS LONG
DIM imgW AS INTEGER, imgH AS INTEGER, nCol AS INTEGER, nRng AS INTEGER
p = 7 ' after magic + version
imgW = CVI(MID$(blob, p, 2)): p = p + 2
imgH = CVI(MID$(blob, p, 2)): p = p + 2
nCol = CVI(MID$(blob, p, 2)): p = p + 2
DIM pal(0 TO 255) AS _UNSIGNED LONG
FOR i = 0 TO nCol - 1
    pal(i) = _CV(_UNSIGNED LONG, MID$(blob, p, 4)): p = p + 4
NEXT
nRng = CVI(MID$(blob, p, 2)): p = p + 2
DIM rLo(1 TO 16) AS INTEGER, rHi(1 TO 16) AS INTEGER, rOvl(1 TO 16) AS INTEGER
DIM rSps(1 TO 16) AS SINGLE, rMode(1 TO 16) AS INTEGER, rOn(1 TO 16) AS INTEGER
DIM rPhase(1 TO 16) AS DOUBLE, rShift(1 TO 16) AS INTEGER
FOR i = 1 TO nRng
    rLo(i) = CVI(MID$(blob, p, 2)): p = p + 2
    rHi(i) = CVI(MID$(blob, p, 2)): p = p + 2
    rOvl(i) = CVI(MID$(blob, p, 2)): p = p + 2
    rate = CVL(MID$(blob, p, 4)): p = p + 4
    rSps(i) = rate * 60 / CRNG_UNIT ' steps per second
    rMode(i) = CVI(MID$(blob, p, 2)): p = p + 2 ' 0 forward, 1 reverse, 2 ping-pong
    rOn(i) = CVI(MID$(blob, p, 2)): p = p + 2 ' 0 = paused
    rPhase(i) = CVL(MID$(blob, p, 4)): p = p + 4
    rShift(i) = -1
NEXT

' --- the art (32-bit) and the cycling overlay (8-bit, index 0 clear) ---
DIM art AS LONG, ovl AS LONG, frame AS LONG, m AS _MEM, px AS STRING
art = _NEWIMAGE(imgW, imgH, 32)
px = MID$(blob, p, imgW * imgH * 4): p = p + imgW * imgH * 4
m = _MEMIMAGE(art): _MEMPUT m, m.OFFSET, px: _MEMFREE m
ovl = _NEWIMAGE(imgW, imgH, 256)
px = MID$(blob, p, imgW * imgH)
m = _MEMIMAGE(ovl): _MEMPUT m, m.OFFSET, px: _MEMFREE m
_CLEARCOLOR 0, ovl
frame = _NEWIMAGE(imgW, imgH, 32)

' --- window: the largest whole-number zoom that fits the desktop ---
DIM zoom AS INTEGER: zoom = 1
DO WHILE imgW * (zoom + 1) <= _DESKTOPWIDTH * 0.9 AND imgH * (zoom + 1) <= _DESKTOPHEIGHT * 0.85
    zoom = zoom + 1
LOOP
SCREEN _NEWIMAGE(imgW * zoom, imgH * zoom, 32)
_TITLE "DRAW-COLOR-CYCLE.BAS - color cycling (SPACE pause, +/- speed, ESC quit)"

' --- main loop: rotate each range on its own clock ---
DIM lastT AS DOUBLE, nowT AS DOUBLE, dt AS DOUBLE, speed AS SINGLE
DIM paused AS INTEGER, changed AS INTEGER, n AS INTEGER, s AS INTEGER, k AS LONG, kh AS LONG
speed = 1: lastT = TIMER(.001): changed = -1
DO
    nowT = TIMER(.001): dt = nowT - lastT: lastT = nowT
    IF dt < 0 OR dt > 1 THEN dt = 0 ' midnight wrap / stall
    FOR i = 1 TO nRng
        n = rHi(i) - rLo(i) + 1
        IF rOn(i) <> 0 AND paused = 0 THEN rPhase(i) = rPhase(i) + dt * rSps(i) * speed
        k = INT(rPhase(i))
        SELECT CASE rMode(i)
            CASE 1 ' reverse
                s = (n - (k MOD n)) MOD n
            CASE 2 ' ping-pong: 0, 1 .. n-1 .. 1, 0
                s = k MOD (2 * (n - 1))
                IF s > n - 1 THEN s = 2 * (n - 1) - s
            CASE ELSE ' forward
                s = k MOD n
        END SELECT
        IF s <> rShift(i) THEN
            rShift(i) = s: changed = -1
            FOR j = 0 TO n - 1 ' overlay color j shows palette color (j - s) of the range
                _PALETTECOLOR rOvl(i) + j, pal(rLo(i) + ((j - s) MOD n + n) MOD n), ovl
            NEXT
        END IF
    NEXT
    IF changed THEN
        _DEST frame: CLS , _RGB32(0, 0, 0)
        _PUTIMAGE , art, frame
        _PUTIMAGE , ovl, frame
        _DEST 0
        _PUTIMAGE , frame, 0
        _DISPLAY
        changed = 0
    END IF
    kh = _KEYHIT
    SELECT CASE kh
        CASE 27: SYSTEM
        CASE 32: paused = NOT paused
        CASE 43, 61: IF speed < 8 THEN speed = speed * 1.25
        CASE 45, 95: IF speed > 0.1 THEN speed = speed / 1.25
        CASE 82, 114
            FOR i = 1 TO nRng: rPhase(i) = 0: NEXT
    END SELECT
    _LIMIT 120
LOOP

' --- palette, ranges, art and overlay: deflate + base64 ---
DATA "eJztncGKHEcWRUuyLVnyzBiMmMUYxCy8sLfGCy8aPOBZGQa0M9PgX/DS9C8MaGesxfyDd/oIrf0l+oN0ZdEVWdWRGXUj81XEy8hz"
DATA "4YJUnX0j+kXljYz3Iqr+/f1/v3+0+9ejd7t/7l48ed59/dnL7ru/f9n95x9fd7cvb7rbV6+6N69fd3fvu+7lz2+6Fze33adf3nQv"
DATA "d3fdV8/edN989rb77vM/uh++eN/99G3X3f3Ydb/+0nW//9Z179523W63k/l493T3fPdo97+P9//bHX5398nuxe6j3f+f7XaP71/p"
DATA "e6iw/ysUooceeuihhx566KGHHnrooYceeuihhx566KGHHnro1dYjLuihhx566KGHHnrooYceeuihhx566KGHHnrooYdea3rEBT30"
DATA "0EMPPfTQQw899NBDDz300EMPPfTQQw899NBrTY+4oIceeuihhx566KGHHnrooYceeuihhx566KGHHnqt6REX9NBDDz300EMPPfTQ"
DATA "Qw899NBDDz300EMPPfTQQ681PeKCHnrooYceeuihhx566KGHHnrooYceeuihhx566LWmR1zQQw899NBDDz300EMPPfTQQw899NBD"
DATA "Dz300EMPvdb0iAt66KGHHnrooYceeuihhx566KGHHnrooYceeuih15perXbfvH4NIYQHbs131zQ2EMLrEv+DEG6VW/a/21evDrx7"
DATA "3wUeXxvjy5/fBKaue3FzG5i67tMvbwJT19E/+kf/lvfvSPxv8L/T2KVieDq2qTE+HdvUGJ+ObWqM6R/9o3/L+3dKD/5Xq93Tv30s"
DATA "dmMxHBvbsTEeG9uxMR4b27Expn/0j/4t71/K/1p5rsP/6B/9o3/4H/5H/+gf/cP/LvnfVAzHYnZpbFNjPHbdpbFNjTH9o3/0L69/"
DATA "p8T/qP/SP/q3tf4d6cH/arU75n8Qwu2Q/S/4H4RbJf6n+9+LJ88hhCsh/of/QbhVPrx/x3KS+B/+B2GLnPK+Uw/k/Af+B2GLTHnf"
DATA "kex/wf8gbJH4H/4H4VaJ/+F/EG6Vufk//A//g7AV5tZ/a/lVrXbxPwjbpXJPs//l3P9S5wzXNPYQbp34X57/XfqciTWNPYRbJ/6n"
DATA "+5/yOWNrGnsIt85o/TbyWTP4H/4HYYuc8r5TD+T8B/4HYYtMed+R7H8h/wdhi8T/8vyP+i+E7RD/y/e/FNc09hBunbn5P/zPl//9"
DATA "8MX77qdvuzPe/XjOX3855++/nfPd23O+3N2d8atnbw606vO1+nfkN5+9DSw5FnP61/O7z/84o1V/lPiVjI8yviX70zO3/lvLr2q1"
DATA "693/Snnftfzvmt5Xw/+Wel8/n1n1R4lfyfgo41uyPz2Ve5r9L+f+l/o+qtLjV8r7ruF/1/Y+y2cphRbeZ+l/SvxKxkcZ35L96Yn/"
DATA "5fnfpe8jLT1+pbzP8lmqlPfV9L+53nct/7t2TkOhMr4l+9MT/9P9L1Ujqul/pfJpVn0u5X21/G+J913D/0rkNBR6y0f2fOh1Y3s7"
DATA "8D+//rfGWkIp76vhf0u9r5/PrPpTMqeh0Fs+sueU9516IOc/1uF/a6kllPI+y2cphRbeZ+l/JXMaCr3lI3umvO9I9r/4zf+tsZZQ"
DATA "yvtq+t9c77uW/107p6HQWz6yJ/6X53/e6r9rrCWU8r5a/rfE+67hfyVyGgq95SN74n/5/udp/5/ifVZtWd27JeuAyv5IRcfb/khF"
DATA "p2ROQ42hp3xkz9z8H/7n1/+mnqus2rrkff39quiUrAMq+yMVHW/7IxWdkjkNhd7ykT1z67+1/KpWu2vxvxJnii55X47/laoDKvsj"
DATA "FZ2S966S01B0SuY0cmPoIR/ZU7mn2f9y7n9j3xFV0/8u5dOs2rrkfar/lawDKvsjFZ2S965VTkPJR1r1OSeGXvKRPfG/PP+b+o7Q"
DATA "Wv5X8kyR8lkLik7JOqCyP1LRKXnvWuU0lFqMVZ/VGHrKR/bE/3T/S31HvAf/o5YQc421BKuchlKHtuqzQm/5yJ4Pve7u/f69ck/8"
DATA "bz3+Ry1hnGusJVjlNNa4P7Jkf3pOed+pB3L+w7f/UUuY5hprCVY5jTXujyzZn54p7zuS/S9+83/UEtJcYy3BKqeh7L226rMaQ0/5"
DATA "yJ74X57/eav/UktIc421BKuchnLuxKrPCr3lI3vif/n+52n/H7WENNdYS7DKaShn7qz6nBtDD/nInrn5P/zPn/9RS5jmGmsJVjmN"
DATA "kp+1kBNDL/nInrn131p+Vatd7/5HLSHNNdYSrHIaJT9rQY2hp3xkT+WeZv/Luf+NzREe/I9aQsw11hKschpW57Wt6C0f2RP/y/O/"
DATA "qRxBbf+jljDONdYSrHIaVue1regtH9kT/9P9L1Ujqul/1BKmucZaglVOw+q8thW95SN7PvS6sb0d+J9f/6OWkOYaawlWOQ2r89pW"
DATA "9JaP7DnlfaceyPmPdfgftYSYa6wlWOU0rM5rW9FbPrJnyvuOZP+L3/xfq7UE5d719tmvc/qn1Drm5jSU/ik6reYje+J/ef7nrf7b"
DATA "ai3Bylus/nZP3qeOqdI/RafVfGRP/C/f/zzt/2u1lmDlLVZ/uyfvy/G/S/1TdFrNR/bMzf/hf379r6VagpW3WP3tnrxP9T+lf4pO"
DATA "q/nInrn131p+Vavdtfhfa7UEK2+x+ts9ed8c//NwXtsqH2lJ5Z5m/8u5/419R1RN/7uUT7NqS7l3FZ2StQSrv92T96ljqvRP0fGW"
DATA "j7Qk/pfnf1PfEVrL/5RaglVbJeuAVt5i9bd78r4c/7vUP0XHWz7Skvif7n+p74j34H9Tz1VWbSn3rqJTspZg9bd78j7V/5T+KTre"
DATA "8pGWjNZvN7eB+N96/C+1prRqS7l3FZ2StQSrv92T983xv6n+KTre8pGWnPK+Uw/k/Idv/7uUT7NqS7l3FR2rOqBVPtLbvWuV01C8"
DATA "WdHxlo+0ZMr7jmT/i9/8n1JLsGrLWx3QKh/p7d61ymkoz6WKjrd8pCXxvzz/81b/VWoJVm15qwNa5SO93btWOQ1lTa7oeMtHWhL/"
DATA "y/e/FEuPn1JLsGrLWx3QKh/p7d61ymko+UhFx1s+0pK5+T/8z5//XcqnWbXlrQ5olY/0du9a5TSUWoyi4y0facnc+m8tv6rVrnf/"
DATA "s6olKPRWB7TKR3q7d61yGkodWtHxlo+0pHJPs//l3P/G5ggP/reklqCw1XMJ3u5dq5yG1f5Ib/lIS+J/ef43lSOo7X9LawkKWz2X"
DATA "4O3etcppWO2P9JaPtCT+p/tfqkZU0/8sagkKWz2X4O3e9bY/0ls+0pIPvW5sbwf+59f/rGoJCtdYB1zjvVtyf2TJnIZVPtKSU953"
DATA "6oGc/1iH/y2pJShcYx3QWy1BYcn9kSVzGlb5SEumvO9I9r/4zf9Z1RIUrrEO6K2WoLDk/siSOQ2rfKQl8b88//NW/7WqJShcYx3Q"
DATA "Wy1BHdNS+yNL5jSs8pGWxP/y/c/T/j9l3rVqa411QG+1BIUl90eWzGko+UirGKrMzf/hf379j1pCzJK1BKs+l9wfWTKnoeQjrWKo"
DATA "Mrf+W8uvarW7Fv+jljDOkrUEqz6X3B9ZMqeh5COtYqhSuafZ/3Luf2PfEVXT/y6996zaopawrs9asPA+y5yGko+0iqFK/C/P/6a+"
DATA "I7SW/ynzrlVb1BLW9VkLFt5nmdNQ8pFWMVSJ/+n+l/qOeA/+t/S9Z1EHVNhqLcGqz1Y5Dau9zVZU3n8l+9Pzodfdvd+/V+6J/63H"
DATA "/67tfeo6SGGrtQSrPlvlNJTxtepzbgyn3n8l+9NzyvtOPZDzH779r4T3Wfpfq7UEyzG1yGko42vV55wYpt5/JfvTM+V9R7L/xW/+"
DATA "r5T3Xcv/WqolWPVZyWkoOiVzGmoML73/SvanJ/6X53/e6r+lvO8a/tdaLcGqz0pOQ9FRxteqzwqV91/J/vTE//L9z9P+v1Lep9YB"
DATA "FVJLSFPJaSg6yvha9Tk3hlPvv5L96Zmb/8P//PlfCe+z9D9qCZfH9NJzvaKjjK9Vn3NimHr/lexPz9z6by2/qtWud/8r5X3X8j9q"
DATA "CTGVnIaiUzKnocbw0vuvZH96Kvc0+1/O/W9sjvDgf9f0vmv4H7WEcSo5DUVHGV+rPitU3n8l+9MT/8vzv6kcQS3/gxDOJ/6n+1+q"
DATA "RoT/Qbg+PvS6sb0d+B/+B2GLnPK+Uw/k/Af+B2GLTHnfkex/If8HYYvE//L8z1v9F0I4n/hfvv952v8HIZzP3Pwf/of/QdgKc+u/"
DATA "tfyqVrv4H4TtUrmn2f9y7n9j3xGF/0G4PuJ/ef439R2h+B+E6yP+p/tf6jvi8T8I18do/XZzG4j/4X8Qtswp7zv1QM5/4H8QtsiU"
DATA "9x3J/hfyfxC2SPwvz/+o/0LYDvG/fP+DELZHJf+H/0EIW+Wl+m8tv6rV7hz/G4vhGFPfo3nK1OctnDK1Lqd/9I/+af17SPa/ZJx/"
DATA "m3iGTo1taowvfd7W2Nimxpj+0T/6l+eB+J/mf6kc6qWxHRtj5fNWp8Z2tDZN/+gf/cv2QPwP/6N/9A//w/9S5P1H/+gf/ncNv6rV"
DATA "Lvk/+kf/ttO/MbL/hfov/aN/W+nfQ+J/EEKI/0EIt0v8D0K4Vdbyq635LnrooYceeuihhx566KGHHnrooYceeuihhx566KHXvh5x"
DATA "QQ899NBDDz300EMPPfTQQw899NBDDz300EMPPfRa0yMu6KGHHnrooYceeuihhx566KGHHnrooYceeuihh15resQFPfTQQw899NBD"
DATA "Dz300EMPPfTQQw899NBDDz300GtNj7ighx566KGHHnrooYceeuihhx566KGHHnrooYceeq3pERf00EMPPfTQQw899NBDDz300EMP"
DATA "PfTQQw899NBDrzU94oIeeuihhx566KGHHnrooYceeuihhx566KGHHnrotaZHXNBDDz300EMPPfTQQw899NBDDz300EMPPfTQQw+9"
DATA "1vR2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAauHRo0f3/3r8+PH9vz744IP7f3344YfNXmeCvdy94L7Z+4b3zd43"
DATA "vG/2vuH2rjPBQe4geGj20PCh2UPDh2YPDbd3HfEjfuuPH/63FIPcsVnmXwAAaBiDSYIZGCZpMAPDQyKYA+K3DMRvIQjfQhA+JxhW"
DATA "hmAGhswEmIEhM7YxDKmZRdhq/IbU4DJsNH5DanopNvz2M7uDs65vAobx2yaKhu/Z8z0+2eMve/x1j7/t8dEeT57EF49f9+TJ06dP"
DATA "E02cXff04z3ia4JeQie0m7jmgJLvvunwjcdvInzJ+D0M37P4mqCX0AntJq6xhTAQ0+Ebjd9U+EbeUgFR+EbiF/QSOqHdxDWmUIxg"
DATA "Onwjb6np8F2I33n4xuM3ZRoBod3ENZaQJqLp8I3Ebzp86fg9CN9o/CZNI0DxyAOMHjuk+GVNCdPhS8bvYfiex9ckTCNA8cgeVo+9"
DATA "avz0KWE6fCNvqYAofCPxS5hGgOKRe9gtuxT/y5oSpsN3IX7n4RuP35RpBCgeuYfhslWYf7OmhOnwpeP3IHyj8ct4jkxcs0fZZX8I"
DATA "X/yj+M9NzIDhOTK8ojxHhleyniMT1/QouuwP7774R8fwfRJeScyA4TkyvKI8R4ZXsp4jE9ccUHLZn1gUHcN3Er/pGTA8R4ZXlOfI"
DATA "8ErWc2TiGlsIhajEougYviF+iRkwPEeGV5TnyPBK1nNk4hpTKIXQxKIopBbCK0pqIbyiPEeGV7KeIxPXWEIqxFeZEmLTyHqOTFxz"
DATA "gNE2VDF+FaaE2DSyniMT1/Sw2gatxa/GlBCbRtZzZOKaPey24Sv+V2VKiE0jkVoYBAWP3MPwGIMw/1aZEmLTSKQWAhSP3MP8GEgS"
DATA "VaaE2DQSqYVTwYse2aNk+OpMCbFpJFILJ4KXPfKAksdAqkwJsWkkUguDoOCRthAGosqUEJtGvNaOoXikKRQjqDIlxKYRr7VjKB5p"
DATA "CWkiqjIlxKYRr7VjKB55gNH+Uyl+VaaE2DTitXYMxSN7WO1/VuNXfkqITSNea8dQPHIPu/33iv/NmxLiXQvxr49fN1GiUtbaikfu"
DATA "YXh+QZh/500JcVjiXxfCNzSqrLUVj9yj7PmPeVNCHJb414XwncRPWGsrHtmj6PmPeVNCHJb414XwDfFT1tqKRx5Q8vzHvCkhDkv8"
DATA "60L4zuJ3ca0de+S1IRSi5q0S4rDEvy6Eb2hUWWvHHnllKIXQeauEOCzxrwvhO4mfsNaOPfK6kArx81YJcVjiXxfCN8RPWWvHHjmB"
DATA "kuc/5q0S4rDEvy6E7yx+F9fasUeOo+j5j4WrhKz069BoZBrKWjv2yFGUPf+RWBTNWyUEJP7c2DSUtXbskaMoe/4jsSiat0oISPy5"
DATA "sWkoa+3YI0dR9vxHYlE0b5UQsHBnl+KR46hz/iP+0bxVQsDCnV2KR06gyvmP+EfzVgkBC3d2KR55beSc/4h/NG+VELBwZ5fikVdG"
DATA "1vmP+EfzVgkBC3d2Ze1+vQryzn/EP5q3SghYuLNL8cgJVDn/Ef8oawa02uybMI3EWvsMdc5/xD/KmgGVKSEg8RyZMI3EWvsUlc5/"
DATA "xD/KmgGtNvsmTCOx1j5FpfMf8Y+yZkCrzb4J0+D8xxGJ58iEaXD+44jEc2TCNBJr7XNs+fxHwjQSa+0rYYXnPxKmwfmPIxLZ5oRp"
DATA "+D7/kZgBAzj/EWE6fHmnxDd//iMxAwbMmxJGGhWyzTF8n/9IzIAB86aE+GIl2xzD9/mPxAwYwPmPCNPhkypyAZs//xGFT6rIBWz+"
DATA "/EcUPqkiF5A1JSjZ5hi+z39E4ZMqcgFZU0JD5z/AJMpORI5Q8vxHgyh6/qM9lD3/0R7Knv9oD2XPfzQIwrcQhM8JNvn543bY5uff"
DATA "m6FsId4RSp7/aBBFz3+0h7LnP9pD2fMf7aHs+Y8GQfgWwjx8g+CwtBlyC8Nd3sp1xhje0MPSeshtDbNMK9cZYzDUIbUz5FaHp5xW"
DATA "riN+xK+l+OF/S3FslvkXAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADA1fEnKUAU8w=="
DATA *
