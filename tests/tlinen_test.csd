<CsoundSynthesizer>
<CsOptions>
-odac -dm0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/tee.udo"


instr 1, tlinen_test
  prints "=== tlinen test ===\n"
  ktrig metro 1/4
  kdel delayk ktrig, 1
  kfreq tlinen kdel, 440, 0.5, 3, 0.5
  kfreq += 440
  printk 0.25, kfreq
  asig poscil 0.2, kfreq
  outs asig, asig
endin


</CsInstruments>
<CsScore>
i "tlinen_test" 0 20
</CsScore>
</CsoundSynthesizer>
