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


instr 1, lpread_test
  prints "Running test for lpread\n"
  lpclear_i
  ktrigger, kevent, krow, kcol lpread
  if ktrigger == 1 then
    if kevent == $LP_KEY_DOWN then
      printks "key down %d %d\n", 0.1, krow, kcol
    elseif kevent == $LP_KEY_UP then
      printks "key up %d %d\n", 0.1, krow, kcol
    elseif kevent == $LP_SIDE_DOWN then
      printks "side down %d\n", 0.1, krow
    elseif kevent == $LP_SIDE_UP then
      printks "side up %d\n", 0.1, krow
    elseif kevent == $LP_TOP_DOWN then
      printks "top down %d\n", 0.1, kcol
    elseif kevent == $LP_TOP_UP then
      printks "top up %d\n", 0.1, kcol
    endif
  endif
endin


alwayson "lpread_test"
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
