SCREEN 9  'Now what on Earth does this line do?! ;)

VX = 250  'Virtual-origin X coordinate.
VY = 150  'Virtual-origin Y coordinate.

X = 100
Y = 100

Rotation = 0  'The rotation counter.
Angle = -5 * .017453

DO
  _LIMIT 30
  OldX = X
  OldY = Y
  X = (OldX * COS(Angle)) + (OldY * SIN(Angle))
  Y = (OldY * COS(Angle)) - (OldX * SIN(Angle))
  PSET (X + VX, (.75 * Y) + VY), 15
  CIRCLE (X + VX, (.75 * Y) + VY), 5, 15
  Rotation = Rotation + 5
LOOP WHILE Rotation < 360
