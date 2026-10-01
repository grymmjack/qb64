#!/usr/bin/env python3
"""
make_tunes.py - write the example tunes as MIDI files (MIDI/*.mid).

MID2SND turns them into PC speaker banks (see make_tunes.sh). Each tune is
a tempo, a time signature and up to 4 parts at once. A part is a string of
notes:

    C5:q  D#4:e.  Bb3:h  r:s  C4+E4+G4:h  A2:6

    pitch   C D E F G A B, then # or b, then the octave (C4 = middle C);
            r = rest; + joins notes into a chord
    length  w h q e s t (whole ... 32nd), a dot makes it half as long again,
            or a number of 16ths

Everything here is either public domain (the composers died long ago) or
written for this project.
"""
import os, struct

TPQ = 480
LEN = {'w': 1920, 'h': 960, 'q': 480, 'e': 240, 's': 120, 't': 60}
NOTE = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}


def pitch(n):
    p = NOTE[n[0].upper()]
    i = 1
    while n[i] in '#b':
        p += 1 if n[i] == '#' else -1
        i += 1
    return p + (int(n[i:]) + 1) * 12


def dur(d):
    if d.isdigit():
        return int(d) * 120
    t = LEN[d[0]]
    if d.endswith('.'):
        t = t * 3 // 2
    return t


def parse(part):
    """[(start tick, length, pitch)] and the part's total length"""
    out, t = [], 0
    for tok in part.split():
        n, d = tok.split(':')
        ln = dur(d)
        if n != 'r':
            for x in n.split('+'):
                out.append((t, ln, pitch(x)))
        t += ln
    return out, t


def vlq(v):
    b = [v & 127]
    v >>= 7
    while v:
        b.insert(0, (v & 127) | 128)
        v >>= 7
    return bytes(b)


def track(events):
    """events: [(tick, bytes)] -> MTrk chunk"""
    events.sort(key=lambda e: (e[0], e[1][0] & 0xF0 == 0x90))  # offs before ons
    data, last = b'', 0
    for t, ev in events:
        data += vlq(t - last) + ev
        last = t
    data += b'\x00\xff\x2f\x00'
    return b'MTrk' + struct.pack('>I', len(data)) + data


def write_mid(path, title, tempo, parts, beats=4):
    """tempo: BPM or [(quarter beat, BPM), ...]"""
    if not isinstance(tempo, list):
        tempo = [(0, tempo)]
    t0 = [(0, b'\xff\x03' + vlq(len(title)) + title.encode()),
          (0, b'\xff\x58\x04' + bytes([beats, 2, 24, 8]))]
    for beat, bpm in tempo:
        us = int(60000000 / bpm)
        t0.append((int(beat * TPQ), b'\xff\x51\x03' + struct.pack('>I', us)[1:]))
    chunks = [track(t0)]
    for ch, part in enumerate(parts):
        notes, _ = parse(part)
        ev = []
        for t, ln, p in notes:
            ev.append((t, bytes([0x90 | ch, p, 96])))
            ev.append((t + ln, bytes([0x80 | ch, p, 0])))
        chunks.append(track(ev))
    hdr = b'MThd' + struct.pack('>IHHH', 6, 1, len(chunks), TPQ)
    with open(path, 'wb') as f:
        f.write(hdr + b''.join(chunks))


# --- accompaniment helpers ------------------------------------------------

# two-note chord voicings (under the melody) and bass roots
CH = {
    'C': ('E4+G4', 'C3', 'G2'), 'Cm': ('Eb4+G4', 'C3', 'G2'),
    'D': ('F#4+A4', 'D3', 'A2'), 'Dm': ('F4+A4', 'D3', 'A2'),
    'E': ('G#4+B4', 'E3', 'B2'), 'Em': ('G4+B4', 'E3', 'B2'),
    'F': ('F4+A4', 'F2', 'C3'), 'F#m': ('F#4+A4', 'F#2', 'C#3'),
    'G': ('G4+B4', 'G2', 'D3'), 'G7': ('F4+B4', 'G2', 'D3'),
    'A': ('E4+A4', 'A2', 'E3'), 'Am': ('E4+A4', 'A2', 'E3'), 'A7': ('E4+G4', 'A2', 'E3'),
    'Bm': ('D4+F#4', 'B2', 'F#3'), 'B': ('D#4+F#4', 'B2', 'F#3'),
    'D7': ('F#4+C5', 'D3', 'A2'), 'C#': ('F4+G#4', 'C#3', 'G#2'),
}


def low(ch, octs=1):
    """chord voicing an octave (or more) lower"""
    out = []
    for n in ch.split('+'):
        i = len(n) - 1
        out.append(n[:i] + str(int(n[i]) - octs))
    return '+'.join(out)


def block(chords, beats, voice_oct=0):
    """held two-note chords, one per entry, each 'beats' quarters long"""
    d = str(beats * 4)
    return ' '.join((CH[c][0] if voice_oct == 0 else low(CH[c][0], voice_oct)) + ':' + d
                    if c != '-' else 'r:' + d for c in chords)


def bass_pump(chords, beats):
    """root - fifth in quarters"""
    out = []
    for c in chords:
        if c == '-':
            out.append('r:' + str(beats * 4))
            continue
        _, r, f = CH[c]
        for b in range(beats):
            out.append((r if b % 2 == 0 else f) + ':e' + ' r:e')
    return ' '.join(out)


def bass_octaves(chords, beats):
    """bouncing octave eighths (Korobeiniki style)"""
    out = []
    for c in chords:
        r = CH[c][1]
        hi = r[:-1] + str(int(r[-1]) + 1)
        out += [r + ':e', hi + ':e'] * beats
    return ' '.join(out)


def waltz(chords):
    """3/4: bass on 1, chord on 2 and 3"""
    out_b, out_c = [], []
    for c in chords:
        if c == '-':
            out_b.append('r:q.'), out_b.append('r:q.')
            out_c.append('r:h.')
            continue
        v, r, _ = CH[c]
        out_b.append(r + ':h.')
        out_c.append('r:q ' + low(v) + ':q ' + low(v) + ':q')
    return ' '.join(out_b), ' '.join(out_c)


def oompah(chords, beats=4):
    """4/4: chord on the off beats (2 and 4)"""
    out = []
    for c in chords:
        v = low(CH[c][0])
        out.append(' '.join(['r:q ' + v + ':q'] * (beats // 2)))
    return ' '.join(out)


TUNES = {}

# --- Ode to Joy (Beethoven, 1824) -------------------------------------------
a1 = "F#5:q F#5:q G5:q A5:q A5:q G5:q F#5:q E5:q D5:q D5:q E5:q F#5:q F#5:q. E5:e E5:h"
a2 = "F#5:q F#5:q G5:q A5:q A5:q G5:q F#5:q E5:q D5:q D5:q E5:q F#5:q E5:q. D5:e D5:h"
b = "E5:q E5:q F#5:q D5:q E5:q F#5:e G5:e F#5:q D5:q E5:q F#5:e G5:e F#5:q E5:q D5:q E5:q A4:h"
ch = ('D D A A D D A A ' 'D D A A D D A D ' 'A D A D A Bm E A ' 'D D A A D D A D').split()
TUNES['ODETOJOY'] = dict(title='Ode to Joy', tempo=132, parts=[
    ' '.join([a1, a2, b, a2]), block(ch, 2), bass_pump(ch, 2)])

# --- Fur Elise (Beethoven, 1810), the opening ----------------------------------
rh_a = ("E5:s D#5:s E5:s B4:s D5:s C5:s A4:e r:s C4:s E4:s A4:s B4:e r:s E4:s G#4:s B4:s "
        "C5:e r:s E4:s E5:s D#5:s E5:s D#5:s E5:s B4:s D5:s C5:s A4:e r:s C4:s E4:s A4:s "
        "B4:e r:s E4:s C5:s B4:s")
rh_b = ("A4:e r:s B4:s C5:s D5:s E5:e. G4:s F5:s E5:s D5:e. F4:s E5:s D5:s C5:e. E4:s D5:s C5:s "
        "B4:e r:s E4:s E5:s D#5:s")
lh_bars_a = ['-', 'A2 E3 A3', 'E2 E3 G#3', 'A2 E3 A3', '-', 'A2 E3 A3', 'E2 E3 G#3']
lh_bars_b = ['A2 E3 A3', 'C3 G3 C4', 'G2 G3 B3', 'A2 E3 A3', 'E2 E3 E4']
lh_end = ['A2 E3 A3']


def lh_arp(bars):
    """left hand 16th arpeggios, held with the pedal: 3 parts"""
    p = ['', '', '']
    for bar in bars:
        if bar == '-':
            for i in range(3):
                p[i] += ' r:6'
            continue
        n = bar.split()
        p[0] += ' %s:6' % n[0]
        p[1] += ' r:1 %s:5' % n[1]
        p[2] += ' r:2 %s:4' % n[2]
    return p


lh = lh_arp(lh_bars_a + lh_bars_b + lh_bars_a + lh_end)
TUNES['FURELISE'] = dict(title='Fur Elise', tempo=112, beats=3, parts=[
    'E5:s D#5:s ' + rh_a + ' ' + rh_b + ' ' + rh_a + ' A4:q.',
    'r:2' + lh[0], 'r:2' + lh[1], 'r:2' + lh[2]])

# --- Korobeiniki (Russian folk song; the Tetris theme) ------------------------
ka = ("E5:q B4:e C5:e D5:q C5:e B4:e A4:q A4:e C5:e E5:q D5:e C5:e B4:q. C5:e D5:q E5:q "
      "C5:q A4:q A4:q r:q r:e D5:q F5:e A5:q G5:e F5:e E5:q. C5:e E5:q D5:e C5:e "
      "B4:q B4:e C5:e D5:q E5:q C5:q A4:q A4:q r:q")
kb = "E5:h C5:h D5:h B4:h C5:h A4:h G#4:h B4:h E5:h C5:h D5:h B4:h C5:q E5:q A5:h G#5:w"
kca = 'E Am E Am Dm C E Am'.split()
kcb = 'Am E Am E Am E Am E'.split()
TUNES['KOROBEINIK'] = dict(title='Korobeiniki', tempo=150, parts=[
    ' '.join([ka, ka, kb]),
    bass_octaves(kca + kca + kcb, 4),
    block(kca + kca + kcb, 4, 1)])

# --- Greensleeves (English, 16th century) ---------------------------------------
gv = ("C5:h D5:q E5:q. F5:e E5:q D5:h B4:q G4:q. A4:e B4:q C5:h A4:q A4:q. G#4:e A4:q "
      "B4:h G#4:q E4:h A4:q C5:h D5:q E5:q. F5:e E5:q D5:h B4:q G4:q. A4:e B4:q "
      "C5:q. B4:e A4:q G#4:q. F#4:e G#4:q A4:h. A4:h. "
      "G5:h. G5:q. F#5:e E5:q D5:h B4:q G4:q. A4:e B4:q C5:h A4:q A4:q. G#4:e A4:q "
      "B4:h G#4:q E4:h. G5:h. G5:q. F#5:e E5:q D5:h B4:q G4:q. A4:e B4:q "
      "C5:q. B4:e A4:q G#4:q. F#4:e G#4:q A4:h. A4:h.")
gch = ('Am C G Em Am Am E E Am C G Em Am E Am Am '
       'C C G Em Am E E E C C G Em Am E Am Am').split()
gb, gc = waltz(gch)
TUNES['GREENSLEEV'] = dict(title='Greensleeves', tempo=140, beats=3, parts=[
    'A4:q ' + gv, 'r:q ' + gb, 'r:q ' + gc])

# --- Minuet in G (Petzold, from the Notebook for Anna Magdalena Bach) -----------
m1 = ("D5:q G4:e A4:e B4:e C5:e D5:q G4:q G4:q E5:q C5:e D5:e E5:e F#5:e G5:q G4:q G4:q "
      "C5:q D5:e C5:e B4:e A4:e B4:q C5:e B4:e A4:e G4:e F#4:q G4:e A4:e B4:e G4:e A4:h.")
m2 = ("D5:q G4:e A4:e B4:e C5:e D5:q G4:q G4:q E5:q C5:e D5:e E5:e F#5:e G5:q G4:q G4:q "
      "C5:q D5:e C5:e B4:e A4:e B4:q C5:e B4:e A4:e G4:e A4:q B4:e A4:e G4:e F#4:e G4:h.")
mb = ("G3+B3:h A3:q B3:h. C4:h. B3:h. A3:h. G3:h. D4:h B3:q D4:q D3:q C4:q "
      "B3:h A3:q G3:h B3:q C4:h. B3:q C4:q B3:q A3:h G3:q B3:h. D4:q D3:q F#3:q G3:h.")
TUNES['MINUETG'] = dict(title='Minuet in G', tempo=120, beats=3, parts=[m1 + ' ' + m2, mb])

# --- Canon in D (Pachelbel, around 1690) ------------------------------------------
cprog = 'D A Bm F#m G D G A'.split()
c_bass = 'D3:h A2:h B2:h F#2:h G2:h D2:h G2:h A2:h'
c_mel = ("F#5:h E5:h D5:h C#5:h B4:h A4:h B4:h C#5:h "
         "D5:h C#5:h B4:h A4:h G4:h F#4:h G4:h E4:h "
         "D5:q F#5:q A5:q G5:q F#5:q D5:q F#5:q E5:q D5:q B4:q D5:q A5:q G5:q B5:q A5:q G5:q "
         "F#5:q D5:q E5:q C#6:q D6:q F#6:q A6:q A5:q B5:q G5:q A5:q F#5:q D5:q D6:q D6:q C#6:q "
         "D6:w")
c_inner = {'D': 'D4+F#4', 'A': 'C#4+E4', 'Bm': 'D4+F#4', 'F#m': 'C#4+F#4', 'G': 'B3+D4'}
c_ch = ' '.join(c_inner[c] + ':h' for c in cprog)
TUNES['CANOND'] = dict(title='Canon in D', tempo=96, parts=[
    c_mel,
    ' '.join([c_ch] * 4) + ' D4+F#4:w',
    ' '.join([c_bass] * 4) + ' D3:w'])

# --- In the Hall of the Mountain King (Grieg, 1875), speeding up ---------------
hk = ("B3:e C#4:e D4:e E4:e F#4:e D4:e F#4:q F4:e C#4:e F4:q E4:e C4:e E4:q "
      "B3:e C#4:e D4:e E4:e F#4:e D4:e F#4:e B4:e A4:e F#4:e D4:e F#4:e A4:h")


def up(s, n):
    out = []
    for tok in s.split():
        p, d = tok.split(':')
        out.append(p[:-1] + str(int(p[-1]) + n) + ':' + d)
    return ' '.join(out)


hbass = ' '.join(['B2:e r:e'] * 4 + ['F#2:e r:e'] * 4 + ['B2:e r:e'] * 4 + ['F#2:e r:e'] * 4)
TUNES['MTNKING'] = dict(title='In the Hall of the Mountain King',
                        tempo=[(0, 96), (16, 116), (32, 140), (48, 168), (64, 200)],
                        parts=[' '.join([hk, hk, up(hk, 1), up(hk, 1), up(hk, 1)]) + ' B5:q',
                               ' '.join([hbass] * 5) + ' B2:q',
                               'r:w r:w r:w r:w ' + ' '.join([up(hk, -1)] * 4) + ' B3:q'])

# --- Happy Birthday (Hill sisters, 1893; public domain) -------------------------
hb = ("G4:e. G4:s A4:q G4:q C5:q B4:h G4:e. G4:s A4:q G4:q D5:q C5:h G4:e. G4:s "
      "G5:q E5:q C5:q B4:q A4:q F5:e. F5:s E5:q C5:q D5:q C5:h.")
hbb, hbc = waltz('C G G C C F G C'.split())
TUNES['BIRTHDAY'] = dict(title='Happy Birthday', tempo=120, beats=3, parts=[
    hb, 'r:q ' + hbb, 'r:q ' + hbc])

# --- Jingle Bells (Pierpont, 1857), the chorus -------------------------------------
jb = ("E5:q E5:q E5:h E5:q E5:q E5:h E5:q G5:q C5:q. D5:e E5:w "
      "F5:q F5:q F5:q. F5:e F5:q E5:q E5:q E5:e E5:e E5:q D5:q D5:q E5:q D5:h G5:h "
      "E5:q E5:q E5:h E5:q E5:q E5:h E5:q G5:q C5:q. D5:e E5:w "
      "F5:q F5:q F5:q F5:q F5:q E5:q E5:q E5:e E5:e G5:q G5:q F5:q D5:q C5:w")
jch = 'C C C C F C D7 G C C C C F C G C'.split()
TUNES['JINGLEBELL'] = dict(title='Jingle Bells', tempo=160, parts=[
    jb, oompah(jch), bass_pump(jch, 4)])

# --- originals --------------------------------------------------------------
TUNES['FANFARE'] = dict(title='Fanfare', tempo=132, parts=[
    "C5:e C5:s C5:s C5:e G4:e C5:e E5:e G5:q E5:e. G5:s C6:h.",
    "E4:e E4:s E4:s E4:e E4:e G4:e C5:e E5:q C5:e. E5:s G5:h.",
    "C3:q r:e C3:e C3:q C3:q G2:q C3:h."])
TUNES['LEVELUP'] = dict(title='Level up', tempo=150, parts=[
    "C5:s E5:s G5:s C6:s F5:s A5:s C6:s F6:s G5:s B5:s D6:s G6:s C6:h",
    "E4:q A4:q B4:q E4+G4:h",
    "C3:q F3:q G3:q C3:h"])
TUNES['GAMEOVER'] = dict(title='Game over', tempo=76, parts=[
    "G4:q F#4:q F4:q E4:h.",
    "E4:q D#4:q D4:q C#4:h.",
    "C3:q B2:q Bb2:q A2:h."])
cl_mel = ("A5:q. G5:e E5:q C5:q F5:q. E5:e C5:q A4:q G5:q. E5:e C5:q E5:q D5:h B4:h "
          "A5:q. G5:e E5:q C5:q F5:q. E5:e C5:q A4:q G5:q. E5:e C5:q D5:e E5:e C5:w")
cl_ch = 'Am F C G Am F C C'.split()
arp = {'Am': 'A3 C4 E4 C4', 'F': 'F3 A3 C4 A3', 'C': 'C4 E4 G4 E4', 'G': 'G3 B3 D4 B3'}
cl_arp = ' '.join(n + ':s' for c in cl_ch for n in arp[c].split() * 4)
TUNES['CHIPLOOP'] = dict(title='Chip loop', tempo=140, parts=[
    cl_mel, cl_arp, bass_octaves(cl_ch, 4)])


if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(os.path.join(here, 'MIDI'), exist_ok=True)
    for name, t in TUNES.items():
        lens = [parse(p)[1] for p in t['parts']]
        path = os.path.join(here, 'MIDI', name.lower() + '.mid')
        write_mid(path, t['title'], t['tempo'], t['parts'], t.get('beats', 4))
        print('%-11s %d parts, lengths in beats: %s' % (name, len(t['parts']),
                                                         ' '.join('%g' % (n / TPQ) for n in lens)))
