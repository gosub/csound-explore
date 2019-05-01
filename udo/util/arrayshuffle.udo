/*
  arrayshuffle - shuffle an array with the Fisher-Yates algorithm
*/


#ifndef ARRAYSHUFFLEUDO


#include "randint.udo"


opcode arrayshuffle, i[], i[]
  inputarray[] xin
  ilen lenarray inputarray
  index = 0
  while index < ilen-1 do
    irandindex randint ilen-1, index
    itemp = inputarray[index]
    inputarray[index] = inputarray[irandindex]
    inputarray[irandindex] = itemp
    index += 1
  od
  xout inputarray
endop


opcode arrayshuffle, k[], k[]
  kinputarray[] xin
  ilen lenarray kinputarray
  kindex = 0
  while kindex < ilen-1 do
    krandindex randint ilen-1, kindex
    ktemp = kinputarray[kindex]
    kinputarray[kindex] = kinputarray[krandindex]
    kinputarray[krandindex] = ktemp
    kindex += 1
  od
  xout kinputarray
endop


#define ARRAYSHUFFLEUDO ##
#end
