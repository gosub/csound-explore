<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/clockdiv.udo"


instr 1
  ktrig metro 8 ; 16th @ 120bpm

  kpulse clockdiv ktrig, 3
  kpulse2 clockdiv ktrig, 5
  kbeat clockdiv ktrig, 4

  schedkwhen ktrig # kpulse # kpulse2, 0, 0, 2, 0, 0.1
  schedkwhen kbeat, 0, 0, 3, 0, 0.1
endin


instr 2, hat
  aenv linen 0.2, 0.02, p3, 0.1
  asig pinkish aenv
  outs asig, asig
endin


instr 3, kick
  aenv linen 0.5, 0.01, p3, p3-0.01
  apitch line 200, p3, 50
  asig poscil aenv, apitch
  outs asig, asig
endin


alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
