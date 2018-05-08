<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
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
			; reset speed, head and counter
			kspeed[kcol] = 0
			khead[kcol] = -1
			kcounter[kcol] = 0
			; clear the column
			kndx = 0
			until kndx == 7 do
				LPledoff kndx, kcol
				kndx += 1
			od
		elseif kevent == 1 && krow < 7 then
		 ; keypress from first to butlast row
		 ; set speed according to column
			kspeed[kcol] = krow
		endif
	endif

	; set metronome to 16th of kbpm
	ktick metro (kbpm * 4 / 60)
	if ktick == 1 then
	; HIC SUNT LEONES
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
