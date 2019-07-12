<CsoundSynthesizer>
<CsOptions>
-odac -dm0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../../udo/tee/tcoin.udo"


instr 1, tcoint_test
  prints "=== tcoint test ===\n"
  ktrig metro 1
  kcoin tcoin ktrig
  knote = (kcoin==1? 48 : 60)
  schedkwhen ktrig, 0, 0, 2, 0, 0.2, cpsmidinn(knote)
endin


instr 2
  aenv madsr 0.05, 0, 1, 0.05
  asig poscil aenv*0.2, p4
  outs asig, asig
endin


alwayson 1

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
