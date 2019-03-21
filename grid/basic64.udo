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
