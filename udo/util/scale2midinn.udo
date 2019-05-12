/*
  scale2midinn - return a midi note number given scale, degree, root and octave
*/


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


;; TODO: name2scale in a separate file
;; TODO: name2scale, add modal scales
;; TODO: name2scale, add harmonic minor
;; TODO: name2scale, add blues scale
;; TODO: name2scale, add pentatonic scales
;; TODO: name2scale, add exotic scales
;; TODO: name2scale, k-rate?
;; TODO: name2scale, tests
;; TODO: name2scale, add to readme


#ifndef NAME2SCALEUDO


opcode name2scale, i[], S
  Scalename xin
  if Scalename == "major" then
    iscale[] fillarray 0,2,4,5,7,9,11
  elseif Scalename == "minor" then
    iscale[] fillarray 0,2,3,5,7,8,10
  endif
  xout iscale
endop


#define NAME2SCALEUDO ##
#end
