/*
  tlinen    - Triggerable version of linen opcode
*/


#ifndef TLINENUDO


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


#define TLINENUDO ##
#end

