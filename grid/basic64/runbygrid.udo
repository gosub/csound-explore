/*
  runbygrid - udo for scheduling instruments with momo and togo
*/

#include "../lpmini.inc"


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
