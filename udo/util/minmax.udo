/*
  minmax - sort two numbers
*/


#ifndef MINMAXUDO


opcode minmax, kk, kk
  ka, kb xin
  kmin min ka, kb
  kmax max ka, kb
  xout kmin, kmax
endop


opcode minmax, ii, ii
  ia, ib xin
  imin min ia, ib
  imax max ia, ib
  xout imin, imax
endop


#define MINMAXUDO ##
#end
