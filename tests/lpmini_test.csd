<CsoundSynthesizer>
<CsOptions>
-odac -dm0
-+rtmidi=alsaseq -M20 -Q20
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1



#include "../grid/lpmini.inc"


instr 1, lpledon_test, lpledoff_test, lpcolor_test
  prints "Running test for lpledon, lpledoff, lpcolor\n"
  kcolumn init 0
  krow init 0
  lpclear_i
  kmetro metro 4
  if (kmetro == 1) then
    lpledoff krow, kcolumn
    krow = int(rnd:k(8))
    kcolumn = int(rnd:k(8))
    kcolor lpcolor int(rnd:k(4)), int(rnd:k(4))
    lpledon kcolor, krow, kcolumn
  fi
endin


instr 2, lpcolumnon_test, lpcolumnoff_test
  prints "Running test for lpcolumnon, lpcolumnoff\n"
  kcolumn init 0
  lpclear_i
  kmetro metro 4
  if (kmetro == 1) then
    lpcolumnoff kcolumn
    kcolumn = int(rnd:k(8))
    kcolor lpcolor int(rnd:k(4)), int(rnd:k(4))
    lpcolumnon kcolor, kcolumn
  fi
endin


instr 3, lprowon_test, lprowoff_test
  prints "Running test for lprowon, lprowoff\n"
  krow init 0
  lpclear_i
  kmetro metro 4
  if (kmetro == 1) then
    lprowoff krow
    krow = int(rnd:k(8))
    kcolor lpcolor int(rnd:k(4)), int(rnd:k(4))
    lprowon kcolor, krow
  fi
endin


instr 4, lpcolor_i_test, lpledon_i_test
  prints "Running test for lpcolor_i, lpledon_i\n"
  lpclear_i
  irow = 0
  while (irow < 4) do
    icol = 0
    while (icol < 4) do
      icolor lpcolor_i irow, icol
      lpledon_i icolor, irow*2,   icol*2
      lpledon_i icolor, irow*2,   icol*2+1
      lpledon_i icolor, irow*2+1, icol*2
      lpledon_i icolor, irow*2+1, icol*2+1
      icol += 1
    od
    irow += 1
  od
  turnoff
endin


instr 5, lprowon_i_test, lprowoff_i_test, lpcolumnon_i_test, lpcolumnoff_i_test
  prints "Running test for lprowon_i, lprowoff_i, lpcolumnon_i, lpcolumnoff_i\n"
  lpclear_i
  lprowon_i $LP_GREEN, 0
  lprowon_i $LP_GREEN, 2
  lprowon_i $LP_GREEN, 4
  lprowon_i $LP_GREEN, 6
  lprowoff_i 2
  turnoff
  lpcolumnon_i $LP_RED, 0
  lpcolumnon_i $LP_RED, 2
  lpcolumnon_i $LP_RED, 4
  lpcolumnon_i $LP_RED, 6
  lpcolumnoff_i 2
endin


instr 6, lpsideon_test, lpsideoff_test, lpsideon_i_test, lpsideoff_i_test
  prints "Running test for lpsideon, lpsideoff, lpsideon_i, lpsideoff_i\n"
  lpclear_i
  lpsideon_i $LP_GREEN, 4
  lpsideon_i $LP_GREEN, 5
  lpsideon_i $LP_RED, 6
  lpsideon_i $LP_RED, 7
  lpsideoff_i 5
  lpsideoff_i 6
  kindex init 0
  kcol init 0
  ktick metro 4
  if ktick == 1 then
    lpsideoff kcol
    kcol += 1
    kcol = kcol % 4
    lpsideon $LP_YELLOW, kcol
  endif
endin


instr 99, all_test
  prints "TEST LOOP BEGINS\n"
  itests = 6
  itestinterval = 4
  itest = 1
  while itest <= itests do
    schedule itest, (itest-1)*itestinterval, itestinterval
    itest += 1
  od
  schedule p1, itests*itestinterval, 1
  turnoff
endin


alwayson "all_test"
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
