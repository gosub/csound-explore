/*
  tline     - Triggerable version of line opcode
*/


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


;; TODO: ifndef

