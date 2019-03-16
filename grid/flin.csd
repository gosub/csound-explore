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


instr flin
  kbpm init 120
  khead[] init 8
  kspeed[] init 8
  klength[] fillarray 4,4,4,4,4,4,4,4
  kcounter[] init 8
  kdepth init 16

  ; clear the grid at init time
  lpclear_i

  ktrig, kevent, krow, kcol lpread
  if ktrig == 1 then
    if kevent == $LP_KEY_DOWN && krow == 7 then
      ; keypress on last row
      ; if column running, stop the note
      if (kspeed[kcol] != 0) then
        turnoff2 nstrnum("flin_synth")+(kcol*0.01), 4, 1
      fi
      ; set speed to zero
      kspeed[kcol] = 0
      ; clear the column
      lpcolumnoff kcol
    elseif kevent == $LP_KEY_DOWN && krow < 7 then
      ; keypress from first to butlast row
      ; set speed according to column
      ; reinit head and counter
      if (kspeed[kcol] == 0) then
        khead[kcol] = -1
        kcounter[kcol] = 1
        lpcolumnon $LP_GREEN_LOW, kcol
      fi
      kspeed[kcol] = krow + 1
    endif
  endif

  ; set metronome to 16th of kbpm
  ktick metro (kbpm * 4 / 60)
  if ktick == 1 then
    kcol = 0
    until kcol == 8 do
      if kspeed[kcol] != 0 then
        if kcounter[kcol] >= kspeed[kcol] then

          kcounter[kcol] = 1
          khead[kcol] = khead[kcol] + 1

          ; if head reaches bottom of loop zone, backup
          if khead[kcol] >= kdepth then
            khead[kcol] = 0
          endif

          ; if head reaches first row, play note
          if khead[kcol] == 0 then
            event "i", nstrnum("flin_synth")+(kcol*0.01), 0, -1, kcol
          endif

          ; if tail reaches first row, stop note
          if khead[kcol] == 0 + klength[kcol] then
            turnoff2 nstrnum("flin_synth")+(kcol*0.01), 4, 1
          endif


          ; if head between 0 and 7, light a led
          if (khead[kcol] >= 0) && (khead[kcol] <= 7) then
            lpledon $LP_GREEN, khead[kcol], kcol
          endif

          ; if tail between 0 and 7, turn off a led
          if (khead[kcol] >= klength[kcol]) && (khead[kcol] <= 7+klength[kcol]) then
            lpledon $LP_GREEN_LOW, khead[kcol]+klength[kcol], kcol
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
