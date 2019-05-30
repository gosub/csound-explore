<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1


;; TODO: transform this experiment in a test
;; TODO: reuse more options from diskin2


#include "../udo/util/rndstring.udo"
#include "../udo/dirplay.udo"
gSdirectory = "/home/gg/downloads/audio/samples/patatap-samples-wav"


instr random_player
  itempi[] fillarray 4,2,6,3,1.5
  itempochangerate = 1
  krandom randh lenarray(itempi)-1, itempochangerate
  ktempo = itempi[abs(krandom)]
  kmetro metro ktempo
  kmetronome metro 1
  a1L, a1R dirplaywhen kmetro, gSdirectory, random:k(0,100), 0
  a2L, a2R dirplaywhen kmetronome, gSdirectory, 4, 1
  aL sum a1L/10, a2L/2
  aR sum a1R/10, a2R/2
  outs aL, aR
endin


instr single_player
  aL, aR dirplay gSdirectory, 2, 0
  outs aL, aR
endin


alwayson "random_player"
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
