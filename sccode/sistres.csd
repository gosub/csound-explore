<CsoundSynthesizer>
<CsOptions>
-odac -d
-m4
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/tee.udo"


; port of «sistres» by alln4tural
; http://sccode.org/1-1Ni


; increase to 16 for the original value
; my pc starts having buffer underruns around 10
#define CLUSTERSIZE #8#


;; TODO: extract lfgauss
;; TODO: extract exprand
;; TODO: extract splay
;; TODO: extract arrayofsubinstr


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


opcode arrayofsubinstr, a[], a[]iio
  audioarr[], index, instrnum, iparam xin
  ilen lenarray audioarr
  if index < ilen then
    audioarr arrayofsubinstr audioarr, index+1, instrnum, iparam
    audioarr[index] subinstr instrnum, index, ilen-1, iparam
  endif
  xout audioarr
endop


opcode arrayofsubinstr, a[], a[]iSo
  audioarr[], index, Sinstrname, iparam xin
  instrnum nstrnum Sinstrname
  audioarr arrayofsubinstr audioarr, index, instrnum, iparam
  xout audioarr
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


instr b_sine
  iindex = p4
  imaxindex = p5
  inote = p6
  ifreq cpsmidinn inote
  icps exprand ifreq, ifreq+(ifreq/64)
  aout poscil 0.2, icps
  out aout
endin


instr cluster
  idur = p3
  inote = p4
  insnum = p5
  acluster[] init $CLUSTERSIZE
  asines[] arrayofsubinstr acluster, 0, insnum, inote
  asigL, asigR splay asines
  aenv lfgauss idur, 1/4, 0, 0
  outs asigL*aenv, asigR*aenv
endin


instr b_part
  knotes[] fillarray 40, 45, 52
  kmetro metro 1/4
  knote tchoice kmetro, knotes
  schedkwhen kmetro, 0, 0, "cluster", 0, 9, knote, nstrnum("b_sine")
endin


gkxnotes[] fillarray 72, 69, 64

instr x_part
  knotes[][] init 6, 3
  knotes fillarray 72,69,64,\
                   70,64,62,\
                   67,60,70,\
                   65,60,69,\
                   64,60,67,\
                   65,60,69
  kmetro metro 1/10
  gkxnotes tsequence kmetro, knotes
  printarray gkxnotes, kmetro, "%.0f"
endin


instr c_sine
  iindex = p4
  imaxindex = p5
  inote = p6
  ifreq cpsmidinn inote
  icps exprand ifreq-(ifreq/128), ifreq+(ifreq/128)
  aout poscil 0.1, icps
  out aout
endin


instr c_part
  kmetro metro 2
  knote tchoice kmetro, gkxnotes
  schedkwhen kmetro, 0, 0, "cluster", 0, 6, knote, nstrnum("c_sine")
endin


</CsInstruments>
<CsScore>
i "b_part" 0 314
i "x_part" 0 300
i "c_part" 0.1 310
</CsScore>
</CsoundSynthesizer>
