/*
  talternate - Alternate two values, on trigger
*/


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


;; TODO: talternate test
;; TODO: talternate to readme
;; TODO: ifndef