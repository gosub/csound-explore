<CsoundSynthesizer>
<CsOptions>
-d -odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


;; TODO: add fuzz FX
;; TODO: add delay FX
;; TODO: add reverb FX

instr pluck
  kamp init 0.1
  icps cpsmidinn p4
  kcps init icps
  imethod = 3
  aenv linen 1, 0.001, p3, p3-0.001
  ares pluck kamp, kcps, icps, 0, imethod
  outs ares*aenv, ares*aenv
endin


;; TODO: plucker, extract value (tempo) alternator
;; TODO: plucker, add octave selector
;; TODO: plucker, add pentatonic selector

instr plucker
  kcount init -1
  ktempo init 3
  ktick metro ktempo
  kcount += ktick
  if kcount % 4 == 0 then
    ktempo = 6
  elseif kcount % 4 >= 2 then
    ktempo = 2
  endif
  schedkwhen ktick, 0, 0, "pluck", 0, 0.5, 57
  printk2 kcount
endin


alwayson "plucker"

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
