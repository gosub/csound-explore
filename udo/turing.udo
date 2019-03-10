/*
  turing - MusicThing Turing Machine clone
*/

; TODO: add audio rate version
; TODO: write expansion outputs to channel

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

