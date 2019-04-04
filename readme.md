#  Overview of my Csound explorations

## grid

launchpad based, monome inspired

- lpmini.inc - library for the launchpad mini mkII
- flin.csd - clone of flin instrument from monome sums
- step.csd - clone of step instrument from monome sums
- basic64.udo - simple grid UDOs
  - momo - 64 momentary switches (udo)
  - togo - 64 toggle switches (udo)
  - fado - 8 smooth faders (udo)

## udo

- clockdiv.udo - clock divider
- euclidean.udo - euclidean rhythm sequencer
- resonators.udo - clone of Resonators device from Ableton Live
- shiftreg.udo - digital shift register with 8 outputs
- turing.udo - Turing Machine eurorack module clone
- tee.udo - trigger based UDOs
  - tsequence - sequence an array on trigger (udo)
  - tchoice - sequence a random array member on trigger (udo) 
  - twchoice - sequence a random array member on trigger, with probability (udo)
  - tstepper - sequence an array on trigger, with step-length, reverse, rotation and reset (udo) 

## sccode

ports of SuperCollider instruments, from sccode.org

- 3kicks - port of [«three kicks» by snappizz](http://sccode.org/1-57g)
- fm\_rhodes - port of [«FM Rhodes» by snappizz](http://sccode.org/1-522)
- wavetable\_bass - port of [«wavetable bass» by snappizz](http://sccode.org/1-57b)

## tests
minimal tests for all my instruments and UDOs

## misc
various experiments, most UDOs and instruments start here

## WIP / INCOMPLETE / NOT WORKING YET

### tidal
port of a subset of the TidalCycles pattern language to Csound

### reaktor
port of interesting N.I. Reaktor instruments to Csound
