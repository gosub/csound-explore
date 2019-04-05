<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
-+rtmidi=alsaseq -M20 -Q20
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "lpmini.inc"

gSamplename = "/home/gg/downloads/audio/samples/csound/loop.wav"
;read mono sample, since tablei does not support stereo
giSample   ftgen 0,0,0,1,gSamplename,0,0,1
giSampleLen filelen gSamplename


instr mlr
  icolumns init 8
  klast init -1
  kindex init -1
  kreset init 0
  koffset init 0
  krunning init 0
  kgroup init 0
  klane init 1

  lpclear_i

  kreset = 0
  ktrig, kevent, krow, kcol lpread
  if (ktrig==1) && (kevent==$LP_KEY_DOWN) then
    if krow == 0 then
      if kcol == kgroup then
        krunning = 0
        lpledoff 0, kgroup
        lpledoff klane, klast
        klast = -1
      endif
    else
      if krow == klane then
        kreset = 1
        koffset = kcol
        if krunning == 0 then
          krunning = 1
          lpledon $LP_GREEN, 0, kgroup
        endif
      endif
    endif
  endif

  asig = 0

  if krunning == 1 then
    areset upsamp kreset
    aph, adummy syncphasor 1/giSampleLen, areset
    kph downsamp aph
    kindex = (int(kph*7.999) + koffset) % icolumns
    if kindex != klast then
      lpledon $LP_GREEN, klane, kindex
      if klast != -1 then
        lpledoff klane, klast
      endif
      klast = kindex
    endif
    aph += 1/8 * koffset
    asig tablei aph, giSample, 1, 0, 1
  endif
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
