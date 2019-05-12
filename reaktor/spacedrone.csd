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

gkQ = 5 ; Filter Q
gkSpeed = 5 ; Pitch Randomness Freq
gkAmount = 1 ; Pitch Randomness Depth
gkPitch = 0 ; Pitch -12 <-> 12


instr 1
  kVoice = 0
  
  kEnv = 
  kPitchOffsetted = 
  kPitchEnveloped = gkPitch * kEnv
  kPitchShifted = kPitchEnveloped + kPitchOffsetted
  kPitchRand randh gkAmount, gkSpeed
  kPitch = kPitchRand + kPitchShifted
  kFreq = cpspch(kPitch)
  kBW = kFreq/gkQ

a1 rand 0.01, 2
a2 resonz a1, kFreq, kBW

   outs a2, a2

endin

</CsInstruments>
<CsScore>

i 1 0 3

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
