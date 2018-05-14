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


instr flin
	kbpm init 80
	khead[] init 8
	kspeed[] init 8
	klength[] fillarray 4,4,4,4,4,4,4,4
	kcounter[] init 8

	; clear the grid at init time
	LPcleari

	; fill the last row at init time
	indx = 0
	until indx == 8 do
		LPledoni $LPRED, 7, indx
		indx += 1
	od

	ktrig, kevent, krow, kcol LPread
	if ktrig == 1 then
		if kevent == 1 && krow == 7 then
			; keypress on last row
			; set speed to zero
			kspeed[kcol] = 0
			; clear the column
			kndx = 0
			until kndx == 7 do
				LPledoff kndx, kcol
				kndx += 1
			od
		elseif kevent == 1 && krow < 7 then
		 ; keypress from first to butlast row
		 ; set speed according to column
			; reinit head and counter
			khead[kcol] = -1
			kcounter[kcol] = 1
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
     
     ; if head reaches last row, play note
     if khead[kcol] == 7 then
      event "i", nstrnum("flin_synth")+(kcol*0.01), 0, -1, kcol
     endif

     ; if tail reaches last row, stop note
     if khead[kcol] == 7 + klength[kcol] then
      turnoff2 nstrnum("flin_synth")+(kcol*0.01), 4, 0
     endif
     
     ; if head reaches bottom of loop zone, backup
     if khead[kcol] >= 16 then
      khead[kcol] = 0
     endif
     
     ; if head between 0 and 6, light a led
     if (khead[kcol] >= 0) && (khead[kcol] <= 6) then
      LPledon $LPGREEN, khead[kcol], kcol
     endif
     
     ; if tail between 0 and 6, turn off a led
     if (khead[kcol] >= klength[kcol]) && (khead[kcol] <= 6+klength[kcol]) then
      LPledoff khead[kcol]+klength[kcol], kcol
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
	inote = p4
	a1 oscili 0.1, (p4+1)*110
	out a1, a1
endin

; enable flin instrument
alwayson "flin"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
