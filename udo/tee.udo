/*
  tsequence - Triggerable Sequencer
  tchoice   - Triggerable Random Sequencer
  twchoice  - Triggerable Weighted Random Sequencer
  tstepper  - Trigerrable Advanced Sequencer
  tcount    - Trigger counter
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


opcode tchoice, k, kk[]
  ktrig, ksequence[] xin
  kout init 0
  if ktrig == 1 then
    kindex random 0, lenarray:k(ksequence) - 0.001
    kout = ksequence[int(kindex)]
  endif
  xout kout
endop


opcode twchoice, k, kk[]k[]
  ktrig, ksequence[], kweights[] xin
  kout init 0
  if ktrig == 1 then
    krnd random 0, sumarray(kweights)
    kindex = 0
    ksum = 0
    kfound = -1
    until (kindex == lenarray(kweights)) || (kfound != -1) do
      ksum += kweights[kindex]
      if krnd < ksum then
        kfound = kindex
      endif
      kindex += 1
    od
    kout = ksequence[int(kfound)]
  endif
  xout kout
endop


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


opcode tcount, k, ko
  ktrig, imax xin
  kvalue init 0
  if ktrig == 1 then
    kvalue += 1
    kvalue = (imax != 0 ? kvalue % imax : kvalue)
  endif
  xout kvalue
endop


opcode tcount, k, kO
  ktrig, kmax xin
  kvalue init 0
  if ktrig == 1 then
    kvalue += 1
    kvalue = (kmax != 0 ? kvalue % kmax : kvalue)
  endif
  xout kvalue
endop

;; TODO: tline
;; TODO: tlinen
