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
  Samplefolder = "/home/gg/downloads/audio/samples/sum/mlr/"
  gSamplename[] init 7
  giSample[] init 7
  giSampleLen[] init 7
  gSamplename[0] strcat Samplefolder, "soul_chicken.wav"
  gSamplename[1] strcat Samplefolder, "drum_solo.wav"
  gSamplename[2] strcat Samplefolder, "counterpoint.wav"
  gSamplename[3] strcat Samplefolder, "pianos.wav"
  gSamplename[4] strcat Samplefolder, "plucks.wav"
  gSamplename[5] strcat Samplefolder, "the_bends.wav"
  gSamplename[6] strcat Samplefolder, "timba.wav"
  ;read mono sample, since tablei does not support stereo
  indx = 0
  while indx < 7 do
    giSample[indx]    ftgen 0,0,0,1,gSamplename[indx],0,0,1
    giSampleLen[indx] filelen gSamplename[indx]
    indx += 1
  od
endop


opcode _mlr_lane, a, iiiikkk
  ilane, ilength, isampletable, isamplelen, klooping, ksync, kposition xin
  ilane = ilane + 1
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


opcode _mlr_stop_group, k[], kk[]k[]
; given a group, a group_assign and current running status
; return a new running status
  kgroup, kgroupassign[], krunning[] xin
  klane = 0
  while klane < 7 do
    krunning[klane] = (kgroupassign[klane] == kgroup ? 0 : krunning[klane])
    klane += 1
  od
  xout krunning
endop


instr mlr
  icolumns = (p4==0 ? 8 : p4)
  kreset[] init 7
  koffset[] init 7
  krunning[] init 7
  kgroupassign[] fillarray 0,0,1,1,1,2,2 ;; lane -> group
  klane init 1
  kgroup init 0

  lpclear_i
  _mlr_setup

  kreset = 0
  ktrig, kevent, krow, kcol lpread
  if (ktrig==1) && (kevent==$LP_KEY_DOWN) then
    if krow == 0 && kcol < 4 then
      ;; click on group
      kgroup = kcol
      krunning _mlr_stop_group kgroup, kgroupassign, krunning
    else
      ;; click on lane
      klane = krow-1
      kreset[klane] = 1
      koffset[klane] = kcol
      if krunning[klane] == 0 then
        krunning _mlr_stop_group kgroup, kgroupassign, krunning
        krunning[klane] = 1
        lpledon $LP_GREEN, 0, kgroupassign[klane]
      endif
    endif
  endif

  asig _mlr_lane 0, icolumns, giSample[0], giSampleLen[0], krunning[0], kreset[0], koffset[0]
  asig _mlr_lane 1, icolumns, giSample[1], giSampleLen[1], krunning[1], kreset[1], koffset[1]
  asig _mlr_lane 2, icolumns, giSample[2], giSampleLen[2], krunning[2], kreset[2], koffset[2]
  asig _mlr_lane 3, icolumns, giSample[3], giSampleLen[3], krunning[3], kreset[3], koffset[3]
  asig _mlr_lane 4, icolumns, giSample[4], giSampleLen[4], krunning[4], kreset[4], koffset[4]
  asig _mlr_lane 5, icolumns, giSample[5], giSampleLen[5], krunning[5], kreset[5], koffset[5]
  asig _mlr_lane 6, icolumns, giSample[6], giSampleLen[6], krunning[6], kreset[6], koffset[6]
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
