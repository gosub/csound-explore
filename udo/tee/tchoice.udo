/*
  tchoice   - Triggerable Random Sequencer
*/


#ifndef TCHOICEUDO


opcode tchoice, k, kk[]
  ktrig, ksequence[] xin
  kout init 0
  if ktrig == 1 then
    kindex random 0, lenarray:k(ksequence) - 0.001
    kout = ksequence[int(kindex)]
  endif
  xout kout
endop


#define TCHOICEUDO ##
#end

