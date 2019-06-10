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
  if iType1 <= 3 then
    if iType1 == 1 then
      iMode1 = 0
    elseif iType1 == 2 then
      iMode1 = 2
    elseif iType1 == 3 then
      iMode1 = 4
    endif
    aSig1 vco2 kAmp1, iCPS*kOct1*kTune1, iMode1, kPW1
  else
    aSig1 noise kAmp1, 0.5
  endif

  ; oscillator 2
  if iType2 <= 3 then
    if iType2 == 1 then
      iMode2 = 0
    elseif iType2 == 2 then
      iMode2 = 2
    elseif iType2 == 3 then
      iMode2 = 4
    endif
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


opcode moogy, a, ii[]
  inote, ipreset[] xin
  kAmp1 = ipreset[0]
  iType1 = ipreset[1]
  kPW1 = ipreset[2]
  kOct1 = ipreset[3]
  kTune1 = ipreset[4]
  kAmp2 = ipreset[5]
  iType2 = ipreset[6]
  kPW2 = ipreset[7]
  kOct2 = ipreset[8]
  kTune2 = ipreset[9]
  iCF = ipreset[10]
  iFAtt = ipreset[11]
  iFDec = ipreset[12]
  iFSus = ipreset[13]
  iFRel = ipreset[14]
  kRes = ipreset[15]
  iAAtt = ipreset[16]
  iADec = ipreset[17]
  iASus = ipreset[18]
  iARel = ipreset[19]
  aout moogy inote,kAmp1,iType1,kPW1,kOct1,kTune1,kAmp2,iType2,kPW2,kOct2,kTune2,iCF,iFAtt,iFDec,iFSus,iFRel,kRes,iAAtt,iADec,iASus,iARel
  xout aout
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


giMoogyPresets[][] init 4, 20
giMoogyPresets fillarray .2,  2,  .5,   0,  -5,  .2,  2,   0.5, 0,    5,   1,   .01,  1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                         .2,  2,  .5,   0,  -8,  .2,  2,   0.5, 0,    8,   3,   .01,  1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                         .2,  2,  .5,   0,  -8,  .2,  2,   0.5, -1,   8,   7,  .01,   1,    .1,   .1,  .5,  .005, .01, 1,   .05, \
                         .2,  1,  .5,   0,  -10, .2,  1,   0.5, -2,   10,  40,  .01,  3,    .001, .1,  .5,  .005, .01, 1,   .05


opcode moogy_preset, k[], k
  kpresetnum xin
  kpresetnum max kpresetnum, 0
  kpresetnum min kpresetnum, lenarray:k(giMoogyPresets, 1)-1
  kPresets[][] = giMoogyPresets
  kpreset[] getrow kPresets, kpresetnum
  xout kpreset
endop


opcode moogy_preset, i[], i
  ipresetnum xin
  ipresetnum max ipresetnum, 0
  ipresetnum min ipresetnum, lenarray:i(giMoogyPresets, 1)-1
  ipreset[] getrow giMoogyPresets, ipresetnum
  xout ipreset
endop


opcode moogy_rnd_preset, i[], o
  iprintit xin

  seed 0
  ;; MAYBE: better random parameters
  iAmp1 random 0.1, 0.7
  iType1 int random(1, 4.999)
  iPW1 random 0.1, 0.9
  iOct1 int random(-1.999, 2.999)
  iTune1 = (random(0, 1)>0.5 ? 0 : int(linrand(100)+1))
  iAmp2 random 0.1, 0.7
  iType2 int random(1, 4.999)
  iPW2 random 0.1, 0.9
  iOct2 int random(-1.999, 2.999)
  iTune2 = (random(0,1)>0.5 ? 0 : int(linrand(100)+1))
  iCF = (random(0, 1)>0.5 ? 1 : int(linrand(10)+1))
  iFAtt random 0.001, 0.1
  iFDec random 0, 0.1
  iFSus = (random(0,1)>0.5 ? 1 : int(linrand(10)+1))
  iFRel random 0.001, 0.5
  iRes random 0, 1
  iAAtt random 0.001, 0.1
  iADec random 0, 0.1
  iASus random 0, 1
  iARel random 0.001, 0.5

  ipreset[] fillarray iAmp1,iType1,iPW1,iOct1,iTune1,iAmp2,iType2,iPW2,iOct2,iTune2,iCF,iFAtt,iFDec,iFSus,iFRel,iRes,iAAtt,iADec,iASus,iARel
  if iprintit == 1 then
    printarray ipreset, "%.3f,"
  endif
  xout ipreset
endop
