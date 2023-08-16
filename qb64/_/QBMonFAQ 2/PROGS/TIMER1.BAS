'************************************************************************
' TIMER1.BAS - Selbstanspassender Timer
' ==========
' Timer mit teilbarer Genauigkeit
'
' Dieser Benchmark misst 3 Sekunden lang einen Wert (Zeit&), der danach
' genutzt werden kann, um Pausenschleifen zu erzeugen, die auf
' verschiedenen Rechnern gleich lange laufen. Eine solche Warteschleife
' hätte folgenden Syntax:
'
' T&=0: TWait&=1 (Zeit die gewartet werden soll in Sekunden oder Teilen)
' TWait& = Zeit& * TWait&
' While TWait& < T&: T& = T& + 1: WEND
'
' (c) 05/01/2000 by East-Power-Soft, produced by us - for free use by U.
'************************************************************************
'
ON TIMER(1) GOSUB Benchmark
Z& = 0: T& = 0
TIMER ON
WHILE T& < 2: Z& = Z& + 1: WEND
TIMER OFF
ZEIT& = (TEnd& - TAnf&)
Wert = 498417
C = (CINT(((100 * ZEIT&) / Wert) * 100)) / 100
Y = ZEIT& - Wert
PRINT "  Zeitwert:"; USING "#########"; ZEIT&
PRINT "Abweichung:"; USING "#########"; Y
PRINT "Entspricht:"; C; "% eines Pentium 100MHz."
END
'
Benchmark:
   T& = T& + 1
   SELECT CASE T&
      CASE 1: TAnf& = Z&
      CASE 2: TEnd& = Z&
   END SELECT
RETURN

