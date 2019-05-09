<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

; port of «FM Rhodes» by snappizz
; which in turn is a port of STK's Rhodey
; (yamaha DX7-style Fender Rhodes)
; http://sccode.org/1-522

#define PDEFAULT(pnum'var'default) # $var = (pcount()<$pnum ? $default : p$pnum) #
giSine ftgen 0,0,2048,10,1


instr 1
 ; p4:freq p5:pan p6:amp p7:vel
 ; p8:modIndex p9:mix p10:lfoSpeed p11:lfoDepth
 $PDEFAULT(4'ifreq'440)
 $PDEFAULT(5'ipan'0)
 $PDEFAULT(6'iamp'0.1)
 $PDEFAULT(7'ivel'0.8)
 $PDEFAULT(8'imodIndex'0.2)
 $PDEFAULT(9'imix'0.2)
 $PDEFAULT(10'ilfoSpeed'0.4)
 $PDEFAULT(11'ilfoDepth'0.1)

 ilfoSpeed = ilfoSpeed * 12
 ifreq = ifreq * 2

 aenv1 adsr 0.001, 1.25, 0.0, 0.04
 aenv2 adsr 0.001, 1.00, 0.0, 0.04
 aenv3 adsr 0.001, 1.50, 0.0, 0.04
 aenv4 adsr 0.001, 1.50, 0.0, 0.04

 aosc4 poscil 1, ifreq * 0.5
 aosc4 = aosc4 * 2 * 0.535887 * imodIndex * aenv4 * ivel

 aphase3 phasor ifreq
 aosc3 tablei aphase3+aosc4, giSine, 1, 0, 1
 aosc3 = aosc3 * aenv3 * ivel

 aosc2 poscil 1, ifreq*15
 aosc2 = aosc2 * 0.108819 * aenv2 * ivel

 aphase1 phasor ifreq
 aosc1 tablei aphase1+aosc2, giSine, 1, 0, 1
 aosc1 = aosc1 * aenv1 * ivel

 asnd = aosc3 * (1-imix) + aosc1 * imix
 aenv transegr 0.0001, 0.0001, -4, 1, 0.1, -4, 0.0001
 alfo poscil ilfoDepth, ilfoSpeed
 alfo = alfo + 1
 asnd = asnd * aenv * alfo

 aleft, aright pan2 asnd*iamp, (ipan+1)/2
 outs aleft, aright
endin


;; TODO: extract scale2midinn in a util/ udo


opcode scale2midinn, i, i[]iii
 iscale[], ioctave, iroot, idegree xin
 inote = ioctave * 12 + iroot
 if idegree >= 0 then
   inote += iscale[idegree % lenarray(iscale)] + 12 * int(idegree/lenarray(iscale))
 else
   idegree = idegree * -1
   inote -= iscale[idegree % lenarray(iscale)] + 12 * int(idegree/lenarray(iscale))
 endif
 xout inote
endop


instr 2
 icount = p4
 iinstr = 1
 imixolydian[] fillarray 0, 2, 4, 5, 7, 9, 10
 ioctave = 4
 iroot = 2
 ilegatos[] fillarray .9, .5, .5, .9, .9, .9, .9, .5, 1, .5, 1, .6, .3
 idurs[] fillarray 1+(1/3), 1/3, 1/3, 1/7, 6/7, 5/6, 1/6, 1/2, 2/6, 1/6, 2+(1/2), 1, 1/2
 idegrees[] fillarray 0,2,4,7,8,7,0,1,5,1,-999,-1,1,
                      0,2,4,8,9,7,0,1,5,1,-999,-1,1 ; -999 is rest
 idegrees2[] fillarray 2,0,0,0,0,0,0,3,0,3,0,1,3,
                       2,0,0,0,0,0,0,3,0,3,0,1,3
 idegrees3[] fillarray 4,0,0,0,0,0,0,6,0,6,0,3,5,
                       4,0,0,0,0,0,0,6,0,6,0,3,5
 imix = 0.2
 imodIndex = 0.2
 ilfoSpeed = 0.5
 ilfoDepth = 0.4
 ivel gauss 0.1
 ivel += 0.8
 ipan = 0
 iamp = 0.3
 itempo = 1.5

 idur = idurs[icount % lenarray(idurs)] / itempo
 ilegato = ilegatos[icount % lenarray(ilegatos)]
 idegree = idegrees[icount % lenarray(idegrees)]

 if idegree != -999 then
  inote scale2midinn imixolydian, ioctave, iroot, idegree
  ifreq = cpsmidinn(inote)
  schedule iinstr, 0, idur*ilegato, ifreq, ipan, iamp, ivel, imodIndex, imix, ilfoSpeed, ilfoDepth

  idegree2 = idegrees2[icount % lenarray(idegrees2)]
  if idegree2 != 0 then
   inote2 scale2midinn imixolydian, ioctave, iroot, idegree2
   ifreq2 = cpsmidinn(inote2)
   schedule iinstr, 0, idur*ilegato, ifreq2, ipan, iamp, ivel, imodIndex, imix, ilfoSpeed, ilfoDepth
  endif

  idegree3 = idegrees3[icount % lenarray(idegrees3)]
  if idegree3 != 0 then
   inote3 scale2midinn imixolydian, ioctave, iroot, idegree3
   ifreq3 = cpsmidinn(inote3)
   schedule iinstr, 0, idur*ilegato, ifreq3, ipan, iamp, ivel, imodIndex, imix, ilfoSpeed, ilfoDepth
  endif
 endif

 ; recursive call to self, after dur
 schedule 2, idur, 1, icount+1
 turnoff
endin

</CsInstruments>
<CsScore>
; instrument 1 is the Rhodes
; instrument 2 is a recreation of the Pbind, with a time recursive instr
; scale2midinn is an opcode that turns a scale, octave, root and degree in a midi note number

; plays instrument 2 for 1 hour
i2 0 3600 0
</CsScore>
</CsoundSynthesizer>
