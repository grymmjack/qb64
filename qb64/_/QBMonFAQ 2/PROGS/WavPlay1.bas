'*********************************************************
' WavPlay1.bas - Einfacher WAV-Player - Simple WAV-Player
' ============
' (c) Tobias Doerffel ("todo"; todosoft*gmx.de) 29.4.02
'*********************************************************
DEFINT A-Z
CLS
PRINT "Please enter path and filename of the WAV file"
INPUT "e.g. c:\windows\media\chimes.wav : "; FileName$
PRINT "Please wait, loading file into virtual memory"
OPEN FileName$ FOR BINARY AS #1
DO
aa$ = SPACE$(1024)
GET #1, , aa$
LOOP UNTIL LOF(1) = LOC(1)
CLOSE #1
'
PRINT "playing wave file..."
Delay% = 100 'Wert an die Geschw. des PCs anpassen
             'adapt to the CPU speed.
             'Set to the approx. MHz
OPEN FileName$ FOR BINARY AS #1
Dummy$ = INPUT$(100, #1)
BytesRemaining& = LOF(1) - 100
BufferMax% = 100
WAIT 556, 128, 255
OUT 556, &HD1
'
DO
IF BufferMax% > BytesRemaining& THEN
  BufferMax% = BytesRemaining&
  BytesTemaining& = 0
ELSE
  BytesRemaining& = BytesRemaining& - BufferMax%
END IF
Buffer$ = INPUT$(BufferMax%, #1)
FOR i% = 1 TO BufferMax%
  WAIT 556, 128, 255
  OUT &H22C, &H10
  WAIT 556, 128, 255
  OUT &H22C, ASC(MID$(Buffer$, i%, 1))
  FOR j% = 1 TO Delay%: NEXT j%
NEXT i%
LOOP UNTIL BytesRemaining& < 100
WAIT 556, 128, 255
OUT &H22C, &H3D
CLOSE #1
END

