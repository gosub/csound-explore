<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/util.udo"


instr once_test
  prints "once test\n"
  konce once
  printk2 konce, 0, 1
  if konce == 1 then
    printks "This line is printed at k-rate, using once\n", 0.1
  endif
endin


</CsInstruments>
<CsScore>
i "once_test" 0 5
</CsScore>
</CsoundSynthesizer>
