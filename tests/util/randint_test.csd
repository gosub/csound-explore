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


#include "../../udo/util/randint.udo"
#include "../../udo/util/once.udo"  ;; used by randint_test
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


</CsInstruments>
<CsScore>
i "randint_test" 0 1
</CsScore>
</CsoundSynthesizer>
