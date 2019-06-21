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


#include "../../udo/util/minmax.udo"


instr minmax_test
  prints "minmax test\n"
  imin, imax minmax 3, 5
  prints "minmax 3,5: %d,%d\n", imin, imax
  imin, imax minmax 7, 4
  prints "minmax 7,4: %d,%d\n", imin, imax
  imin, imax minmax 2, 2
  prints "minmax 2,2: %d,%d\n", imin, imax
endin


</CsInstruments>
<CsScore>
i "minmax_test" 0 1
</CsScore>
</CsoundSynthesizer>
