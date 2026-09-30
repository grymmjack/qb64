# PC-SPEAKER: the DOS PC speaker, rebuilt in QB64-PE

**Short version:** this folder plays old-school PC speaker sounds, including the
**Duke Nukem 1** (`.DN1`) and **Commander Keen** (`.CK1`) sound effects, in
QB64-PE on a modern computer. It is written entirely in QB64-PE, with no C and
no `DECLARE LIBRARY`.

![DN1PLAY playing the Duke Nukem 1 BOMBEXPLODE sound](SCREENSHOTS/1-duke-bombexplode.png)

It is a port of the Borland C++ code from **NCOT Technology's** video about
programming the PC speaker under MS-DOS. The original code is at
[ncot-tech/pc-speaker](https://github.com/ncot-tech/pc-speaker), with a copy at
[grymmjack/ncot-pc-speaker](https://github.com/grymmjack/ncot-pc-speaker).

**📺 Video:** [https://youtu.be/bH8UITZadf4](https://youtu.be/bH8UITZadf4).
Every C program in the video has a QB64-PE version here. See
[Follow along with the video](#follow-along-with-the-video) for which file
goes with which part.

Built and tested with the QB64-PE **v4.7.0-GLFW** compiler.

---

## Quick start

1. Open **`DN1PLAY.BAS`** in QB64-PE.
2. Press **F5**.
3. Use the arrow keys to pick a sound, then press **Enter** to hear it.
4. Press **A** to play every sound in order.
5. Press **Tab** to switch to the Commander Keen sounds.

| Key | What it does |
| --- | --- |
| Up / Down / PgUp / PgDn / Home / End, mouse wheel | pick a sound |
| Enter / Space / mouse click | play it |
| A | play everything, starting at the selected sound (press A again to stop) |
| S | stop |
| + / - | speed the sound up or slow it down by 5 Hz |
| R | reset the speed to 140 Hz |
| L | low-pass filter on/off (muffles the sound like a small speaker) |
| W | save the selected sound as a `.wav` in `EXPORT/` |
| E | save every sound as a `.wav` in `EXPORT/` |
| Tab | load the next sound bank in the folder |
| Esc | quit |

You can also drag any `.DN1`/`.DN2`/`.DN3`/`.CK1`/`.CK2`/`.CK3` file onto the
window, or pass one on the command line: `DN1PLAY path/to/file.dn1`.

---

## Screenshots

The sound list is on the left and details of the selected sound are on the
right. The graph shows the sound's pitch over time: orange bars are notes, grey
ticks along the bottom are silence, and the white line is the play position.

**Duke Nukem 1: `BOMBEXPLODE` playing** (`duke1-b.dn1`, 24 sounds)

![DN1PLAY playing the Duke Nukem 1 BOMBEXPLODE sound](SCREENSHOTS/1-duke-bombexplode.png)

**Duke Nukem 1: `BADGUYGOUP` playing**

![DN1PLAY playing the Duke Nukem 1 BADGUYGOUP sound](SCREENSHOTS/2-duke-badguygoup.png)

**Commander Keen 1: `LVLDONESND` playing** (`SOUNDS.CK1`, 63 sounds; press Tab to switch to it)

![DN1PLAY playing the Commander Keen LVLDONESND sound](SCREENSHOTS/3-keen-lvldone.png)

---

## What we did, in plain English

### 1. How the real PC speaker worked

The original IBM PC speaker could not play recorded audio or mix sounds. It was
a **1-bit device**: at any moment the speaker cone was either pushed **out** or
pulled **in**. That was all it could do.

To make a tone, the PC used a timer chip, the **PIT** (8253/8254). The PIT has
three counters driven by a 1,193,182 Hz clock:

* **Counter 0** fires the system timer interrupt 18.2 times per second (INT 08h,
  which calls INT 1Ch). Programs hook this to do something on a steady beat.
* **Counter 2** is wired to the speaker. You give it a number, called the
  **divisor**, and it flips the speaker out and in at `1193182 / divisor` Hz.
  For example, a divisor of 2711 gives 440 Hz, the note A4.
* **Port 61h** switches the counter 2 connection to the speaker on or off.

In C that looks like this:

```c
outportb(0x43, 0xB6);          // counter 2, square wave mode
outportb(0x42, divisor & 255); // divisor, low byte
outportb(0x42, divisor >> 8);  // divisor, high byte
outportb(0x61, inportb(0x61) | 3);  // connect the speaker
```

### 2. How Duke Nukem 1 and Keen stored sounds

Games made sound effects by changing the divisor quickly: **140 times per
second**. A sound effect is just a list of divisors:

```
4050, 4050, 3800, 3500, 0, 0, 2900, ... $FFFF
  |                       |              |
  | one value per 1/140 s | 0 = silence  | $FFFF = end of sound
```

`.DN1` and `.CK1` files are banks of these lists with a small header on the
front. The format is under **File format** below.

### 3. How we rebuilt it in QB64-PE

Modern computers have no PC speaker port to write to, so **`PCSPKR.BM` pretends
to be the hardware**:

```
your program                    PCSPKR.BM (fake hardware)                      QB64-PE audio
─────────────                   ─────────────────────────                      ─────────────
PCSPK_SetDivisor 2711   ──►   counter 2 flips the speaker out/in at      ──►   _SNDRAWBATCH  (live)
PCSPK_Off                     1,193,182 steps per second (1-bit signal)        _SNDNEW       (pre-rendered)
                              │                                                .WAV export
                              ▼
                              averaged down to the sound card's rate
                              (e.g. 48,000 samples per second)
                              │
                              ▼
                              "speaker cone" filter (removes DC offset,
                              optional low-pass)
```

* **It simulates the chip at full speed.** For each sample the sound card needs,
  it works out how much of that time the speaker was "out" and uses the average.
  That keeps the buzzy 1-bit character of a real PC speaker without the digital
  crackle you get from sampling it naively.
* **The timer interrupt is replaced by `PCSPK_Tick`.** In DOS you hooked INT 1Ch
  and the CPU called your code 18.2 times a second. Here the audio stream sets
  the pace. `PCSPK_Tick` renders one tick of sound, then returns so you can run
  your handler:

  ```basic
  DO WHILE PCSPK_Tick   ' one timer tick of audio just got rendered...
      my_handler        ' ...so run what used to be the interrupt handler
  LOOP
  ```

  This is more accurate than the DOS original. Every handler call lines up with
  the exact audio sample, so the timing never drifts.

---

## Follow along with the video

Each timestamp jumps to the part of the video where the C version is explained.
The file next to it is the QB64-PE version.

| Video | What happens | QB64-PE file |
| --- | --- | --- |
| [5:56](https://youtu.be/bH8UITZadf4?t=356) | The 8253 PIT: channel 2 wired to the speaker, divisors, port 61h | `PCSPKR.BM`, which emulates all of it |
| [9:54](https://youtu.be/bH8UITZadf4?t=594) | `play_sound`, `no_sound`, `timer_wait`: a single beep | `BEEP.BAS` |
| [11:13](https://youtu.be/bH8UITZadf4?t=673) | Hooking INT 1Ch so the program keeps running while the tone plays | `BEEP2.BAS` (and `INTTEST.BAS`) |
| [14:05](https://youtu.be/bH8UITZadf4?t=845) | The Tetris tune from hand-transcribed sheet music | `BEEP3.BAS`, press **2** |
| [16:47](https://youtu.be/bH8UITZadf4?t=1007) | The 330-note tune converted from MIDI (Doom's E1M1 bassline) | `BEEP3.BAS`, press **1** |
| [24:55](https://youtu.be/bH8UITZadf4?t=1495) | Pulling the sound effects out of Commander Keen's `SOUNDS.CK1` | `BEEP4.BAS`, then **`DN1PLAY.BAS`** for Keen and Duke |
| [31:34](https://youtu.be/bH8UITZadf4?t=1894) | How PWM works | the PWM section below |
| [34:48](https://youtu.be/bH8UITZadf4?t=2088) | The sine-wave PWM code | `PWM.BAS` |
| [36:32](https://youtu.be/bH8UITZadf4?t=2192) | Playing a real WAV file, and the fight with DOS's 64K memory segments | `WAV.BAS` |

A few things work out differently in QB64-PE:

* **No 64K memory limit.** Most of the WAV section of the video is about
  `LOADFILE.C` reading the file in chunks of less than 32K, plus far pointers and
  `farmalloc`. None of that is needed in QB64-PE: the whole file goes into one
  string, so `LOADFILE.C` has no port.
* **The "crunchy" Keen sounds.** At 27:59 the video says its Keen playback
  sounds crunchier than the real game. `BEEP4.BAS` copies the C, which
  reprograms the timer every 7 ms, so it sounds the same as in the video.
  `DN1PLAY.BAS` plays at 140 samples per second and only reprograms the timer
  when the value changes, which is how id Software's sound code worked, as far
  as I remember. That may be why the C version sounds crunchier. Compare the
  two and see.
* **`PWM.C` doesn't quite do what the video describes.** The explanation at
  32:00 is correct: flip the speaker at a fast fixed rate and vary how long it
  stays on. The C code at 34:48 instead feeds each sample to the timer as a
  square-wave divisor, which makes a warbly noise. `PWM.BAS` reproduces that,
  and pressing **M** switches to real PWM as the video describes it: a clean
  sine wave with a faint 8 kHz whine.
* **No crashing.** In the video a crash leaves the speaker beeping forever,
  and the WAV player won't run inside the Borland editor because there isn't
  enough conventional memory. Neither can happen here.

## What's in this folder

| File | What it is | Ported from |
| --- | --- | --- |
| **`DN1PLAY.BAS`** | **The Duke Nukem / Keen sound player. Start here.** | new |
| `PCSPKR.BI` + `PCSPKR.BM` | The fake PC speaker library. Put the `.BI` at the top of your program and the `.BM` at the bottom. | `BEEPER.C`, `WAVLOAD.C`, `LOADFILE.C`, `BEEP4.C` |
| `NOTES.BI` | Named divisors for musical notes (`NOTE_A4`, `NOTE_C5`, ...) | `NOTES.H` |
| `BEEP.BAS` | The smallest possible example: 440 Hz for 5 timer ticks | `BEEP.C` |
| `INTTEST.BAS` | Hooks the timer and counts 18 ticks. No sound; uses QB64's `ON TIMER`. | `INTTEST.C` |
| `BEEP2.BAS` | A tone plus a timer countdown | `BEEP2.C` |
| `BEEP3.BAS` | A music player driven by the timer interrupt (press 1 or 2 to pick a tune) | `BEEP3.C` + `MELODY.C` |
| `BEEP4.BAS` | Plays the first 20 Commander Keen sounds, the same way the C did | `BEEP4.C` |
| `PWM.BAS` | Tries to play a sine wave on a 1-bit speaker. Press M to hear what the C really did (warbly noise) versus true PWM (a clean tone). | `PWM.C` |
| `WAV.BAS` | Plays real 8-bit `.wav` files through the 1-bit speaker using PWM. Press C to compare with normal playback. | `WAV.C` |
| `ASSETS/` | `duke1-b.dn1` (Duke), `SOUNDS.CK1` (Keen), and three test `.wav` files | original repo |
| `SCREENSHOTS/` | The images in this README | |

### PWM: playing recordings on a speaker with two positions

`WAV.BAS` and `PWM.BAS` use the cleverest trick here. The speaker can only be in
or out, but if you flip it **8,000 times a second** and vary how long it stays
out each time, the cone can't keep up. It averages the pulses, so a long pulse
sounds "loud" and a short pulse sounds "quiet". That is **pulse width
modulation (PWM)**. It is how DOS games squeezed speech and sampled sound out of
a beeper. You'll also hear a high 8 kHz whine; real PC speakers made it too.

---

## Cheat sheet: C to QB64-PE

| C (Borland, DOS) | QB64-PE (`PCSPKR.BM`) |
| --- | --- |
| `play_sound(divisor)` | `PCSPK_SetDivisor divisor` |
| `play_sound_freq(freq)` | `PCSPK_SetFreq freq` |
| `nosound()` | `PCSPK_Off` |
| `outportb(0x43, 0xB6/0xB0)` + divisor on `0x42` | `PCSPK_PitWrite PCSPK_MODE_SQUARE/PCSPK_MODE_ONESHOT, count` |
| `outportb(0x61, inportb(0x61) \| 3)` | `PCSPK_SpeakerOn` |
| reprogram PIT counter 0 (`0x40`) | `PCSPK_SetTickDivisor d` or `PCSPK_SetTickRate hz` |
| `setvect(0x1C, handler)` + wait loop | `DO WHILE PCSPK_Tick: handler: LOOP` |
| `timer_wait(n)` / `delay(ms)` | `PCSPK_WaitTicks n` / `PCSPK_WaitSeconds s` |

## Library reference (`PCSPKR.BM`)

* **Speaker:** `PCSPK_SetDivisor`, `PCSPK_SetFreq`, `PCSPK_Off`, `PCSPK_PitWrite`,
  `PCSPK_SpeakerOn`, `PCSPK_SpeakerOff`, `PCSPK_SetVolume`, `PCSPK_SetLowPass`
* **Live playback:** `PCSPK_Tick`, `PCSPK_SetTickRate`, `PCSPK_SetTickDivisor`,
  `PCSPK_WaitTicks`, `PCSPK_WaitSeconds`, `PCSPK_Drain` (wait until everything
  has played), `PCSPK_SetLead`, `PCSPK_StreamClose`
* **Pre-render a sound:** call `PCSPK_CaptureBegin`, then `PCSPK_SetDivisor` and
  `PCSPK_AdvanceSeconds` as needed. `PCSPK_CaptureEnd&` returns a handle you can
  `_SNDPLAY`. `PCSPK_SaveWAV "file.wav"` writes the capture to a file.
* **Duke/Keen banks:** `PCSPK_IFSLoad`, `PCSPK_IFSCount`, `PCSPK_IFSName`,
  `PCSPK_IFSSamples`, `PCSPK_IFSValue`, `PCSPK_IFSOffset`, `PCSPK_IFSPriority`,
  `PCSPK_IFSRender&(index, hz)`
* **8-bit WAV files:** `PCSPK_WavLoad`, `PCSPK_WavRate`, `PCSPK_WavLength`,
  `PCSPK_WavSample`, `PCSPK_WavError`

A minimal program:

```basic
'$INCLUDE:'PCSPKR.BI'
PCSPK_SetFreq 440     ' beep...
PCSPK_WaitSeconds 0.5
PCSPK_Off             ' ...stop
PCSPK_Drain
END
'$INCLUDE:'PCSPKR.BM'
```

## File format: `.DN1` / `.CK1` (Inverse Frequency Sound)

```
Header (16 bytes)
  0   "SND",0        signature
  4   uint16         file size
  6   uint16         number of sounds
  8   uint16         unknown
  10  6 bytes        padding
Sound table (16 bytes per sound)
  0   uint16         where this sound's data starts
  2   uint8          priority (the game uses it to decide which sound wins)
  3   uint8          always 8
  4   char[12]       name, e.g. "BOMBEXPLODE"
Sound data
  uint16 per step: PIT divisor, 0 = silence, $FFFF = end. 140 steps per second.
```

The original `BEEP4.C` reads the sound count from byte 8 instead of byte 6, so it
reports 50 sounds for Duke and 60 for Keen. The real counts are **24** and
**63**. The QB64-PE version reads the right field.

## Notes and gotchas

* **The 140 Hz playback rate is from memory, not checked against a source.** If
  Duke sounds too fast or too slow, adjust it with +/- in `DN1PLAY`.
  `BEEP4.BAS` deliberately keeps the C code's timing: 7 ms per step, about
  143 Hz.
* The original repo has `duke1-b.dn1`, `.dn2` and `.dn3`, but they are
  byte-for-byte identical, so only `.dn1` is included.
* A compiled QB64-PE program starts in its own folder. `PCSPK_FindFile$` looks
  for the `ASSETS/` files next to the program, in the folder you launched from,
  or in the current folder. `EXPORT/` is created next to the program.
* This was built on a machine with no sound card. The audio was checked by
  rendering to `.wav` and measuring it: a 440 Hz tone measures 440 Hz, and the
  PWM sine peaks at 440 Hz. It has not been listened to on real speakers yet.
