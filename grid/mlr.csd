<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "launchpad.inc"

gSamplename = "/home/gg/downloads/loop.wav"
;read mono sample, since tablei does not support stereo
giSample   ftgen 0,0,0,1,gSamplename,0,0,1
giSampleLen filelen gSamplename

instr mlr
  kindex init 0
  aph phasor 1/giSampleLen
  asig tablei aph, giSample, 1
  outs asig, asig
  kindex downsamp aph
  kindex = int(kindex*7.999)
  printk2 kindex
endin


; enable controller instrument
alwayson "mlr"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
