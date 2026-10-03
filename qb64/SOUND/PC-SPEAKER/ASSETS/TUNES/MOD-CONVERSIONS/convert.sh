#!/bin/sh
# Rebuild the .SND banks from the modules in MODS/: 4 voices, at most 45 s
# (what fits a 64 KB IFS bank). Needs MID2SND compiled next to it or on the
# PATH:  qb64pe -x ../../../MID2SND.BAS -o MID2SND
cd "$(dirname "$0")" || exit 1
M=./MID2SND
[ -x "$M" ] || M=MID2SND
for f in MODS/*.mod; do
    b=$(basename "$f" .mod)
    "$M" "$f" "$(echo "$b" | tr a-z- A-Z_).SND" -s 45 || exit 1
done
