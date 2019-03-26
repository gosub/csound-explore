/*
  euclidean - Euclidean Pattern Sequencer
  euclideangen - Euclidean Step Calculator
*/


opcode euclideangen, k, kkkO
  ; uses bresenham's algorithm
  kindex, kpulses, ksteps, krotate xin
  kslope = kpulses/ksteps
  kstep = (kindex + krotate) % ksteps
  ; to accomodate for floating point error
  if (kslope - frac(kstep*kslope) > 0.000001) then
    kout = 1
  else
    kout = 0
  fi
  xout kout
endop


opcode euclideangen, i, iiio
  ; uses bresenham's algorithm
  iindex, ipulses, isteps, irotate xin
  islope = ipulses/isteps
  istep = (iindex + irotate) % isteps
  ; to accomodate for floating point error
  if (islope - frac(istep*islope) > 0.000001) then
    iout = 1
  else
    iout = 0
  fi
  xout iout
endop


opcode euclidean, k, kkkOO
  ktrig, kpulses, ksteps, krotate, kreset xin
  kout = 0
  kindex init -1

  if kreset == 1 then
    kindex = -1
  endif

  if (ktrig == 1) then
    kindex += 1
    kindex = kindex % ksteps
    kout euclideangen kindex, kpulses, ksteps, krotate
  fi
  xout kout
endop

