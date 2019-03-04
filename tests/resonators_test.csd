<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/resonators.udo"

instr 1
  krate rspline 0.1, 0.5, 2, 10
  apulse mpulse 0.8, krate
  aL, aR resonators apulse, apulse
  outs aL, aR
endin

alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
