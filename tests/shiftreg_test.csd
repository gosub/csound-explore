<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/shiftreg.udo"


instr 1
  amod pinkish 1
  ktrig metro 4

  a1, a2, a3, a4, a5, a6, a7, a8 shiftreg amod, ktrig

  asig1 poscil sc_lag(a1,0.01), 100
  asig2 poscil sc_lag(a2,0.01), 200
  asig3 poscil sc_lag(a3,0.01), 300
  asig4 poscil sc_lag(a4,0.01), 400
  asig5 poscil sc_lag(a5,0.01), 500
  asig6 poscil sc_lag(a6,0.01), 600
  asig7 poscil sc_lag(a7,0.01), 700
  asig8 poscil sc_lag(a8,0.01), 800
  asum sum asig1, asig2, asig3, asig4, asig5, asig6, asig7, asig8
  alim tanh asum
  alim = alim * 0.3
  outs alim, alim
endin


alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
