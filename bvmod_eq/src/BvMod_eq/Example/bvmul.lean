import BvMod_eq.solve_mle

abbrev ff := 2435875175126190479447740508185965837690552500527637822603658699938581184513
abbrev f := ZMod ff

variable (fresh_pf0_sum_bit0 : f)
variable (fresh_pf0_sum_bit1 : f)
variable (fresh_pf0_sum_bit2 : f)
variable (fresh_pf0_sum_bit3 : f)
variable (a : BitVec 2)
variable (b : BitVec 2)



instance : Fact (Nat.Prime ff) := by sorry

instance NotTwo: BvMod_eq.GtTwo (ff) := by
  have hlt: 2 < ff := by decide
  sorry


lemma square_eq_one_zero (x : f) : x * x = x <-> ( x.val <= 1)  /\ (((  x.val : BitVec 4)= 0#4 ) \/ ((x.val : BitVec 4) =1) ):= by
sorry

def bool_to_bv (w: ℕ) (b: Bool) : (BitVec w) := if b == true then 1 else 0

lemma BitVec_ofNat_eq_iff {x y : ℕ} (w) (hx : x < 2^w) (hy : y < 2^w) :
  (x = y) <-> (BitVec.ofNat w x = BitVec.ofNat w y) := by
  constructor
  intro h
  rw [h]
  intro h
  unfold BitVec.ofNat at h
  unfold Fin.ofNat at h
  have h' := congrArg (fun x => x.toFin.val) h
  simp at h
  apply Nat.mod_eq_of_modEq at h'
  have hxy : x % 2^w = y := h' hy
  rw [Nat.mod_eq_of_lt] at hxy
  apply hxy
  apply hx
-- lemma BitVec_ofNat_eq_iff {w} {x y : ℕ} [NeZero w]:
--   (x = y) <-> (BitVec.ofNat w x = BitVec.ofNat w y) := by
--   intro h
--   rw [h]



def BvMod_eq.bv_to_f  (a: BitVec  2) : (f) :=
  ((a.toNat): f)

lemma bvmul_2:

 (   ( fresh_pf0_sum_bit0  *fresh_pf0_sum_bit0) = fresh_pf0_sum_bit0) ->
      ( fresh_pf1_sum_bit1 * fresh_pf1_sum_bit1) = fresh_pf1_sum_bit1 ->
     ( ( fresh_pf2_sum_bit2 * fresh_pf2_sum_bit2)  = fresh_pf2_sum_bit2) ->
     ( ( fresh_pf3_sum_bit3 * fresh_pf3_sum_bit3) = fresh_pf3_sum_bit3) ->

     (
       ( 1 * fresh_pf0_sum_bit0) +
       ( 2 * fresh_pf1_sum_bit1) +
       ( 4  *fresh_pf2_sum_bit2) +
       ( 8 * fresh_pf3_sum_bit3) =
       ( (BvMod_eq.bv_to_f a) * BvMod_eq.bv_to_f b )) ->
      (a.toNat <= 3) ->
     (b.toNat <= 3)
    ->
     (bool_to_bv 4  ((a * b)[0]) =
      (BitVec.ofNat 4 (fresh_pf0_sum_bit0.val)) ) := by
      intro h1 h2 h3 h4 h5 h6 h7
      rw [square_eq_one_zero] at h1 h2 h3 h4
      rcases h1 with ⟨h1_1, h1_2⟩
      rcases h2 with ⟨h2_1, h2_2⟩
      rcases h3 with ⟨h3_1, h3_2⟩
      rcases h4 with ⟨h4_1, h4_2⟩
      unfold BvMod_eq.bv_to_f at h5
      rw [BvMod_eq.ZMod.eq_if_val] at h5
      valify [h1_1, h2_1, h3_1, h4_1] at h5
      simp at h5
      rw [Nat.mod_eq_of_lt] at h5
      rw [Nat.mod_eq_of_lt] at h5
      rw [ BitVec_ofNat_eq_iff 4] at h5
      bvify [h1_1, h2_1, h3_1, h4_1] at h5
      simp at h5
      unfold bool_to_bv
      bv_normalize
      bv_decide
      try_apply_lemma_hyps [h1_1, h2_1, h3_1, h4_1, h6, h7]
      apply h6
      apply h7
      norm_num
      apply h6
      apply h7
      norm_num

def x := 3#2
def y := 1#2

#eval (x*y)[0]
#eval (x*y)[1]
