<CsoundSynthesizer>
<CsOptions>
-o alarm.wav -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

instr 1
iamp = p4
ifreq = p5
a1 oscil iamp, ifreq
aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
a2 = a1*aenv
out a2
endin

</CsInstruments>
<CsScore>
i1 0       0.25  0.1  500
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     >    .
i1 ^+0.5   .     0.5  .
i1 ^+0.5   1     0.7  750

</CsScore>
</CsoundSynthesizer>