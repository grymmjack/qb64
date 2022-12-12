REM Parametric Figure 7
REM \CHAP9\CH9_17.BAS

N = 14
SCREEN 9: CLS
X0 = 320: Y0 = 175: R = 150: K = 1.5
DIM X(N), Y(N)
D = 6.28319 / N: T = 0
FOR I = 1 TO N
  T = T + D
  X(I) = X0 + K * R * SIN(T)
  Y(I) = Y0 + R * COS(T)
NEXT I
M = N - 1
FOR I = 1 TO M
   I1 = I + 1
   FOR J = I1 TO N
      LINE (X(I), Y(I))-(X(J), Y(J))
   NEXT J
NEXT I
A$ = INPUT$(1)
