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


; lane structure fields
#define LANE_TABLE     #0#
#define LANE_SAMPLELEN #1#
#define LANE_RUNNING   #2#
#define LANE_RESET     #3#
#define LANE_OFFSET    #4#
#define LANE_GROUP     #5#
#define LANE_FSM       #6#
#define LANE_FSMVAL    #7#
#define LANE_START     #8#
#define LANE_END       #9#
#define LANE_DIR       #10#
#define LANE_STRUCT_SIZE #11#


opcode _mlr_setup, i[]i[]i[]i[], i
  icolumns xin
  igroupassign[] fillarray 0,0,1,1,1,2,2 ;; lane -> group
  Samplefolder = "/home/gg/downloads/audio/samples/sum/mlr/"
  Samplename[] init 7
  iSample[] init 7
  iSampleLen[] init 7
  iends[] init 7
  Samplename[0] strcat Samplefolder, "soul_chicken.wav"
  Samplename[1] strcat Samplefolder, "timba.wav"
  Samplename[2] strcat Samplefolder, "counterpoint.wav"
  Samplename[3] strcat Samplefolder, "the_bends.wav"
  Samplename[4] strcat Samplefolder, "plucks.wav"
  Samplename[5] strcat Samplefolder, "pianos.wav"
  Samplename[6] strcat Samplefolder, "voices.wav"
  ;read mono sample, since tablei does not support stereo
  indx = 0
  while indx < 7 do
    iSample[indx]    ftgen 0,0,0,1,Samplename[indx],0,0,1
    iSampleLen[indx] filelen Samplename[indx]
    iends[indx] = icolumns - 1
    indx += 1
  od
  xout iSample, iSampleLen, igroupassign, iends
endop


opcode _mlr_lane, a, iik[][]
  ilanenum, ilength, klanes[][] xin
  klane[] getrow klanes, ilanenum
  irow = ilanenum + 1
  klast init -1
  kprevlooping init 0
  kloopfrac = (abs(klane[$LANE_END] - klane[$LANE_START])+1)/ilength

  asig = 0
  if klane[$LANE_RUNNING] == 1 then
    async upsamp klane[$LANE_RESET]
    kfreq = 1/klane[$LANE_SAMPLELEN]*1/kloopfrac
    aphase, adummy syncphasor kfreq, async
    aphase *= kloopfrac
    kphase downsamp aphase
    kindex = (int(kphase*(ilength-0.001)) + klane[$LANE_OFFSET] + klane[$LANE_START]) % ilength
    if kindex != klast then
      lpledon $LP_GREEN, irow, kindex
      if klast != -1 then
        lpledoff irow, klast
      endif
      klast = kindex
    endif
    aphase += 1/ilength * klane[$LANE_START]
    aphase += 1/ilength * klane[$LANE_OFFSET]
    asig tableikt aphase, klane[$LANE_TABLE], 1, 0, 1
  else
    if kprevlooping == 1 then
      lpledoff irow, klast
      klast = -1
    endif
  endif
  kprevlooping = klane[$LANE_RUNNING]
  xout asig
endop


opcode _mlr_stop_group, k[][], kk[][]
; given a group, a group_assign and current running status
; return a new running status
  kgroup, klanes[][] xin
  klane = 0
  while klane < 7 do
    kassigned = klanes[klane][$LANE_GROUP]
    krunning = klanes[klane][$LANE_RUNNING]
    klanes[klane][$LANE_RUNNING] = (kassigned == kgroup ? 0 : krunning)
    klane += 1
  od
  xout klanes
endop

opcode _mlr_lane_reset_clear, k[][], k[][]
  klanes[][] xin
  kndx = 0
  while kndx < lenarray(klanes) do
    klanes[kndx][$LANE_RESET] = 0
    kndx += 1
  od
  xout klanes
endop

opcode _mlr_lane_keyup, k[][], kkk[][]
  klanenum, kcol, klanes[][] xin
  klane[] getrow klanes, klanenum
  if klane[$LANE_FSM] == $MLR_FSM_KEYDOWN then
    klane[$LANE_RESET] = 1
    klane[$LANE_OFFSET] = kcol
    klane[$LANE_START] = 0
    klane[$LANE_END] = 7 ;; TODO: should be icolumns-1
    kgroup = klane[$LANE_GROUP]
    if klane[$LANE_RUNNING] == 0 then
      klanes _mlr_stop_group kgroup, klanes
      klane[$LANE_RUNNING] = 1
      lpledon $LP_GREEN, 0, kgroup
    endif
    klane[$LANE_FSM] = $MLR_FSM_WAIT
  elseif klane[$LANE_FSM] == $MLR_FSM_TILLRELEASE then
    if klane[$LANE_FSMVAL] > 1 then
      klane[$LANE_FSMVAL] = klane[$LANE_FSMVAL] -1
    else
      klane[$LANE_FSMVAL] = 0
      klane[$LANE_FSM] = $MLR_FSM_WAIT
    endif
  endif
  klanes setrow klane, klanenum
  xout klanes
endop


opcode _mlr_lane_keydown, k[][], kkk[][]
  klanenum, kcol, klanes[][] xin
  klane[] getrow klanes, klanenum
  if klane[$LANE_FSM] == $MLR_FSM_WAIT then
    klane[$LANE_FSM] = $MLR_FSM_KEYDOWN
    klane[$LANE_FSMVAL] = kcol
  elseif klane[$LANE_FSM] == $MLR_FSM_KEYDOWN then
    kstart min klane[$LANE_FSMVAL], kcol
    kend max klane[$LANE_FSMVAL], kcol
    klane[$LANE_START] = kstart
    klane[$LANE_END] = kend
    klane[$LANE_RESET] = 1
    klane[$LANE_OFFSET] = 0
    klanes _mlr_stop_group klane[$LANE_GROUP], klanes
    klane[$LANE_RUNNING] = 1
    lpledon $LP_GREEN, 0, klane[$LANE_GROUP]
    klane[$LANE_FSM] = $MLR_FSM_TILLRELEASE
    klane[$LANE_FSMVAL] = 2
  elseif klane[$LANE_FSM] == $MLR_FSM_TILLRELEASE then
    klane[$LANE_FSMVAL] = klane[$LANE_FSMVAL] + 1
  endif
  klanes setrow klane, klanenum
  xout klanes
endop


instr mlr
  icolumns = (p4==0 ? 8 : p4)
  klanes[][] init 7, $LANE_STRUCT_SIZE
  klane init 1
  kgroup init 0
  konce init 0
  lpclear_i
  itables[], ilens[], igroups[], iends[] _mlr_setup icolumns

  if konce == 0 then
    kndx = 0
    while kndx < 7 do
      klanes[kndx][$LANE_TABLE] = itables[kndx]
      klanes[kndx][$LANE_SAMPLELEN] = ilens[kndx]
      klanes[kndx][$LANE_GROUP] = igroups[kndx]
      klanes[kndx][$LANE_END] = iends[kndx]
      kndx += 1
    od
    konce = 1
  endif

  klanes _mlr_lane_reset_clear klanes

  ktrig, kevent, krow, kcol lpread
  if (ktrig==1) then
    klane = krow-1
    if kevent == $LP_KEY_DOWN && krow == 0 && kcol < 4 then
      ;; click on group
      kgroup = kcol
      klanes _mlr_stop_group kgroup, klanes
      lpledoff 0, kgroup
    elseif krow > 0 && kevent == $LP_KEY_UP then
      klanes _mlr_lane_keyup klane, kcol, klanes
    elseif krow > 0 && kevent == $LP_KEY_DOWN then
      klanes _mlr_lane_keydown klane, kcol, klanes
    endif
  endif

  asig0 _mlr_lane 0, icolumns, klanes
  asig1 _mlr_lane 1, icolumns, klanes
  asig2 _mlr_lane 2, icolumns, klanes
  asig3 _mlr_lane 3, icolumns, klanes
  asig4 _mlr_lane 4, icolumns, klanes
  asig5 _mlr_lane 5, icolumns, klanes
  asig6 _mlr_lane 6, icolumns, klanes
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
