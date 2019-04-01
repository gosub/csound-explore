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


instr 1, tsequence_tchoice_test
  prints "=== tsequence & tchoice test ===\n"
  ksequence[] fillarray 45, 49, 52, 56, 57, 61
  ktrig metro 6
  kdur timeinsts
  kdur = int(kdur/4)
  kalt = kdur % 2
  if kalt == 0 then
    knote tsequence ktrig, ksequence+12
  else
    knote tchoice ktrig, ksequence
  endif
  schedkwhen ktrig, 0, 0, 2, 0, 0.2, cpsmidinn(knote)


  ktrig2 metro 6/8
  knote2 tsequence ktrig2, ksequence-7
  schedkwhen ktrig2, 0, 0, 2, 0, 0.2*8, cpsmidinn(knote2)
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
