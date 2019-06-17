/*
  strchanged - return 1 when a string changes
  strchanged2 - return 1 when a string changes and at start
*/


;; TODO: tests
;; TODO: readme


#ifndef STRCHANGEDUDO


opcode strchanged, k, S
  Str xin
  kstored init 0
  if kstored == 0 then
    kstored = 1
    kout = 0
  else
    kout = (strcmp(Stored,Str)==0?0:1)
  endif
  Stored = Str
  xout kout
endop


opcode strchanged2, k, S
  Str xin
  kstored init 0
  if kstored == 0 then
    kstored = 1
    kout = 1
  else
    kout = (strcmp(Stored,Str)==0?0:1)
  endif
  Stored = Str
  xout kout
endop


#define STRCHANGEDUDO ##
#end
