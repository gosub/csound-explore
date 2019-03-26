<CsoundSynthesizer>
<CsOptions>
-d -odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1


instr kick
  ienv = 0.1
  kamp linen 0.3, p3*ienv, p3, p3*(1-ienv)
  kcps line 100, p3, 30
  kfiltfreq line 200, p3, 50
  asig vco2 0.5, kcps, 2, 0.6
  asig2 vco2 0.5, kcps
  afilt butterlp asig+asig2, kfiltfreq
  outs afilt*kamp, afilt*kamp
endin


;; looper is a temporal recursive instrument
;; it schedule a secondary instrument (p4)
;; for next n beats (p5) following a pattern (p6)
;; and then schedules itself.
;; there is only one problem, it drifts.
;; the schedule opcode does not compensate for
;; the time that has elapsed since the beginning
;; of the current instance.
;; on my laptop it drifts 1 ms every 4 seconds


instr looper
  iinstrument = p4
  ibeats = p5
  Spattern = p6
  isubs = ibeats/strlen(Spattern)
  it = 0
  while it < strlen(Spattern) do
    Schar strsub Spattern, it, it+1
    ion  = (strcmp(Schar, "1")==0 ? 1 : 0)
    if ion == 1 then
      schedule iinstrument, it*isubs, 0.2
    endif
    it += 1
  od
  ; temporal recursion
  schedule p1, ibeats, 1, iinstrument, ibeats, Spattern
  turnoff
endin

</CsInstruments>
<CsScore>

i "looper" 0 3600 1 2 "1000100010010100"

</CsScore>
</CsoundSynthesizer>
