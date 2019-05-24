<CsoundSynthesizer>
<CsOptions>
-d -odac
-+rtmidi=alsaseq -Q128 -M128
-m0
</CsOptions>
<CsInstruments>

#include "../grid/basic64/momo.udo"
#include "../grid/basic64/runbygrid.udo"

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

gitempo init 6
gktrig init 0

instr 1
  irow = p4
  icol = p5
  ienv = 0.1
  kindex init -1
  inote = (irow+5)*5+icol*7
  kindex += gktrig
  kindex = kindex % 3
  if kindex==0 then
    karp = inote
  elseif kindex==1 then
    karp = inote + 3
  elseif kindex == 2 then
    karp = inote +7
  endif
  schedkwhen gktrig, 0, 0, 3, 0, 1/gitempo, 2, karp, 100
  ;; midion 2, inote, 100
endin

instr 3
  ichn = p4
  inote = p5
  ivel = p6
  midion ichn, inote, ivel
endin

instr 2
  kgrid[][] init 8,8
  kgrid momo
  runbygrid kgrid, 1
  gktrig metro gitempo
endin


alwayson 2
massign 0,0
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
