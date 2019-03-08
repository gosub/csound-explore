/*
  clockdiv - Clock Divider
*/


opcode clockdiv, k, kk
  kcount init 0
  ktrig, kdiv xin
  kres = 0
  if (ktrig == 1) then
    if (kcount == 0) then
      kres = 1
    endif
    kcount += 1
    kcount = kcount % kdiv
  endif
  xout kres
endop

