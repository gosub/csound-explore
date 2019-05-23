/*
  togo - 64 toggle switches
*/

#include "../lpmini.inc"


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
