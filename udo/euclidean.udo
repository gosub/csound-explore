
;; TODO: turn isteps into ksteps
;; TODO: euclidean

opcode euclideanarray, k[], ikk
  ; uses bresenham algorithm
  isteps, kpulses, krotate xin
  kArray[] init isteps
  if (kpulses > 0) then
    kslope = kpulses/isteps
    kprevious = -1
    kloop = 0
    while kloop < isteps do
      kcurrent = round(floor(kloop*kslope))
      kindex = (kloop + krotate) % isteps
      kArray[kindex] = (kcurrent != kprevious ? 1 : 0)
      kprevious = kcurrent
      kloop += 1
    od
  else
    kArray[] = kArray * 0
  endif
  xout kArray
endop

