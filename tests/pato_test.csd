<CsoundSynthesizer>
<CsOptions>
-dm0
-odac
-+rtmidi=alsaseq -Q20 -M20
</CsOptions>
<CsInstruments>

#include "../grid/basic64.udo"

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1



instr pato_test
  kpatches[][] init 32, 32
  kinputs[] init 32
  koutputs[] init 32

  kinputs[0] poscil 0.1, 1
  kinputs[1] poscil 0.1, 1/2
  kinputs[2] poscil 0.1, 1/3
  kinputs[3] poscil 0.1, 1/4
  kinputs[4] poscil 0.1, 1/6
  kinputs[5] poscil 0.1, 1/8
  kinputs[6] poscil 0.1, 1/10
  kinputs[7] poscil 0.1, 1/12

  kpatches pato
  koutputs patchby kpatches, kinputs

  asig1 poscil koutputs[0], cpsmidinn(48)
  asig2 poscil koutputs[1], cpsmidinn(50)
  asig3 poscil koutputs[2], cpsmidinn(52)
  asig4 poscil koutputs[3], cpsmidinn(53)
  asig5 poscil koutputs[4], cpsmidinn(55)
  asig6 poscil koutputs[5], cpsmidinn(57)
  asig7 poscil koutputs[6], cpsmidinn(59)
  asig8 poscil koutputs[7], cpsmidinn(60)
  afinal sum asig1, asig2, asig3, asig4, asig5, asig6, asig7, asig8
  outs afinal, afinal
endin


alwayson "pato_test"
massign 0,0

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
