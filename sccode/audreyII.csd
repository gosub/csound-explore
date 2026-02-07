<CsoundSynthesizer>
<CsOptions>
-odac -d
-m4
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1


; port of Audrey II drone synthesizer
; original hardware by Synthux Academy / Fede Repic
; SC reference: 2026-02-06_audrey_II.scd
;
; signal flow:
;   noise seed (-90dBFS) + fb_return -> KS resonator -> overdrive
;   -> LPF -> HPF -> reverb
;       ^                                          |
;       +-- feedback delay ("body", stereo) <------+
;                                                  |
;                                            echo send
;                                                  v
;                                     echo delay (tape degrade)
;                                     BPF 800Hz -> tanh
;
; no oscillator generates sound -- the feedback loop
; self-excites when gain > ~0 dB
;
; control via channels (use CsoundQt, Cabbage, or csound -+):
;   freq      MIDI note   16..72      (default 48)
;   fbGain    dB          -60..12     (default -20)
;   body      seconds     0.001..0.1  (default 0.01)
;   lpf       Hz          100..18000  (default 12000)
;   hpf       Hz          10..4000    (default 60)
;   verbMix   0..1                    (default 0.3)
;   verbDecay 0.2..1                  (default 0.5)
;   echoSend  0..1                    (default 0)
;   echoTime  seconds     0.05..5     (default 0.3)
;   echoFb    0..1.5                  (default 0.5)
;   vol       0..1                    (default 0.3)


; --- channel defaults ---
chn_k "freq",      3, 2, 48,    16, 72
chn_k "fbGain",    3, 2, -20,   -60, 12
chn_k "body",      3, 2, 0.01,  0.001, 0.1
chn_k "lpf",       3, 2, 12000, 100, 18000
chn_k "hpf",       3, 2, 60,    10, 4000
chn_k "verbMix",   3, 2, 0.3,   0, 1
chn_k "verbDecay", 3, 2, 0.5,   0.2, 1
chn_k "echoSend",  3, 2, 0,     0, 1
chn_k "echoTime",  3, 2, 0.3,   0.05, 5
chn_k "echoFb",    3, 2, 0.5,   0, 1.5
chn_k "vol",       3, 2, 0.3,   0.001, 1

instr 1
  ; --- read channels ---
  kRawFreq   chnget "freq"
  kRawFbG    chnget "fbGain"
  kRawBody   chnget "body"
  kRawLpf    chnget "lpf"
  kRawHpf    chnget "hpf"
  kRawVmix   chnget "verbMix"
  kRawVdec   chnget "verbDecay"
  kRawEsend  chnget "echoSend"
  kRawEtime  chnget "echoTime"
  kRawEfb    chnget "echoFb"
  kRawVol    chnget "vol"

  ; --- smoothed controls ---
  kFreq   portk kRawFreq, 0.2, 48
  kFbAmp  = ampdb(portk(kRawFbG, 0.05, -20))
  kBody   portk kRawBody, 1.0, 0.01
  kLpf    portk kRawLpf, 0.05, 12000
  kHpf    portk kRawHpf, 0.05, 60
  kVmix   portk kRawVmix, 0.05, 0.3
  kVdecay portk kRawVdec, 0.05, 0.5
  kEsend  portk kRawEsend, 0.05, 0
  kEtime  portk kRawEtime, 0.5, 0.3
  kEfb    portk kRawEfb, 0.05, 0.5
  kVol    portk kRawVol, 0.05, 0.3

  kPitch  = cpsmidinn(kFreq)
  kPeriod = 1 / kPitch

  ; brightness damping cutoff (SC OnePole coef 0.98)
  iDamp = -(log(0.98)) * sr / 6.2831853


  ; --- feedback return (previous ksmps cycle) ---
  aFbL    init 0
  aFbR    init 0
  aEchoRL init 0
  aEchoRR init 0


  ; === MAIN FEEDBACK LOOP ===

  ; white noise seed at -90 dBFS + feedback
  aSeedL  noise ampdbfs(-90), 0
  aSeedR  noise ampdbfs(-90), 0
  aSigL   = aSeedL + (aFbL * kFbAmp)
  aSigR   = aSeedR + (aFbR * kFbAmp)

  ; karplus-strong resonator (tuned comb + brightness damping)
  ; decay: ~31 periods to -60 dB
  kRvt    = kPeriod * 31
  aSigL   vcomb aSigL, kRvt, kPeriod, 0.2
  aSigR   vcomb aSigR, kRvt, kPeriod, 0.2
  aSigL   tone  aSigL, iDamp
  aSigR   tone  aSigR, iDamp

  ; overdrive (soft clipping)
  aSigL   = tanh(aSigL * 1.5)
  aSigR   = tanh(aSigR * 1.5)

  ; feedback loop filters
  aSigL   butterlp aSigL, kLpf
  aSigR   butterlp aSigR, kLpf
  aSigL   butterhp aSigL, kHpf
  aSigR   butterhp aSigR, kHpf
  aSigL   dcblock aSigL
  aSigR   dcblock aSigR

  ; reverb (inside the feedback loop, as in original)
  aWetL, aWetR freeverb aSigL, aSigR, kVdecay, 0.5
  aVerbL  = aSigL * (1 - kVmix) + aWetL * kVmix
  aVerbR  = aSigR * (1 - kVmix) + aWetR * kVmix


  ; --- body feedback delay (stereo decorrelated) ---
  ; right channel offset by 4 samples for width
  kBodyR  = max(1/sr, kBody - (4/sr))

        adum1 delayr 0.25
  aFbL  deltap3 kBody
        delayw aVerbL

        adum2 delayr 0.25
  aFbR  deltap3 kBodyR
        delayw aVerbR


  ; === ECHO DELAY (outside the feedback loop) ===

  ; tape degradation: BPF + soft clip on each repetition
  aEchoTL butterbp aEchoRL, 800, 800
  aEchoTR butterbp aEchoRR, 800, 800
  aEchoTL = tanh(aEchoTL)
  aEchoTR = tanh(aEchoTR)

  ; mix echo send with degraded feedback, then delay
  aEchoInL = (aVerbL * kEsend) + (aEchoTL * kEfb)
  aEchoInR = (aVerbR * kEsend) + (aEchoTR * kEfb)

        adum3 delayr 5.0
  aEchoOL deltap3 kEtime
        delayw aEchoInL

        adum4 delayr 5.0
  aEchoOR deltap3 kEtime
        delayw aEchoInR

  ; echo feedback return for next cycle
  aEchoRL = aEchoOL
  aEchoRR = aEchoOR


  ; === OUTPUT ===
  aOutL   = (aVerbL + aEchoOL) * 0.5 * kVol
  aOutR   = (aVerbR + aEchoOR) * 0.5 * kVol

  ; limiter (clip at 0.7, matching SC Limiter threshold)
  aOutL   limit aOutL, -0.7, 0.7
  aOutR   limit aOutR, -0.7, 0.7

          outs aOutL, aOutR
endin

alwayson 1

</CsInstruments>
<CsScore>
f 0 3600
</CsScore>
</CsoundSynthesizer>
