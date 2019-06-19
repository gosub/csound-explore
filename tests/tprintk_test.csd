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


instr 1, tprintk_test
  prints "=== tprintk test ===\n"
  kcount init 0
  ktrig metro 1
  tprintk ktrig, kcount
  kcount += ktrig
endin


</CsInstruments>
<CsScore>
i "tprintk_test" 0 10
</CsScore>
</CsoundSynthesizer>
