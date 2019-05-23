/*
  fado - 8 smooth faders
*/

#include "../lpmini.inc"


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
