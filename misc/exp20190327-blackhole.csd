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


instr cleanguit
  inote = p4
  irate semitone inote-48
  a1, a2 diskin2 "/home/gg/downloads/audio/samples/cleanguitC3.wav", irate
  gaBus1 += a1
endin


;; TODO: plucker, extract value (tempo) alternator
;; TODO: plucker, add octave selector
;; TODO: plucker, add pentatonic selector

instr plucker
  kcount init -1
  ktempo init 1
  ktick metro ktempo
  kcount += ktick
  if kcount % 4 == 0 then
    ktempo = 2
  elseif kcount % 4 >= 2 then
    ktempo = 1/2
  endif
  knote = (int(kcount/8) % 4 == 3 ? 41 : 48)
  schedkwhen ktick, 0, 0, "cleanguit", 0, 0.1, knote
  printk2 knote
endin


; ergosphere - modulation delay

;; TODO: ergosphere - verify functionality
;; TODO: ergosphere - check parameters limits
;; TODO: ergosphere - incorporate in blackhole

opcode ergosphere, a, akkkkkk
  ain, kmix, ktime, kfeedback, kmod, kspeed, kbypass xin
  if kbypass == 1 then
    aout = ain
  else
    alfo poscil kmod, kspeed
    adummy delayr 1
    adelay deltap3 ktime + alfo
    delayw ain + kfeedback * adelay
    aout ntrpol ain, adelay, kmix
  endif
  xout aout
endop


; event horizon - space reverb

;; TODO: eventhorizon - implement
;; TODO: eventhorizon - verify functionality
;; TODO: eventhorizon - check parameters limits
;; TODO: eventhorizon - incorporate in blackhole

opcode eventhorizon, a, akkkkk
  ain, kmix, kecho, kradiancy, kpitch, kbypass xin
  aout = ain
  xout aout
endop


; singularity - destruction fuzz

;; TODO: singularity - implement
;; TODO: singularity - verify functionality
;; TODO: singularity - check parameters limits
;; TODO: singularity - incorporate in blackhole

opcode singularity, a, akk
  ain, kdisintegrate, kbypass xin
  aout = ain
  xout aout
endop


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
