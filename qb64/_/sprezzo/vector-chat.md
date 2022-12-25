* = Ball




*       /|\
 perp    |     x2,y2
    \ q  |    / para
      \ A|A /
        \|/
        / m
      /
    /
   x1,y1

x = x + vx * dt

point vector
x,y

velocity vector
vx, vy

dt
delta time (_LIMIT)

rotated/new velocity vector:
new_vx   new_vy
x       y
v_para, v_perp
para = parallel, perp = perpendicular
----             |
                 |
----             |-----



tl;dr:
(i) rotate to coordinates where collision easy
(ii) do easy collision calculation
(iii) unrotate

1. get A (angle of collision)
A = angle of collision

\/
ax, ay = angle line
nx, ny = perpendicular line

x1,y1 = point where para starts
x2,y2 = point where para ends

slope: 
m = (y2 - y1) / (x2 - x1)
-90deg from wall = q
q: 
-1/m (slope)
q: -q/m (slope of perpendicular line)

q needs to turn into nx,ny
nx=1, ny=q
size=magnitude (synonyms) can be any number
speed: v = sqrt(vx^2 + vy^2)
# divide by speed to get only the point
# normalized = point only (unit vector)

vector v:
    new_vx = vx/v : new_vy = vy/v
    velocity vector becomes (vx/v, vy/v)

vector n:
    magnitude: n = sqr(1 + q^2)
    nx = nx/n : ny = ny/n

A = arccos(vx*nx + vy*ny)


2. get perp/para
v_perp = vx * cos(A) - vy * sin(A)
v_para = vx * sin(A) + vy * cos(A)

collision is done by changing: v_perp = -v_perp 

3. unrotate
for random: +/- to angle A before unrotate
vx = v_perp * cos(A) - v_para * sin(A)
vy = v_perp * sin(A) + v_para * cos(A)

