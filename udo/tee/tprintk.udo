/*
  tprintk   - Print a k-rate value on trigger
*/


opcode tprintk, 0, kk
  ktrig, kvalue xin
  if ktrig == 1 then
    printk 0, kvalue
  endif
endop


;; TODO: tprintk incorporate more parameters from printk
;; TODO: ifndef