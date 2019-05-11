/*
  scale2midinn - return a midi note number given scale, degree, root and octave
*/


;; TODO: name2scale.udo - return most common scales by name
;; TODO: scale2midinn with scale parameter as string
;; TODO: k-rate version
;; TODO: tests
;; TODO: add to readme


#ifndef SCALE2MIDINNUDO


opcode scale2midinn, i, i[]ojo
 iscale[], idegree, iroot, ioctave xin
 iroot = (iroot == -1 ? 60 : iroot)
 inote = ioctave * 12 + iroot
 if idegree >= 0 then
   inote += iscale[idegree % lenarray(iscale)] + 12 * int(idegree/lenarray(iscale))
 else
   idegree = idegree * -1
   inote -= iscale[idegree % lenarray(iscale)] + 12 * int(idegree/lenarray(iscale))
 endif
 xout inote
endop


#define SCALE2MIDINNUDO ##
#end
