/*
  tsequence - Triggerable Sequencer
  tchoice   - Triggerable Random Sequencer
  twchoice  - Triggerable Weighted Random Sequencer
  tstepper  - Trigerrable Advanced Sequencer
  tcount    - Trigger counter
  tline     - Triggerable version of line opcode
  tlinen    - Triggerable version of linen opcode
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


opcode tline, k, kiii
  ktrig, ia, idur, ib xin
  krun init 0
  kstart init 0

  if ktrig == 1 then
    krun = 1
    kstart timeinsts
    reinit retrig
  endif

  kelapsed = timeinsts() - kstart
  retrig:
  if kelapsed >= idur then
    kout = ib
  elseif krun == 1 then
    kout line ia, idur, ib
  else
    kout = ia
  endif
  xout kout
endop


opcode tline, a, kiii
  ktrig, ia, idur, ib xin
  krun init 0
  kstart init 0

  if ktrig == 1 then
    krun = 1
    kstart timeinsts
    reinit retrig
  endif

  retrig:
  kelapsed = timeinsts() - kstart
  if kelapsed >= idur then
    aout = ib
  elseif krun == 1 then
    aout line ia, idur, ib
  else
    aout = ia
  endif
  xout aout
endop


opcode tlinen, k, kkiii
  ktrig, kamp, irise, idur, idec xin
  krun, kstart init 0, 0

  if ktrig == 1 then
    krun = 1
    kstart timeinsts
    reinit retrig
  endif

  kelapsed = timeinsts() - kstart
  retrig:
  koutside = ((kelapsed >= idur) || (krun == 0) ? 1 : 0)
  kout = (koutside == 1 ? 0 : linen:k(kamp, irise, idur, idec))
  xout kout
endop


opcode tlinen, a, kaiii
  ktrig, aamp, irise, idur, idec xin
  krun, kstart init 0, 0

  if ktrig == 1 then
    krun = 1
    kstart timeinsts
    reinit retrig
  endif

  kelapsed = timeinsts() - kstart
  retrig:
  koutside = ((kelapsed >= idur) || (krun == 0) ? 1 : 0)
  aout = (koutside == 1 ? 0 : linen:a(aamp, irise, idur, idec))
  xout aout
endop


;; TODO: tcoin
;; TODO: tcoin test
;; TODO: tcoin to readme
;; TODO: trandomwalk
;; TODO: trandomwalk test
;; TODO: trandomwalk to readme
;; TODO: each udo in a separate file inside the tee directory
