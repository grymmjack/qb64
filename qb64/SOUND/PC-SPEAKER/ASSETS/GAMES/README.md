# ASSETS/GAMES: PC speaker sound files from DOS games

DN1PLAY can play every file in this list. Only the files marked
**in git** are committed. They are shareware episode 1 files or freeware, so
they can be passed on. Everything else is from a registered or commercial
release and is listed in this folder's `.gitignore`. If you own the game, copy
the file here yourself (see the bottom of this page) and DN1PLAY will find it.
It will never be committed.

Shareware files were meant to be passed around as the complete original
package, not as single files pulled out of it. They are here so the player
has something to play. If you want the whole game, get the original
shareware release or buy it; most of these games are still sold.

| File | Game | Status |
| --- | --- | --- |
| `SOUNDS.CK1` | Commander Keen 1: Marooned on Mars | **in git** - shareware episode 1 |
| `DUKE1.DN1`, `DUKE1-B.DN1` | Duke Nukem: Shrapnel City | **in git** - shareware episode 1 |
| `COSMO1.STN` | Cosmo's Cosmic Adventure: Forbidden Planet | **in git** - shareware episode 1 |
| `VOLUME1A.MS1` | Major Stryker, episode 1 | **in git** - shareware episode 1 |
| `MR1.8` | Math Rescue, episode 1 | **in git** - shareware episode 1 |
| `CC1-1.SND` ... `CC1-3.SND` | Crystal Caves: Trouble with Twibbles | **in git** - shareware episode 1 |
| `AUDIOHED.BM1-3`, `AUDIOT.BM1-3` | Bio Menace (all 3 episodes) | **in git** - freeware since 2005 |
| `COSMO2.STN`, `COSMO3.STN` | Cosmo, episodes 2-3 | local only - registered |
| `VOLUME2A.MS2`, `VOLUME3A.MS3` | Major Stryker, episodes 2-3 | local only - registered |
| `MR2.8`, `MR3.8` | Math Rescue, episodes 2-3 | local only - registered |
| `CC2-*.SND`, `CC3-*.SND` | Crystal Caves, episodes 2-3 | local only - registered |
| `NUKEM2.CMP` | Duke Nukem II (full game archive) | local only - registered |
| `SOUNDS.HOV` | Hovertank 3-D | local only - commercial (Softdisk) |
| `SOUNDS.ROV` | Rescue Rover | local only - commercial (Softdisk) |
| `SOUNDS.CA2` | Catacomb II | local only - commercial (Softdisk) |
| `SOUNDS.SLO` | Slordax: The Unknown Enemy | local only - commercial (Softdisk) |
| `AUDIOHED/AUDIOT.CHS`, `.FNG`, `.CIR` | Cyberchess, Finagle, Circuitry | local only - commercial (Softdisk) |
| `AUDIOHED/AUDIOT.WL6` | Wolfenstein 3D (registered) | local only - commercial |
| `AUDIOHED/AUDIOT.SOD` | Spear of Destiny | local only - commercial |
| `AUDIOHED/AUDIOT.BS6` | Blake Stone: Aliens of Gold (registered) | local only - commercial |
| `AUDIOHED/AUDIOT.VSI` | Blake Stone: Planet Strike | local only - commercial |
| `AUDIOHED/AUDIOT.CO7` | Corridor 7: Alien Invasion | local only - commercial |
| `AUDIOHED/AUDIOT.BC` | Operation Body Count | local only - commercial |
| `AUDIOHED/AUDIOT.N3D` | Super Noah's Ark 3-D | local only - commercial |
| `DOOM.WAD`, `DOOM2.WAD` | DOOM, DOOM II (registered) | local only - commercial |
| `TNT.WAD`, `PLUTONIA.WAD` | Final DOOM | local only - commercial |
| `STRIFE1.WAD` | Strife | local only - commercial |
| `DARKWAR.WAD` | Rise of the Triad: Dark War | local only - commercial |
| `CHEX.WAD`, `CHEX2.WAD` | Chex Quest 1 and 2 | local only - given away free in cereal boxes, but still copyrighted by General Mills |

## Free alternatives that can be committed

* `../freedoom-dp.wad`: DOOM-style sounds from Freedoom (BSD licensed).
* The shareware episodes of several games use the same formats, so their
  files could be committed too: Wolfenstein 3D (`AUDIOT.WL1`), Blake Stone
  (`AUDIOT.BS1`), Rise of the Triad (`HUNTBGIN.WAD`), DOOM (`DOOM1.WAD`) and
  Duke Nukem II.

## Filling this folder from your own copies

If you have the eXoDOS collection, `~/.cache/exodos-index/extract_pcspeaker.py`
copies every supported file out of it:

```
python3 ~/.cache/exodos-index/extract_pcspeaker.py qb64/SOUND/PC-SPEAKER/ASSETS/GAMES
```

Otherwise copy the files named above from your installed games.
