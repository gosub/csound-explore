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

#include "../../udo/util/strchanged.udo"


instr strchanged_test
  prints "strchanged test\n"
  String init "ba"
  ktempo metro 1
  kchanged strchanged String
  if kchanged == 1 then
    printks "%s\n", 0, String
  endif
  if ktempo == 1 then
    String strcatk String, "na"
  endif
endin


</CsInstruments>
<CsScore>
i "strchanged_test"    0 10
</CsScore>
</CsoundSynthesizer>
