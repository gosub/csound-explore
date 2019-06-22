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
  Sfile =  "/home/gg/downloads/audio/samples/cleanguitC3.wav"
  a1, a2 diskin2 Sfile, irate
  xtratim filelen(Sfile)
  gaBus1 += a1
endin


;; TODO: plucker, add octave selector
;; TODO: plucker, add pentatonic selector


opcode talternate, k, kkkkkP
  ktrig, ka, kb, kmod, kthres, kdiv xin
  kcount init -1
  kcount += ktrig
  if int(kcount/kdiv)%kmod < kthres then
    kout = ka
  else
    kout = kb
  endif
  xout kout
endop


instr plucker
  kcount init -1
  ktempo init 1
  ktick metro ktempo
  kcount += ktick
  ktempo talternate ktick, 1, 2, 4, 2
  knote talternate ktick, 48, 41, 4, 3, 8
  schedkwhen ktick, 0, 0, "cleanguit", 0, 0.1, knote
  printk2 knote
endin


; ergosphere - modulation delay


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

;; TODO: eventhorizon - find a value for irevcutoff, or derive it from kradiancy

opcode eventhorizon, a, akkkkk
  ain, kmix, kecho, kradiancy, kpitch, kbypass xin
  apitched init 0
  irevcutoff init 1000

  if kbypass == 1 then
    aout = ain
  else
    apreverb = ain + apitched * kradiancy
    apreverb dcblock2 apreverb
    apreverb tanh apreverb
    areverbL, areverbR reverbsc apreverb, apreverb, kecho, irevcutoff
    areverb sum areverbL, areverbR

    ifftsize  = 2048
    ioverlap  = ifftsize / 4
    iwinsize  = ifftsize
    iwinshape = 1; von-Hann window

    fftin pvsanal ain, ifftsize, ioverlap, iwinsize, iwinshape
    fftscale pvscale fftin, kpitch, 0, 1
    apitched pvsynth fftscale

    aout ntrpol ain, areverb, kmix
  endif
  xout aout
endop


; singularity - destruction fuzz

;; TODO: singularity - derive pre&postgain, shape1&2 from kdisintegrate
/*
opcode singularity, a, akk
  ain, kdisintegrate, kbypass xin
  if kbypass == 1 then
    aout = ain
  else
    kpregain = 1 + kdisintegrate
    kpostgain = 1 - (kdisintegrate / 2)
    kshape1 = 1 - kdisintegrate
    kshape2 = 1 - kdisintegrate/2
    aout distort1 ain, kpregain, kpostgain, kshape1, kshape2, 1
  endif
  xout aout
endop
*/

opcode singularity, a, akk
  ain, kdisintegrate, kbypass xin
  ifn	ftgen	0,0, 257, 9, .5,1,270
  if kbypass == 1 then
    aout = ain
  else
    ain = ain * (1+kdisintegrate)
    aout distort ain, kdisintegrate, ifn
  endif
  xout aout
endop


;; TODO: blackhole - map parameters limits for ergosphere to [0:1]
;; TODO: blackhole - map parameters limits for eventhorizon to [0:1]
;; TODO: blackhole - map parameters limits for singularity to [0:1]


opcode blackhole, a, akkkkkkkkkkkkk
  ain, kmix1, ktime, kfeedback, kmod, kspeed, kbypass1, \
             kmix2, kecho, kradiancy, kpitch, kbypass2, \
                               kdisintegrate, kbypass3 xin
  asig1 ergosphere ain, kmix1, ktime, kfeedback, kmod, kspeed, kbypass1
  asig2 eventhorizon asig1, kmix2, kecho, kradiancy, kpitch, kbypass2
  aout singularity asig2, kdisintegrate, kbypass3
  xout aout
endop


instr finalFX
  asig = gaBus1

  kmix1, ktime, kfeedback, kmod, kspeed, kbypass1 init 0.5, 0.3, 0.2, 0.1, 1/5, 0
  kmix2, kecho, kradiancy, kpitch, kbypass2 init 0.7, 0.9, 0.7, 1.5, 0
  kdisintegrate, kbypass3 init 0.9, 0

  asig blackhole asig, kmix1, ktime, kfeedback, kmod, kspeed, kbypass1, \
                       kmix2, kecho, kradiancy, kpitch, kbypass2, \
                       kdisintegrate, kbypass3
  outs asig, asig
  clear gaBus1
endin


alwayson "finalFX"
alwayson "plucker"


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
