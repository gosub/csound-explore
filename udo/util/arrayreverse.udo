/*
  arrayreverse - reverse an array
*/


#ifndef ARRAYREVERSEUDO


opcode arrayreverse, i[], i[]
  inputarray[] xin
  ilen lenarray inputarray
  ioutputarray[] init ilen
  index = 0
  while index < ilen do
    ioutputarray[index] = inputarray[ilen-1-index]
    index += 1
  od
  xout ioutputarray
endop


opcode arrayreverse, k[], k[]
  kinputarray[] xin
  ilen lenarray kinputarray
  koutputarray[] init ilen
  kindex = 0
  while kindex < ilen do
    koutputarray[kindex] = kinputarray[ilen-1-kindex]
    kindex += 1
  od
  xout koutputarray
endop


#define ARRAYREVERSEUDO ##
#end
