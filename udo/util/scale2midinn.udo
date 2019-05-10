/*
  scale2midinn - return a midi note number given scale, degree, root and octave
*/


;; TODO: change parameter order to <scale, degree, root, octave>
;; TODO: default values for degree = 0, root = -1 = C3, octave = 0
;; TODO: tests
;; TODO: name2scale.udo - return most common scales by name
;; TODO: scale2midinn with scale parameter as string
;; TODO: k-rate version
;; TODO: add to readme


#ifndef SCALE2MIDINNUDO


opcode scale2midinn, i, i[]iii
 iscale[], ioctave, iroot, idegree xin
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
