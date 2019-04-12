<CsoundSynthesizer>

<CsOptions>
-odac -Ma
-m0
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 4
nchnls = 2
0dbfs = 1


#include "../udo/moogy.udo"
prealloc 1, 10


instr moogy_test
  kpreset[] moogy_preset p5
  aOut moogy p4, kpreset
  outs aOut,aOut
endin


giBeats[] fillarray 1/4, 1/4, 1/4, 1/4
giNote[] fillarray 50, 53, 57, 59


;; TODO: extract arpy as seperate UDO


instr arpy
 kbpm init 120
 kndx init 0
 ipre = p4
 prints "Playing preset: %d\n", p4
 kbeat = giBeats[kndx]
 kdur = 60*kbeat/kbpm
 knote = giNote[kndx]
 kmetro metro 1/kdur
	if kmetro == 1 then
		event "i", "moogy_test", 0, kdur, knote, ipre
	 kndx += 1
	 kndx = kndx % 4
	endif
endin

</CsInstruments>

<CsScore>

i "arpy" 0 10 0
i "arpy" + .  1
i "arpy" + .  2
i "arpy" + .  3

</CsScore>

</CsoundSynthesizer>
