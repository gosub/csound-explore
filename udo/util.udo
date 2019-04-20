/*
  once - true only once, at k-rate
*/

;; TODO: arrayshuffle
;; TODO: arrayreverse
;; TODO: randint
;; TODO: add "once" to readme


opcode once, k, 0
  kcount init 2
  if kcount > 0 then
    kcount -= 1
  endif
  xout kcount
endop
