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


; fsm states for top line
#define STEP_FSM_WAIT        #0#
#define STEP_FSM_KEYDOWN     #1#
#define STEP_FSM_TILLRELEASE #2#

; colors
#define STEP_NOTE_COLOR   #$LP_GREEN#
#define STEP_CURSOR_COLOR #$LP_AMBER#
#define STEP_LOOP_COLOR   #$LP_GREEN_LOW#

instr step
	kgrid[][] init 8, 8
	kbpm init 80
	
	; next step and last step
	knextstep init 0
	klaststep init 7

	; clear the grid at init time
	LPcleari

	; loop start / loop end
	kloopstart init 0
	kloopend init 7

	; initialize top row state machine
	kfsm init $STEP_FSM_WAIT
	
	; fill the first row at init time
	indx = 0
	until indx == 8 do
		LPledoni $STEP_LOOP_COLOR, 0, indx
		indx += 1
	od

	ktrig, kevent, krow, kcol LPread
	if ktrig == 1 then
	 kstatus = kgrid[krow][kcol]

		; on keydown on row 2-8, toggle grid status
		if krow > 0 && kevent == $LP_KEY_DOWN && kstatus == 0 then
		 kgrid[krow][kcol] = 1
			LPledon $STEP_NOTE_COLOR, krow, kcol

		elseif krow > 0 && kevent == $LP_KEY_DOWN && kstatus == 1 then
			kgrid[krow][kcol] = 0
			LPledoff krow, kcol
		
		; keyevent on first row
		elseif krow == 0 then
			if kfsm == $STEP_FSM_WAIT && kevent == $LP_KEY_DOWN then
				key1 = kcol
				kfsm = $STEP_FSM_KEYDOWN
			elseif kfsm == $STEP_FSM_KEYDOWN && kevent == $LP_KEY_UP then
				knextstep = kcol
				kfsm = $STEP_FSM_WAIT
			elseif kfsm == $STEP_FSM_KEYDOWN && kevent == $LP_KEY_DOWN then
				; set new loop points
			 kloopstart min kcol, key1
			 kloopend max kcol, key1
			 ; update top row
			 kndx = 0
			 until kndx == 8 do
					if kndx >= kloopstart && kndx <= kloopend then
						LPledon $STEP_LOOP_COLOR, 0, kndx
					else
						LPledoff 0, kndx
					endif
					kndx += 1
			 od
			 ; new fsm state
				kfsm = $STEP_FSM_TILLRELEASE
				kfsm_tillrelease = 2
			elseif kfsm == $STEP_FSM_TILLRELEASE && kevent == 1 then
				kfsm_tillrelease += 1
			elseif kfsm == $STEP_FSM_TILLRELEASE && kevent == 0 then
			 kfsm_tillrelease -= 1
			 if kfsm_tillrelease == 0 then
					kfsm = $STEP_FSM_WAIT
			 endif
			endif
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
				LPledon $STEP_CURSOR_COLOR, kndx, knextstep
			endif

			if kgrid[kndx][klaststep] == 0 then
				LPledoff kndx, klaststep
			endif

			kndx += 1
		od
		
		klaststep = knextstep
		knextstep += 1
		if knextstep > kloopend then
			knextstep = kloopstart
		endif
	endif
endin


instr synth
	inote = p4
	Sdir = "/home/gg/downloads/samples/sums/step/"
	Sfiles[] fillarray strcat(Sdir, "bd01.wav"), strcat(Sdir, "sd01.wav"),
	                   strcat(Sdir, "mt01.wav"), strcat(Sdir, "cp01.wav"),
	                   strcat(Sdir, "cr01.wav"), strcat(Sdir, "oh01.wav"),
	                   strcat(Sdir, "hh01.wav")
	xtratim filelen(Sfiles[inote])
	a1 diskin2 Sfiles[inote]
	out a1, a1
endin

; enable step instrument
alwayson "step"
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
