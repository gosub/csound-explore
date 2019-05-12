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

giVoices = 32


;; spacedrone parameters - min,def,max

;; kPan                        kDensity
;; kRndPan                     kRndTrig
;; kOffset                     kDynamic
;; kFundamental                kAttack
;; kPitch                      kDecay
;; kSpeed                      kDamp
;; kAmt                        kGain
;; kRes


opcode _LFOSection, a, kk
  kPan, kRnd xin
  krnd mtof kRnd
  kcps = mtof(kPan) + randh:k(krnd, krnd)
  alfo lfo 1, kcps, 1
  xout alfo
endop


gktotalpower init 9
opcode calctotalpower, 0, kk
  kOffset, kDamp xin
  if changed2(kOffset, kDamp) == 1 then
    gktotalpower = 0
    knd = 1
    while knxd <= giVoices do
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
  kfreq = mtof(randh(kAmt, kSpeed) + (kPitch * kEnv + kvoiceoffset))
  ;; TODO: verify relation between Resonance and Q
  kq = kRes ^ 0.03125
  anoise rand 0.5
  afiltered lowpass2 anoise, kfreq, kq
  xout afiltered
endop


;; TODO: _EnvSection
;; TODO: Geiger


opcode spacedronevoice, aa, ikkkkkkkkkkkkkkk
  iVoiceNum, kPan, kRndPan, kOffset, kFundamental, kPitch, kSpeed, kAmt, \
  kRes, kDensity, kRndTrig, kDynamic, kAttack, kDecay, kDamp, kGain xin

  aenv _EnvSection kDensity, kRndTrig, kDynamic, kAttack, kDecay
  anoise _NoiseSection iVoiceNum, downsamp(aEnv), kPitch, kSpeed, kAmt, kRes, kOffset, kFundamental
  katten _DampSection iVoiceNum, kOffset, kDamp, kGain
  apanning _LFOSection kPan, kRnd

  asig = aenv * anoise * katten
  aleft, aright pan2 asig, apanning
  xout aleft, aright
endop


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
