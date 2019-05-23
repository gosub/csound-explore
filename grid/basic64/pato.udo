/*
  pato - 64 patching points, 32ins (left) 32outs (right)
*/

#include "../lpmini.inc"


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
