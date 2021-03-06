/*
  resonators - Ableton Live Resonators clone
*/


opcode resonators, aa, aakkkkkkkkkPOPOOOOOOOOOO
  ainL, ainR, knote, ksemiII, ksemiIII, ksemiIV, ksemiV, \
    kdecay, kfilteron, kfiltermode, kfilterfreq, kspread, kgainfinal, kdrywet, \
    kgainI, kgainII, kgainIII, kgainIV, kgainV, \
    kdetuneI, kdetuneII, kdetuneIII, kdetuneIV, kdetuneV xin

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
  kfreqII  = kfreqI * semitone(ksemiII)  * cent(kdetuneII)
  kfreqIII = kfreqI * semitone(ksemiIII) * cent(kdetuneIII)
  kfreqIV  = kfreqI * semitone(ksemiIV)  * cent(kdetuneIV)
  kfreqV   = kfreqI * semitone(ksemiV)   * cent(kdetuneV)

  aresI   vcomb (ainL+ainR), kdecay, 1/kfreqI, 1
  aresII  vcomb ainL, kdecay, 1/kfreqII, 1
  aresIII vcomb ainR, kdecay, 1/kfreqIII, 1
  aresIV  vcomb ainL, kdecay, 1/kfreqIV, 1
  aresV   vcomb ainR, kdecay, 1/kfreqV, 1

  aresI   *= ampdbfs(kgainI)
  aresII  *= ampdbfs(kgainII)
  aresIII *= ampdbfs(kgainIII)
  aresIV  *= ampdbfs(kgainIV)
  aresV   *= ampdbfs(kgainV)

  asumL sum aresI/2, aresII, aresIV
  asumR sum aresI/2, aresIII, aresV
  asumL *= ampdbfs(kgainfinal)
  asumR *= ampdbfs(kgainfinal)
  amix1 = asumL * sqrt(kdrywet) + ainL * sqrt(1 - kdrywet)
  amix2 = asumR * sqrt(kdrywet) + ainR * sqrt(1 - kdrywet)
  amix1L, amix1R pan2 amix1, 0.5 - (0.5 * kspread)
  amix2L, amix2R pan2 amix2, 0.5 + (0.5 * kspread)
  xout amix1L + amix2L, amix1R + amix2R
endop

