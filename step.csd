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



instr step
	kgrid[][] init 8, 8
	kbpm init 80
	
	; next step and last step
	knextstep init 0
	klaststep init 7
	
	; clear the grid at init time
	LPcleari
	
	; fill the first row at init time
	indx = 0
	until indx == 8 do
		LPledoni 60, 0, indx
		indx += 1
	od
	
	ktrig, kevent, krow, kcol LPread
	if ktrig == 1 then
	 kstatus = kgrid[krow][kcol]
		; on keydown on row 2-8, toggle grid status
		if krow > 0 && kevent == 1 && kstatus == 0 then
		 kgrid[krow][kcol] = 1
			LPledon LPcolor(0, 3), krow, kcol
		
		elseif krow > 0 && kevent == 1 && kstatus == 1 then
			kgrid[krow][kcol] = 0
			LPledoff krow, kcol
		
		; on keyup on row 1, set current step
		elseif krow == 0 && kevent == 0 then
			knextstep = kcol
		endif
	endif
	
	ktick metro (kbpm * 4 / 60)
	if ktick == 1 then
		
		kndx = 1
		until kndx == 8 do
			kstate = kgrid[kndx][knextstep]
			if kstate == 1 then
				event "i", "synth", 0, 0.1, kndx-1
			else
				LPledon LPcolor(1,1), kndx, knextstep
			endif

			if kgrid[kndx][klaststep] == 0 then
				LPledoff kndx, klaststep
			endif

			kndx += 1
		od
		
		klaststep = knextstep
		knextstep = (knextstep +1)%8
	endif
endin


instr synth
	inote = p4
	Sfiles[] fillarray "/home/gg/downloads/patatap-samples-wav/strike_A.wav",
                   "/home/gg/downloads/patatap-samples-wav/strike_B.wav",
                   "/home/gg/downloads/patatap-samples-wav/strike_C.wav",
                   "/home/gg/downloads/patatap-samples-wav/strike_D.wav",
                   "/home/gg/downloads/patatap-samples-wav/strike_E.wav",
                   "/home/gg/downloads/patatap-samples-wav/strike_F.wav",
                   "/home/gg/downloads/patatap-samples-wav/piston-1_A.wav"
	xtratim filelen(Sfiles[inote])
	a1, a2 diskin2 Sfiles[inote]
	out a1, a2
endin

; enable step instrument
alwayson "step"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
