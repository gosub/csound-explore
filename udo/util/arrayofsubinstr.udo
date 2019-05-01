/*
  arrayofsubinstr - instantiate n subinstruments in an array
*/


#ifndef ARRAYOFSUBINSTRUDO


opcode arrayofsubinstr, a[], a[]iio
  audioarr[], index, instrnum, iparam xin
  ilen lenarray audioarr
  if index < ilen then
    audioarr arrayofsubinstr audioarr, index+1, instrnum, iparam
    audioarr[index] subinstr instrnum, index, ilen-1, iparam
  endif
  xout audioarr
endop


opcode arrayofsubinstr, a[], a[]iSo
  audioarr[], index, Sinstrname, iparam xin
  instrnum nstrnum Sinstrname
  audioarr arrayofsubinstr audioarr, index, instrnum, iparam
  xout audioarr
endop


#define ARRAYOFSUBINSTRUDO ##
#end
