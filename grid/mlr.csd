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


;; TODO: refactor lane state in an array of arrays; State = [LaneState], LaneState = [Running, Offset, Start, End, ...]
;; TODO: sub-loop reverse
;; TODO: bpm
;; TODO: quantization
;; TODO: pattern recorder
;; TODO: add to readme
;; TODO: support for stereo samples
;; TODO: limiter


#include "lpmini.inc"


; fsm states for each lane
#define MLR_FSM_WAIT        #0#
#define MLR_FSM_KEYDOWN     #1#
#define MLR_FSM_TILLRELEASE #2#


opcode _mlr_setup, 0, 0
  Samplefolder = "/home/gg/downloads/audio/samples/sum/mlr/"
  gSamplename[] init 7
  giSample[] init 7
  giSampleLen[] init 7
  gSamplename[0] strcat Samplefolder, "soul_chicken.wav"
  gSamplename[1] strcat Samplefolder, "timba.wav"
  gSamplename[2] strcat Samplefolder, "counterpoint.wav"
  gSamplename[3] strcat Samplefolder, "the_bends.wav"
  gSamplename[4] strcat Samplefolder, "plucks.wav"
  gSamplename[5] strcat Samplefolder, "pianos.wav"
  gSamplename[6] strcat Samplefolder, "voices.wav"
  ;read mono sample, since tablei does not support stereo
  indx = 0
  while indx < 7 do
    giSample[indx]    ftgen 0,0,0,1,gSamplename[indx],0,0,1
    giSampleLen[indx] filelen gSamplename[indx]
    indx += 1
  od
endop


opcode _mlr_lane, a, iiiikkkkk
  ilane, ilength, isampletable, isamplelen, klooping, ksync, kposition, kstart, kend xin
  ilane = ilane + 1
  klast init -1
  kprevlooping init 0
  kloopfrac = (abs(kend-kstart)+1)/ilength

  asig = 0
  if klooping == 1 then
    async upsamp ksync
    aphase, adummy syncphasor 1/isamplelen*1/kloopfrac, async
    aphase *= kloopfrac
    kphase downsamp aphase
    kindex = (int(kphase*(ilength-0.001)) + kposition + kstart) % ilength
    if kindex != klast then
      lpledon $LP_GREEN, ilane, kindex
      if klast != -1 then
        lpledoff ilane, klast
      endif
      klast = kindex
    endif
    aphase += 1/ilength * kstart
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


opcode _mlr_lane_keyup, k[]k[]k[]k[]k[]k[]k[], kkk[]k[]k[]k[]k[]k[]k[]k[]
  klane, kcol, kreset[], koffset[], krunning[], klanefsm[], kgroupassign[], klanestart[], klaneend[], klanefsmvalue[] xin
  if klanefsm[klane] == $MLR_FSM_KEYDOWN then
    kreset[klane] = 1
    koffset[klane] = kcol
    klanestart[klane] = 0
    klaneend[klane] = 7 ;; TODO: should be icolumns-1
    kgroup = kgroupassign[klane]
    if krunning[klane] == 0 then
      krunning _mlr_stop_group kgroup, kgroupassign, krunning
      krunning[klane] = 1
      lpledon $LP_GREEN, 0, kgroupassign[klane]
    endif
    klanefsm[klane] = $MLR_FSM_WAIT
  elseif klanefsm[klane] == $MLR_FSM_TILLRELEASE then
    if klanefsmvalue[klane] > 1 then
      klanefsmvalue[klane] = klanefsmvalue[klane] -1
    else
      klanefsmvalue[klane] = 0
      klanefsm[klane] = $MLR_FSM_WAIT
    endif
  endif
  xout kreset, koffset, krunning, klanefsm, klanestart, klaneend, klanefsmvalue
endop


opcode _mlr_lane_keydown, k[]k[]k[]k[]k[]k[]k[], kkk[]k[]k[]k[]k[]k[]k[]k[]
  kcol, klane, klanefsm[], klanefsmvalue[], klanestart[], klaneend[], kreset[], koffset[], krunning[], kgroupassign[] xin
  if klanefsm[klane] == $MLR_FSM_WAIT then
    klanefsm[klane] = $MLR_FSM_KEYDOWN
    klanefsmvalue[klane] = kcol
  elseif klanefsm[klane] == $MLR_FSM_KEYDOWN then
    kstart min klanefsmvalue[klane], kcol
    kend max klanefsmvalue[klane], kcol
    klanestart[klane] = kstart
    klaneend[klane] = kend
    kreset[klane] = 1
    koffset[klane] = 0
    krunning[klane] = 1
    lpledon $LP_GREEN, 0, kgroupassign[klane]
    klanefsm[klane] = $MLR_FSM_TILLRELEASE
    klanefsmvalue[klane] = 2
  elseif klanefsm[klane] == $MLR_FSM_TILLRELEASE then
    klanefsmvalue[klane] = klanefsmvalue[klane] + 1
  endif
  xout klanefsm, klanefsmvalue, klanestart, klaneend, kreset, koffset, krunning
endop


instr mlr
  icolumns = (p4==0 ? 8 : p4)
  kreset[] init 7
  koffset[] init 7
  krunning[] init 7
  klanefsm[] init 7 ;; autoinitialized at $MLR_FSM_WAIT = 0
  klanefsmvalue[] init 7
  klanestart[] init 7
  klaneend[] fillarray icolumns-1, icolumns-1, icolumns-1, \
                       icolumns-1, icolumns-1, icolumns-1, icolumns-1
  kgroupassign[] fillarray 0,0,1,1,1,2,2 ;; lane -> group
  klane init 1
  kgroup init 0

  lpclear_i
  _mlr_setup

  kreset = 0
  ktrig, kevent, krow, kcol lpread
  if (ktrig==1) then
    if kevent == $LP_KEY_DOWN && krow == 0 && kcol < 4 then
      ;; click on group
      kgroup = kcol
      krunning _mlr_stop_group kgroup, kgroupassign, krunning
      lpledoff 0, kgroup
    elseif krow > 0 && kevent == $LP_KEY_UP then
      ;; keyup on lane
      klane = krow-1
      kreset, koffset, krunning, klanefsm, klanestart, klaneend, klanefsmvalue \
              _mlr_lane_keyup klane, kcol, kreset, koffset, \
              krunning, klanefsm, kgroupassign, \
	      klanestart, klaneend, klanefsmvalue
    elseif krow > 0 && kevent == $LP_KEY_DOWN then
      ;; keydown on lane
      klane = krow-1
      klanefsm, klanefsmvalue, klanestart, klaneend, kreset, koffset, krunning \
              _mlr_lane_keydown kcol, klane, klanefsm, \
	      klanefsmvalue, klanestart, klaneend, kreset, koffset, krunning, kgroupassign
    endif
  endif

  asig0 _mlr_lane 0, icolumns, giSample[0], giSampleLen[0], krunning[0], kreset[0], koffset[0], klanestart[0], klaneend[0]
  asig1 _mlr_lane 1, icolumns, giSample[1], giSampleLen[1], krunning[1], kreset[1], koffset[1], klanestart[1], klaneend[1]
  asig2 _mlr_lane 2, icolumns, giSample[2], giSampleLen[2], krunning[2], kreset[2], koffset[2], klanestart[2], klaneend[2]
  asig3 _mlr_lane 3, icolumns, giSample[3], giSampleLen[3], krunning[3], kreset[3], koffset[3], klanestart[3], klaneend[3]
  asig4 _mlr_lane 4, icolumns, giSample[4], giSampleLen[4], krunning[4], kreset[4], koffset[4], klanestart[4], klaneend[4]
  asig5 _mlr_lane 5, icolumns, giSample[5], giSampleLen[5], krunning[5], kreset[5], koffset[5], klanestart[5], klaneend[5]
  asig6 _mlr_lane 6, icolumns, giSample[6], giSampleLen[6], krunning[6], kreset[6], koffset[6], klanestart[6], klaneend[6]
  asig sum asig0, asig1, asig2, asig3, asig4, asig5, asig6
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
