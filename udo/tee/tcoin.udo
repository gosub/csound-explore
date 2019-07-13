/*
  tcoin     - Flip a coin on trigger
*/

#include "tchoice.udo"


opcode tcoin, k, k
  ktrig xin
  kcoin[] fillarray 0,1
  kout tchoice ktrig, kcoin
  xout kout
endop


;; TODO: ifndef