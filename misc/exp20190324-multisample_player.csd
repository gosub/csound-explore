<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

;; TODO: turn into a directory sample player UDO
;; (or an instrument, since you cannot change diskin2 filename at k-time)

gSdirectory = "/home/gg/downloads/audio/samples/sums/step"
;gSdirectory = "/home/gg/downloads/audio/samples/patatap-samples-wav"
gSfiles[] directory gSdirectory
ginumfiles lenarray gSfiles


opcode playfile, a, S
  Sfilename xin
  p3 filelen Sfilename
  inumchan filenchnls Sfilename
  if inumchan == 1 then
    asig diskin2 Sfilename
  else
    asig1, asig2 diskin2 Sfilename
    asig = asig1 + asig2
  endif
  xout asig
endop


opcode playfile, aa, S
  Sfilename xin
  p3 filelen Sfilename
  inumchan filenchnls Sfilename
  if inumchan == 1 then
    asig diskin2 Sfilename
    asig1 = asig
    asig2 = asig
  else
    asig1, asig2 diskin2 Sfilename
  endif
  xout asig1, asig2
endop


instr sample
  iamp = p5
  isample = round(p4 * (ginumfiles-1))
  Ssample = gSfiles[isample]
  asig1, asig2 playfile Ssample
  outs asig1*iamp, asig2*iamp
endin


instr random_player
  itempi[] fillarray 4,2,6,3,1.5
  itempochangerate = 1
  krandom randh lenarray(itempi)-1, itempochangerate
  ktempo = itempi[abs(krandom)]
  kmetro metro ktempo
  kmetronome metro itempochangerate
  schedkwhen kmetro, 0, 0, "sample", 0, 1, random:k(0,1), 0.1
  schedkwhen kmetronome, 0, 0, "sample", 0, 1, 0.5, 0.8
endin


alwayson "random_player"
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
