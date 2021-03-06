<CsoundSynthesizer>
<CsOptions>
-d -odac -iadc
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


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
  asig1 singularity ain, kdisintegrate, kbypass3
  asig2 ergosphere asig1, kmix1, ktime, kfeedback, kmod, kspeed, kbypass1
  aout eventhorizon asig2, kmix2, kecho, kradiancy, kpitch, kbypass2
  xout aout
endop


instr finalFX
  asig,asig2 ins

  kmix1, ktime, kfeedback, kmod, kspeed, kbypass1 init 0.5, 0.3, 0.9, 0.0, 1/10, 0
  kmix2, kecho, kradiancy, kpitch, kbypass2 init 0.5, 0.5, 0.4, 1.5, 0
  kdisintegrate, kbypass3 init 0.5, 0

  asig blackhole asig, kmix1, ktime, kfeedback, kmod, kspeed, kbypass1, \
                       kmix2, kecho, kradiancy, kpitch, kbypass2, \
                       kdisintegrate, kbypass3
  outs asig, asig
endin


alwayson "finalFX"


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
