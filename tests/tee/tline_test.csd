<CsoundSynthesizer>
<CsOptions>
-odac -dm0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../../udo/tee/tline.udo"


instr 1, tline_test
  prints "=== tline test ===\n"
  ktrig metro 1/2
  kdel delayk ktrig, 1
  kfreq tline kdel, 440, 1, 880
  printk 0.25, kfreq
  asig poscil 0.2, kfreq
  outs asig, asig
endin


</CsInstruments>
<CsScore>
i "tline_test" 0 10
</CsScore>
</CsoundSynthesizer>
