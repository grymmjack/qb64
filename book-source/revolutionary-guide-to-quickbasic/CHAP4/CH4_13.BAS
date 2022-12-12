REM Creating and Using the Sounds Procedure with Ports
REM \CHAP4\CH4_13.BAS

DECLARE SUB Sounds (Freq!, Length!)

CONST WHOLE = 5000!, QRTR = WHOLE / 4!
CONST C = 523!, D = 587.33, E = 659.26, F = 698.46
CONST G = 783.99, A = 880!, B = 987.77, C1 = 1046.5
CALL Sounds(C, QRTR): CALL Sounds(D, QRTR)
CALL Sounds(E, QRTR): CALL Sounds(F, QRTR)
CALL Sounds(G, QRTR): CALL Sounds(A, QRTR)
CALL Sounds(B, QRTR): CALL Sounds(C1, WHOLE)

SUB Sounds (Freq!, Length!) STATIC
  Clicks% = CINT(1193280! / Freq!)
  LoByte% = Clicks% AND &HFF
  HiByte% = Clicks% \ 256
  OUT 67, 182
  OUT 66, LoByte%
  OUT 66, HiByte%
  SpkrOn% = INP(97) OR &H3
  OUT 97, SpkrOn%
  FOR I! = 1 TO Length!: NEXT I!
  SpkrOff% = INP(97) AND &HFC
  OUT 97, SpkrOff%
END SUB   
 