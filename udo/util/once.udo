/*
  once - true only once, at k-rate
*/


#ifndef ONCEUDO


opcode once, k, 0
  kcount init 2
  if kcount > 0 then
    kcount -= 1
  endif
  xout kcount
endop


#define ONCEUDO ##
#end
