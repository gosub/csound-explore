/*
  tsequence - Triggerable Sequencer
  tchoice   - Triggerable Random Sequencer
  tstepper  - Trigerrable Advanced Sequencer
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


;; TODO: twchoice, weighted random sequencer


opcode tstepper, k, kk[]POOO
  ktrig, ksequence[], kstep, kreverse, krotate, kreset xin
  kout init 0
  kindex init 0
  krestart init 1
  if kreset == 1 then
    krestart = 1
  endif
  if ktrig == 1 then
    if krestart == 1 then
      kindex = 0
      krestart = 0
    else
      kindex += kstep * (kreverse!=0 ? -1 : 1)
      if kindex < 0 then
        kindex = lenarray:k(ksequence) + kindex
      endif
    endif
    kindex = kindex % lenarray:k(ksequence)
    krotated = (kindex + krotate) % lenarray:k(ksequence)
    kout = ksequence[int(krotated)]
  endif
  xout kout
endop

