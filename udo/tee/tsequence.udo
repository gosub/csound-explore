/*
  tsequence - Triggerable Sequencer
*/


#ifndef TSEQUENCEUDO


opcode tsequence, k, kk[]
  ktrig, ksequence[] xin
  kout init 0
  kindex init -1
  if (ktrig == 1) then
    kindex += 1
    kindex = kindex % lenarray:k(ksequence)
    kout = ksequence[int(kindex)]
  endif
  xout kout
endop


opcode tsequence, k[], kk[][]
  ktrig, ksequence[][] xin
  kindex init -1
  if (ktrig == 1) then
    kindex += 1
    kindex = kindex % lenarray:k(ksequence)
    kout[] getrow ksequence, int(kindex)
  endif
  xout kout
endop


#define TSEQUENCEUDO ##
#end
