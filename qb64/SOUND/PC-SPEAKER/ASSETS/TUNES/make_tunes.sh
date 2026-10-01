#!/bin/sh
# Rebuild the example tunes: MIDI files from make_tunes.py, then one IFS
# bank per tune with MID2SND (4 voices), PLAYDEMO.mml (QB64 PLAY strings),
# and the short jingles together in JINGLES.SND. Needs MID2SND compiled next to it or on the PATH:
#   qb64pe -x ../../MID2SND.BAS -o MID2SND
cd "$(dirname "$0")" || exit 1
M=./MID2SND
[ -x "$M" ] || M=MID2SND
python3 make_tunes.py || exit 1
for t in odetojoy furelise korobeinik greensleev minuetg canond mtnking birthday jinglebell chiploop; do
    "$M" "MIDI/$t.mid" "$(echo $t | tr a-z A-Z).SND" || exit 1
done
"$M" PLAYDEMO.mml PLAYDEMO.SND || exit 1
rm -f JINGLES.SND
for t in fanfare levelup gameover; do
    "$M" "MIDI/$t.mid" JINGLES.SND -a || exit 1
done
