' Ported from: https://github.com/evanshortiss/vector2d

OPTION _EXPLICIT
OPTION _EXPLICITARRAY
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

TYPE VECT2D
     x AS SINGLE
     y AS SINGLE
END TYPE

DIM v1 AS VECT2D
v1.x! = 10 : v1.y! = 20

DIM v2 AS VECT2D
v2.x! = 30 : v2.y! = 40

DIM v3 AS VECT2D

' setAxes
VECT2D_setAxes v3, 40.123, 80.456
' VECT2D$ not rounded
PRINT VECT2D$(v3, FALSE)
' VECT2D$ rounded
PRINT VECT2D$(v3, TRUE)

' setX
VECT2D_setX v3, 313
PRINT VECT2D$(v3, FALSE)

' setY
VECT2D_setY v3, 248.810
PRINT VECT2D$(v3, FALSE)

' getX
PRINT _TRIM$(STR$(VECT2D_getX(v3)))

' getY
PRINT _TRIM$(STR$(VECT2D_getY(v3)))

' add
VECT2D_add v3, v1, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_add v3, v3, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_add v3, v3, v3
PRINT VECT2D$(v3, FALSE)

' sub
VECT2D_sub v3, v2, v1
PRINT VECT2D$(v3, FALSE)
VECT2D_sub v3, v3, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_sub v3, v3, v3
PRINT VECT2D$(v3, FALSE)

' multByVECT2D
VECT2D_multByVECT2D v3, v1, v2
PRINT VECT2D$(v3, FALSE)

' multBySingle
VECT2D_multBySingle v3, v1, 10
PRINT VECT2D$(v3, FALSE)

' divByVECT2D
VECT2D_divByVECT2D v3, v1, v2
PRINT VECT2D$(v3, FALSE)

' divBySingle
VECT2D_divBySingle v3, v1, 10
PRINT VECT2D$(v3, FALSE)

' normalize
VECT2D_normalize v3, v1
PRINT VECT2D$(v3, FALSE)

' unit
VECT2D_unit v3, v1
PRINT VECT2D$(v3, FALSE)

' reverse
VECT2D_reverse v3, v1
PRINT VECT2D$(v3, FALSE)

' abs
VECT2D_abs v3, v1
PRINT VECT2D$(v3, FALSE)

' zero
VECT2D_zero v3, v1
PRINT VECT2D$(v3, FALSE)

' distance
PRINT _TRIM$(STR$(VECT2D_distance(v1, v2)))

' rotate
VECT2D_rotate v3, v1, 100
PRINT VECT2D$(v3, FALSE)

' round
v1.x! = 123.456 : v1.y! = 789.012
VECT2D_round v3, v1
PRINT VECT2D$(v3, FALSE)

' lengthsq
DIM s AS SINGLE
s = VECT2D_lengthsq(v1)
PRINT _TRIM$(STR$(s!))

' length
s = VECT2D_length(v1)
PRINT _TRIM$(STR$(s!))

' dotproduct
s = VECT2D_dotproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' crossproduct
s = VECT2D_crossproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' magnitude
s = VECT2D_magnitude(v1.x!, v1.y!)
PRINT _TRIM$(STR$(s!))

' eq
DIM b AS INTEGER
b% = VECT2D_eq(v1, v2)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"
b% = VECT2D_eq(v1, v1)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"



SUB VECT2D_setAxes (vret AS VECT2D, x AS SINGLE, y AS SINGLE)
    vret.x! = x!
    vret.y! = y!
END SUB

SUB VECT2D_setX (vret AS VECT2D, x AS SINGLE)
    vret.x! = x!
END SUB

SUB VECT2D_setY (vret AS VECT2D, y AS SINGLE)
    vret.y! = y!
END SUB

FUNCTION VECT2D$ (vec1 AS VECT2D, rounded AS INTEGER)
    IF rounded% = FALSE THEN
        VECT2D$ = "(" _
            + _TRIM$(STR$(vec1.x!)) _
            + ", " + _TRIM$(STR$(vec1.y!)) _
        + ")"
    ELSE
        DIM vret AS VECT2D
        VECT2D_round vret, vec1
        VECT2D$ = "(" _
            + _TRIM$(STR$(vret.x!)) _
            + ", " + _TRIM$(STR$(vret.y!)) _
        + ")"
    END IF
END FUNCTION

FUNCTION VECT2D_getX! (vec1 AS VECT2D)
    VECT2D_getX! = vec1.x!
END FUNCTION

FUNCTION VECT2D_getY! (vec1 AS VECT2D)
    VECT2D_getY! = vec1.y!
END FUNCTION

SUB VECT2D_add (vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
    vret.x! = vec1.x! + vec2.x!
    vret.y! = vec1.y! + vec2.y!
END SUB

SUB VECT2D_sub (vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
    vret.x! = vec1.x! - vec2.x!
    vret.y! = vec1.y! - vec2.y!
END SUB

SUB VECT2D_multByVECT2D (vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
    vret.x! = vec1.x! * vec2.x!
    vret.y! = vec1.y! * vec2.y!
END SUB

SUB VECT2D_multBySingle (vret AS VECT2D, vec1 AS VECT2D, n AS single)
    vret.x! = vec1.x! * n!
    vret.y! = vec1.y! * n!
END SUB

SUB VECT2D_divByVECT2D (vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
    vret.x! = vec1.x! / vec2.x!
    vret.y! = vec1.y! / vec2.y!
END SUB

SUB VECT2D_divBySingle (vret AS VECT2D, vec1 AS VECT2D, n AS SINGLE)
    vret.x! = vec1.x! / n!
    vret.y! = vec1.y! / n!
END SUB

SUB VECT2D_normalize (vret AS VECT2D, vec1 AS VECT2D)
    DIM magnitude AS SINGLE
    magnitude! = VECT2D_magnitude(vec1.x!, vec1.y!)
    VECT2D_divBySingle vret, vec1, magnitude!
END SUB

SUB VECT2D_unit (vret AS VECT2D, vec1 AS VECT2D)
    VECT2D_normalize vret, vec1
END SUB

SUB VECT2D_reverse (vret AS VECT2D, vec1 AS VECT2D)
    vret.x! = -vec1.x!
    vret.y! = -vec1.y!
END SUB

SUB VECT2D_abs (vret AS VECT2D, vec1 AS VECT2D)
    vret.x! = ABS(vec1.x!)
    vret.y! = ABS(vec1.y!)
END SUB

SUB VECT2D_zero (vret AS VECT2D, vec1 AS VECT2D)
    vret.x! = 0
    vret.y! = 0
END SUB

FUNCTION VECT2D_distance! (vec1 AS VECT2D, vec2 AS VECT2D)
    DIM AS SINGLE x, y
    x! = vec1.x! - vec2.x!
    y! = vec1.y! - vec2.y!
    VECT2D_distance! = SQR(x! * x! + y! * y!)
END FUNCTION

SUB VECT2D_rotate (vret as VECT2D, vec1 AS VECT2D, radians as SINGLE)
    DIM AS SINGLE cosine, sine
    cosine! = COS(radians)
    sine!   = SIN(radians)
    vret.x! = vec1.x! * cosine! - vec1.y! * sine!
    vret.y! = vec1.x! * sine! + vec1.y! * cosine!
END SUB

SUB VECT2D_round (vret AS VECT2D, vec1 AS VECT2D)
    vret.x! = _ROUND(vec1.x!)
    vret.y! = _ROUND(vec1.y!)
END SUB

FUNCTION VECT2D_lengthsq! (vec1 AS VECT2D)
    VECT2D_lengthsq! = vec1.x! * vec1.x! + vec1.y! * vec1.y!
END FUNCTION

FUNCTION VECT2D_length! (vec1 AS VECT2D)
    VECT2D_length! = VECT2D_magnitude(vec1.x!, vec1.y!)
END FUNCTION

FUNCTION VECT2D_dotproduct! (vec1 AS VECT2D, vec2 AS VECT2D)
    VECT2D_dotproduct! = vec1.x! * vec2.x! + vec1.y! * vec2.y!
END FUNCTION

FUNCTION VECT2D_crossproduct! (vec1 AS VECT2D, vec2 AS VECT2D)
    VECT2D_crossproduct! = vec1.x! * vec2.y! - vec1.y! * vec2.x!
END FUNCTION

FUNCTION VECT2D_magnitude! (x AS SINGLE, y AS SINGLE)
    VECT2D_magnitude! = SQR(x * x + y * y)
END FUNCTION

FUNCTION VECT2D_eq% (vec1 AS VECT2D, vec2 AS VECT2D)
    IF vec1.x! = vec2.x! AND vec1.y! = vec2.y! THEN
        VECT2D_eq% = TRUE
    ELSE
        VECT2D_eq% = FALSE
    END IF
END FUNCTION

FUNCTION radians_to_degrees! (radians AS SINGLE)
    radians_to_degrees! = _R2D(radians)
    ' radians_to_degrees! = radians! * 180 / _PI
END FUNCTION

FUNCTION degrees_to_radians! (degrees AS SINGLE)
    degrees_to_radians! = _D2R(degrees)
    ' degrees_to_radians! = degrees! * _PI / 180
END FUNCTION