<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in
-odac -+rtmidi=alsaseq -Q20 -M20
</CsOptions>
<CsInstruments>

#include "../grid/basic64.udo"

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


instr 1
  kfaders[] init 8
  kfaders fado
  asig0 vco2 0.1 * kfaders[0], cpsmidinn(60)
  asig1 vco2 0.1 * kfaders[1], cpsmidinn(63)
  asig2 vco2 0.1 * kfaders[2], cpsmidinn(67)
  asig3 vco2 0.1 * kfaders[3], cpsmidinn(71)
  asig4 vco2 0.1 * kfaders[4], cpsmidinn(72)
  asig5 vco2 0.1 * kfaders[5], cpsmidinn(76)
  asig6 vco2 0.1 * kfaders[6], cpsmidinn(79)
  asig7 vco2 0.1 * kfaders[7], cpsmidinn(83)
  asig sum asig0, asig1, asig2, asig3, asig4, asig5, asig6, asig7
  outs asig, asig
endin

alwayson 1
massign 0,0
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
