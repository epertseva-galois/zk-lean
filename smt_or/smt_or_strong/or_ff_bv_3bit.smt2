(set-logic ALL)
(set-option :produce-models true)
(define-sort FF () (_ FiniteField 52435875175126190479447740508185965837690552500527637822603658699938581184513))
(declare-fun one () FF)
(declare-fun zero () FF)
(declare-fun neg_one () FF)
(assert (= one #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513))
(assert (= zero #f0m52435875175126190479447740508185965837690552500527637822603658699938581184513))
(assert (= neg_one #f52435875175126190479447740508185965837690552500527637822603658699938581184512m52435875175126190479447740508185965837690552500527637822603658699938581184513))

(declare-fun bv1 () (_ BitVec 3))
(declare-fun bv2 () (_ BitVec 3))
(declare-fun bvoutput () (_ BitVec 3))

(declare-fun v0 () FF)
(declare-fun v1 () FF)
(declare-fun v2 () FF)
(declare-fun v3 () FF)
(declare-fun v4 () FF)
(declare-fun v5 () FF)

(declare-fun foutput () FF)

;; BV → FF wiring (from hypotheses)
(assert (= v0 (ite (= ((_ extract 2 2) bv1) #b1) one zero)))
(assert (= v1 (ite (= ((_ extract 1 1) bv1) #b1) one zero)))
(assert (= v2 (ite (= ((_ extract 0 0) bv1) #b1) one zero)))
(assert (= v3 (ite (= ((_ extract 2 2) bv2) #b1) one zero)))
(assert (= v4 (ite (= ((_ extract 1 1) bv2) #b1) one zero)))
(assert (= v5 (ite (= ((_ extract 0 0) bv2) #b1) one zero)))

;; bitness constraints for all v[i]
(assert (= v0 (ff.mul v0 v0)))
(assert (= v1 (ff.mul v1 v1)))
(assert (= v2 (ff.mul v2 v2)))
(assert (= v3 (ff.mul v3 v3)))
(assert (= v4 (ff.mul v4 v4)))
(assert (= v5 (ff.mul v5 v5)))

(define-fun OR_6_FF ((v5 FF) (v4 FF) (v3 FF) (v2 FF) (v1 FF) (v0 FF)) FF
  (ff.add (ff.add (ff.add #f0m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.mul #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v2 v5) (ff.mul neg_one (ff.mul v2 v5))))) (ff.mul #f2m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v1 v4) (ff.mul neg_one (ff.mul v1 v4))))) (ff.mul #f4m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v0 v3) (ff.mul neg_one (ff.mul v0 v3)))))
)

(assert (= foutput (OR_6_FF v5 v4 v3 v2 v1 v0)))

;; bvoutput = (bvor bv1 bv2)
(assert
  (= bvoutput
     (bvor bv1 bv2)))
;; TODO(BV-ENCODING):

(declare-fun out0 () FF)
(declare-fun out1 () FF)
(declare-fun out2 () FF)

;; output bits from bvoutput
(assert (= out0 (ite (= ((_ extract 2 2) bvoutput) #b1) one zero)))
(assert (= out1 (ite (= ((_ extract 1 1) bvoutput) #b1) one zero)))
(assert (= out2 (ite (= ((_ extract 0 0) bvoutput) #b1) one zero)))

;; bitness for output bits
(assert (= out0 (ff.mul out0 out0)))
(assert (= out1 (ff.mul out1 out1)))
(assert (= out2 (ff.mul out2 out2)))

;; negated bit-decomposition link (same pattern as your OR file)
(assert (not (= foutput (ff.add (ff.add (ff.mul #f4m52435875175126190479447740508185965837690552500527637822603658699938581184513 out0) (ff.mul #f2m52435875175126190479447740508185965837690552500527637822603658699938581184513 out1)) (ff.mul #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513 out2)))))

(check-sat)
