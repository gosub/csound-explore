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
  ; unipolar square lfo
  klfo lfo 12, 1/6, 3
  klfo2 lfo 1, 1/3, 3
  kdecay lfo 0.3, 1/2
  kdecay += 0.7
  kfilteron init 1
  kfiltermode lfo 2, 1/10, 3
  kfilterfreq lfo 200, 1/20
  kfilterfreq += 400
  kspread lfo 0.5, 1/7
  kspread += 0.5
  kgainfinal init 10
  aL, aR resonators apulse, apulse, 60-klfo, 4-klfo2, 7, 11, 12, kdecay, \
                    kfilteron, kfiltermode, kfilterfreq, kspread, kgainfinal
  outs aL, aR
endin

alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
