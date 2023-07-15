Screen _NewImage(1200, 820, 32)
SetFont: f& = _LoadFont("C:\WINDOWS\fonts\courbd.ttf", 24, "monospace")
_Font f&

Color _RGB(255, 255, 0)
Print Tab(28); "The Sounds of Music"; Tab(24); "(as implemented in QB64PE)"
Print

Tones:
Color _RGB(255, 255, 0): Print " Tones:"
Color _RGB(255, 255, 255): Print
Print " The notes span seven octaves, from C in octave 0 to B# in octave 6, including"
Print " the semitones. Select the octave with ";: Color _RGB(255, 255, 0): Print "On";: Color _RGB(255, 255, 255)
Print " (n ";: Color _RGB(255, 255, 255): Print "can be from 0 to 6, default 3),"
Print " and the note from  ";: Color _RGB(255, 255, 0): Print "A ";: Color _RGB(255, 255, 255): Print "to ";: Color _RGB(255, 255, 0): Print "G";
Color _RGB(255, 255, 255): Print ". Use ";: Color _RGB(255, 255, 0): Print "+ ";: Color _RGB(255, 255, 255): Print "or ";: Color _RGB(255, 255, 0)
Print "# ";: Color _RGB(255, 255, 255): Print "for sharps,";: Color _RGB(255, 255, 0): Print " -";: Color _RGB(255, 255, 255): Print " for flats."
Print: Print " Example (2 octaves): ";: Color _RGB(255, 255, 0): Print "L8 O2 CDEFGAB O3 CDEFGAB O4 C";: Color _RGB(255, 255, 255)
Sleep 1: Play "L8 O2 CDEFGAB O3 CDEFGAB O4 C"
Sleep 3: Cls: Print
Semitones:
Color _RGB(255, 255, 0): Print " Semitones:"
Color _RGB(255, 255, 255): Print
Print " Each octave has 12 semitones: ";: Color _RGB(255, 255, 0): Print " C C# D D# E F F# G G# A A# B": Color _RGB(255, 255, 255)
Print " (that's called a chomatic scale). Select notes by their letter, followed by sharp or flat if needed"
Print " (spaces and case are both ignored)."
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L8 O3 C C# D D# E F F# G G# A A# B O4 C": Color _RGB(255, 255, 255)
Sleep 1: Play "L8 O3 C C# D D# E F F# G G# A A# B o4 C"
Sleep 3: Cls: Print
Tones2:
Color _RGB(255, 255, 0): Print " Tones (method 2):"
Color _RGB(255, 255, 255): Print
Print " Any of the 85 individual semitones (from 0 to 84) can also be selected with ";: Color _RGB(255, 255, 0): Print "Nn ": Color _RGB(255, 255, 255)
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L8 N32 N33 N34 N35 N36 N37 N38 N39 N40";: Color _RGB(255, 255, 255)
Sleep 1: Play "L8 N32 N33 N34 N35 N36 N37 N38 N39 N40"
Sleep 3: Cls: Print
Silence:
Color _RGB(255, 255, 0): Print " Silence:"
Color _RGB(255, 255, 255): Print
Print " Pauses, or rests (silence) can be from 1 to 64 quarter-notes in length"
Print " Example: (this is the same string, with pauses inserted:"
Print: Color _RGB(255, 255, 0): Print " O3 C C# D P4 D# E F P4 F# G G# P4 A A# B O4 C": Color _RGB(255, 255, 255)
Sleep 1: Play "O3 C C# D P4 D# E F P4 F# G G# P4 A A# B O4 C"
Sleep 3: Cls: Print
notelength:
Color _RGB(255, 255, 0): Print " Note Length (multiple notes):"
Color _RGB(255, 255, 255): Print
Print " Length (in fractions of a note) can be 1 to 64 (eg L16 is 1/16 note in length)"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L2 EEE L4 EEE L8 EEE P2 L2 EEE L4 EEE L8 EEE";: Color _RGB(255, 255, 255)
Sleep 1: Play " L2EEE L4 EEE L8 EEE P2 L2 EEE L4 EEE L8 EEE"
Sleep 1: Print: Print
NoteLength2:
Color _RGB(255, 255, 0): Print " Note Length (single notes):"
Color _RGB(255, 255, 255): Print
Sleep 1: Print " An alternative way of changing a note length is by appending"
Print " a number to the note, rather than using Ln."
Print " Example: ";: Color _RGB(255, 255, 0): Print "L2 CC8CC P2 C8CCC P2 CC8CC": Color _RGB(255, 255, 255): Print
Print " The difference is that the appended version only applies to the previous note, then"
Print " dies, while the Ln version persists until over-written by another Ln."
Sleep 2: Play "L2 CC8CC P2 C8CCC P2 CC8CC"
Sleep 3: Cls: Print
NoteLength3:
Color _RGB(255, 255, 0): Print " Note Length (single notes):"
Color _RGB(255, 255, 255): Print
Print " Duration can also be Modified for individual notes by adding one or two ";: Color _RGB(255, 255, 0): Print ". (periods)";: Color _RGB(255, 255, 255): Print " to the note."
Print " A single period extends its length to 1 1/2 times, while a double period extends it"
Print " to 1 3/4 times its length."
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "C P1  C. P1 C.. P2  C P1 C. P1 C.. P2  C P1  C. P1 C..";: Color _RGB(255, 255, 255)
Sleep 1: Play "C P1  C. P1 C.. P2  C P1 C. P1 C.. P2  C P1  C. P1 C.."
Sleep 3: Cls: Print
Mood:
Color _RGB(255, 255, 0): Print " Mood:"
Color _RGB(255, 255, 255): Print
Print " The mood of music can be Modified for groups or for individual notes:"
Color _RGB(255, 255, 0): Print " MS = Staccato (3/4 length), MN = normal (7/8 length), ML = Legato (1.5 times length)":: Color _RGB(255, 255, 255)
Print " Aide de memoir: S for Short, N for Normal, L for Long)"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L2 MS CCCC P8 MN CCCC P8 ML CCCC P1 MS CCCC P8 MN CCCC P8 ML CCCC";: Color _RGB(255, 255, 255)
Sleep 1: Play "L2 MS CCCC P8 MN CCCC P8 ML CCCC P1 MS CCCC P8 MN CCCC P8 ML CCCC"
Sleep 3: Cls: Print
Speed:
Color _RGB(255, 255, 0): Print " Speed (Tempo):"
Color _RGB(255, 255, 255): Print
Print " Tempo, or speed can be from 32 to 255 quarter-notes per minute"
Print " (Default is 120 - standard military march tempo)"
Print " Use ";: Color _RGB(255, 255, 0): Print "Tn";: Color _RGB(255, 255, 255): Print " (where n is from 32 to 255)"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "O3 T90 CDEFGAB O4C T120 CDEFGAB O3C T240 CDEFGAB O4C": Color _RGB(255, 255, 255)
Sleep 1: Play "O3 T90 CDEFGAB O4C T120 O3 CDEFGAB O4C T240 O3 CDEFGAB O4C"
Sleep 3: Cls: Print
Volume:
Color _RGB(255, 255, 0): Print " Volume:"
Color _RGB(255, 255, 255): Print
Print " Volume is specified with ";: Color _RGB(255, 255, 0): Print " Vn";: Color _RGB(255, 255, 255): Print ", where n can be be 0 to 100)"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L2 V100 C P16 V75 C P16 V50 C P16 V25 C V100 C P16 V75 C P16 V50 C P16 V25 C": Color _RGB(255, 255, 255)
Sleep 1: Play "L2 V100 C P16 V75 C P16 V50 C P16 V25 C V100 C P16 V75 C P16 V50 C P16 V25 C"
Sleep 3: Cls: Print
Polyphonics:
Color _RGB(255, 255, 0): Print " Polyphonics:"
Color _RGB(255, 255, 255): Print
Print " Polyphonics (multiple notes simultaneously) is provided with commas between notes"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L1 O3 C,E,G,O4 C P4 O3 C,E,G,O4 C P4 O3 C,E,G,O4 C": Color _RGB(255, 255, 255)
Sleep 1: Play "L1 O3 C,E,G,O4 C P4 O3 C,E,G,O4 C P4 O3 C,E,G,O4 C"
Sleep 3: Cls: Print
BackgroundSound:
Color _RGB(255, 255, 0): Print " Background Sound:"
Color _RGB(255, 255, 255): Print
Print " A programme can either continue executing, or pause while music is played."
Color _RGB(255, 255, 0): Print " MF (Music Foreground) pauses programme, MB allows programme to continue.": Color _RGB(255, 255, 255)
Print: Print " Example: (Press a key)":
Play "MF L2 O3 CDEFGAB O4 C"
For a = 1 To 4: Print " Music has finished!": _Delay .2: Next
Sleep 1: Play "MB L2 O3 CDEFGAB O4 C"
For a = 1 To 4: Print " Music is playing!";: _Delay .2: Next
Sleep 3: Cls: Print
timbre:
Color _RGB(255, 255, 0): Print " Timbre (richness):"
Color _RGB(255, 255, 255): Print
Print " The timbre, or texture  of notes can be changed by changing their waveform with the ";: Color _RGB(255, 255, 0): Print " @";: Color _RGB(255, 255, 255): Print " symbol."
Print " There are 5 waveforms: ";: Color _RGB(255, 255, 0): Print "1=square,  2=sawtooth,  3=triangle,  4=sine,  5=white-noise": Color _RGB(255, 255, 255)
Print " (You may need to turn volume up to hear the difference here)"
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print " L2 @1 C P2 @2 C P2 @3 C P2 @4 C P2 @5 C P4 @1 C P2 @2 C P2 @3 C P2 @4 C P3 @4 C": Color _RGB(255, 255, 255)
Sleep 1: Play "L2 @1 C P2 @2 C P2 @3 C P2 @4 C P2 @5 C P4 @1 C P2 @2 C P2 @3 C P2 @4 C P3 @4 C"
Print " (the reason for the final @4 in this string, is that the @ is sticky, and remains for the next PLAY string)."
Sleep 3: Cls: Print
accent:
Color _RGB(255, 255, 0): Print " Accent (attack):"
Color _RGB(255, 255, 255): Print
Print " The attack rate of notes can be changed with ";: Color _RGB(255, 255, 0): Print "Q";: Color _RGB(255, 255, 255): Print " (can be from 0 to 100)."
Print " This changes note from, say the emphatic piano sound, to the softer sound of a flute."
Print: Print " Example: ";: Color _RGB(255, 255, 0): Print "L2  Q0 CEG P1  Q50 CEG P1  Q100 CEG": Color _RGB(255, 255, 255)
Sleep 1: Play "L2  Q0 CEG P1  Q50 CEG P1  Q100 CEG": Sleep 1
Print: Print " Press a key to finish"
Sleep: System