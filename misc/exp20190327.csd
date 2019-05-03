<CsoundSynthesizer>
<CsOptions>
-d -odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


gaBus1 init 0


instr pluck
  kamp init 0.1
  icps cpsmidinn p4
  kcps init icps
  imethod = 3
  aenv linen 1, 0.001, p3, p3-0.001
  ares pluck kamp, kcps, icps, 0, imethod
  gaBus1 += ares*aenv
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
  knote = (int(kcount/8) % 4 == 3 ? 33 : 45)
  schedkwhen ktick, 0, 0, "pluck", 0, 0.1, knote
  printk2 knote
endin


;; TODO: blackhole, better reverb
;; TODO: blackhole, lowpass?
;; TODO: blackhole - ergosphere
;; TODO: blackhole - event horizon
;; TODO: blackhole - singularity


opcode blackhole, a, a
  ain xin

  ; reverb params
  kreverbtime init 0.7
  ; delay params
  kfeedback init 0.2
  kdelaymix init 0.6
  kdelaytime init 0.333
  ; distortion params
  idistortion = 0
  kgain = 3

  ; reverb
  asig0 reverb ain, kreverbtime

  ; delay
  adummy delayr 10
  adelay deltap kdelaytime
  asig1 = asig0 + adelay * kdelaymix
  delayw asig1 + adelay*kfeedback

  ; fuzz/disortion
  asig2 clip asig1*kgain, idistortion, 0.1
  xout asig2
endop


instr finalFX
  asig = gaBus1
  asig blackhole asig
  outs asig, asig
  clear gaBus1
endin


alwayson "finalFX"
alwayson "plucker"


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
