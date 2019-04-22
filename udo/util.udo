/*
  once - true only once, at k-rate
  randint - return a random int between max and min (default 0)
  arrayreverse - reverse an array
*/

;; TODO: arrayshuffle


opcode once, k, 0
  kcount init 2
  if kcount > 0 then
    kcount -= 1
  endif
  xout kcount
endop


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

