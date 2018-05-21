#define LP_NOTEON   #144#
#define LP_NOTEOFF  #128#

#define LP_OFF       #12#
#define LP_RED       #15#
#define LP_RED_LOW   #13#
#define LP_AMBER     #63#
#define LP_AMBER_LOW #29#
#define LP_YELLOW    #62#
#define LP_GREEN     #60#
#define LP_GREEN_LOW #28#

#define LP_KEY_DOWN  #1#
#define LP_KEY_UP    #0#
#define LP_SIDE_DOWN #3#
#define LP_SIDE_UP   #2#
#define LP_TOP_DOWN  #5#
#define LP_TOP_UP    #4#

opcode LPread, kkkk, J
	kch xin

	ktrigger = 0
	kevent = 0
	krow = 0
	kcol = 0

	kstatus, kchan, kdata1, kdata2 midiin
	if kchan == kch || kch == -1 then
		if kstatus == $LP_NOTEON then
			krow = int(kdata1 / 16)
			kcol = int(kdata1 % 16)
			if kdata2 == 127 then
				ktrigger = 1
				kevent = (kcol == 8 ? $LP_SIDE_DOWN : $LP_KEY_DOWN)
			elseif kdata2 == 0 then
			 ktrigger = 1
				kevent = (kcol == 8 ? $LP_SIDE_UP : $LP_KEY_UP)
			endif
		endif 
	endif
	xout ktrigger, kevent, krow, kcol
endop


opcode LPledon, 0, kkkO
	kcolor, krow, kcol, kchan xin
	midiout $LP_NOTEON, kchan, (krow*16)+kcol, kcolor
endop


opcode LPledoni, 0, iiio
	icolor, irow, icol, ichan xin
	midiout_i $LP_NOTEON, ichan, (irow*16)+icol, icolor
endop


opcode LPledoff, 0, kkO
	krow, kcol, kchan xin
	midiout $LP_NOTEOFF, kchan, (krow*16)+kcol, 0
endop


opcode LPclear, 0, O
	kchan xin
	midiout 176, kchan, 0, 0
endop


opcode LPcleari, 0, o
	ichan xin
	midiout_i 176, ichan, 0, 0
endop


opcode LPcolor, k, kk
	kred, kgreen xin
	kred min kred, 3
	kgreen min kgreen, 3
	xout (kgreen*16)+kred
endop
