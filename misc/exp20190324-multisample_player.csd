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

gSdirectory = "/home/gg/downloads/audio/samples/sums/step"
;gSdirectory = "/home/gg/downloads/audio/samples/patatap-samples-wav"
gSfiles[] directory gSdirectory
ginumfiles lenarray gSfiles

opcode inckwhen, k, ki
  ktrig, imax xin
  kvalue init imax
  if ktrig == 1 then
    kvalue += 1
  endif
  kvalue = kvalue % imax
  xout kvalue
endop



instr sample
  iamp = p5
  isample = round(p4 * (ginumfiles-1))
  Ssample = gSfiles[isample]
  p3 filelen Ssample
  asig diskin2 Ssample
  outs asig*iamp, asig*iamp
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
