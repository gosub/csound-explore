/*
  tcount    - Trigger counter
*/


#ifndef TCOUNTUDO


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


#define TCOUNTUDO ##
#end
