/*
  patchby - udo for connecting opcodes with pato
*/

#include "../lpmini.inc"


opcode patchby, k[], k[]k[]
  kpatches[][], kinputs[] xin
  koutputs[] init 32
  koutput = 0
  while koutput<32 do
    koutputs[koutput] = sumarray(kinputs * getcol(kpatches, koutput))
    koutput += 1
  od
  xout koutputs
endop
