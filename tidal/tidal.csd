<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32

nchnls = 2
0dbfs = 1

instr 1
  icycle = p4
  ; beats
  schedule 2, 0, 2, "bd"
  schedule 2, 0.5, 2, "sd"
  if icycle % 3==0 then
    schedule 2, 0.75, 2, "bd"
  endif
  schedule 2, 1, 2, "bd"
  schedule 2, 1.5, 2, "sd"
  ; temporal recursion
  schedule 1, 2, 1, (icycle+1)
  turnoff
endin

instr 2
	Sample = p4
	Sdir = "/home/gg/downloads/samples/sums/step/"
	a1 diskin strcat(Sdir, strcat(Sample, "01.wav"))
	out a1, a1
endin

</CsInstruments>
<CsScore>
i1 0 1 0 # just to start instrument 1
</CsScore>
</CsoundSynthesizer>