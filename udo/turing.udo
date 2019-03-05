/*
  turing - MusicThing Turing Machine clone
*/

; TODO: add step number control
; TODO: add audio rate version
; TODO: write expansion outputs to channel

opcode turing, k, kk
  ktrig, kctrl xin
  kregisters[] init 8
  printarray kregisters
  if (ktrig==1) then

    ; shift registers right, with wrapping
    ktemp = kregisters[7]
    kindex = 7
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

