/*
  tprintk   - Print a k-rate value on trigger
*/


#ifndef TPRINTKUDO

opcode tprintk, 0, kko
  ktrig, kvalue, ispace xin
  if ktrig == 1 then
    printk 0, kvalue, ispace
  endif
endop


#define TPRINTK ##
#end

