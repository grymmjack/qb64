# PWMSFXR: layered sfxr through the PC speaker

**Short version:** [PCSFXR](../PCSFXR)'s big sibling. Build a sound effect from
**up to four voices**, each a full sfxr generator with **any of eight
waveforms** (square / pulse, sawtooth, sine, triangle, white noise, pink
noise, brown noise and a metallic 1-bit "LFSR" buzz), its own volume, pan
and start delay. Hear the mix through the emulated PC speaker with **PWM**
(the RealSound / demo scene trick that gets real audio out of a 1-bit
speaker), or clean in stereo. Then use it in a game, as QB64-PE code, as a
`.wav`, or in [PCSEDIT](../PC-SPEAKER).

Written entirely in QB64-PE, on top of the PC speaker emulator in
[`../PC-SPEAKER`](../PC-SPEAKER) and the sfxr engine in
[`../PCSFXR`](../PCSFXR).

## Quick start

1. Open **`PWMSFXR.BAS`** in QB64-PE and press **F5**.
2. Click a **Generator** button. Each one rolls a new *layered* sound:
   an explosion is white noise + a brown-noise rumble + a sine "thump", a
   coin is a square blip with a triangle an octave up, and so on.
3. Pick a voice (**Voice 1-4** tabs or keys **1**-**4**), change its
   waveform, volume, pan, delay and sfxr sliders. It plays again when you
   let go of a slider.
4. **One voice: ...** re-rolls just the voice you're on, keeping its wave.
   **Mutate** nudges every voice a little.

| Input | What it does |
| --- | --- |
| Space | play |
| 1-4 | pick a voice |
| ON / OFF | that voice in the mix or not |
| Right-click a slider | reset it |
| Drop a `.pwmsfx` on the window | load it |
| Esc | quit |

## Output

* **PC speaker (PWM):** the mix (in mono) through the 1-bit speaker: every
  carrier period the speaker gets one pulse, as wide as the sound is high.
  The carrier (8, 11, 16 or 22 kHz) trades resolution against whine; the
  speaker cone filter softens it.
* **Clean (stereo):** the mix as it is, with the pans.

## Using a sound

| Button | What you get |
| --- | --- |
| Save .WAV | the clean mix, 16-bit stereo 44.1 kHz |
| Save PWM .WAV | what the speaker plays |
| Save 8-bit .WAV | 8-bit mono 11025 Hz (plays in `PC-SPEAKER/WAV.BAS`) |
| For PCSPLAY (game) | `NAME.WAV` and `NAME_PCSPLAY.BM` for a game using [PCSPLAY](../PC-SPEAKER/README.md#your-sounds-in-your-own-game-pcsplay): `NAME_Load` once, then `SFX_NAME` plays it through the speaker with PWM, over your PCSEDIT music. Or `PCSP_LoadWav "NAME", "NAME.WAV"`. |
| SOUND code .BAS | a ready-to-run program: every voice is a QB64-PE [`SOUND`](https://qb64phoenix.com/qb64wiki/index.php/SOUND) voice (0-3) with its waveform, volume and pan, pitch and level per 1/140 s, queued with `SOUND WAIT` / `SOUND RESUME`. Copy `SOUND_NAME` into your game. No library. |
| PLAY code .BAS | the same as [`PLAY`](https://qb64phoenix.com/qb64wiki/index.php/PLAY) strings (`@` waveform, `V` volume, `MB`), pitches rounded to semitones |
| Save / Load .pwmsfx | the whole sound: each voice's settings and its sfxr `.json` |
| Send to PCSEDIT | each voice's **pitch line** as a multi-voice sound in the bank PCSEDIT has open (see PCSFXR's README for how the inbox works). The PC speaker plays pitches, not waveforms, so noise voices become random pitches, the way DOS games made explosions. |

QB64-PE's SOUND and PLAY have no filters or flanger, so those sliders only
count in PWM / clean / WAV / PCSPLAY. Square waves with the duty cycle away
from 50% become SOUND's pulse wave.
