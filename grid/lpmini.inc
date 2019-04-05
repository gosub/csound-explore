#ifndef LPMINIINC


#define LP_NOTEON   #144#
#define LP_NOTEOFF  #128#
#define LP_MIDICC   #176#

#define LP_OFF        #12#
#define LP_GREEN      #60#
#define LP_GREEN_MID  #44#
#define LP_GREEN_LOW  #28#
#define LP_RED        #15#
#define LP_RED_MID    #14#
#define LP_RED_LOW    #13#
#define LP_YELLOW     #61#
#define LP_AMBER      #31#
#define LP_AMBER_MID  #30#
#define LP_AMBER_LOW  #47#
#define LP_ORANGE     #63#
#define LP_ORANGE_MID #46#
#define LP_ORANGE_LOW #29#
#define LP_OCHRE      #62#
#define LP_OCHRE_LOW  #45#

#define LP_KEY_DOWN  #1#
#define LP_KEY_UP    #0#
#define LP_SIDE_DOWN #3#
#define LP_SIDE_UP   #2#
#define LP_TOP_DOWN  #5#
#define LP_TOP_UP    #4#


opcode lpread, kkkk, J
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
    elseif kstatus == $LP_MIDICC then
      kcol = kdata1-104
      krow = 0
      if kdata2 == 127 then
        ktrigger = 1
        kevent = $LP_TOP_DOWN
      elseif kdata2 == 0 then
        ktrigger = 1
        kevent = $LP_TOP_UP
      endif
    endif
  endif
  xout ktrigger, kevent, krow, kcol
endop


opcode lpledon, 0, kkkO
  kcolor, krow, kcol, kchan xin
  midiout $LP_NOTEON, kchan, (krow*16)+kcol, kcolor
endop


opcode lpledon_i, 0, iiio
  icolor, irow, icol, ichan xin
  midiout_i $LP_NOTEON, ichan, (irow*16)+icol, icolor
endop


opcode lpledoff, 0, kkO
  krow, kcol, kchan xin
  midiout $LP_NOTEOFF, kchan, (krow*16)+kcol, 0
endop


opcode lpledoff_i, 0, iio
  irow, icol, ichan xin
  midiout_i $LP_NOTEOFF, ichan, (irow*16)+icol, 0
endop


opcode lpclear, 0, O
  kchan xin
  midiout 176, kchan, 0, 0
endop


opcode lpclear_i, 0, o
  ichan xin
  midiout_i 176, ichan, 0, 0
endop


opcode lpcolumnon, 0, kkO
  kcolor, kcolumn, kchan xin
  kindex = 0
  while (kindex < 8) do
    lpledon kcolor, kindex, kcolumn, kchan
    kindex += 1
  od
endop


opcode lpcolumnon_i, 0, iio
  icolor, icolumn, ichan xin
  iindex = 0
  while (iindex < 8) do
    lpledon_i icolor, iindex, icolumn, ichan
    iindex += 1
  od
endop


opcode lpcolumnoff, 0, kO
  kcolumn, kchan xin
  kindex = 0
  while (kindex < 8) do
    lpledoff kindex, kcolumn, kchan
    kindex += 1
  od
endop


opcode lpcolumnoff_i, 0, io
  icolumn, ichan xin
  iindex = 0
  while (iindex < 8) do
    lpledoff_i iindex, icolumn, ichan
    iindex += 1
  od
endop


opcode lprowon, 0, kkO
  kcolor, krow, kchan xin
  kindex = 0
  while (kindex < 8) do
    lpledon kcolor, krow, kindex, kchan
    kindex += 1
  od
endop


opcode lprowon_i, 0, iio
  icolor, irow, ichan xin
  iindex = 0
  while (iindex < 8) do
    lpledon_i icolor, irow, iindex, ichan
    iindex += 1
  od
endop


opcode lprowoff, 0, kO
  krow, kchan xin
  kindex = 0
  while (kindex < 8) do
    lpledoff krow, kindex, kchan
    kindex += 1
  od
endop


opcode lprowoff_i, 0, io
  irow, ichan xin
  iindex = 0
  while (iindex < 8) do
    lpledoff_i irow, iindex, ichan
    iindex += 1
  od
endop


opcode lpcolor, k, kk
  kred, kgreen xin
  kred min kred, 3
  kgreen min kgreen, 3
  xout 12+(kgreen*16)+kred
endop


opcode lpcolor_i, i, ii
  ired, igreen xin
  ired min ired, 3
  igreen min igreen, 3
  xout 12+(igreen*16)+ired
endop


opcode lpsideon, 0, kkO
  kcolor, krow, kchan xin
  midiout $LP_NOTEON, kchan, (krow*16)+8, kcolor
endop


opcode lpsideon_i, 0, iio
  icolor, irow, ichan xin
  midiout_i $LP_NOTEON, ichan, (irow*16)+8, icolor
endop


opcode lpsideoff, 0, kO
  krow, kchan xin
  midiout $LP_NOTEOFF, kchan, (krow*16)+8, 0
endop


opcode lpsideoff_i, 0, io
  irow, ichan xin
  midiout_i $LP_NOTEOFF, ichan, (irow*16)+8, 0
endop


;; TODO: add lptopon, lptopoff, lptopon_i, lptopoff_i


#define LPMINIINC ##
#end
