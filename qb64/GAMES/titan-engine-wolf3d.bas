_TITLE "TITAN-ENGINE: WOLF3D [2026 REBORN]"
SCREEN _NEWIMAGE(800, 700, 32)
_MOUSEHIDE: _PRINTMODE _KEEPBACKGROUND
 
' --- Global Core ---
CONST MAP_SIZE = 24
DIM SHARED worldMap(MAP_SIZE, MAP_SIZE) AS INTEGER
DIM SHARED doorOffsets(MAP_SIZE, MAP_SIZE) AS SINGLE
DIM SHARED tex&(120), wpns&(5, 4), zBuffer(800) AS SINGLE
 
' Gameplay Vars
DIM SHARED health, ammo, curWpn, wFrame, wTimer, isFiring, wInertiaX, wInertiaY
health = 100: ammo = 64: curWpn = 1
 
' --- 1. The Asset Pipeline ---
path$ = "./"
sheet& = _LOADIMAGE(path$ + "Wolf3d.png", 32)
wpnSheet& = _LOADIMAGE(path$ + "Wolf3d-Wpns.png", 32)
_CLEARCOLOR _RGB32(255, 0, 255), wpnSheet& ' Slice World Textures
_CLEARCOLOR _RGB32(255, 0, 255), sheet& ' Slice World Textures
 
IF sheet& < -1 THEN
  FOR i = 0 TO 63
    tx = (i MOD 8) * 64: ty = INT(i / 8) * 64
    tex&(i) = _NEWIMAGE(64, 64, 32)
    _PUTIMAGE (0, 0)-(63, 63), sheet&, tex&(i), (tx, ty)-(tx + 63, ty + 63)
  NEXT
END IF
 
' Slice Weapons (Alpha-masking enabled)
IF wpnSheet& < -1 THEN
  FOR w = 0 TO 4: FOR f = 0 TO 3
      wpns&(w, f) = _NEWIMAGE(128, 128, 32)
      _PUTIMAGE (0, 0)-(127, 127), wpnSheet&, wpns&(w, f), (w * 128, f * 128)-(w * 128 + 127, f * 128 + 127)
      '_SETALPHA 0, _RGB32(151, 164, 178), wpns&(w, f)
  NEXT: NEXT
END IF
 
' Load Literal Map
RESTORE MapData: FOR y = 0 TO 23: FOR x = 0 TO 23: READ worldMap(x, y): NEXT: NEXT
 
' Player Physics
pX = 12.5: pY = 21.5: pDirX = 0: pDirY = -1
plX = 0.70: plY = 0: MoveSpeed = 0.14: RotSpeed = 0.0035
_CAPSLOCK ON
 
' --- 2. Main Engine Loop ---
DO
  _LIMIT 60: WHILE _MOUSEINPUT: WEND
 
  ' Mouse Look & Weapon Inertia
  mDX = _MOUSEX - 400: mDY = _MOUSEY - 300: _MOUSEMOVE 400, 300
  angle = mDX * RotSpeed
  wInertiaX = mDX * 0.5: wInertiaY = mDY * 0.2 ' Adds "weight" to the gun
 
  ' Rotation Matrix
  oX = pDirX: pDirX = pDirX * COS(angle) - pDirY * SIN(angle): pDirY = oX * SIN(angle) + pDirY * COS(angle)
  oP = plX: plX = plX * COS(angle) - plY * SIN(angle): plY = oP * SIN(angle) + plY * COS(angle)
 
  ' Combat & State Machine
  IF _KEYDOWN(49) THEN curWpn = 0 ' Knife
  IF _KEYDOWN(50) THEN curWpn = 1 ' Pistol
  IF _KEYDOWN(51) THEN curWpn = 2 ' MG
  IF _KEYDOWN(52) THEN curWpn = 3 ' Gatling
  IF _KEYDOWN(53) THEN curWpn = 4 ' Launcher
 
  IF _MOUSEBUTTON(1) AND isFiring = 0 THEN
    IF curWpn = 0 OR ammo > 0 THEN
      isFiring = 1: wTimer = 0
      IF curWpn > 0 THEN ammo = ammo - 1
    END IF
  END IF
  IF isFiring THEN
    wTimer = wTimer + 1
    IF wTimer < 3 THEN wFrame = 1 ELSE IF wTimer < 6 THEN wFrame = 2 ELSE IF wTimer < 9 THEN wFrame = 3 ELSE isFiring = 0: wFrame = 0
  END IF
 
  ' 2026 Sliding Movement
  mX = 0: mY = 0
  IF _KEYDOWN(87) THEN mX = mX + pDirX: mY = mY + pDirY ' W
  IF _KEYDOWN(83) THEN mX = mX - pDirX: mY = mY - pDirY ' S
  IF _KEYDOWN(65) THEN mX = mX + pDirY: mY = mY - pDirX ' A
  IF _KEYDOWN(68) THEN mX = mX - pDirY: mY = mY + pDirX ' D
 
  ' Collision (Independent Axis checking for smooth sliding)
  IF worldMap(INT(pX + mX * MoveSpeed), INT(pY)) <= 0 OR doorOffsets(INT(pX + mX * MoveSpeed), INT(pY)) > 0.8 THEN pX = pX + mX * MoveSpeed
  IF worldMap(INT(pX), INT(pY + mY * MoveSpeed)) <= 0 OR doorOffsets(INT(pX), INT(pY + mY * MoveSpeed)) > 0.8 THEN pY = pY + mY * MoveSpeed
  IF mX <> 0 OR mY <> 0 THEN bob = bob + 0.22
 
  ' Door Animation
  IF _KEYDOWN(32) THEN
    cX = INT(pX + pDirX * 1.5): cY = INT(pY + pDirY * 1.5)
    IF worldMap(cX, cY) >= 20 AND doorOffsets(cX, cY) = 0 THEN doorOffsets(cX, cY) = 0.01
  END IF
  FOR dy = 0 TO 23: FOR dx = 0 TO 23
      IF doorOffsets(dx, dy) > 0 AND doorOffsets(dx, dy) < 1 THEN doorOffsets(dx, dy) = doorOffsets(dx, dy) + 0.04
  NEXT: NEXT
 
  ' --- 3. The Titan Renderer ---
  ' Background (Deep Space Fog)
  FOR y = 0 TO 299
    c = y / 6: LINE (0, y)-(799, y), _RGB32(c / 2, c / 2, c / 1.5)
    c = (300 - y) / 4: LINE (0, 599 - y)-(799, 599 - y), _RGB32(c, c, c)
  NEXT
 
  ' Wall Casting
  FOR x = 0 TO 799
    camX = 2 * x / 800 - 1: rDX = pDirX + plX * camX: rDY = pDirY + plY * camX
    mX = INT(pX): mY = INT(pY): dDX = ABS(1 / rDX): dDY = ABS(1 / rDY)
    IF rDX < 0 THEN stX = -1: sDX = (pX - mX) * dDX ELSE stX = 1: sDX = (mX + 1 - pX) * dDX
    IF rDY < 0 THEN stY = -1: sDY = (pY - mY) * dDY ELSE stY = 1: sDY = (mY + 1 - pY) * dDY
 
    hit = 0: side = 0
    WHILE hit = 0
      IF sDX < sDY THEN sDX = sDX + dDX: mX = mX + stX: side = 0 ELSE sDY = sDY + dDY: mY = mY + stY: side = 1
      IF worldMap(mX, mY) > 0 THEN
        IF side = 0 THEN wX = pY + ((mX - pX + (1 - stX) / 2) / rDX) * rDY ELSE wX = pX + ((mY - pY + (1 - stY) / 2) / rDY) * rDX
        wX = wX - INT(wX)
        IF worldMap(mX, mY) >= 20 THEN
          IF wX > doorOffsets(mX, mY) THEN hit = worldMap(mX, mY)
        ELSE: hit = worldMap(mX, mY): END IF
      END IF
    WEND
    IF side = 0 THEN dist = (mX - pX + (1 - stX) / 2) / rDX ELSE dist = (mY - pY + (1 - stY) / 2) / rDY
    lineH = INT(600 / dist): lS = -lineH / 2 + 300: lE = lineH / 2 + 300
    _PUTIMAGE (x, lS)-(x, lE), tex&(hit), , (INT(wX * 63), 0)-(INT(wX * 63), 63)
 
    ' 2026 Lighting: Distance Fog + Muzzle Flash Lighting
    dark = dist * 16: IF side = 1 THEN dark = dark + 45
    IF isFiring AND wFrame = 2 THEN dark = dark - 70 ' Lighting flash
    IF dark < 0 THEN dark = 0: IF dark > 255 THEN dark = 255
    LINE (x, lS)-(x, lE), _RGBA32(0, 0, 0, dark)
  NEXT x
 
  ' --- 4. Weapon & HUD Overlay ---
  ' Draw Status Bar
  LINE (0, 600)-(799, 699), _RGB32(40, 40, 45), BF
  LINE (0, 600)-(799, 605), _RGB32(100, 0, 0), BF ' Health Bar Background
  LINE (0, 600)-(health * 8, 605), _RGB32(255, 0, 0), BF ' Dynamic Health Bar
  _PRINTSTRING (30, 630), "VIT: " + STR$(health) + "%  MAG: " + STR$(ammo)
 
  ' Render Weapon with Inertia & Bobbing
  gunX = 270 + SIN(bob) * 12 - wInertiaX: gunY = 340 + ABS(COS(bob)) * 18 - wInertiaY
  _PUTIMAGE (gunX, gunY)-(gunX + 256, gunY + 256), wpns&(curWpn, wFrame)
 
  _DISPLAY
LOOP UNTIL _KEYDOWN(27)
 
MapData:
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,3,3,3,3,3,0,5,5,5,20,5,5,5,0,7,7,7,7,7,7,0,1
DATA 1,0,3,0,0,0,3,0,5,0,0,0,0,0,5,0,7,0,0,0,0,7,0,1
DATA 1,0,3,0,0,0,20,0,21,0,0,0,0,0,22,0,23,0,0,0,0,7,0,1
DATA 1,0,3,3,3,3,3,0,5,5,5,5,5,5,5,0,7,7,7,7,7,7,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,1,1,20,1,1,0,0,0,0,0,0,0,0,0,1,1,20,1,1,1,0,1
DATA 1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1
DATA 1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,3,3,20,3,3,0,0,0,0,0,0,0,0,0,5,5,20,5,5,5,0,1
DATA 1,0,3,0,0,0,3,0,0,0,0,0,0,0,0,0,5,0,0,0,0,5,0,1
DATA 1,0,20,0,0,0,20,0,0,0,0,0,0,0,0,0,20,0,0,0,0,20,0,1
DATA 1,0,3,0,0,0,3,0,0,0,0,0,0,0,0,0,5,0,0,0,0,5,0,1
DATA 1,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1