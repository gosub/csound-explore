<CsoundSynthesizer>
<CsOptions>
-d -odac
-+rtmidi=alsaseq -Q20 -M20
</CsOptions>
<CsInstruments>

#include "../../grid/basic64/momo.udo"
#include "../../grid/basic64/runbygrid.udo"

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


instr 1
  irow = p4
  icol = p5
  ienv = 0.1
  kcps = cpsmidinn((irow+5)*5+icol*7)
  asig2 vco2 0.1, kcps
  outs asig2, asig2
endin


instr 2
  kgrid[][] init 8,8
  kgrid momo
  runbygrid kgrid, 1
endin


alwayson 2
massign 0,0
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
