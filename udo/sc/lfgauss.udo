/*
  lfgauss - port of lfgauss ugen from supercollider
*/


opcode lfgauss, a, kkk
  kdur, kwidth, kphase xin
  ax phasor 1/kdur
  ax = ax*2 - 1
  aout = exp:a((ax - kphase)^2 / (-2.0 * kwidth^2))
  xout aout
endop
