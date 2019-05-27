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


;; TODO: choose if use dirplay or dirplaywhen
;; TODO: put in separate UDO
;; TODO: test
;; TODO: readme


opcode rndstring, S, i
  ilen xin
  Sresult init ""
  ilen max 1, ilen
  idx = 0
  while idx < ilen do
    Sresult strcat Sresult, sprintf("%c", random(97,122.999))
    idx += 1
  od
  xout Sresult
endop


gSdirectory = "/home/gg/downloads/audio/samples/sums/step"


instr __sndfileplay
  Sfilename = p4
  Schan = p5
  p3 filelen Sfilename
  inumchan filenchnls Sfilename
  if inumchan == 1 then
    asig diskin2 Sfilename
    chnset asig, strcat(Schan, "L")
    chnset asig, strcat(Schan, "R")
  else
    aL, aR diskin2 Sfilename
    chnset aL, strcat(Schan, "L")
    chnset aR, strcat(Schan, "R")
  endif
endin


instr __dirplay
  Sdir = p4
  ifilenum = p5
  ichoke = p6
  Schan = p7
  Sfilelist[] directory Sdir
  ifilecount lenarray Sfilelist
  Sfilename = Sfilelist[ifilenum%ifilecount]
  if ichoke == 0 then
    schedule "__sndfileplay", 0, 1, Sfilename, Schan
  else
    instance = nstrnum("__sndfileplay") + ichoke*0.01
    turnoff2 instance, 4, 1
    schedule instance, 0, 1, Sfilename, Schan
  endif
  turnoff
endin


opcode dirplaywhen, aa, kSkk
  ktrig, Sdir, kfilenum, kchoke xin
  Sfmt init {{i %d 0 1 "%s" %d %d "%s"}}
  Schan rndstring 16
  ;chn_a strcat(Schan, "L"),2
  ;chn_a strcat(Schan, "R"),2
  scoreline sprintfk(Sfmt, nstrnum("__dirplay"), Sdir, kfilenum, kchoke, Schan), ktrig
  aL chnget strcat(Schan, "L")
  aR chnget strcat(Schan, "R")
  xout aL, aR
endop


opcode dirplay, aa, Sii
  Sdir, ifilenum, ichoke xin
  Schan rndstring 16
  schedule "__dirplay", 0, 1, Sdir, ifilenum, ichoke, Schan
  aL chnget strcat(Schan, "L")
  aR chnget strcat(Schan, "R")
  xout aL, aR
endop


instr random_player
  itempi[] fillarray 4,2,6,3,1.5
  itempochangerate = 1
  krandom randh lenarray(itempi)-1, itempochangerate
  ktempo = itempi[abs(krandom)]
  kmetro metro ktempo
  kmetronome metro 1
  a1L, a1R dirplaywhen kmetro, gSdirectory, random:k(0,100), 0
  a2L, a2R dirplaywhen kmetronome, gSdirectory, 4, 1
  aL sum a1L/10, a2L/2
  aR sum a1R/10, a2R/2
  outs aL, aR
endin


alwayson "random_player"
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
