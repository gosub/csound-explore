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


instr 1, tsequence__tstepper_tchoice_test
  prints "=== tee test ===\n"
  ksequence[] fillarray 45, 49, 52, 56, 57, 61
  ktrig metro 6
  kdur timeinsts
  kdur = int(kdur/4)
  kalt = kdur % 3
  if kalt == 0 then
    printks "tsequence\n", 12
    knote tsequence ktrig, ksequence+12
  elseif kalt == 1 then
    printks "tstepper\n", 12
    knote tstepper ktrig, ksequence+7, 1, 1, 3
  else
    printks "tchoice\n", 12
    knote tchoice ktrig, ksequence
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
