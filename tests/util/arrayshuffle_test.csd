<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1


#include "../../udo/util/arrayshuffle.udo"
#include "../../udo/util/once.udo"  ;; used by randint_test
seed 0


instr arrayshuffle_test
  prints "arrayshuffle test\n"
  iarray[] genarray 1, 10
  ishuffled[] arrayshuffle iarray
  printarray iarray, "%.0f", "original array (i-rate): "
  printarray ishuffled, "%.0f", "shuffled array (i-rate): "
  karray[] genarray_i 7, 14
  kshuffled[] arrayshuffle karray
  konce once
  printarray karray, konce, "%.0f", "original array (k-rate): "
  printarray kshuffled, konce, "%.0f", "shuffled array (k-rate): "
endin


</CsInstruments>
<CsScore>
i "arrayshuffle_test" 0 1
</CsScore>
</CsoundSynthesizer>
