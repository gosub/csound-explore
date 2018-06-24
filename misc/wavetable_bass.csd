<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

; port of «wavetable bass» by snappizz
; which in turn is inspired by
; the formula parser of Serum
; http://sccode.org/1-57b

#define PI #3.14159265#
giframes = 256
gisamples = 2048
gibuffers[] init giframes

; lo-fi triangle
; { |x, z| round((z * 14 + 2) * x.abs) / (z * 7 + 1) - 1 }
opcode lofiTriangle,i,ii
 ix,iz xin
 ival = round((iz*14+2) * abs(ix)) / (iz*7+1) -1
 xout ival
endop

; harmonic sync
; { |x, z| var w = (x + 1) / 2; sin(w * pi) * sin(w * pi * (62 * z * z * z + 2)) }
opcode harmonicSync,i,ii
 ix,iz xin
 iw = (ix+1)/2
 ival = sin(iw*$PI) * sin(iw * $PI * (62*iz*iz*iz+2))
 xout ival
endop

; brassy
; { |x, z| sin(pi * x.sign * x.abs.pow((1 - z + 0.1) * pi * pi)) }
opcode brassy,i,ii
 ix,iz xin
 ival = sin($PI * signum(ix) * pow(abs(ix), (1-iz+0.1) * $PI * $PI))
 xout ival
endop

; saw/sine reveal
; { |x, z| if(x + 1 > (z * 2), x, sin(x * pi)) }
opcode sawSineReveal,i,ii
 ix,iz xin
 if ix + 1 > iz * 2 then
  ival = ix
 else
  ival = sin(ix*$PI)
 endif
 xout ival
endop

; i can has kickdrum
; { |x, z| sin(pi * z * z * 32 * log10(x + 1.1)) }
opcode iCanHasKickdrum,i,ii
 ix,iz xin
 ival = sin($PI * iz * iz * 32 * log10(ix + 1.1))
 xout ival
endop

; midpoint mischief
; { |x, z| 0.5 * cos(x * 0.5pi) * (x.sin * pi + ((1 - z) * sin(z * pow(x * x, z) * 32pi))) }
opcode midpointMischief,i,ii
 ix,iz xin
 if ix==0 && iz==0 then
  ip = 0
 else
  ip = pow(ix*ix,iz)
 endif
 ival = 0.5 * cos(ix * 0.5 * $PI) * (sin(ix) * $PI  + ((1 - iz) * sin(iz * ip * 32 * $PI)))
 xout ival
endop

; taffy
; {|x, z| sin(x*2pi) * cos(x*pi) * cos(z*pi*pi*(abs(pow(x*2, 3)-1)))}
opcode taffy,i,ii
 ix,iz xin
 ival = sin(ix*2*$PI) * cos(ix*$PI) * cos(iz * $PI * $PI * (abs(pow:i(ix*2, 3) - 1)))
 xout ival
endop


opcode midiratio,k,k
 kmidi xin
 kratio = pow:k(pow:k(2, 1/12), kmidi)
 xout kratio
endop


opcode clippin,k,kii
 kval, imin, imax xin
 if kval < imin then
  kval = imin
 elseif kval > imax then
  kval = imax
 endif
 xout kval
endop


; pow(d/c, (x-a)/(b-a)) * c
opcode linexp,k,kkkkk
 kx, ka, kb, kc, kd xin
 kres = pow(kd/kc, (kx-ka)/(kb-ka)) * kc
 xout kres
endop


instr 1
 iframe = 0
 until iframe == giframes do
  isample = 0
  gibuffers[iframe] = ftgen(0, 0, gisamples, 10, 0)
  until isample == gisamples do
   iz = iframe/(giframes-1)
   ix = isample/(gisamples-1)
   ival taffy ix, iz ; try different formulas: lofiTriangle,harmonicSync, brassy, sawSineReveal, iCanHasKickdrum, midpointMischief
   tablew ival, isample, gibuffers[iframe], 0
   isample += 1
  od
  iframe += 1
 od
endin


instr 2
 iamp = p5
 kfreq cpsmidinn p4
 ktable rspline 0, 1.0, 11, 11
 ktable = pow(ktable, 3)
 ktable = ktable * (giframes - 1)
 ktable clippin ktable, 0, giframes-1
 aphs1 phasor kfreq
 aphs2 phasor kfreq*midiratio:k(0.1)
 aphs3 phasor kfreq*midiratio:k(-0.1)
 aosc1 tableikt aphs1, gibuffers[ktable], 1
 aosc2 tableikt aphs2, gibuffers[ktable], 1
 aosc3 tableikt aphs3, gibuffers[ktable], 1
 asig = aosc1 + aosc2 + aosc3
 asub poscil db(-3), kfreq/2
 asig = tanh((asig +asub)*1.4)
 kfiltfreq rspline 0.0, 1.0, 6.3, 6.3
 kfiltfreq linexp kfiltfreq, 0, 1, 400, 8000
 asig lowpass2 asig, kfiltfreq, 1/0.8
 aenv madsr 0.1, 0.3, 0.7, 0.1
 asig = asig * aenv
 asig = asig * iamp
 outs asig, asig
endin

</CsInstruments>
<CsScore>
i1 0 1

r 7
i2 0 3 [12*3+12] 0.4
i2 + . [12*3+10] .
i2 + . [12*3+3]  .
i2 + . [12*3+5]  .
i2 + . [12*3+8]  .
e
</CsScore>
</CsoundSynthesizer>
