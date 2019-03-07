/*
  shifreg - Shift Register with 8 outputs
*/


opcode shiftreg, kkkkkkkk, kk
  ksig, ktrig xin
  k1,k2,k3,k4,k5,k6,k7,k8 init 0,0,0,0,0,0,0,0
  k8 samphold k7, ktrig
  k7 samphold k6, ktrig
  k6 samphold k5, ktrig
  k5 samphold k4, ktrig
  k4 samphold k3, ktrig
  k3 samphold k2, ktrig
  k2 samphold k1, ktrig
  k1 samphold ksig, ktrig
  xout k1, k2, k3, k4, k5, k6, k7, k8
endop


opcode shiftreg, aaaaaaaa, ak
  asig, ktrig xin
  a1,a2,a3,a4,a5,a6,a7,a8 init 0,0,0,0,0,0,0,0
  a8 samphold a7, ktrig
  a7 samphold a6, ktrig
  a6 samphold a5, ktrig
  a5 samphold a4, ktrig
  a4 samphold a3, ktrig
  a3 samphold a2, ktrig
  a2 samphold a1, ktrig
  a1 samphold asig, ktrig
  xout a1, a2, a3, a4, a5, a6, a7, a8
endop

