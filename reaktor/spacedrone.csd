<CsoundSynthesizer>
<CsOptions>
-odac
-d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

seed 0
giVoices init 10 ;; dummy value, its changed inside spacedrone instrument

;; spacedrone parameters - min,def,max

;; kPan           -120,-60,0        kDensity     -96,-36,24
;; kRndPan        -120,-60,0        kRndTrig      0,30,60
;; kOffset        0,16,32           kDynamic      0, 0.5, 1
;; kFundamental   0,60,120          kAttack       -20,40,100
;; kPitch         -12,0,12          kDecay        -20,40,100
;; kSpeed         0,5,10            kDamp         -2,0,2
;; kAmt           0,1,2             kGain         0, 0.5, 1
;; kRes           0,0.49,0.99


opcode SlowRandom, k, kk
  kF, kA xin
  arnd random -kA, kA
  aout zdf_1pole arnd, kF
  kout downsamp aout
  xout kout
endop


opcode _LFOSection, a, kk
  kPan, kRnd xin
  krnd mtof kRnd
  kcps = mtof(kPan) + SlowRandom(krnd, krnd)
  alfo lfo 1, kcps, 1
  xout alfo
endop


gktotalpower init 9
opcode calctotalpower, 0, kk
  kOffset, kDamp xin
  if changed2(kOffset, kDamp) == 1 then
    gktotalpower = 0
    kndx = 1
    while kndx <= giVoices do
      gktotalpower += (1/(kndx+kOffset))^kDamp
      kndx += 1
    od
  endif
endop


opcode _DampSection, k, ikkk
  iVoiceNum, kOffset, kDamp, kGain xin
  kv = iVoiceNum + kOffset
  kpow = (1/kv)^kDamp
  calctotalpower kOffset, kDamp
  kpowscaled = kpow / gktotalpower
  kattenuation = kGain^3 * kpowscaled
  xout kattenuation
endop


opcode _NoiseSection, a, ikkkkkkk
  iVoiceNum, kEnv, kPitch, kSpeed, kAmt, kRes, kOffset, kFundamental xin
  kvoiceoffset = ftom((iVoiceNum + kOffset) * mtof(kFundamental))
  kfreq = mtof(SlowRandom(kSpeed,kAmt) + (kPitch * kEnv + kvoiceoffset))
  kq = kRes ^ 0.03125
  anoise rand 0.5
  kq = kq*499 + 1
  ;; Reaktor 2-pole filter resonance is between 0 and 1
  ;; CSound svfilter q is between 1 and 500
  alow, ahigh, afiltered svfilter anoise, kfreq, kq
  xout afiltered
endop


opcode _Geiger, k, kkk
  kDensity, kRndTrig, kDynamic xin
  kfreqmod init 0
  kfreq = mtof(kDensity + kfreqmod)
  kfreqmod randomh 1-kRndTrig, 1+kRndTrig, kfreq, 3
  kgate randomh 1-kDynamic, 1+kDynamic, kfreq, 3
  kgate += kDynamic * -1
  xout kgate
endop


opcode ReakLog2sec, k,k
  klog xin
  kms = (10^(klog/20))
  ksec = kms/1000
  xout ksec
endop


;; The behaviour of ADR-Env in Reaktor is like this:
;; gate from 0 to >0 begins attack phase
;; attack is linear upto gate value
;; if attack peak is reached, exponential decay starts
;; at any moment, when gate goes back to 0, exponential release start
;; if gate change value during decay, a new attack is triggered


opcode adr, a, kkkk
  kgate, katt, kdec, krel xin
  kstart init 0
  kphase init 0
  kfirst init 1
  iattacklimit init 0
  aenv init 0
  kattacktrig trigger kgate, 0, 0
  kenv downsamp aenv
  kdecaytrig trigger kenv, iattacklimit, 0
  kreleasetrig trigger kgate, 0, 1

  if kattacktrig == 1 || kfirst == 1 || (kphase == 2 && changed(kgate)==1 && kgate>kenv) then
    kphase = 1
    if kfirst == 1 then
      kgate = 1
      kfirst = 0
    endif
    reinit restart
  elseif kdecaytrig == 1 then
    kphase = 2
    reinit restart
  elseif kreleasetrig == 1 then
    kphase = 3
    reinit restart
  endif

restart:
  iattacklimit init i(kgate)
  ia = (i(kenv)==0 ? 0.0001 : i(kenv))
  if kphase == 1 then
    ib = i(kgate)
    it = i(katt)/(ib-ia)
    aenv line ia, it, ib
  elseif kphase == 2 then
    it = i(kdec)/ia
    aenv expon ia, it, 0.0001
  elseif kphase == 3 then
    it = i(krel)/ia
    aenv expon ia, it, 0.0001
  endif
  xout aenv
endop


opcode _ADREnv, a, kkkk
  kgate, kAttack, kDecay, kRelease xin
  kattacksec ReakLog2sec kAttack
  kdecaysec ReakLog2sec kDecay
  kreleasesec ReakLog2sec kRelease
  aenv adr kgate, kattacksec, kdecaysec, kreleasesec
  xout aenv
endop


opcode _EnvSection, a, kkkkk
  kDensity, kRndTrig, kDynamic, kAttack, kDecay xin
  kgate _Geiger kDensity, kRndTrig, kDynamic
  aenv _ADREnv kgate, kAttack, kDecay, kDecay
  xout aenv*aenv
endop



opcode spacedronevoice, aa, ikkkkkkkkkkkkkkk
  iVoiceNum, kPan, kRndPan, kOffset, kFundamental, kPitch, kSpeed, kAmt, \
  kRes, kDensity, kRndTrig, kDynamic, kAttack, kDecay, kDamp, kGain xin

  aenv _EnvSection kDensity, kRndTrig, kDynamic, kAttack, kDecay
  anoise _NoiseSection iVoiceNum, downsamp(aenv), kPitch, kSpeed, kAmt, kRes, kOffset, kFundamental
  katten _DampSection iVoiceNum, kOffset, kDamp, kGain
  apanning _LFOSection kPan, kRndPan
  apanning = apanning / 2 + 1; conversion from reaktor pan to csound pan

  asig = anoise * katten * aenv
  aleft, aright pan2 asig, apanning
  xout aleft, aright
endop


opcode spacedronevoice, aa, ik[]
  iVoiceNum, kPrm[] xin
  aleft, aright spacedronevoice iVoiceNum, kPrm[0], kPrm[1], kPrm[2], kPrm[3], kPrm[4], kPrm[5], \
                                           kPrm[6], kPrm[7], kPrm[8], kPrm[9], kPrm[10], kPrm[11], \
                                           kPrm[12], kPrm[13], kPrm[14]
  xout aleft, aright
endop


opcode spacedronevoiceX2, aa, ik[]
  iVoiceNum, kParams[] xin
  al1, ar1 spacedronevoice iVoiceNum+0, kParams
  al2, ar2 spacedronevoice iVoiceNum+1, kParams
  xout al1+al2, ar1+ar2
endop


opcode spacedronevoiceX8, aa, ik[]
  iVoiceNum, kParams[] xin
  al1, ar1 spacedronevoiceX2 iVoiceNum+0, kParams
  al2, ar2 spacedronevoiceX2 iVoiceNum+2, kParams
  al3, ar3 spacedronevoiceX2 iVoiceNum+4, kParams
  al4, ar4 spacedronevoiceX2 iVoiceNum+6, kParams
  xout al1+al2+al3+al4, ar1+ar2+ar3+ar4
endop


opcode spacedronevoiceX32, aa, ik[]
  iVoiceNum, kParams[] xin
  al1, ar1 spacedronevoiceX8 iVoiceNum+0, kParams
  al2, ar2 spacedronevoiceX8 iVoiceNum+8, kParams
  al3, ar3 spacedronevoiceX8 iVoiceNum+16, kParams
  al4, ar4 spacedronevoiceX8 iVoiceNum+24, kParams
  xout al1+al2+al3+al4, ar1+ar2+ar3+ar4
endop


opcode spacedronevoiceX96, aa, ik[]
  iVoiceNum, kParams[] xin
  al1, ar1 spacedronevoiceX32 iVoiceNum+0, kParams
  al2, ar2 spacedronevoiceX32 iVoiceNum+32, kParams
  al3, ar3 spacedronevoiceX32 iVoiceNum+64, kParams
  xout al1+al2+al3, ar1+ar2+ar3
endop


;; TODO: check section outputs against real thing (scope)
;; TODO: verify reverb parameters relations
;; TODO: copy 3 presets
;; TODO: copy all other presets


instr spacedrone
  giVoices init 32
  kSubWind[] fillarray   -105, -40, 0, 12, 3, 1.5, 0.3, 0.77, -60, 30, 0.5, 80, 80, 0.75, 1
  kPolarWind[] fillarray -96, -72, 0, 36, 0, 2.5, 0.12, 0.85, -72, 24, 0.5, 80, 80, 1.35, 0.99

  aL, aR spacedronevoiceX32 1, kPolarWind
  aL, aR reverbsc aL, aR, 0.7, 1000
  outs aL, aR
endin


alwayson "spacedrone"

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
