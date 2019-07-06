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
#define TABLE     #0#
#define SAMPLELEN #1#
#define RUNNING   #2#
#define RESET     #3#
#define OFFSET    #4#
#define GROUP     #5#
#define FSM       #6#
#define FSMVAL    #7#
#define START     #8#
#define END       #9#
#define DIR       #10#
#define STRUCT_SIZE #11#


opcode _mlr_setup, k[][], ik[][]
  icolumns, klanes[][] xin
  igroupassign[] fillarray 0,0,1,1,1,2,2 ;; lane -> group
  Sfold = "/home/gg/downloads/audio/samples/sum/mlr/"
  Sfiles[] fillarray "soul_chicken.wav", "timba.wav", "counterpoint.wav",\
                     "the_bends.wav", "plucks.wav", "pianos.wav", "voices.wav"
  itables[] init 7
  itables[0] ftgen 0,0,0,1,strcat(Sfold,Sfiles[0]),0,0,1
  itables[1] ftgen 0,0,0,1,strcat(Sfold,Sfiles[1]),0,0,1
  itables[2] ftgen 0,0,0,1,strcat(Sfold,Sfiles[2]),0,0,1
  itables[3] ftgen 0,0,0,1,strcat(Sfold,Sfiles[3]),0,0,1
  itables[4] ftgen 0,0,0,1,strcat(Sfold,Sfiles[4]),0,0,1
  itables[5] ftgen 0,0,0,1,strcat(Sfold,Sfiles[5]),0,0,1
  itables[6] ftgen 0,0,0,1,strcat(Sfold,Sfiles[6]),0,0,1
  ilens[] init 7
  ilens[0] filelen strcat(Sfold,Sfiles[0])
  ilens[1] filelen strcat(Sfold,Sfiles[1])
  ilens[2] filelen strcat(Sfold,Sfiles[2])
  ilens[3] filelen strcat(Sfold,Sfiles[3])
  ilens[4] filelen strcat(Sfold,Sfiles[4])
  ilens[5] filelen strcat(Sfold,Sfiles[5])
  ilens[6] filelen strcat(Sfold,Sfiles[6])

  konce init 0
  if konce == 0 then
    kndx = 0
    while kndx < 7 do
      ;read mono sample, since tablei does not support stereo
      klanes[kndx][$TABLE] = itables[kndx]
      klanes[kndx][$SAMPLELEN] = ilens[kndx]
      klanes[kndx][$GROUP] = igroupassign[kndx]
      klanes[kndx][$END] = icolumns -1
      kndx += 1
    od
    konce = 1
  endif

  xout klanes
endop


opcode _mlr_lane, a, iik[][]
  ilanenum, ilength, klanes[][] xin
  klane[] getrow klanes, ilanenum
  irow = ilanenum + 1
  klast init -1
  kprevlooping init 0
  kloopfrac = (abs(klane[$END] - klane[$START])+1)/ilength

  asig = 0
  if klane[$RUNNING] == 1 then
    async upsamp klane[$RESET]
    kfreq = 1/klane[$SAMPLELEN]*1/kloopfrac
    aphase, adummy syncphasor kfreq, async
    aphase = (klane[$DIR]==1 ? 1-aphase : aphase)
    aphase *= kloopfrac
    kphase downsamp aphase
    kindex = (int(kphase*(ilength-0.001)) + klane[$OFFSET] + klane[$START]) % ilength
    if kindex != klast then
      lpledon $LP_GREEN, irow, kindex
      if klast != -1 then
        lpledoff irow, klast
      endif
      klast = kindex
    endif
    aphase += 1/ilength * klane[$START]
    aphase += 1/ilength * klane[$OFFSET]
    asig tableikt aphase, klane[$TABLE], 1, 0, 1
  else
    if kprevlooping == 1 then
      lpledoff irow, klast
      klast = -1
    endif
  endif
  kprevlooping = klane[$RUNNING]
  xout asig
endop


opcode _mlr_stop_group, k[][], kk[][]
; given a group, a group_assign and current running status
; return a new running status
  kgroup, klanes[][] xin
  klane = 0
  while klane < 7 do
    kassigned = klanes[klane][$GROUP]
    krunning = klanes[klane][$RUNNING]
    klanes[klane][$RUNNING] = (kassigned == kgroup ? 0 : krunning)
    klane += 1
  od
  xout klanes
endop


opcode _mlr_lane_reset_clear, k[][], k[][]
  klanes[][] xin
  kndx = 0
  while kndx < lenarray(klanes) do
    klanes[kndx][$RESET] = 0
    kndx += 1
  od
  xout klanes
endop


opcode _mlr_lane_start, k[][], kk[][]kkkk
  klanenum, klanes[][], koffset, kstart, kend, kdir xin
  klane[] getrow klanes, klanenum

  klane[$RESET] = 1
  klane[$OFFSET] = koffset
  klane[$START] = kstart
  klane[$END] = kend
  klane[$DIR] = kdir
  kgroup = klane[$GROUP]
  if klane[$RUNNING] == 0 then
    klanes _mlr_stop_group kgroup, klanes
    klane[$RUNNING] = 1
    lpledon $LP_GREEN, 0, kgroup
  endif

  klanes setrow klane, klanenum
  xout klanes
endop


opcode _mlr_lane_keyup, k[][], kkk[][]
  klanenum, kcol, klanes[][] xin
  if klanes[klanenum][$FSM] == $MLR_FSM_KEYDOWN then
    klanes _mlr_lane_start klanenum, klanes, kcol, 0, 7, 0
    klanes[klanenum][$FSM] = $MLR_FSM_WAIT
  elseif klanes[klanenum][$FSM] == $MLR_FSM_TILLRELEASE then
    if klanes[klanenum][$FSMVAL] > 1 then
      klanes[klanenum][$FSMVAL] = klanes[klanenum][$FSMVAL] -1
    else
      klanes[klanenum][$FSMVAL] = 0
      klanes[klanenum][$FSM] = $MLR_FSM_WAIT
    endif
  endif
  xout klanes
endop


opcode _mlr_lane_keydown, k[][], kkk[][]
  klanenum, kcol, klanes[][] xin
  if klanes[klanenum][$FSM] == $MLR_FSM_WAIT then
    klanes[klanenum][$FSM] = $MLR_FSM_KEYDOWN
    klanes[klanenum][$FSMVAL] = kcol
  elseif klanes[klanenum][$FSM] == $MLR_FSM_KEYDOWN then
    kstart = klanes[klanenum][$FSMVAL]
    kend = kcol
    if kstart <= kend then
      klanes _mlr_lane_start klanenum, klanes, 0, kstart, kend, 0
    else
      klanes _mlr_lane_start klanenum, klanes, 0, kend, kstart, 1
    endif
    klanes[klanenum][$FSM] = $MLR_FSM_TILLRELEASE
    klanes[klanenum][$FSMVAL] = 2
  elseif klanes[klanenum][$FSM] == $MLR_FSM_TILLRELEASE then
    klanes[klanenum][$FSMVAL] = klanes[klanenum][$FSMVAL] + 1
  endif
  xout klanes
endop


instr mlr
  icolumns = (p4==0 ? 8 : p4)
  klanes[][] init 7, $STRUCT_SIZE
  klane init 1
  kgroup init 0

  lpclear_i
  klanes _mlr_setup icolumns, klanes

  ;; at every k-cycle clear eventual lane reset
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
