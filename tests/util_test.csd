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

#include "../udo/util/arrayreverse.udo"
#include "../udo/util/arrayshuffle.udo"
#include "../udo/util/minmax.udo"
#include "../udo/util/randint.udo"
#include "../udo/util/once.udo"  ;; used by randint_test

;; TODO: separate tests in single files under the util directory



seed 0

instr randint_test
  prints "randint test\n"
  indx = 0
  while indx < 7 do
    irnd randint 5
    prints "(i-rate) randint 5: %d\n", irnd
    indx += 1
  od
  konce once
  if konce == 1 then
    indx = 0
    while indx < 7 do
      irnd2 randint 7, 3
      prints "(i-rate) randint 7, 3: %d\n", irnd2
      indx += 1
    od
    kndx = 0
    while kndx < 7 do
      krnd randint 5
      printks2 "(k-rate) randint 5: %d\n", krnd
      kndx += 1
    od
    kndx = 0
    while kndx < 7 do
      krnd2 randint 7, 3
      printks2 "(k-rate) randint 7, 3: %d\n", krnd2
      kndx += 1
    od
  endif
endin


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
i "randint_test" 0 1
i "arrayreverse_test" + .
i "arrayshuffle_test" + .
i "minmax_test" + .
</CsScore>
</CsoundSynthesizer>
