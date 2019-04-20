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

instr moogy_note
  ipresetnum = p5
  aOut moogy p4, giparams
  outs aOut,aOut
endin


opcode arpy, kk, kk[]k[]V
  kbpm, kdurations[], knotes[], kgate xin
  kdur_idx, knot_idx init 0, 0
  ktriggernote = 0
  kduration = 60*kdurations[kdur_idx]/kbpm
  knote = knotes[knot_idx]
  kmetro metro 1/kduration
  if kmetro == 1 then
    ktriggernote = knote
    kdurationout = kduration * kgate
    kdur_idx += 1
    kdur_idx = kdur_idx % lenarray:k(kdurations)
    knot_idx += 1
    knot_idx = knot_idx % lenarray:k(knotes)
  endif
  xout ktriggernote, kdurationout
endop


instr moogy_test
  ipre = p4
  kbeats[] fillarray 1/4, 1/3, 1/4, 1/2
  knotes[] fillarray 50, 53, 57, 59, 53
  if ipre < 100 then
    prints "Playing preset: %d\n", p4
    giparams moogy_preset ipre
  else
    prints "Playing random preset\n"
    giparams moogy_rnd_preset 1
  endif
  ktrignote, kdur arpy 80, kbeats, knotes, 0.5
  schedkwhen ktrignote, 0, 0, "moogy_note", 0, kdur, ktrignote
endin


</CsInstruments>

<CsScore>

i "moogy_test" 0 5  0
i "moogy_test" + .  1
i "moogy_test" + .  2
i "moogy_test" + .  3
i "moogy_test" + .  101
i "moogy_test" + .  102
i "moogy_test" + .  103
i "moogy_test" + .  104

</CsScore>

</CsoundSynthesizer>
