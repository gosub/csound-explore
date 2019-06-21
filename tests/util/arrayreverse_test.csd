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

#include "../../udo/util/arrayreverse.udo"
#include "../../udo/util/once.udo"
seed 0


instr arrayreverse_test
  prints "arrayreverse test\n"
  iarray[] genarray 1, 10
  ireversed[] arrayreverse iarray
  printarray iarray, "%.0f", "original array (i-rate): "
  printarray ireversed, "%.0f", "reversed array (i-rate): "
  karray[] genarray_i 7, 14
  kreversed[] arrayreverse karray
  konce once
  printarray karray, konce, "%.0f", "original array (k-rate): "
  printarray kreversed, konce, "%.0f", "reversed array (k-rate): "
endin


</CsInstruments>
<CsScore>
i "arrayreverse_test" 0 1
</CsScore>
</CsoundSynthesizer>
