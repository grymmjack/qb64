FOR n = 1 TO 100
    x = RND * 70 + 1
    y = RND * 45 + 1
    c = RND * 16
    PrintAt x, y, c, "I love BASIC!"
NEXT n

SUB PrintAt (X, Y, C, text$)
LOCATE Y, X
COLOR C
PRINT text$
END SUB


