<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "launchpad.inc"

seed 0

giSine   ftgen 0,0,4096,10,1
giSaw    ftgen 0,0,4096,10,1,0.5,0.3,0.25,0.2,0.167,0.14,0.125,.111
giSquare ftgen 0,0,4096,10,1,0,0.3,0,0.2,0,0.14,0,.111

; controller instrument
instr 1
 ; grid notes
 iBase = 40
 iScale[] fillarray 0, 2, 3, 5, 7, 8, 10, 12 ; minor scale

 ; generate random values for the synth
 ; a different synth each run
 iRatios[] fillarray 1, 1/2, 2/3, 3/4, 4/5, 3/5
 iRatioIndx random 0, 6
 iRatio = iRatios[int(iRatioIndx)]
 iIndex random 1, 20
 iAtt random 0.01, 2
 iDec random 0.01, 1
 iSus random 0.5, 1
 iRel random 0.01, 2
 iTable[] fillarray, giSine, giSaw, giSquare
 iOscCar random 0, lenarray(iTable)
 iOscCar = iTable[int(iOscCar)]
 iOscMod random 0, lenarray(iTable)
 iOscMod = iTable[int(iOscMod)]
 print iRatio, iIndex, iAtt, iDec, iSus, iRel, iOscCar, iOscMod

 ; clear the grid at init time
 LPcleari

 ktrig, kevent, krow, kcol LPread
 if ktrig == 1 then
  kIns = (8*krow+kcol) * 0.01
  if kevent == $LP_KEY_DOWN then
   ; notes go up by octaves, and left by iScale degrees
   kNote = iBase + (7-krow)*12 + iScale[kcol]
   event "i", 2+kIns, 0, -1, cpsmidinn(kNote), iRatio, iIndex, iAtt, iDec, iSus, iRel, iOscCar, iOscMod
   LPledon $LP_GREEN, krow, kcol
  elseif kevent == $LP_KEY_UP then
   turnoff2 2+kIns, 4, 1
   LPledoff krow, kcol
  endif
 endif
endin


; synth instrument
instr 2
 iAmp = 0.1
 iCarFreq, iRatio, iIndex, iAtt, iDec, iSus, iRel, iOscCar, iOscMod passign 4
 iModFreq = iCarFreq * iRatio
 iModAmp = iIndex*iModFreq
 aModulator poscil iModAmp, iModFreq, iOscMod
 kEnv madsr iAtt, iDec, iSus, iRel
 aCarrier poscil kEnv*iAmp, iCarFreq+aModulator, iOscCar
 outs aCarrier, aCarrier
endin


; enable controller instrument
alwayson 1
; disable automatic midi channel assignment
massign 0, 0


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
