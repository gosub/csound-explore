/*
  randint - return a random int between max and min (default 0)
*/


#ifndef RANDINTUDO


#include "minmax.udo"


opcode randint, k, kO
  kmax, kmin xin
  kmin int kmin
  kmax int kmax
  ; ensure sorting
  kmin, kmax minmax kmin, kmax
  krnd random kmin, kmax+0.9999
  krnd int krnd
  xout krnd
endop


opcode randint, i, io
  imax, imin xin
  imin int imin
  imax int imax
  ; ensure sorting
  imin, imax minmax imin, imax
  irnd random imin, imax+0.9999
  irnd int irnd
  xout irnd
endop


#define RANDINTUDO ##
#end
