/*
  tcoin     - Flip a coin on trigger
*/


opcode tcoin, k, k
  ktrig xin
  kcoin[] fillarray 0,1
  kout tchoice ktrig, kcoin
  xout kout
endop


;; TODO: import tchoice
;; TODO: ifndef