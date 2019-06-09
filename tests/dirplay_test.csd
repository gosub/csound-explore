<CsoundSynthesizer>
<CsOptions>
-odac -d
-m 0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1


#include "../udo/dirplay.udo"
gSdirectory = "/home/gg/downloads/audio/samples/patatap-samples-wav"


instr dirplaywhen_test
  prints "dirplaywhen test\n"
  itempi[] fillarray 4,2,6,3,1.5
  itempochangerate = 1
  kcount init -1
  krandom randh lenarray(itempi)-1, itempochangerate
  ktempo = itempi[abs(krandom)]
  kmetro metro ktempo
  kmetronome metro 1
  kcount += kmetronome
  a1L, a1R dirplaywhen kmetro, gSdirectory, random:k(0,100)
  a2L, a2R dirplaywhen kmetronome, gSdirectory, int(kcount/4), 1
  aL sum a1L/7, a2L/2
  aR sum a1R/7, a2R/2
  outs aL, aR
endin


instr dirplay_test
  prints "dirplay test\n"
  aL, aR dirplay gSdirectory, p4
  outs aL, aR
endin


</CsInstruments>
<CsScore>
i "dirplay_test" 0 2 1
i "dirplaywhen_test" 2 20
</CsScore>
</CsoundSynthesizer>
