/*
  once - true only once, at k-rate
  randint - return a random int between max and min (default 0)
*/

;; TODO: arrayshuffle
;; TODO: arrayreverse


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
