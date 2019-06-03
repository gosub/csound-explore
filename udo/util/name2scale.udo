/*
  name2scale - given a scale name, return an array usable by scale2midinn
*/


;; TODO: neapolitan scales
;; TODO: add exotic scales
;; TODO: k-rate?
;; TODO: tests
;; TODO: add to readme


#ifndef NAME2SCALEUDO


opcode name2scale, i[], S
  Scalename xin
  if Scalename == "major" || Scalename == "ionian" then
    iscale[] fillarray 0,2,4,5,7,9,11
  elseif Scalename == "minor" || Scalename == "natural_minor" || Scalename == "aeolian" then
    iscale[] fillarray 0,2,3,5,7,8,10
  elseif Scalename == "dorian" then
    iscale[] fillarray 0,2,3,4,7,9,10
  elseif Scalename == "phrygian" then
    iscale[] fillarray 0,1,3,5,7,8,10
  elseif Scalename == "lydian" then
    iscale[] fillarray 0,2,4,6,7,9,11
  elseif Scalename == "mixolydian" then
    iscale[] fillarray 0,2,4,5,7,9,11
  elseif Scalename == "locrian" then
    iscale[] fillarray 0,1,3,5,6,8,10
  elseif Scalename == "harmonic_minor" then
    iscale[] fillarray 0,2,3,5,7,8,11
  elseif Scalename == "pentatonic" || Scalename == "major_pentatonic" then
    iscale[] fillarray 0,2,4,7,9
  elseif Scalename == "minor_pentatonic" then
    iscale[] fillarray 0,3,5,7,10
  elseif Scalename == "blues" then
    iscale[] fillarray 0,3,5,6,7,10
  elseif Scalename == "whole" then
    iscale[] fillarray 0,2,4,6,8,10
  elseif Scalename == "bartok" || Scalename == "hindu" then
    iscale[] fillarray 0,2,4,5,7,8,10
  elseif Scalename == "chromatic" then
    iscale[] fillarray 0,1,2,3,4,5,6,7,8,9,10,11
  elseif Scalename == "spanish" then
    iscale[] fillarray 0,1,4,5,7,8,10
  elseif Scalename == "hungarian" || Scalename == "hungarian_minor" then
    iscale[] fillarray 0,2,3,6,7,8,11
  endif
  xout iscale
endop


#define NAME2SCALEUDO ##
#end
