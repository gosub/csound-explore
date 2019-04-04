/*
  momo - 64 momentary switches
  togo - 64 toggle switches
  runbygrid - udo for scheduling instruments with momo and togo
  fado - 8 smooth faders
*/

#include "lpmini.inc"


opcode momo, k[], 0
  kgrid[][] init 8, 8
  ktrigger, kevent, krow, kcol lpread
  if ktrigger == 1 then
    if kevent == $LP_KEY_DOWN then
      lpledon $LP_GREEN, krow, kcol
      kgrid[krow][kcol] = 1
    elseif kevent == $LP_KEY_UP then
      lpledoff krow, kcol
      kgrid[krow][kcol] = 0
    endif
  endif
  xout kgrid
endop


opcode togo, k[], 0
  kgrid[][] init 8, 8
  ktrigger, kevent, krow, kcol lpread
  if ktrigger == 1 then
    if kevent == $LP_KEY_DOWN then
      if kgrid[krow][kcol] == 0 then
        lpledon $LP_GREEN, krow, kcol
        kgrid[krow][kcol] = 1
      else
        lpledoff krow, kcol
        kgrid[krow][kcol] = 0
      endif
    endif
  endif
  xout kgrid
endop


opcode runbygrid, 0, k[]kO
  kgrid[][], kinstrument, kduration xin
  krunning[][] init 8,8
  kduration = (kduration == 0 ? -1 : kduration)
  krow = 0
  while krow < 8 do
    kcol = 0
    while kcol < 8 do

      kinstance = kinstrument + (krow*8+kcol) * 0.01
      kgate = kgrid[krow][kcol]
      if kgate == 1 then
        if (krunning[krow][kcol] == 0) then
          event "i", kinstance, 0, kduration, krow, kcol
          krunning[krow][kcol] = 1
        endif
      else
        if (krunning[krow][kcol] != 0) then
          turnoff2 kinstance, 4, 1
          krunning[krow][kcol] = 0
        endif
      endif

      kcol += 1
    od
    krow += 1
  od
endop


opcode _fado_col, k, kik
  krow, icol, ksmoothness xin
  ksmooth init 0
  kled init 0
  lpledon_i $LP_GREEN, 7, icol

  ksmooth portk krow/7, ksmoothness
  koldled = kled
  kled = round(portk(krow, ksmoothness))
  if (changed:k(kled) == 1) then
    kstart min kled, koldled
    kend max kled, koldled
    kindex = kstart
    while kindex <= kend do
      if kindex <= kled then
        lpledon $LP_GREEN, 7-kindex, icol
      else
        lpledoff, 7-kindex, icol
      endif
      kindex += 1
    od
  endif
  xout ksmooth
endop


opcode fado, k[], 0
  kvalue[] init 8
  ksmooth[] init 8
  ksmoothness init 0.1
  lpclear_i
  ktrigger, kevent, krow, kcol lpread
  if ktrigger == 1 then
    if kevent == $LP_KEY_UP then
      kvalue[kcol] = 7-krow
    endif
  endif
  ksmooth[0] _fado_col kvalue[0], 0, ksmoothness
  ksmooth[1] _fado_col kvalue[1], 1, ksmoothness
  ksmooth[2] _fado_col kvalue[2], 2, ksmoothness
  ksmooth[3] _fado_col kvalue[3], 3, ksmoothness
  ksmooth[4] _fado_col kvalue[4], 4, ksmoothness
  ksmooth[5] _fado_col kvalue[5], 5, ksmoothness
  ksmooth[6] _fado_col kvalue[6], 6, ksmoothness
  ksmooth[7] _fado_col kvalue[7], 7, ksmoothness
  xout ksmooth
endop


;; TODO: add pato, basic cable patching app
