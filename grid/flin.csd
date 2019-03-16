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

#include "launchpad.inc"

; states of a finite state machine
; for the possible key presses
; each column has its state
; INIT: no key presses
; HOLD1: one key down
; HOLDN: multiple keys down

#define FSM_INIT  #0#
#define FSM_HOLD1 #1#
#define FSM_HOLDN #2#


instr flin
  ; BPM
  kbpm init 120

  ; head position of the falling note, from 0 to kdepth
  khead[] init 8

  ; speed of the falling note
  ; also indicates if the note is on or off
  ; 1 is max speed, 8 min speed
  ; each tick a counter is increased
  ; when counter equals speed, note falls a step
  kspeed[] init 8

  ; length of the falling note
  klength[] fillarray 4,4,4,4,4,4,4,4

  ; virtual depth of the columns
  kdepth init 16

  ; counters for the speed measurement
  kcounter[] init 8

  ; current state of the column in the finite state machine
  kfsm[] init 8

  ; hold values for the state transitions
  kfsm_state[] init 8


  ; clear the grid at init time
  lpclear_i

  ktrig, kevent, krow, kcol lpread
  ; when a midi event occurs
  if ktrig == 1 then

    ; when no key are pressed and one key down occurs
    ; save the current row and transition to HOLD1
    if kfsm[kcol] == $FSM_INIT then
      if kevent == $LP_KEY_DOWN then
        kfsm_state[kcol] = krow
        kfsm[kcol] = $FSM_HOLD1
      endif

    ; when one key is pressed
    ; if one key up occurs
    ;   stop a running note if last row
    ;   start note and set speed based on row
    ;   go back to INIT
    ; if another key down occurs
    ;   save number ok keys down (2) to fsm_state
    ;   transition to HOLDN
    elseif kfsm[kcol] == $FSM_HOLD1 then
      if kevent == $LP_KEY_UP then
        if krow == 7 then
          if (kspeed[kcol] != 0) then
            turnoff2 nstrnum("flin_synth")+(kcol*0.01), 4, 1
            kspeed[kcol] = 0
            lpcolumnoff kcol
          endif
        else
          if (kspeed[kcol] == 0) then
            khead[kcol] = -1
            kcounter[kcol] = 1
            lpcolumnon $LP_GREEN_LOW, kcol
          endif
          kspeed[kcol] = krow + 1
        endif
        kfsm[kcol] = $FSM_INIT
      elseif kevent == $LP_KEY_DOWN then
        ;; TODO: when changing length
        ;;       leds get messy, must be redrawn
        ;;       but only if running!
        klength[kcol] = krow + 1
        kfsm_state[kcol] = 2
        kfsm[kcol] = $FSM_HOLDN
      endif

    ; when multiple keys are down
    ; fsm_value counts the number of keys down
    ; additional key_downs increase that value
    ; key_ups decrease it
    ; when state is 0 no button is pressed anymore
    ; and is possible to go back to INIT
    elseif kfsm[kcol] == $FSM_HOLDN then
      if kevent == $LP_KEY_DOWN then
        kfsm_state[kcol] = kfsm_state[kcol] + 1
      elseif kevent == $LP_KEY_UP then
        kfsm_state[kcol] = kfsm_state[kcol] - 1
        if kfsm_state[kcol] == 0 then
          kfsm[kcol] = $FSM_INIT
        endif
      endif
    endif

  endif

  ; set metronome to 16th of kbpm
  ktick metro (kbpm * 4 / 60)
  if ktick == 1 then
    kcol = 0
    until kcol == 8 do
      ; when note in current column is running
      if kspeed[kcol] != 0 then
        ; a note ticks only when counter matches speed
        ; speed is not a good name since 1 is max speed and
        ; 8 is min speed, slowness or drag would be a better name
        if kcounter[kcol] >= kspeed[kcol] then

          kcounter[kcol] = 1
          khead[kcol] = khead[kcol] + 1

          ; if head reaches bottom of loop zone, backup
          if khead[kcol] >= kdepth then
            khead[kcol] = 0
          endif

          ;; ktail is the last led of the falling note
          ;; if length is 1, ktail == khead
          ktail = khead[kcol] - klength[kcol] + 1

          ; if head reaches first row, play note
          if khead[kcol] == 0 then
            event "i", nstrnum("flin_synth")+(kcol*0.01), 0, -1, kcol
          endif

          ; if tail leaves first row, stop note
          if ktail == 1 then
            turnoff2 nstrnum("flin_synth")+(kcol*0.01), 4, 1
          endif


          ; if head between 0 and 7, light a led
          if (khead[kcol] >= 0) && (khead[kcol] <= 7) then
            lpledon $LP_GREEN, khead[kcol], kcol
          endif

          ; if tail between 1 and 8, turn off previous led
          if (ktail >= 1) && (ktail <= 8) then
            lpledon $LP_GREEN_LOW, ktail-1, kcol
          endif

        else
          ; increase speed counter
          kcounter[kcol] = kcounter[kcol] + 1
        endif
      endif
      kcol += 1
    od
  endif
endin


instr flin_synth
  imidi = 0
  idegree = p4
  iscale[] fillarray 50, 54, 57, 60, 64, 67, 71, 74
  if (imidi==0) then
    aEnv madsr 0.5,0,1,1
    a1 vco2 0.1, cpsmidinn(iscale[idegree])
    out a1*aEnv, a1*aEnv
  else
    midion 2, iscale[idegree], 100
  fi
endin


; enable flin instrument
alwayson "flin"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
