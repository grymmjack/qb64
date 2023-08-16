'*************************************************************************
' MYTIMER.BAS = Microdelays for QBasic by changing the system TIMER
' ===========   Configuration
'               Erzeugung kleiner Wartezeiten durch Umkonfigurieren des
'               System-Timers
' Checked working, seems very accurate, but be worry about a high (>12000)
' values for scanfreq. Read the code before using it. <dg>
'
'(c) Douggie Green ( douggie*blissinx.demon.co.uk ), 1995
'**************************************************************************
DEFINT H, L, X
DEFDBL F, S
CLS
INPUT "Input scanning frequency: ", scanfreq

'Initial Calculations
TickFreq = 18.20678518#                 'Number of Ticks per second
TimerResolution = 65536 * TickFreq      'Used to change computer's tick freq.
Delay = INT(TimerResolution / scanfreq) 'Calculates the delay between
                                        'clock ticks (Quantized)
DelayL = Delay MOD 256                  'Delay - Low Byte
DelayH = INT(Delay / 256)               'Delay - High byte
actualfreq = TimerResolution / Delay    'Actual frequency the computer is
                                        'operating at
resfrac = TickFreq / actualfreq         'A resulting fraction used to easily
                                        'calculate the elapsed time

PRINT "Press any key to start."
WHILE INKEY$ = ""
WEND

'Set timer register to new timing rate (Timer now speeds up)
'Elapsed time 1s will now show up using "TIMER" as > 1s
OUT &H43, &H36
OUT &H40, DelayL
OUT &H40, DelayH

'Reset time (TIMER=0)
TIME$ = "00:00:00"
PRINT "Press any key to stop."

WHILE INKEY$ = ""
   LOCATE 4, 1
   PRINT USING "#####.####"; TIMER * resfrac
   'Calculates actual elapsed time (TIMER-InitialTime)*resfrac
WEND

FinalTime = TIMER
'gets final time

CLS
PRINT "Total Elapsed Time: ";
PRINT USING "#####.####"; FinalTime * resfrac

'Reset timer register - Normal time mode
'Important! returns timing mode to normal for DOS
'Some programs will not properly execute under a different time
'speed mode.
OUT &H43, &H36
OUT &H40, 255
OUT &H40, 255

END

'Theory of operation:
'Port 43h is some sort of computer paremeters register
'function 36h changes the tick timer speed by accepting two bytes from data
'register 40h.
'^----This was gleaned from a (horribly complex) C++ program and prototyped
'into a QuickBasic program.

'From experimentation, a two byte integer is entered into the computer as
'a tick speed. The low byte is entered first (bits 0 to 7, 2^0 to 2^7) and
'the high byte second (bits 8 to 15, 2^8 to 2^15). This is expressed in my
'program as Delay, with DelayL and DelayH calculated. This corresponds to
'the delay between tick counts of the processor. (As I understand,
'each tick an internal interrupt is called to update the clock. If TSRs are
'dependent on the system clock, they will also be called (the more TSRs,
'the slower the response of the computer).

'I found that for a high number (Delay = 65535), the clock speed was identical
'to the normal clock speed. For low numbers, the clock goes faster. For really
'low values, the clock speed slows down and stops at Delay=0. It gets dampened
'by the fact that updating the clock and such takes a finite amount of time,
'and can take longer than the tick delay time. Thus you need to find the best
'scanning frequency for a particular computer. My 486DX266 can scan at a
'frequency of at least 15000 Hz, where my zenith 8086 laptop can scan up to
'maybe 1200 at best.

'After a scanning frequency is specified, it is converted to store in the
'computers memory by the equation: Delay = 65536 * (18.206../Scan frequency)
'Only the integer portion of the delay is taken.
'Thus the computers New tick frequency does not exactly match the scan
'frequency and our new frequency is calculated by the equation:
'                 65536 * 18.20678158
'F       = -------------------------------------
' actual    int(65536 * 18.20678158 / scanrate)
'Thus F_actual is very close to the scan rate (within a few percent).
'The new tick frequency will speed up the clock at a rate porportional to
'the tick frequency. with 18.2..Hz being the normal frequency,
'the clock gets speeded up (F_actual/18.2..) times.
'Thus our final actual time = TIMER / (F_actual/18.2...)
'                           = TIMER * (18.2.../F_actual)
'In our program, the scanning frequency is constant so we can set a constant
'to multiply the timer by to get the elapsed time in seconds (resfrac) in our
'case.

'Well, good luck implementing this program, I had no trouble fitting this
'code into an existing program (Race car timer). I just had to include the
'setup code at the beginning of the program and multiply all times by
'resfrac to get the elapsed time, worked like a charm.

'Sorry, I lost the original C program that had the wonderful TSR code to
'continuously set the tick timer to go faster. I do not know who to
'attribute for first supplying the addresses for the timer registers.
'I didn't bother to fix the Midnight rollover problem or the resetted time
'problems (no doubt easy enough to fix).
'Any comments, questions, fixes, etc. direct to comp.lang.basic.misc or
'alt.lang.basic or Email to: zabudsk*ecf.utoronto.ca
'Code can be freely distributed anywhere.

