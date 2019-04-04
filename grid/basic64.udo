/*
  momo - 64 momentary switches
  togo - 64 toggle switches
  runbygrid - udo for scheduling instruments with momo and togo
  fado - 8 smooth faders
  pato - 64 patching points, 32ins (left) 32outs (right)
  patchby - udo for connecting opcodes with pato
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


opcode _pato_same_pos, k, kkkk
  krow1, kcol1, krow2, kcol2 xin
  kout = ((krow1==krow2) && (kcol1==kcol2) ? 1 : 0)
  xout kout
endop


opcode _pato_same_side, k, kk
  kcol1, kcol2 xin
  kside1 = ((kcol1 < 4) ? 0 : 1)
  kside2 = ((kcol2 < 4) ? 0 : 1)
  kout = ((kside1 == kside2) ? 1 : 0)
  xout kout
endop


opcode _pato_draw_links_from, 0, kkk[]
  krow, kcol, kconnections[] xin
  lpclear
  kside = (kcol<4 ? 0 : 1)
  lpledon (kside==0?$LP_GREEN:$LP_RED), krow, kcol
  if kside == 0 then
    kindex = krow * 4 + kcol
    klinks[] getrow kconnections, kindex
  else
    kindex = krow * 4 + kcol - 4
    klinks[] getcol kconnections, kindex
  endif
  kindex = 0
  while kindex < 32 do
    if klinks[kindex] == 1 then
      lpledon (kside==0 ? $LP_RED : $LP_GREEN), int(kindex / 4), (kindex % 4) + (kside==0 ? 4 : 0)
    endif
    kindex += 1
  od
endop


opcode _pato_draw_all_links, 0, k[]
  kconnections[] xin
  lpclear
  krow = 0
  while krow < 8 do
    kcol = 0
    while kcol < 4 do
      kindex = krow * 4 + kcol
      if sumarray(getrow(kconnections, kindex)) > 0 then
        lpledon $LP_GREEN_LOW, krow, kcol
      endif
      if sumarray(getcol(kconnections, kindex)) > 0 then
        lpledon $LP_RED_LOW, krow, kcol+4
      endif
      kcol += 1
    od
    krow += 1
  od
endop


opcode _pato_find_connection, kk, kkkk
  krow1, kcol1, krow2, kcol2 xin
  if kcol1<4 then
    kfromrow = krow1
    kfromcol = kcol1
    ktorow = krow2
    ktocol = kcol2
  else
    kfromrow = krow2
    kfromcol = kcol2
    ktorow = krow1
    ktocol = kcol1
  endif
  koutputrow = kfromrow * 4 + kfromcol
  koutputcol = ktorow * 4 + (ktocol-4)
  xout koutputrow, koutputcol
endop


opcode pato, k[], 0
  kconnections[] init 32,32
  kconnecting init 0
  kfromrow, kfromcol init 0, 0
  lpclear_i
  ktrigger, kevent, krow, kcol lpread
  if ktrigger == 1 then
    if kevent == $LP_KEY_DOWN then
      if kconnecting == 0 then
        ; starting a new connection
        kconnecting = 1
        kfromrow = krow
        kfromcol = kcol
        _pato_draw_links_from kfromrow, kfromcol, kconnections
      elseif _pato_same_pos(krow, kcol, kfromrow, kfromcol) == 1 then
        ; click on same button cancel the connection
        kconnecting = 0
        _pato_draw_all_links kconnections
      elseif _pato_same_side(kcol, kfromcol) == 1 then
        ; click on same side restart the connection
        kfromrow = krow
        kfromcol = kcol
        _pato_draw_links_from kfromrow, kfromcol, kconnections
      else
        ; click on other side closes/open the connection
        kconnecting = 0
        kin, kout _pato_find_connection krow, kcol, kfromrow, kfromcol
        kconnections[kin][kout] = (kconnections[kin][kout] == 1 ? 0 : 1)
        _pato_draw_all_links kconnections
      endif
    endif
  endif
  xout kconnections
endop


opcode patchby, k[], k[]k[]
  kpatches[][], kinputs[] xin
  koutputs[] init 32
  koutput = 0
  while koutput<32 do
    koutputs[koutput] = sumarray(kinputs * getcol(kpatches, koutput))
    koutput += 1
  od
  xout koutputs
endop
