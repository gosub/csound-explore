/*
  scale2midinn - return a midi note number given scale, degree, root and octave
*/


;; TODO: k-rate version
;; TODO: tests
;; TODO: add to readme


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


opcode scale2midinn, i, Sojo
  Scalename, idegree, iroot, ioctave xin
  iscale[], iscalelen name2scale Scalename
  inote scale2midinn iscale, idegree, iroot, ioctave, iscalelen
  xout inote
endop


#define SCALE2MIDINNUDO ##
#end
