/*
  tsequence - Triggerable Sequencer
  tchoice   - Triggerable Random Sequencer
*/


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


opcode tchoice, k, kk[]
  ktrig, ksequence[] xin
  kout init 0
  if ktrig == 1 then
    kindex random 0, lenarray:k(ksequence) - 0.001
    kout = ksequence[int(kindex)]
  endif
  xout kout
endop
