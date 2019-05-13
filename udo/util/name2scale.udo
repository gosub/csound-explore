/*
  name2scale - given a scale name, return an array usable by scale2midinn
*/


;; TODO: add modal scales
;; TODO: add harmonic minor
;; TODO: add blues scale
;; TODO: add pentatonic scales
;; TODO: add exotic scales
;; TODO: k-rate?
;; TODO: tests
;; TODO: add to readme


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
