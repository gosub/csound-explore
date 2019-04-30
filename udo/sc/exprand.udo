/*
  exprand - port of exprand method from supercollider
*/


opcode exprand, i, ii
  ilo, ihi xin
  iout = ilo * exp(log(ihi/ilo) * random(0, 1))
  xout iout
endop


opcode exprand, k, kk
  klo, khi xin
  kout = klo * exp(log(khi/klo) * random(0, 1))
  xout kout
endop
