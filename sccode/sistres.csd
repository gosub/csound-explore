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


#include "../udo/tee/tchoice.udo"
#include "../udo/tee/tsequence.udo"
#include "../udo/util/arrayofsubinstr.udo"
#include "../udo/sc/lfgauss.udo"
#include "../udo/sc/exprand.udo"
#include "../udo/sc/splay.udo"


; port of «sistres» by alln4tural
; http://sccode.org/1-1Ni


; increase to 16 for the original value
; my pc starts having buffer underruns around 10
#define CLUSTERSIZE #8#


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
