/*
  splay - port of splay ugen from supercollider
*/


opcode splay, aa, a[]o
  asignals[], index xin
  aL, aR init 0, 0
  ilen lenarray asignals
  ; level compensation only on index 0, after all the recursions
  ilevel = (index==0 ? sqrt(1/ilen) : 1)
  if index < ilen then
    ipos = index * 1/(ilen-1)
    aL, aR pan2 asignals[index], ipos, 2
    arestL, arestR splay asignals, index+1
    aL += arestL
    aR += arestR
  endif
  xout aL*ilevel, aR*ilevel
endop
