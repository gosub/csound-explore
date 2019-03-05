<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/turing.udo"


instr 1
  kprob init 0.3
  krate rspline 2, 8, 2, 10
  ktrig metro krate

  kpulse turing ktrig, kprob

  kfreq = kpulse * 1000 + 100
  schedkwhen kpulse, 0, 0, 2, 0, 0.2, kfreq
endin


instr 2
  aenv madsr 0.05, 0.01, 0.5, 0.05
  asig poscil aenv*0.25, p4
  outs asig, asig
endin


alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
