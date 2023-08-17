'*********** COPYFILE.BAS - file copy subroutine

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB CopyFile (InFile$, OutFile$)

SUB CopyFile (InFile$, OutFile$) STATIC

  File1 = FREEFILE
  OPEN InFile$ FOR BINARY AS #File1
 
  File2 = FREEFILE
  OPEN OutFile$ FOR BINARY AS #File2

  Remaining& = LOF(File1)
  DO
    IF Remaining& > 4096 THEN
      ThisPass = 4096
    ELSE
      ThisPass = Remaining&
    END IF
    Buffer$ = SPACE$(ThisPass)
    GET #File1, , Buffer$
    PUT #File2, , Buffer$
    Remaining& = Remaining& - ThisPass
  LOOP WHILE Remaining&

  CLOSE File1, File2

END SUB
