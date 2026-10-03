# MOD-CONVERSIONS: tracker modules on the PC speaker

Amiga / PC tracker modules (`MODS/*.mod`) converted with `MID2SND` into IFS
banks: 4 voices, the first 45 seconds (what fits a 64 KB bank). Open a bank
in PCSEDIT and press **Ctrl+J** for PWM to hear the voices together, or play
it in DN1PLAY to hear the ARP version a game would play. Drums come out as
short beeps; see `MID2SND -i` and `-x` in the main README to leave them out.

`convert.sh` rebuilds the banks from the modules.

The music is by its authors, not part of this project. These are scene
modules, made to be passed around and shared freely; they're here as
examples of the converter, credited below. If you're the author and would
rather they weren't, open an issue and they'll go.

| Bank | Module | Author |
| --- | --- | --- |
| `4MAT_MENU8.SND` | anarchy menu 8 | 4-Mat (Anarchy) |
| `4MAT_MENU9.SND` | anarchy menu 9 | 4-Mat (Anarchy) |
| `4MAT_MENU12.SND` | anarchy menu 12 | 4-Mat (Anarchy) |
| `4MAT_MENU16.SND` | anarchy menu 16 | 4-Mat (Anarchy) |
| `4MAT_ANARME10.SND` | a10 (Anarme 10) | 4-Mat |
| `4MAT_CHIPSHOP.SND` | chip shop | 4-Mat |
| `4MAT_ZAPPEDOUT.SND` | zapped-out | 4-Mat |
| `HEATBEAT_DEATHSONG.SND` | deathsong | Heatbeat |
| `HEATBEAT_MATKAMIES.SND` | matkamies | Heatbeat |
| `XTD_SYNTHERELLA3.SND` | syntherella 3 | XTD |
| `XTD_SHAKY.SND` | shaky | XTD |
| `XTD_MOCHOOM.SND` | mochoom | XTD |
| `XTD_BENNY.SND` | benny | XTD |
| `XTD_ECONOMY6.SND` | economy 6 | XTD |
| `JESTER_CHIPMUNKS.SND` | chipmunks | Jester |
| `JESTER_SUNSETGLOW.SND` | sunset glow | Jester |
| `DRAWESOME_INTROMUSIC2.SND` | intromusic2 | Dr. Awesome |
| `DUBMOOD_STARCHIP.SND` | Starchip | Dubmood & JosSs |
