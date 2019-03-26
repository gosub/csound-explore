<CsoundSynthesizer>
<CsOptions>
-odac -d
-+rtmidi=alsaseq -M20 -Q20
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gichan = 2


iindex = 1
while iindex < 9 do
  ctrlinit gichan, iindex, 0
  iindex += 1
od


instr 1
  imin = 0
  imax = 1

  aknob1 ctrl7 gichan, 1, imin, imax
  aknob2 ctrl7 gichan, 2, imin, imax
  aknob3 ctrl7 gichan, 3, imin, imax
  aknob4 ctrl7 gichan, 4, imin, imax
  aknob5 ctrl7 gichan, 5, imin, imax
  aknob6 ctrl7 gichan, 6, imin, imax
  aknob7 ctrl7 gichan, 7, imin, imax
  aknob8 ctrl7 gichan, 8, imin, imax

  ; major scale
  ;0,2,4,5,7,9,11,0,2...

  achordA1 poscil	0.333, cpspch(8.00)
  achordA2 poscil	0.333, cpspch(8.04)
  achordA3 poscil	0.333, cpspch(8.07)
  achordA sum achordA1, achordA2, achordA3

  achordB1 poscil	0.333, cpspch(8.02)
  achordB2 poscil	0.333, cpspch(8.05)
  achordB3 poscil	0.333, cpspch(8.09)
  achordB sum achordB1, achordB2, achordB3

  achordC1 poscil	0.333, cpspch(8.04)
  achordC2 poscil	0.333, cpspch(8.07)
  achordC3 poscil	0.333, cpspch(8.11)
  achordC sum achordC1, achordC2, achordC3

  achordD1 poscil	0.333, cpspch(8.05)
  achordD2 poscil	0.333, cpspch(8.09)
  achordD3 poscil	0.333, cpspch(9.00)
  achordD sum achordD1, achordD2, achordD3

  achordE1 poscil	0.333, cpspch(8.07)
  achordE2 poscil	0.333, cpspch(8.11)
  achordE3 poscil	0.333, cpspch(9.02)
  achordE sum achordE1, achordE2, achordE3

  achordF1 poscil	0.333, cpspch(8.09)
  achordF2 poscil	0.333, cpspch(9.00)
  achordF3 poscil	0.333, cpspch(9.04)
  achordF sum achordF1, achordF2, achordF3

  achordA = achordA * aknob1
  achordB = achordB * aknob2
  achordC = achordC * aknob3
  achordD = achordD * aknob4
  achordE = achordE * aknob5
  achordF = achordF * aknob6

  amix sum achordA, achordB, achordC, achordD, achordE, achordF
  outs amix, amix
endin


alwayson 1
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
