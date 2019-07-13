/*
  tchoice   - Triggerable Random Sequencer
*/


opcode tchoice, k, kk[]
  ktrig, ksequence[] xin
  kout init 0
  if ktrig == 1 then
    kindex random 0, lenarray:k(ksequence) - 0.001
    kout = ksequence[int(kindex)]
  endif
  xout kout
endop


;; TODO: ifndef
