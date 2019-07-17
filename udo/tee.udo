/*
  tsequence - Triggerable Sequencer
  twchoice  - Triggerable Weighted Random Sequencer
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


;; TODO: trandomwalk
;; TODO: trandomwalk test
;; TODO: trandomwalk to readme
;; TODO: tsequence  UDO in a separate file inside the tee directory
;; TODO: twchoice   UDO in a separate file inside the tee directory

