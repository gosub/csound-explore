<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/euclidean.udo"


instr 1, euclideangen_test
  ilenmin = 3
  ilenmax = 8

  prints "=== euclideangen test ===\n"
  ilen = ilenmin
  while (ilen <= ilenmax) do
    ipulses = 0
    while (ipulses <= ilen) do
      index = 0
      String sprintf "%d/%d = [", ipulses, ilen
      while (index < ilen) do
        iv euclideangen index, ipulses, ilen
        Siv sprintf "%d ", iv
        String strcat String, Siv
        index += 1
      od
      String strcat String, "]\n"
      prints String
      ipulses += 1
    od
    ilen += 1
  od
  turnoff
endin


instr 2, euclidean_test
  kindex init 0
  ktrig metro 8
  
  ktrig2 metro 1/4
  if (ktrig2 == 1) then
    ksteps random 4, 16
    kpulses random 3, ksteps
    ksteps int ksteps
    kpulses int kpulses
    printk2 ksteps, 0, 1
    printk2 kpulses, 0, 1
  fi

  kpulse euclidean ktrig, kpulses, ksteps 

  kindex += kpulse
  inotes[] fillarray 60, 63, 67, 70
  kfreq cpsmidinn inotes[kindex % 4]
  schedkwhen kpulse, 0, 0, 3, 0, 0.2, kfreq
endin


instr 3
  aenv madsr 0.05, 0.01, 0.5, 0.05
  asig poscil aenv*0.25, p4
  outs asig, asig
endin


alwayson 1
alwayson 2

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
