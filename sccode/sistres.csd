<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/tee.udo"

; port of «sistres» by alln4tural
; http://sccode.org/1-1Ni

;; TODO: instr "sine"
;; TODO: arrayofsubinstr
;; TODO: c_part

opcode lfgauss, a, kkk
  kdur, kwidth, kphase xin
  ax phasor 1/kdur
  ax = ax*2 - 1
  aout = exp:a((ax - kphase)^2 / (-2.0 * kwidth^2))
  xout aout
endop

opcode exprand, i, ii
  ilo, ihi xin
  iout = ilo * exp(log(ihi/ilo) * random(0, 1))
  xout iout
endop


opcode exprand, k, kk
  klo, khi xin
  kout = klo * exp(log(khi/klo) * random(0, 1))
  xout kout
endop


opcode splay, aa, a[]o
  asignals[], index xin
  aL, aR init 0, 0
  ilen lenarray asignals
  ; level compensation only on index 0, after all the recursions
  ilevel = (index==0 ? sqrt(1/ilen) : 1)
  if index < ilen then
    ipos = index * 1/(ilen-1)
    aL, aR pan2 asignals[index], ipos, 2
    arestL, arestR splay asignals, index+1
    aL += arestL
    aR += arestR
  endif
  xout aL*ilevel, aR*ilevel
endop



instr b_instr
  idur = p3
  inote = p4
  cluster[] init 16
  sines[] arrayofsubinstr cluster, "sine"
  asigL, asigR splay sines
  aenv lfgauss idur, 1/4, 0, 0
  outs asigL*aenv, asigR*aenv
endin



instr b_part
  knotes[] fillarray 40, 45, 52
  kmetro metro 1/4
  knote tchoice kmetro, knotes
  schedkwhen kmetro, 0, 0, "b_instr", 0, 9, knote
endin


</CsInstruments>
<CsScore>
i "b_part" 0 60

</CsScore>
</CsoundSynthesizer>
