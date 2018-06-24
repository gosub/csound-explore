<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

; port of «three kicks» by snappizz
; http://sccode.org/1-57g

#define XLINE(start'end'dur) # expsega $start, $dur, $end, 1, $end #
#define PERC(att'rel) # transeg 0.00001, $att, -4, 1, $rel, -4, 0.00001 #
#define PERCLIN(att'rel) # linseg 0, $att, 1, $rel, 0 #


instr kick1
 iamp = p4
 ipan = (p5+1)/2

 a1_freq $XLINE(800'400'0.01)
 a1_env $PERC(0.0005'0.01)
 a1 poscil a1_env, a1_freq

 a2_src rand 1
 a2_freq $XLINE(800'100'0.01)
 a2_env $PERC(0.001'0.02)
 a2_env delay a2_env, 0.001
 a2 butterbp a2_src, a2_freq, a2_freq * 0.6 ; Bandwidth = Freq * 1/Q
 a2 = a2 * a2_env

 a3_freq $XLINE(172'50'0.01)
 a3_env $PERCLIN(0.0001'0.3)
 a3_env delay a3_env, 0.005
 a3 poscil a3_env, a3_freq

 asig = tanh(a1+a2+a3) * iamp
 aleft, aright pan2 asig, ipan
 outs aleft, aright
endin


instr kick2
 iamp = p4
 ipan = (p5+1)/2

 a1_src rand 1
 a1_env $PERC(0.003'0.03)
 a1 butterhp a1_src, 1320
 a1 = a1 * a1_env * 0.5
 
 a2_freq $XLINE(750'161'0.02)
 a2_env $PERC(0.0005'0.02)
 a2 poscil a2_env, a2_freq
 
 a3_freq $XLINE(167'52'0.04)
 a3_env $PERC(0.0005'0.3)
 a3 poscil a3_env, a3_freq

 asig = tanh(a1+a2+a3) * iamp
 aleft, aright pan2 asig, ipan
 outs aleft, aright
endin


instr kick3
 iamp = p4
 ipan = (p5+1)/2

 a1_freq $XLINE(1500'800'0.01)
 a1_env $PERCLIN(0.0005'0.01)
 a1 poscil a1_env, a1_freq

 a2_src mpulse 1, 0
 a2 butterbp a2_src, 6100, 6100
 a2 = a2 * ampdb(3)

 a3_src rand 1
 a3_env $PERC(0.001'0.02)
 a3 butterbp a3_src, 300, 300*0.9
 a3 = a3 * a3_env
 
 a4_freq $XLINE(472'60'0.045)
 a4_env $PERCLIN(0.0001'0.3)
 a4_env delay a4_env, 0.005
 a4 poscil a4_env, a4_freq

 asig = tanh(a1+a2+a3+a4) * iamp
 aleft, aright pan2 asig, ipan
 outs aleft, aright
endin


</CsInstruments>
<CsScore>

i "kick1" 0 1 .4 0
i "kick1" + .  . .
i "kick1" + .  . .
i "kick1" + .  . .

b 4

i "kick2" 0 1 .4 0
i "kick2" + .  . .
i "kick2" + .  . .
i "kick2" + .  . .

b 8

i "kick3" 0 1 .4 0
i "kick3" + .  . .
i "kick3" + .  . .
i "kick3" + .  . .


</CsScore>
</CsoundSynthesizer>
