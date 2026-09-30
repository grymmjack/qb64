# PC-SPEAKER

A pure QB64-PE port of [ncot-pc-speaker](https://github.com/grymmjack/ncot-pc-speaker),
which was MS-DOS PC speaker code for Borland C++.

There is no C and no `DECLARE LIBRARY`. The PC speaker hardware is emulated in
BASIC and the result goes out through QB64-PE's own audio engine
(`_SNDOPENRAW`/`_SNDRAWBATCH` for real time, `_SNDNEW`/`_MEMSOUND` for
pre-rendered sounds).

Built and tested with the QB64-PE **v4.7.0-GLFW** compiler.

## Play the Duke Nukem 1 sounds

Open `DN1PLAY.BAS` in QB64-PE and run it (F5). It loads `ASSETS/duke1-b.dn1`.

| Key | Action |
| --- | --- |
| Up / Down / PgUp / PgDn / Home / End, mouse wheel | select a sound |
| Enter / Space / click | play it |
| A | play every sound, starting at the selected one |
| S | stop |
| + / - / R | change the playback rate by 5 Hz / reset it to 140 Hz |
| L | turn the speaker low-pass filter on or off |
| W / E | export the selected sound / all sounds to `EXPORT/*.wav` |
| Tab | load the next `.DN?` / `.CK?` bank in the same folder |
| Esc | quit |

Drag a `.DN1`, `.DN2`, `.DN3`, `.CK1`, `.CK2` or `.CK3` file onto the window
to load it, or pass one on the command line. Commander Keen 1-3 use the same
format, so `ASSETS/SOUNDS.CK1` works too (press Tab).

## Files

| File | From | What it does |
| --- | --- | --- |
| `PCSPKR.BI` / `PCSPKR.BM` | `BEEPER.C`, `WAVLOAD.C`, `LOADFILE.C`, `BEEP4.C` | The emulator library. Include the `.BI` at the top of a program and the `.BM` at the bottom. |
| `NOTES.BI` | `NOTES.H` | PIT divisors for notes C3 to C6 (`NOTE_A4`, `NOTE_REST`, and so on) |
| `BEEP.BAS` | `BEEP.C` | Plays 440 Hz for 5 timer ticks |
| `INTTEST.BAS` | `INTTEST.C` | Hooks the timer and counts down 18 ticks. Uses `ON TIMER`, QB64's equivalent of hooking INT 1Ch. |
| `BEEP2.BAS` | `BEEP2.C` | Plays a tone while a timer handler counts down |
| `BEEP3.BAS` | `BEEP3.C`, `MELODY.C` | A timer-driven music sequencer. Plays the 330-note `MELODY.C` or the `notes[]` tune from `BEEP3.C`. |
| `BEEP4.BAS` | `BEEP4.C` | Loads the Keen `SOUNDS.CK1` bank and plays the first 20 sounds (7 ms per sample, as in the C) |
| `PWM.BAS` | `PWM.C` | PWM sine wave at an 8 kHz tick rate. Press M to switch between the original behaviour and true PWM. |
| `WAV.BAS` | `WAV.C` | Plays 8-bit WAV files through the 1-bit speaker using one-shot PWM pulses. Press C to compare with `_SNDOPEN`. |
| `DN1PLAY.BAS` | new | Interactive IFS sound bank player with a frequency/time plot and WAV export |

## How the emulation works

* **PIT channel 2** runs in mode 3 (square wave; `outportb(0x43, 0xB6)`) or
  mode 0 (one-shot; `0xB0`). It is emulated at the real 1.193182 MHz PIT clock
  and box-filtered down to the audio rate. Each output sample is the exact
  average speaker level over the PIT clocks it covers, so you hear the real 1-bit
  timbre, including the PWM carrier whine, without aliasing.
* **Port 61h** gate and data bits are `PCSPK_SpeakerOn` and `PCSPK_SpeakerOff`.
* **The speaker cone** is modelled by a DC blocker. `PCSPK_SetLowPass hz`
  adds an optional 2-pole low-pass, which makes it sound like a small, muffled
  speaker.
* **Timer interrupts** (INT 08h/1Ch, `getvect`/`setvect`) become `PCSPK_Tick`.
  The audio stream sets its pace, so a handler runs on exactly the right sample,
  with no jitter or drift:

  ```basic
  DO WHILE PCSPK_Tick   ' one timer tick of audio was rendered...
      my_handler        ' ...so run what used to be the interrupt handler
  LOOP
  ```

  `PCSPK_SetTickRate hz` or `PCSPK_SetTickDivisor d` reprogram the tick rate,
  like PIT channel 0 in the C code.

## C to QB64-PE cheat sheet

| C (Borland, DOS) | QB64-PE |
| --- | --- |
| `play_sound(divisor)` | `PCSPK_SetDivisor divisor` |
| `play_sound_freq(freq)` | `PCSPK_SetFreq freq` |
| `nosound()` | `PCSPK_Off` |
| `outportb(0x43,0xB6/0xB0); outportb(0x42,lo); outportb(0x42,hi)` | `PCSPK_PitWrite PCSPK_MODE_SQUARE/PCSPK_MODE_ONESHOT, count` |
| `outportb(0x61, inportb(0x61) \| 3)` | `PCSPK_SpeakerOn` |
| reprogram PIT channel 0 | `PCSPK_SetTickDivisor d` |
| `setvect(0x1C, handler)` + busy loop | `DO WHILE PCSPK_Tick: handler: LOOP` |
| `timer_wait(n)` / `delay(ms)` | `PCSPK_WaitTicks n` / `PCSPK_WaitSeconds s` |

## Library API (PCSPKR.BM)

* Speaker: `PCSPK_SetDivisor`, `PCSPK_SetFreq`, `PCSPK_Off`, `PCSPK_PitWrite`,
  `PCSPK_SpeakerOn`, `PCSPK_SpeakerOff`, `PCSPK_SetVolume`, `PCSPK_SetLowPass`
* Real time: `PCSPK_Tick`, `PCSPK_SetTickRate`, `PCSPK_SetTickDivisor`,
  `PCSPK_WaitTicks`, `PCSPK_WaitSeconds`, `PCSPK_Drain`, `PCSPK_SetLead`,
  `PCSPK_StreamClose`
* Offline: `PCSPK_CaptureBegin`, then `PCSPK_AdvanceSeconds`/`PCSPK_AdvanceClocks`,
  then `PCSPK_CaptureEnd&`, which returns a sound handle you can `_SNDPLAY`.
  `PCSPK_SaveWAV file$` writes the capture to a file.
* IFS sound banks: `PCSPK_IFSLoad`, `PCSPK_IFSCount`, `PCSPK_IFSName`,
  `PCSPK_IFSSamples`, `PCSPK_IFSValue`, `PCSPK_IFSOffset`, `PCSPK_IFSPriority`,
  `PCSPK_IFSRender&(index, hz)`
* 8-bit WAV: `PCSPK_WavLoad`, `PCSPK_WavRate`, `PCSPK_WavLength`,
  `PCSPK_WavSample`, `PCSPK_WavError`

## IFS (Inverse Frequency Sound) format

```
Header, 16 bytes:
  "SND",0 | uint16 file size | uint16 sound count | uint16 ? | 6 bytes padding
Sound table, 16 bytes per sound:
  uint16 offset | uint8 priority | uint8 (always 8) | char[12] name
Data:
  uint16 PIT divisors, 0 = silence, $FFFF = end, played at 140 per second
```

`BEEP4.C` reads the sound count from offset 8 instead of offset 6, so it prints
50 for Duke and 60 for Keen. The real counts are 24 and 63.

## Notes

* `duke1-b.dn1`, `.dn2` and `.dn3` in the original repo are identical, so only
  `.dn1` is copied here.
* A compiled QB64-PE program starts in its own folder. `PCSPK_FindFile$` looks
  for data files relative to the current directory, `_STARTDIR$` and the
  executable. `EXPORT/` is created next to the executable.
