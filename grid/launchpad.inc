#define LPNOTEON #144#
#define LPNOTEOFF #128#

#define LPOFF #12#
#define LPRED #15#
#define LPAMBER #63#
#define LPYELLOW #62#
#define LPGREEN #60#


opcode LPread, kkkk, J
	kch xin

	ktrigger = 0
	kevent = 0
	krow = 0
	kcol = 0

	kstatus, kchan, kdata1, kdata2 midiin
	if kchan == kch || kch == -1 then
		if kstatus == $LPNOTEON then
			krow = int(kdata1 / 16)
			kcol = int(kdata1 % 16)
			if kdata2 == 127 then
				ktrigger = 1
				kevent = 1
			elseif kdata2 == 0 then
			 ktrigger = 1
			 kevent = 0
			endif
		endif 
	endif
	xout ktrigger, kevent, krow, kcol
endop


opcode LPledon, 0, kkkO
	kcolor, krow, kcol, kchan xin
	midiout $LPNOTEON, kchan, (krow*16)+kcol, kcolor
endop


opcode LPledoni, 0, iiio
	icolor, irow, icol, ichan xin
	midiout_i $LPNOTEON, ichan, (irow*16)+icol, icolor
endop


opcode LPledoff, 0, kkO
	krow, kcol, kchan xin
	midiout $LPNOTEOFF, kchan, (krow*16)+kcol, 0
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
