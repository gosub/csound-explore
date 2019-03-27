/*
  resonators - Ableton Live Resonators clone
*/


opcode resonators, aa, aa
  ainL, ainR xin

  ;; TODO: transform this variables in parameters
  kdecay init 0.5
  knote init 60
  kfilterfreq init 500
  kfilteron init 1
  ksemitonesII init 3
  ksemitonesIII init 5
  ksemitonesIV init 7
  ksemitonesV init 11

  ;; TODO: filter type selectable
  if kfilteron == 1 then
    ainL butterlp ainL, kfilterfreq
    ainR butterlp ainR, kfilterfreq
  endif

  ;; TODO: add cent detune
  kfreqI cpsmidinn knote
  kfreqII  = kfreqI * semitone(ksemitonesII)
  kfreqIII = kfreqI * semitone(ksemitonesIII)
  kfreqIV  = kfreqI * semitone(ksemitonesIV)
  kfreqV   = kfreqI * semitone(ksemitonesV)

  aresI   vcomb (ainL+ainR), kdecay, 1/kfreqI, 1
  aresII  vcomb ainL, kdecay, 1/kfreqII, 1
  aresIII vcomb ainR, kdecay, 1/kfreqIII, 1
  aresIV  vcomb ainL, kdecay, 1/kfreqIV, 1
  aresV   vcomb ainR, kdecay, 1/kfreqV, 1

  ;; TODO: add spread, dry/wet, gain
  aoutL sum aresI/2, aresII, aresIV
  aoutR sum aresI/2, aresIII, aresV
  xout aoutL, aoutR
endop

