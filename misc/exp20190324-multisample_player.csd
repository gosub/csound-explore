<CsoundSynthesizer>
<CsOptions>
-odac -d
-m0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1


;; TODO: rename dirplay to __dirplay
;; TODO: use channels to tunnel audio from __sndfileplay to dirplaywhen
;; TODO: choose if use dirplay or dirplaywhen
;; TODO: put in separate UDO
;; TODO: test
;; TODO: readme


gSdirectory = "/home/gg/downloads/audio/samples/sums/step"


instr __sndfileplay
  Sfilename = p4
  p3 filelen Sfilename
  inumchan filenchnls Sfilename
  if inumchan == 1 then
    asig diskin2 Sfilename
    outs asig, asig
  else
    aL, aR diskin2 Sfilename
    outs aL, aR
  endif
endin


instr dirplay
  Sdir = p4
  ifilenum = p5
  ichoke = p6
  Sfilelist[] directory Sdir
  ifilecount lenarray Sfilelist
  Sfilename = Sfilelist[ifilenum%ifilecount]
  if ichoke == 0 then
    schedule "__sndfileplay", 0, 1, Sfilename
  else
    instance = nstrnum("__sndfileplay") + ichoke*0.01
    turnoff2 instance, 4, 1
    schedule instance, 0, 1, Sfilename
  endif
  turnoff
endin


opcode dirplaywhen, 0, kSkk
  ktrig, Sdir, kfilenum, kchoke xin
  scoreline sprintfk({{i %d 0 1 "%s" %d %d}}, nstrnum("dirplay"), Sdir, kfilenum, kchoke), ktrig
endop


instr random_player
  itempi[] fillarray 4,2,6,3,1.5
  itempochangerate = 1
  krandom randh lenarray(itempi)-1, itempochangerate
  ktempo = itempi[abs(krandom)]
  kmetro metro ktempo
  kmetronome metro 1
  dirplaywhen kmetro, gSdirectory, random:k(0,100), 0
  dirplaywhen kmetronome, gSdirectory, 0, 1
endin


alwayson "random_player"
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
