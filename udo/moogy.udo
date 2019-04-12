/*
  moogy - 2osc+noise Moog inspired instrument
*/


opcode moogy, a, ikikkkkikkkiiiiikiiii
  iNote,kAmp1,iType1,kPW1,kOct1,kTune1,kAmp2,iType2,kPW2,kOct2,kTune2,iCF,iFAtt,iFDec,iFSus,iFRel,kRes,iAAtt,iADec,iASus,iARel xin
  iCPS cpsmidinn iNote
  kOct1 octave kOct1
  kOct2 octave kOct2
  kTune1 cent kTune1
  kTune2 cent kTune2

  ; oscillator 1
  if iType1==1 || iType1==2 then
    iMode1 = (iType1==1?0:2)
    aSig1 vco2 kAmp1, iCPS*kOct1*kTune1, iMode1, kPW1
  else
    aSig1 noise kAmp1, 0.5
  endif

  ; oscillator 2
  if iType2==1 || iType2==2 then
    iMode2 = (iType2==1?0:2)
    aSig2 vco2 kAmp2, iCPS*kOct2*kTune2, iMode2, kPW2
  else
    aSig2 noise kAmp2, 0.5
  endif

  ;mix oscillators
  aMix sum aSig1, aSig2
  ;lowpass filter
  kFiltEnv expsegr 0.0001, iFAtt, iCPS*iCF, iFDec, iCPS*iCF*iFSus, iFRel, 0.0001
  aOut moogladder aMix, kFiltEnv, kRes

  ;amplitude envelope
  aAmpEnv expsegr 0.0001, iAAtt, 1, iADec, iASus, iARel, 0.0001
  aOut = aOut*aAmpEnv
  xout aOut
endop


opcode moogy, a, ik[]
  inote, kpreset[] xin
  kAmp1 = kpreset[0]
  kType1 = kpreset[1]
  iType1 = i(kType1)
  kPW1 = kpreset[2]
  kOct1 = kpreset[3]
  kTune1 = kpreset[4]
  kAmp2 = kpreset[5]
  kType2 = kpreset[6]
  iType2 = i(kType2)
  kPW2 = kpreset[7]
  kOct2 = kpreset[8]
  kTune2 = kpreset[9]
  kCF = kpreset[10]
  iCF = i(kCF)
  kFAtt = kpreset[11]
  iFAtt = i(kFAtt)
  kFDec = kpreset[12]
  iFDec = i(kFDec)
  kFSus = kpreset[13]
  iFSus = i(kFSus)
  kFRel = kpreset[14]
  iFRel = i(kFRel)
  kRes = kpreset[15]
  kAAtt = kpreset[16]
  iAAtt = i(kAAtt)
  kADec = kpreset[17]
  iADec = i(kADec)
  kASus = kpreset[18]
  iASus = i(kASus)
  kARel = kpreset[19]
  iARel = i(kARel)
  aout moogy inote,kAmp1,iType1,kPW1,kOct1,kTune1,kAmp2,iType2,kPW2,kOct2,kTune2,iCF,iFAtt,iFDec,iFSus,iFRel,kRes,iAAtt,iADec,iASus,iARel
  xout aout
endop


opcode moogy_preset, k[], k
  kpresetnum xin
  kPresets[][] init 4, 20
  kPresets fillarray .2,  2,  .5,   0,  -5,  .2,  2,   0.5, 0,    5,   1,   .01,  1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                     .2,  2,  .5,   0,  -8,  .2,  2,   0.5, 0,    8,   3,   .01,  1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                     .2,  2,  .5,   0,  -8,  .2,  2,   0.5, -1,   8,   7,  .01,   1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                     .2,  1,  .5,   0,  -10, .2,  1,   0.5, -2,   10,  40,  .01,  3,    .001, .1,  .5,  .005, .01, 1,   .05
  kpresetnum max kpresetnum, 0
  kpresetnum min kpresetnum, lenarray:k(kPresets, 1)-1
  kpreset[] getrow kPresets, kpresetnum
  xout kpreset
endop


;; TODO: add a preset generator as a UDO
