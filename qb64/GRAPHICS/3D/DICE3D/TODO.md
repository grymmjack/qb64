# DICE3D - roadmap

Organized from the wishlist. Grouped into batches; `[x]` = done. All batches
A-E are complete.

## Batch A - physics & correctness (flagged as wrong/weird)  [DONE]
- [x] Natural settle: physics determines the resting face - no end-of-roll spin
      (die tumbles, slows, tips onto the nearest face; that face IS the value)
- [x] D4 lands on its base (flat), apex up - not balanced on a point
- [x] D4 correct value shown (top-read: 3 numbers per face at the corners)
      (D4 rotated top-read corners; D10 centred + kite-axis aligned)
- [x] Configurable throw dynamics: spin strength + shake/scatter strength
- [x] Runtime result API: dice3d_count/value/dropped/total/sides
- [x] demo: tilt steps by 5, dice count, box size, ENTER-to-type value

## Batch B - colours & materials (full manual control, not just themes)  [DONE]
- [x] Individual colour control: body, markings, edges, box bg, box outline,
      marble, wire (K cycles target, RGB edits it) + preset themes
- [x] Wireframe overlay: colour + opacity drawn on top of the body
- [x] Marble: adjustable vein colour + texture opacity
- [x] Crystal: adjustable transparency
- [x] Translucent body option (orange translucent w/ white pips, etc.)
- [x] instant preview (dice3d_repose) for look changes - no reroll

## Batch C - per-die config + save/load  [DONE]
- [x] Per-die-type overrides via a 7-slot dice set (own size/font/colours each)
- [x] Save/load a whole dice set to file (dice3d_set_save/load; demo S/L/A)
- [x] Save/load a named theme (dice3d_theme_save/load; demo V/B)

## Batch D - camera & interaction  [DONE]
- [x] Field-of-view / perspective control (cfg.FOV; 0 = orthographic)
- [x] Tilt/angle adjusts by 5; FOV + Yaw sliders added
- [x] Press ENTER on a setting to type an exact value
- [x] Left-click drag inside the box orbits the camera (yaw + tilt)

## Batch E - demo controls  [DONE, in Batch A]
- [x] Choose how many dice to roll (Dice count slider)
- [x] Choose box size (Box size slider)

---
Design note - fairness: physics-determined values are fair-ish via the chaotic
throw (random orientation + spin), like real dice. A `cfg.FAIR` flag can force a
uniform RNG later if a game needs a guaranteed distribution.

Possible polish (not requested): perspective-correct D4 corner numbers;
persistent preview atlas so marble/noise drag is smoother; hardware GL path.
