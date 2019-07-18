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
#include "../udo/tee/tchoice.udo"
#include "../udo/tee/tcount.udo"
#include "../udo/tee/tstepper.udo"
#include "../udo/tee/tsequence.udo"


instr 1, tsequence_tstepper_tchoice_twchoice_tcount_test
  prints "=== tee test ===\n"
  ksequence[] fillarray 45, 49, 52, 56, 57, 61
  kweights[]  fillarray 8,  1,  1,  1,  4,  1
  ktrig metro 6
  printks2 "trig counter: %d, ",tcount(ktrig)
  printks2 "wrap 10: %d\n", tcount(ktrig, 10)
  kdur timeinsts
  kdur = int(kdur/4)
  kalt = kdur % 4
  if kalt == 0 then
    knote tsequence ktrig, ksequence+12
  elseif kalt == 1 then
    knote tstepper ktrig, ksequence+7, 1, 1, 3
  elseif kalt == 2 then
    knote tchoice ktrig, ksequence
  elseif kalt == 3 then
    knote twchoice ktrig, ksequence, kweights
  endif
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
