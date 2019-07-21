/*
  talternate - Alternate two values, on trigger
*/


#ifndef TALTERNATEUDO


opcode talternate, k, kkkkkP
  ktrig, ka, kb, kmod, kthres, kdiv xin
  kcount init -1
  kcount += ktrig
  if int(kcount/kdiv)%kmod < kthres then
    kout = ka
  else
    kout = kb
  endif
  xout kout
endop


#define TALTERNATEUDO ##
#end

;; TODO: talternate test
;; TODO: talternate to readme

