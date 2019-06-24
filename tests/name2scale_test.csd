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


instr 2
  prints "name2scale (k) test\n"
  kchange metro 1/2
  kcount init -1
  kindx init -1
  kscale[] init 1
  kcount += kchange
  ktick metro 6
  kindx += ktick
  if kcount%2==0 then
    Str = "major"
    kbase = 60
  else
    Str = "minor"
    kbase = 52
  endif
  kscale,ksize name2scale Str
  ki = (kindx % 3)*2
  knote = kbase + kscale[ki]
  schedkwhen ktick, 0, 0, "ping", 0, 0.2, knote
endin


instr ping
  aenv madsr p3/3, 0, 1, p3/3
  aout poscil aenv*0.5, cpsmidinn(p4)
  outs aout, aout
endin


</CsInstruments>
<CsScore>
i 1 0 5 "major"
i 1 + . "minor"
i 1 + . "pentatonic"
i 2 15 10
</CsScore>
</CsoundSynthesizer>
