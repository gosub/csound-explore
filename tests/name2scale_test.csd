<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/util/name2scale.udo"


instr 1
  Scalename = p4
  kindx init -1
  prints "name2scale test: %s\n", Scalename
  iscale[],isize name2scale Scalename
  ktick metro 4
  kindx += ktick
  kindx = kindx % isize
  knote = 48 + iscale[kindx]
  schedkwhen ktick, 0, 0, "ping", 0, 0.2, knote
endin


instr ping
  aenv madsr p3/2, 0, 1, p3/3
  aout poscil aenv, cpsmidinn(p4)
  outs aout, aout
endin


</CsInstruments>
<CsScore>
i 1 0 5 "major"
i 1 + . "minor"
i 1 + . "pentatonic"
</CsScore>
</CsoundSynthesizer>
