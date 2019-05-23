/*
  momo - 64 momentary switches
*/

#include "../lpmini.inc"


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
