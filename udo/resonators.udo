/*
  resonators - Ableton Live Resonators clone
*/


opcode resonators, aa, aa
  ainL, ainR xin

  ;; TODO: transform this variables in parameters
  kdecay init 0.5
  knote init 60
  kfilterfreq init 500
  kfiltermode init 0
  kfilteron init 1
  ksemitonesII init 4
  ksemitonesIII init 7
  ksemitonesIV init 11
  ksemitonesV init 12
  kdetuneI, kdetuneII, kdetuneIII, kdetuneIV, kdetuneV init 0, 0, 0, 0, 0
  kdrywet init 1

  if kfilteron == 1 then
    if kfiltermode == 0 then
      ainL butterlp ainL, kfilterfreq
      ainR butterlp ainR, kfilterfreq
    elseif kfiltermode == 1 then
      ainL butterhp ainL, kfilterfreq
      ainR butterhp ainR, kfilterfreq
    elseif kfiltermode == 2 then
      ainL butterbp ainL, kfilterfreq, kfilterfreq/10
      ainR butterbp ainR, kfilterfreq, kfilterfreq/10
    elseif kfiltermode == 3 then
      ainL butterbr ainL, kfilterfreq, kfilterfreq/10
      ainR butterbr ainR, kfilterfreq, kfilterfreq/10
    else
      printks2 "ERROR - invalid kfiltermode value: %d\n", kfiltermode
    endif
  endif

  kfreqI cpsmidinn knote
  kfreqI *= cent(kdetuneI)
  kfreqII  = kfreqI * semitone(ksemitonesII)  * cent(kdetuneII)
  kfreqIII = kfreqI * semitone(ksemitonesIII) * cent(kdetuneIII)
  kfreqIV  = kfreqI * semitone(ksemitonesIV)  * cent(kdetuneIV)
  kfreqV   = kfreqI * semitone(ksemitonesV)   * cent(kdetuneV)

  aresI   vcomb (ainL+ainR), kdecay, 1/kfreqI, 1
  aresII  vcomb ainL, kdecay, 1/kfreqII, 1
  aresIII vcomb ainR, kdecay, 1/kfreqIII, 1
  aresIV  vcomb ainL, kdecay, 1/kfreqIV, 1
  aresV   vcomb ainR, kdecay, 1/kfreqV, 1

  ;; TODO: add spread, gain
  aoutL sum aresI/2, aresII, aresIV
  aoutR sum aresI/2, aresIII, aresV
  amixL = aoutL * kdrywet + ainL * (1 - kdrywet)
  amixR = aoutR * kdrywet + ainR * (1 - kdrywet)
  xout amixL, amixR
endop

