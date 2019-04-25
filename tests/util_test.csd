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

#include "../udo/util.udo"


instr once_test
  prints "once test\n"
  konce once
  printk2 konce, 0, 1
  if konce == 1 then
    printks "This line is printed at k-rate, using once\n", 0.1
  endif
endin


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


;; TODO: minmax_test
;; TODO: minmax 2 readme

</CsInstruments>
<CsScore>
i "once_test"    0 1
i "randint_test" 1 1
i "arrayreverse_test" 2 1
i "arrayshuffle_test" 3 1
</CsScore>
</CsoundSynthesizer>
