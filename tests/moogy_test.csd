<CsoundSynthesizer>

<CsOptions>
-odac -Ma
-m0
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 8
nchnls = 2
0dbfs = 1


#include "../udo/moogy.udo"
prealloc 1, 10

giparams[] init 20

instr moogy_test
  ipresetnum = p5
  aOut moogy p4, giparams
  outs aOut,aOut
endin


giBeats[] fillarray 1/4, 1/4, 1/4, 1/4
giNote[] fillarray 50, 53, 57, 59


;; TODO: extract arpy as seperate UDO


instr arpy
  kbpm init 80
  kndx init 0
  ipre = p4
  if ipre < 100 then
    prints "Playing preset: %d\n", p4
    giparams moogy_preset ipre
  else
    prints "Playing random preset\n"
    giparams moogy_rnd_preset 1
  endif
  kbeat = giBeats[kndx]
  kdur = 60*kbeat/kbpm
  knote = giNote[kndx]
  kmetro metro 1/kdur
  if kmetro == 1 then
    event "i", "moogy_test", 0, kdur, knote
    kndx += 1
    kndx = kndx % 4
  endif
endin

</CsInstruments>

<CsScore>

i "arpy" 0 5  0
i "arpy" + .  1
i "arpy" + .  2
i "arpy" + .  3
i "arpy" + .  101
i "arpy" + .  102
i "arpy" + .  103
i "arpy" + .  104

</CsScore>

</CsoundSynthesizer>
