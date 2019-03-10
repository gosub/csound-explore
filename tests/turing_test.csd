<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../udo/turing.udo"


instr 1
  kprob init 0.3
  ktrig metro 8

  ksteps init 1
  ktrig2 metro 1/10
  if (ktrig2 == 1) then
    ksteps += 1
    if (ksteps > 16) then
      ksteps = 2
    fi
  fi
  printk2 ksteps, 0, 1

  kpulse turing ktrig, kprob, ksteps

  kfreq cpsmidinn 40 + int(kpulse * 40)
  schedkwhen kpulse, 0, 0, 2, 0, 0.2, kfreq
endin


instr 2
  aenv madsr 0.05, 0.01, 0.5, 0.05
  asig poscil aenv*0.25, p4
  outs asig, asig
endin


alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
