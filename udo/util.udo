/*
  once - true only once, at k-rate
  randint - return a random int between max and min (default 0)
  arrayreverse - reverse an array
  arrayshuffle - shuffle an array with the Fisher-Yates algorithm
  arrayofsubinstr - instantiate n subinstruments in an array
*/


opcode once, k, 0
  kcount init 2
  if kcount > 0 then
    kcount -= 1
  endif
  xout kcount
endop


opcode minmax, kk, kk
  ka, kb xin
  kmin min ka, kb
  kmax max ka, kb
  xout kmin, kmax
endop


opcode minmax, ii, ii
  ia, ib xin
  imin min ia, ib
  imax max ia, ib
  xout imin, imax
endop


opcode randint, k, kO
  kmax, kmin xin
  kmin int kmin
  kmax int kmax
  ; ensure sorting
  kmin, kmax minmax kmin, kmax
  krnd random kmin, kmax+0.9999
  krnd int krnd
  xout krnd
endop


opcode randint, i, io
  imax, imin xin
  imin int imin
  imax int imax
  ; ensure sorting
  imin, imax minmax imin, imax
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


opcode arrayofsubinstr, a[], a[]iio
  audioarr[], index, instrnum, iparam xin
  ilen lenarray audioarr
  if index < ilen then
    audioarr arrayofsubinstr audioarr, index+1, instrnum, iparam
    audioarr[index] subinstr instrnum, index, ilen-1, iparam
  endif
  xout audioarr
endop


opcode arrayofsubinstr, a[], a[]iSo
  audioarr[], index, Sinstrname, iparam xin
  instrnum nstrnum Sinstrname
  audioarr arrayofsubinstr audioarr, index, instrnum, iparam
  xout audioarr
endop
