<CsoundSynthesizer>
<CsOptions>
-d -odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


;; TODO: tape saturation
;; TODO: wow/flutter
;; TODO: make udo of tape
;; TODO: add variation and reverb to music generator
;; TODO: correct noise floor

instr tape
  itapelen init 5
  ; delay read used for tape persistence
  atape delayr itapelen

  ; delay tap is the play head
  aplay deltap3 0.1
  aplaynoise sum aplay, noise(0.001, 0.3)

  amusic dust2 0.3, 1/2
  amusic comb amusic, 1, 1/220
  amusic butterlp amusic, 220

  ; delay write is the rec head
  delayw atape+amusic+aplay*0.1

  outs aplaynoise, aplaynoise
endin


alwayson "tape"

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
