/*
  dirplay - play the nth file in a folder, with choke-group support (i-rate)
  dirplaywhen - play the nth file in a folder at trigger, with choke-group support (k-rate)
*/


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
