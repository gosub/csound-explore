#  Overview of my Csound explorations

## grid

launchpad based, monome inspired

- lpmini.inc - library for the launchpad mini mkII
- flin.csd - clone of flin instrument from monome sum
- step.csd - clone of step instrument from monome sum
- basic64 - simple grid UDOs
  - momo.udo - 64 momentary switches
  - togo.udo - 64 toggle switches
  - fado.udo - 8 smooth faders
  - pato.udo - 64 patching points, 32ins-left 32outs-right
  - runbygrid.udo - auxiliary UDO to use instruments with the array returned by momo and togo
  - patchby.udo - auxiliary UDO to connect opcodes with the array returned by pato

## udo

- clockdiv.udo - clock divider
- euclidean.udo - euclidean rhythm sequencer
- dirplay.udo
  - dirplay - play the nth file in a folder, with choke-group support (i-rate)
  - dirplaywhen - play the nth file in a folder at trigger, with choke-group support (k-rate)
- moogy.udo - 2osc + noise Moog inspired instrument
  - moogy - udo with all controls as parameter
  - moogy(ik[]) - same udo with controls passed via an array (except note)
  - moogy\_preset - collection of presets to pass directly to moogy(ik[]) 
  - moogy\_rnd\_preset - random preset generator to pass directly to moogy(ik[]) 
- resonators.udo - clone of Resonators device from Ableton Live
- shiftreg.udo - digital shift register with 8 outputs
- sc - port of SuperCollider UGens
  - exprand.udo - [logarithmic uniform distribution random number generator](http://doc.sccode.org/Classes/SimpleNumber.html#-exprand)
  - lfgauss.udo - [non-band-limited gaussian function oscillator](http://doc.sccode.org/Classes/LFGauss.html)
  - splay.udo - [spreads an array of channels across the stereo field](http://doc.sccode.org/Classes/Splay.html)
- tee.udo - trigger based UDOs
  - tsequence - sequence an array on trigger (udo)
  - tchoice - sequence a random array member on trigger (udo) 
  - twchoice - sequence a random array member on trigger, with probability (udo)
  - tstepper - sequence an array on trigger, with step-length, reverse, rotation and reset (udo) 
  - tcount - trigger counter, with optional wrap-around (udo)
  - tline - triggerable version of the line opcode (udo)
  - tlinen - triggerable version of the linen opcode (udo)
  - tcoin - trow a coin on trigger (udo)
- turing.udo - Turing Machine eurorack module clone
- util
  - once.udo - is true only once, at k-rate
  - minmax.udo - sorts two numbers
  - randint.udo - return a random int between max and min (default 0)
  - rndstring.udo - generate a random string of arbitrary length
  - arrayreverse.udo - reverse an array
  - arrayshuffle.udo - shuffle an array with the Fisher-Yates algorithm
  - arrayofsubinstr.udo - instatiate n subinstruments inside an a-rate array
  - name2scale.udo - given a scale name, return an array usable by scale2midinn (and an array size)
  - strchanged.udo - return 1 when a string changes (k-rate)

## sccode

ports of SuperCollider instruments, from sccode.org

- 3kicks - port of [«three kicks» by snappizz](http://sccode.org/1-57g)
- fm\_rhodes - port of [«FM Rhodes» by snappizz](http://sccode.org/1-522)
- wavetable\_bass - port of [«wavetable bass» by snappizz](http://sccode.org/1-57b)
- sistres - port of [«sistres» by alln4tural](http://sccode.org/1-1Ni)

## tests
minimal tests for all my instruments and UDOs

## misc
various experiments, most UDOs and instruments start here

## WIP / INCOMPLETE / NOT WORKING YET

### tidal
port of a subset of the TidalCycles pattern language to Csound

### reaktor
port of interesting N.I. Reaktor instruments to Csound


# Distribution

Copyright (C) 2018-2019 Giampaolo Guiducci

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

