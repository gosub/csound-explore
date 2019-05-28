/*
  rndstring - generate a random string of arbitrary length
*/


#ifndef RNDSTRINGUDO


opcode rndstring, S, i
  ilen xin
  Sresult init ""
  ilen max 1, ilen
  idx = 0
  while idx < ilen do
    Sresult strcat Sresult, sprintf("%c", random(97,122.999))
    idx += 1
  od
  xout Sresult
endop


#define RNDSTRINGUDO ##
#end
