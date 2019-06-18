/*
  strchanged - return 1 when a string changes
  strchanged2 - return 1 when a string changes and at start
*/


#ifndef STRCHANGEDUDO


opcode strchanged, k, S
  Str xin
  Stored strcpy Str
  kout init 0
  kout = (strcmpk(Stored,Str)==0?0:1)
  Stored strcpyk Str
  xout kout
endop


opcode strchanged2, k, S
  Str xin
  Stored strcpy Str
  kout init 0
  kfirst init 1
  kout = (strcmpk(Stored,Str)==0?0:1)
  Stored strcpyk Str
  if kfirst == 1 then
    kout = 1
    kfirst = 0
  endif
  xout kout
endop


#define STRCHANGEDUDO ##
#end
