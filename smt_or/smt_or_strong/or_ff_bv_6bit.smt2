(set-logic ALL)
(set-option :produce-models true)
(define-sort FF () (_ FiniteField 52435875175126190479447740508185965837690552500527637822603658699938581184513))
(declare-fun one () FF)
(declare-fun zero () FF)
(declare-fun neg_one () FF)
(assert (= one #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513))
(assert (= zero #f0m52435875175126190479447740508185965837690552500527637822603658699938581184513))
(assert (= neg_one #f52435875175126190479447740508185965837690552500527637822603658699938581184512m52435875175126190479447740508185965837690552500527637822603658699938581184513))

(declare-fun bv1 () (_ BitVec 6))
(declare-fun bv2 () (_ BitVec 6))
(declare-fun bvoutput () (_ BitVec 6))

(declare-fun v0 () FF)
(declare-fun v1 () FF)
(declare-fun v2 () FF)
(declare-fun v3 () FF)
(declare-fun v4 () FF)
(declare-fun v5 () FF)
(declare-fun v6 () FF)
(declare-fun v7 () FF)
(declare-fun v8 () FF)
(declare-fun v9 () FF)
(declare-fun v10 () FF)
(declare-fun v11 () FF)

(declare-fun foutput () FF)

;; BV → FF wiring (from hypotheses)
(assert (= v0 (ite (= ((_ extract 5 5) bv1) #b1) one zero)))
(assert (= v1 (ite (= ((_ extract 4 4) bv1) #b1) one zero)))
(assert (= v2 (ite (= ((_ extract 3 3) bv1) #b1) one zero)))
(assert (= v3 (ite (= ((_ extract 2 2) bv1) #b1) one zero)))
(assert (= v4 (ite (= ((_ extract 1 1) bv1) #b1) one zero)))
(assert (= v5 (ite (= ((_ extract 0 0) bv1) #b1) one zero)))
(assert (= v6 (ite (= ((_ extract 5 5) bv2) #b1) one zero)))
(assert (= v7 (ite (= ((_ extract 4 4) bv2) #b1) one zero)))
(assert (= v8 (ite (= ((_ extract 3 3) bv2) #b1) one zero)))
(assert (= v9 (ite (= ((_ extract 2 2) bv2) #b1) one zero)))
(assert (= v10 (ite (= ((_ extract 1 1) bv2) #b1) one zero)))
(assert (= v11 (ite (= ((_ extract 0 0) bv2) #b1) one zero)))

;; bitness constraints for all v[i]
(assert (= v0 (ff.mul v0 v0)))
(assert (= v1 (ff.mul v1 v1)))
(assert (= v2 (ff.mul v2 v2)))
(assert (= v3 (ff.mul v3 v3)))
(assert (= v4 (ff.mul v4 v4)))
(assert (= v5 (ff.mul v5 v5)))
(assert (= v6 (ff.mul v6 v6)))
(assert (= v7 (ff.mul v7 v7)))
(assert (= v8 (ff.mul v8 v8)))
(assert (= v9 (ff.mul v9 v9)))
(assert (= v10 (ff.mul v10 v10)))
(assert (= v11 (ff.mul v11 v11)))

(define-fun OR_12_FF ((v11 FF) (v10 FF) (v9 FF) (v8 FF) (v7 FF) (v6 FF) (v5 FF) (v4 FF) (v3 FF) (v2 FF) (v1 FF) (v0 FF)) FF
  (ff.add (ff.add (ff.add (ff.add (ff.add (ff.add #f0m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.mul #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v5 v11) (ff.mul neg_one (ff.mul v5 v11))))) (ff.mul #f2m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v4 v10) (ff.mul neg_one (ff.mul v4 v10))))) (ff.mul #f4m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v3 v9) (ff.mul neg_one (ff.mul v3 v9))))) (ff.mul #f8m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v2 v8) (ff.mul neg_one (ff.mul v2 v8))))) (ff.mul #f16m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v1 v7) (ff.mul neg_one (ff.mul v1 v7))))) (ff.mul #f32m52435875175126190479447740508185965837690552500527637822603658699938581184513 (ff.add (ff.add v0 v6) (ff.mul neg_one (ff.mul v0 v6)))))
)

(assert (= foutput (OR_12_FF v11 v10 v9 v8 v7 v6 v5 v4 v3 v2 v1 v0)))

;; bvoutput = (bvor bv1 bv2)
(assert
  (= bvoutput
     (bvor bv1 bv2)))
;; TODO(BV-ENCODING):

(declare-fun out0 () FF)
(declare-fun out1 () FF)
(declare-fun out2 () FF)
(declare-fun out3 () FF)
(declare-fun out4 () FF)
(declare-fun out5 () FF)

;; output bits from bvoutput
(assert (= out0 (ite (= ((_ extract 5 5) bvoutput) #b1) one zero)))
(assert (= out1 (ite (= ((_ extract 4 4) bvoutput) #b1) one zero)))
(assert (= out2 (ite (= ((_ extract 3 3) bvoutput) #b1) one zero)))
(assert (= out3 (ite (= ((_ extract 2 2) bvoutput) #b1) one zero)))
(assert (= out4 (ite (= ((_ extract 1 1) bvoutput) #b1) one zero)))
(assert (= out5 (ite (= ((_ extract 0 0) bvoutput) #b1) one zero)))

;; bitness for output bits
(assert (= out0 (ff.mul out0 out0)))
(assert (= out1 (ff.mul out1 out1)))
(assert (= out2 (ff.mul out2 out2)))
(assert (= out3 (ff.mul out3 out3)))
(assert (= out4 (ff.mul out4 out4)))
(assert (= out5 (ff.mul out5 out5)))

;; negated bit-decomposition link (same pattern as your OR file)
(assert (not (= foutput (ff.add (ff.add (ff.add (ff.add (ff.add (ff.mul #f32m52435875175126190479447740508185965837690552500527637822603658699938581184513 out0) (ff.mul #f16m52435875175126190479447740508185965837690552500527637822603658699938581184513 out1)) (ff.mul #f8m52435875175126190479447740508185965837690552500527637822603658699938581184513 out2)) (ff.mul #f4m52435875175126190479447740508185965837690552500527637822603658699938581184513 out3)) (ff.mul #f2m52435875175126190479447740508185965837690552500527637822603658699938581184513 out4)) (ff.mul #f1m52435875175126190479447740508185965837690552500527637822603658699938581184513 out5)))))

(check-sat)
