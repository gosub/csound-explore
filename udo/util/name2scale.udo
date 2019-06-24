/*
  name2scale - given a scale name, return an array usable by scale2midinn
*/


;; TODO: verify k-rate version


#ifndef NAME2SCALEUDO

#define STREQ(STRINGA'STRINGB) #(strcmp($STRINGA,$STRINGB)==0)#


opcode name2scale, i[]i, S
  Scalename xin
  if $STREQ(Scalename'"major") || $STREQ(Scalename'"ionian") then
    iscale[] fillarray 0,2,4,5,7,9,11
    isize = 7
  elseif $STREQ(Scalename'"minor") || $STREQ(Scalename'"natural_minor") || $STREQ(Scalename'"aeolian") then
    iscale[] fillarray 0,2,3,5,7,8,10
    isize = 7
  elseif $STREQ(Scalename'"dorian") then
    iscale[] fillarray 0,2,3,4,7,9,10
    isize = 7
  elseif $STREQ(Scalename'"phrygian") then
    iscale[] fillarray 0,1,3,5,7,8,10
    isize = 7
  elseif $STREQ(Scalename'"lydian") then
    iscale[] fillarray 0,2,4,6,7,9,11
    isize = 7
  elseif $STREQ(Scalename'"mixolydian") then
    iscale[] fillarray 0,2,4,5,7,9,11
    isize = 7
  elseif $STREQ(Scalename'"locrian") then
    iscale[] fillarray 0,1,3,5,6,8,10
    isize = 7
  elseif $STREQ(Scalename'"harmonic_minor") then
    iscale[] fillarray 0,2,3,5,7,8,11
    isize = 7
  elseif $STREQ(Scalename'"pentatonic") || $STREQ(Scalename'"major_pentatonic") then
    iscale[] fillarray 0,2,4,7,9
    isize = 5
  elseif $STREQ(Scalename'"minor_pentatonic") then
    iscale[] fillarray 0,3,5,7,10
    isize = 5
  elseif $STREQ(Scalename'"blues") then
    iscale[] fillarray 0,3,5,6,7,10
    isize = 6
  elseif $STREQ(Scalename'"whole") then
    iscale[] fillarray 0,2,4,6,8,10
    isize = 6
  elseif $STREQ(Scalename'"bartok") || $STREQ(Scalename'"hindu") then
    iscale[] fillarray 0,2,4,5,7,8,10
    isize = 7
  elseif $STREQ(Scalename'"chromatic") then
    iscale[] fillarray 0,1,2,3,4,5,6,7,8,9,10,11
    isize = 12
  elseif $STREQ(Scalename'"spanish") then
    iscale[] fillarray 0,1,4,5,7,8,10
    isize = 7
  elseif $STREQ(Scalename'"hungarian") || $STREQ(Scalename'"hungarian_minor") then
    iscale[] fillarray 0,2,3,6,7,8,11
    isize = 7
  elseif $STREQ(Scalename'"neapolitan") || $STREQ(Scalename'"neapolitan_minor") then
    iscale[] fillarray 0,1,3,5,7,8,11
    isize = 7
  elseif $STREQ(Scalename'"neapolitan_major") then
    iscale[] fillarray 0,1,3,5,7,9,11
    isize = 7
  endif
  xout iscale, isize
endop

#include "strchanged.udo"

opcode name2scale, k[]k, S
  Scalename xin
  kscale[] init 1
  ksize init 0
  if strchanged(Scalename) == 1 then
    printk 0, ksize
    reinit new
  endif
new:
  iscale[], isize name2scale Scalename
  kscale = iscale
  ksize = isize
  xout kscale, ksize
endop


#define NAME2SCALEUDO ##
#end
