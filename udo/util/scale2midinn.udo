/*
  scale2midinn - return a midi note number given scale, degree, root and octave
*/


;; TODO: tests


#ifndef SCALE2MIDINNUDO

#include "name2scale.udo"


opcode scale2midinn, i, i[]ojoo
  iscale[], idegree, iroot, ioctave, iscalelen xin
  iroot = (iroot == -1 ? 60 : iroot)
  iscalelen = (iscalelen == 0 ? lenarray(iscale) : iscalelen)
  inote = ioctave * 12 + iroot
  if idegree >= 0 then
    inote += iscale[idegree % iscalelen] + 12 * int(idegree/iscalelen)
  else
    idegree = idegree * -1
    inote -= iscale[idegree % iscalelen] + 12 * int(idegree/iscalelen)
  endif
  xout inote
endop


opcode scale2midinn, k, k[]OJOO
  kscale[], kdegree, kroot, koctave, kscalelen xin
  kroot = (kroot == -1 ? 60 : kroot)
  kscalelen = (kscalelen == 0 ? lenarray(kscale) : kscalelen)
  knote = koctave * 12 + kroot
  if kdegree >= 0 then
    knote += kscale[kdegree % kscalelen] + 12 * int(kdegree/kscalelen)
  else
    kdegree = kdegree * -1
    knote -= kscale[kdegree % kscalelen] + 12 * int(kdegree/kscalelen)
  endif
  xout knote
endop


opcode scale2midinn, i, Sojo
  Scalename, idegree, iroot, ioctave xin
  iscale[], iscalelen name2scale Scalename
  inote scale2midinn iscale, idegree, iroot, ioctave, iscalelen
  xout inote
endop


opcode scale2midinn, i, SOJO
  Scalename, kdegree, kroot, koctave xin
  kscale[], kscalelen name2scale Scalename
  knote scale2midinn kscale, kdegree, kroot, koctave, kscalelen
  xout knote
endop


#define SCALE2MIDINNUDO ##
#end
