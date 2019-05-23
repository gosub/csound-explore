<CsoundSynthesizer>
<CsOptions>
-dm0
-odac
-+rtmidi=alsaseq -Q20 -M20
</CsOptions>
<CsInstruments>

#include "../../grid/basic64/pato.udo"
#include "../../grid/basic64/patchby.udo"

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1



instr pato_test
  kpatches[][] init 32, 32
  kinputs[] init 32
  koutputs[] init 32

  kinputs[0] lfo 1, 1/20, 0
  kinputs[1] lfo 1, 1/20, 2
  kinputs[2] lfo 1, 1/20, 3
  kinputs[3] lfo 1, 1/20, 4

  kinputs[4] lfo 1, 1/15, 0
  kinputs[5] lfo 1, 1/15, 2
  kinputs[6] lfo 1, 1/15, 3
  kinputs[7] lfo 1, 1/15, 4

  kinputs[8] lfo 1, 1/10, 0
  kinputs[9] lfo 1, 1/10, 2
  kinputs[10] lfo 1, 1/10, 3
  kinputs[11] lfo 1, 1/10, 4

  kinputs[12] lfo 1, 1/5, 0
  kinputs[13] lfo 1, 1/5, 2
  kinputs[14] lfo 1, 1/5, 3
  kinputs[15] lfo 1, 1/5, 4

  kinputs[16] lfo 1, 1, 0
  kinputs[17] lfo 1, 1, 2
  kinputs[18] lfo 1, 1, 3
  kinputs[19] lfo 1, 1, 4

  kinputs[20] lfo 1, 2, 0
  kinputs[21] lfo 1, 2, 2
  kinputs[22] lfo 1, 2, 3
  kinputs[23] lfo 1, 2, 4

  kinputs[24] = 1/2
  kinputs[25] = 1
  kinputs[26] = 2
  kinputs[27] = 3
  kinputs[28] = 4
  kinputs[29] = 5
  kinputs[30] = 6
  kinputs[31] = 7

  kpatches pato
  koutputs patchby kpatches, kinputs

  asig1 poscil 0.1 * portk(koutputs[0], 0.03), cpsmidinn(48+1*koutputs[1])
  asig1 reverb asig1, portk(limit:k(koutputs[2]*3,0,100), 0.1)
  asig1L, asig1R pan2 asig1, 0.5 + koutputs[3]*0.1

  asig2 poscil 0.1 * portk(koutputs[4], 0.03), cpsmidinn(50+1*koutputs[5])
  asig2 reverb asig2, portk(limit:k(koutputs[6]*3,0,100), 0.1)
  asig2L, asig2R pan2 asig2, 0.5 + koutputs[7]*0.1

  asig3 poscil 0.1 * portk(koutputs[8], 0.03), cpsmidinn(52+1*koutputs[9])
  asig3 reverb asig3, portk(limit:k(koutputs[10]*3,0,100), 0.1)
  asig3L, asig3R pan2 asig3, 0.5 + koutputs[11]*0.1

  asig4 poscil 0.1 * portk(koutputs[12], 0.03), cpsmidinn(53+1*koutputs[13])
  asig4 reverb asig4, portk(limit:k(koutputs[14]*3,0,100), 0.1)
  asig4L, asig4R pan2 asig4, 0.5 + koutputs[15]*0.1

  asig5 poscil 0.1 * portk(koutputs[16], 0.03), cpsmidinn(55+1*koutputs[17])
  asig5 reverb asig5, portk(limit:k(koutputs[18]*3,0,100), 0.1)
  asig5L, asig5R pan2 asig5, 0.5 + koutputs[19]*0.1

  asig6 poscil 0.1 * portk(koutputs[20], 0.03), cpsmidinn(57+1*koutputs[21])
  asig6 reverb asig6, portk(limit:k(koutputs[22]*3,0,100), 0.1)
  asig6L, asig6R pan2 asig6, 0.5 + koutputs[23]*0.1

  asig7 poscil 0.1 * portk(koutputs[24], 0.03), cpsmidinn(59+1*koutputs[25])
  asig7 reverb asig7, portk(limit:k(koutputs[26]*3,0,100), 0.1)
  asig7L, asig7R pan2 asig7, 0.5 + koutputs[27]*0.1

  asig8 poscil 0.1 * portk(koutputs[28], 0.03), cpsmidinn(60+1*koutputs[29])
  asig8 reverb asig8, portk(limit:k(koutputs[30]*3,0,100), 0.1)
  asig8L, asig8R pan2 asig8, 0.5 + koutputs[31]*0.1

  afinalL sum asig1L, asig2L, asig3L, asig4L, asig5L, asig6L, asig7L, asig8L
  afinalR sum asig1R, asig2R, asig3R, asig4R, asig5R, asig6R, asig7R, asig8R
  afinalL clip afinalL, 0, 1
  afinalR clip afinalR, 0, 1
  outs afinalL, afinalR
endin


alwayson "pato_test"
massign 0,0

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
