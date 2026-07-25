# AGENTS.md — DICE3D

Guidance for AI coding agents working on **or with** the DICE3D module
(3D polyhedral dice for QB64PE). Read this before editing or building.

DICE3D rolls animated 3D dice inside a top-down "dice box" that overlays the
caller's existing screen. Pure software render (no raw OpenGL): rotate → project
→ painter-sort → texture each face with 2D `_MAPTRIANGLE` into an off-screen box
buffer, then `_PUTIMAGE` just that rectangle over the screen.

---

## 1. Build / compile-check (do this after every edit)

QB64PE is compile-to-C++ with no REPL, so **headless compile is your feedback
loop.** The binary lives at the **lowercase** path (the `qb64pe` shell alias
points at a source-only tree and will fail):

```bash
/home/grymmjack/git/qb64pe/qb64pe -x /abs/path/DICE3D-TEST.BAS
```

- `-x` = compile to an executable without launching the IDE.
- The exe is written **next to the source** (same basename, no extension).
- Output is noisy (ANSI + `[....]` progress bars). To see only real messages:

```bash
/home/grymmjack/git/qb64pe/qb64pe -x FILE.BAS 2>&1 | tr '\r' '\n' | grep -vE '^\[|^$'
```

- Treat it as **FAIL** if the exe wasn't produced OR the output matches
  `error|cannot|undefined|expected|already in use|without`. A stale exe can mask
  a failed compile — delete the exe before recompiling.
- You can only compile a top-level `.BAS` (it `$INCLUDE`s the `.BI`/`.BM`).
  Compiling `DICE3D-TEST.BAS` exercises the whole library.

## 2. Run & screenshot-verify (headless)

QB64 programs need an X display; run under Xvfb. **Do not** use the Homebrew
ImageMagick `import` to grab windows (built without X support) — instead the
harnesses save their **own** PNGs via `_SAVEIMAGE`.

```bash
export DISPLAY=:99
Xvfb :99 -screen 0 1280x1024x24 >/dev/null 2>&1 &
DICE3D_SHOT_DIR=/tmp/out DICE3D_ROLL=d20 ./DICE3D-TEST   # -> /tmp/out/ui.png, then exits
```

Env hooks for headless capture:

- **DICE3D-TEST.BAS** (the configurator): `DICE3D_SHOT_DIR` (roll once, save
  `ui.png`, exit), `DICE3D_ROLL` (die **type** string, e.g. `d20`),
  `DICE3D_MAT` (0..3), `DICE3D_THEME` (0..5), `DICE3D_TWEAK`
  (`orange|marble|crystal` preset looks), `DICE3D_FOV`, `DICE3D_YAW`,
  `DICE3D_TILT`.
- **DICE3D-SHOT.BAS** (frame capture): `DICE3D_ROLL` (full notation, e.g.
  `4d6dl1`), `DICE3D_SHOT_EVERY` (save the box buffer every N frames),
  `DICE3D_SHOT_DIR`, `DICE3D_MAT`, `DICE3D_PIPS`, `DICE3D_BEVEL`, `DICE3D_SIZE`,
  `DICE3D_DROPFX`. Saves `fNNNN.png` frames + `screen_final.png`.
- **DICE3D-IOTEST.BAS** is `$CONSOLE:ONLY` — runs without X; prints save/load
  round-trip results to stdout.

There is also a debug hook in the library itself: set shared `DICE3D_SHOT_EVERY`
> 0 and `DICE3D_SHOT_DIR$` to dump the box buffer every N frames during a roll.

## 3. File map

| File | Role |
|------|------|
| `_ALL.BI` / `_ALL.BM` | Aggregated includes. Include `_ALL.BI` near the top of a program (after `OPTION _EXPLICIT`), `_ALL.BM` at the very bottom. |
| `_CFG.BI` | `DICE3D_CONFIG` + `DICE3D_SPEC` + enums. |
| `_DICE.BI` | Core types (`DICE3D_VEC3`, `DICE3D_QUAT`, `DICE3D_DIE`) + engine globals + mesh arrays. |
| `_MISC.BM` | Vector + quaternion math, small helpers. |
| `_GEO.BM`  | Generic convex-hull mesh builder + per-die vertex sets + D4 corner values. |
| `_TEX.BM`  | Face-atlas baking: materials, bevel, numbers, pips, sprite maps, colour helpers. |
| `_RENDER.BM` | Software 3D renderer (yaw/tilt/FOV projection, painter sort, `_MAPTRIANGLE`, wireframe). |
| `_PHYSICS.BM` | Throw, hop, wall bounce, separation, **natural settle** (physics picks the resting face). |
| `_DICE.BM` | Public API: defaults, parser, `dice3d_roll`, percentile, drop FX, `dice3d_repose`, result accessors. |
| `_IO.BM`   | Save/load a config, a 7-slot dice set, and named themes (`KEY=value` text). |
| `DICE3D-TEST.BAS` | Interactive configurator (F5). Also the main compile target. |
| `DICE3D-SHOT.BAS` / `DICE3D-FACES.BAS` / `DICE3D-IOTEST.BAS` | Verification harnesses. |

`README.md` = user docs. `TODO.md` = roadmap (batches A–E, all done).

## 4. Using the module (in a program)

```basic
OPTION _EXPLICIT
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0: CONST TRUE = NOT FALSE
$END IF
'$INCLUDE:'_ALL.BI'

SCREEN _NEWIMAGE(800, 600, 32): CLS , _RGB32(0, 120, 255)
DIM cfg AS DICE3D_CONFIG
dice3d_config_defaults cfg
cfg.BOX_X = 250: cfg.BOX_Y = 160: cfg.BOX_W = 300: cfg.BOX_H = 300

REDIM r(1 TO 1) AS INTEGER
dice3d_roll "4d6dl1", cfg, r()          ' animates in the box, hands control back

DIM i AS INTEGER
FOR i = 1 TO dice3d_count%              ' runtime result API
    PRINT dice3d_value%(i); IIF... dice3d_dropped%(i)
NEXT
PRINT "total ="; dice3d_total%
'$INCLUDE:'_ALL.BM'                      ' at the very bottom
```

Key facts:
- **Values come from physics** — the die settles on a face; there is no
  predetermined value and no end-of-roll snap. Fairness = the randomized throw
  (`cfg.SPIN_STRENGTH`, `cfg.THROW_STRENGTH`).
- The roll loop drives `_DISPLAY`; host game loops already doing so are fine.
- Fonts/sprites/sounds are **caller-provided handles**; the module never loads
  them. `cfg.FONT_PX` is metadata so a program can reload a saved size.
- Save/load: `dice3d_config_save/load%`, `dice3d_set_save/load%` (array of 7,
  indexed by `dice3d_set_index%(sides)`), `dice3d_theme_save/load%`.

## 5. Extending it (where things go)

- **New die type** → add its vertices to `dice3d_verts` in `_GEO.BM`. The convex
  hull derives the faces; numbering and UVs are automatic. (Only the vertex
  list is die-specific.)
- **New config field** → add to `DICE3D_CONFIG` (`_CFG.BI`), set a default in
  `dice3d_config_defaults` (`_DICE.BM`), and persist it in `_IO.BM`
  (`dice3d_config_write` + `dice3d_config_apply`). If it changes appearance,
  it's picked up by `dice3d_repose` for instant preview.
- **New material** → add a `CASE` in `dice3d_fill_tile` (`_TEX.BM`).
- **New face art** → it's all just "draw into a tile" in `dice3d_make_atlas`;
  the 3D pipeline never changes.

## 6. QB64PE gotchas (all hit during development)

- **Reserved words can't be identifiers.** Do NOT name a variable/param:
  `val`, `key`, `name`, `line`, `base`, `pos`, `to`, `time`, `date`, `step`,
  `out`, `string`, `timer`, etc. Symptoms: `Name already in use (x)`. Rename
  (the code uses `faceval`, `mkey`, `tname`, `ln`, `fbase`, `pcnt`, `texop`…).
- **Single-line `IF` can't have `ELSEIF`** — use a block `IF … END IF`.
- **`IF cond THEN a: NEXT`** puts `NEXT` inside the `THEN`. Put loop bodies with
  conditionals on separate lines.
- `OPTION _EXPLICIT` + `OPTION _EXPLICITARRAY` are on — declare every variable
  and array (`DIM` / `REDIM`).
- `_MAPTRIANGLE` with 3D coords renders to the whole-screen GL layer (we do NOT
  use that — we project to 2D ourselves and use the 2D form, appending
  `, DICE3D_BOXBUF, _SMOOTH` for antialiasing).
- Colours are `_UNSIGNED LONG` (`_RGB32`/`_RGBA32`); image/font handles are
  `LONG`. Keep them straight in save/load.

## 7. Conventions (grymmjack's BOUNCER house style)

- `.BI` = types + `DIM SHARED`; `.BM` = subs/functions; every include starts
  with `$INCLUDEONCE`.
- All public symbols are `dice3d_`-prefixed, `snake_case`. Types are UPPER
  (`DICE3D_CONFIG`, `DICE3D_DIE`).
- Header comment block ending with `@author Rick Christy <grymmjack@gmail.com>`.
- Mesh/UV/`_MAPTRIANGLE` technique is adapted from Petr's `dice.bas` (in
  `qb64/_/Petr/dice.bas`); keep the credit.
- Compile-check every change; screenshot-verify anything visual.
