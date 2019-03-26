/*
  turing - MusicThing Turing Machine clone
*/


opcode turing, k, kkO
  ktrig, kctrl, ksteps xin
  kregisters[] init 16
  ; ksteps is an optional parameter, defaults to 0
  ; 0 is interpreted as 8
  ksteps = (ksteps == 0 ? 8 : ksteps)
  ; 2 <= ksteps <= 16
  ksteps max 2, ksteps
  ksteps min 16, ksteps

  if (ktrig==1) then

    ; shift registers right, with wrapping
    ktemp = kregisters[ksteps-1]
    kindex = ksteps-1
    while kindex > 0 do
      kregisters[kindex] = kregisters[kindex-1]
      kindex -= 1
    od
    kregisters[0] = ktemp

    ; flip first register, with probability
    if (kctrl > random:k(0,1)) then
       kregisters[0] = (ktemp > 0 ? 0 : random:k(0,1))
    endif
  endif

  xout kregisters[0] * ktrig
endop


#include "shiftreg.udo"


opcode turingpulses, kkkkkkkkkkkk, kkO
  ktrig, kctrl, ksteps xin
  kinput turing ktrig, kctrl, ksteps
  k1,k2,k3,k4,k5,k6,k7,k8 shiftreg kinput, ktrig
  xout k1, k2, k3, k4, k5, k6, k7, k8, k1+k2, k2+k4, k4+k7, k1+k2+k4+k7
endop
