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


;; TODO: multiple samples
;; TODO: groups
;; TODO: sub-loops
;; TODO: bpm
;; TODO: quantization
;; TODO: pattern recorder
;; TODO: add to readme
;; TODO: support for stereo samples


#include "lpmini.inc"


opcode _mlr_setup, 0, 0
  Samplefolder = "/home/gg/downloads/audio/samples/csound/"
  gSamplename strcat Samplefolder, "loop.wav"
  ;read mono sample, since tablei does not support stereo
  giSample   ftgen 0,0,0,1,gSamplename,0,0,1
  giSampleLen filelen gSamplename
endop


opcode _mlr_lane, a, iiiikkk
  ilane, ilength, isampletable, isamplelen, klooping, ksync, kposition xin
  klast init -1
  kprevlooping init 0

  asig = 0
  if klooping == 1 then
    async upsamp ksync
    aphase, adummy syncphasor 1/isamplelen, async
    kphase downsamp aphase
    kindex = (int(kphase*(ilength-0.001)) + kposition) % ilength
    if kindex != klast then
      lpledon $LP_GREEN, ilane, kindex
      if klast != -1 then
        lpledoff ilane, klast
      endif
      klast = kindex
    endif
    aphase += 1/ilength * kposition
    asig tablei aphase, isampletable, 1, 0, 1
  else
    if kprevlooping == 1 then
      lpledoff ilane, klast
      klast = -1
    endif
  endif
  kprevlooping = klooping
  xout asig
endop


instr mlr
  icolumns = (p4==0 ? 8 : p4)
  kreset init 0
  koffset init 0
  krunning init 0
  kgroup init 0
  klane init 1

  lpclear_i
  _mlr_setup

  kreset = 0
  ktrig, kevent, krow, kcol lpread
  if (ktrig==1) && (kevent==$LP_KEY_DOWN) then
    if krow == 0 then
      if kcol == kgroup then
        krunning = 0
        lpledoff 0, kgroup
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

  asig _mlr_lane 1, icolumns, giSample, giSampleLen, krunning, kreset, koffset
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
