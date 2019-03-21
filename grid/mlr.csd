<CsoundSynthesizer>
<CsOptions>
-odac -d
-+rtmidi=alsaseq -M20 -Q20
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "lpmini.inc"

gSamplename = "/home/gg/downloads/loop.wav"
;read mono sample, since tablei does not support stereo
giSample   ftgen 0,0,0,1,gSamplename,0,0,1
giSampleLen filelen gSamplename


instr mlr
  klast init -1
  kindex init -1
  kreset init 0
  koffset init 0
  icolumns init 8

  lpclear_i

  ktrig, kevent, krow, kcol lpread
  if (ktrig==1 && kevent==$LP_KEY_DOWN && krow==0) then
    kreset = 1
    koffset = kcol
  else
    kreset = 0
  fi
  areset upsamp kreset
  aph, adummy syncphasor 1/giSampleLen, areset
  kph downsamp aph
  kindex = (int(kph*7.999) + koffset) % icolumns
  if (changed2:k(kindex)==1) then
    lpledon $LP_GREEN, 0, kindex
    if (klast != -1) then
      lpledoff 0, klast
    fi
    klast = kindex
  fi
  aph += 1/8 * koffset
  asig tablei aph, giSample, 1, 0, 1
  outs asig, asig
endin


; enable controller instrument
alwayson "mlr"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
