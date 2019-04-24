/*
  once - true only once, at k-rate
  randint - return a random int between max and min (default 0)
  arrayreverse - reverse an array
  arrayshuffle - shuffle an array with the Fisher-Yates algorithm
*/


opcode once, k, 0
  kcount init 2
  if kcount > 0 then
    kcount -= 1
  endif
  xout kcount
endop


;; TODO: minmax
;; TODO: sort min & max in randint


opcode randint, k, kO
  kmax, kmin xin
  kmin int kmin
  kmax int kmax
  krnd random kmin, kmax+0.9999
  krnd int krnd
  xout krnd
endop


opcode randint, i, io
  imax, imin xin
  imin int imin
  imax int imax
  irnd random imin, imax+0.9999
  irnd int irnd
  xout irnd
endop


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

