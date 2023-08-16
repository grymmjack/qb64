'***************************************************************
' MANDEL1.BAS - Anzeige einer Mandelbrot-Menge
' ===========
' Gesamtansicht, Monochrome Version
'***************************************************************
SCREEN 12 : CLS
XM=320 : YM=240  'Bildschirmmitte
DELH=1.76 : DELV=1.32 : AC=-.65  'Größe, Zentrum der Menge
N1=300 : N2=INT(N1*DELV/DELH)    'Größe der Abbildung
'
' *** Hauptroutine
FOR I=-N1 TO N1 : A=AC+I*DELH/N1
   FOR J=0 TO N2 : B=J*DELV/N2
      U=4*(A*A+B*B) : V=U-2*A+1/4
      IF U+8*A+15/4<0 THEN L=0 : GOTO repeat
      IF V-SQR(V)+2*A-1/2<0 THEN L=0 : GOTO repeat
      X=A : Y=B : K=0
      DO
         Z=X : X=X*X-Y*Y+A : Y=2*Z*Y+B
         S=X*X+Y*Y : K=K+1
      LOOP UNTIL S>100 OR K=50
      IF K MOD 2=1 THEN PSET (XM+I,YM-J) : PSET (XM+I,YM+J)
repeat:
      IF INKEY$<>"" THEN END
   NEXT J
NEXT I : A$=INPUT$(1)
END