<CsoundSynthesizer>
<CsOptions>
-o dac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

; idea from:
; https://twitter.com/0xgokhan/status/1644984450042716160

instr 1
  kclock metro 2
  schedkwhen kclock, 0, 0, 2, 0, 2
endin


instr 2
  imod birnd 0.1
  iamp = 0.25 * (1 + imod)
  ifmod birnd 0.2
  ifreq = 110 * (1 + ifmod)

  aenv linseg 0, p3*.05, 1, p3*.9, 1, p3*.05, 0 ;envelope
  a1 oscili iamp*aenv, ifreq
  outs a1, a1
endin


alwayson 1

</CsInstruments>
</CsoundSynthesizer>
