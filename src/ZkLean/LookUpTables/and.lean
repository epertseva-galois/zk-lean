import ZkLean.Formalism
import ZkLean.solve_mle


set_option maxHeartbeats  20000000000000000000

def AND_16 [Field f] : Subtable f 16 :=
  subtableFromMLE (fun x => 0 + 1*x[7]*x[15] + 2*x[6]*x[14] + 4*x[5]*x[13] + 8*x[4]*x[12] + 16*x[3]*x[11] + 32*x[2]*x[10] + 64*x[1]*x[9] + 128*x[0]*x[8])

open Lean Meta Elab Tactic

/-- `findMod` optionally binds the found composite term:
`findMod` or `findModLT => name`. -/
-- syntax (name := findModLT) "findModLT " num : tactic

-- @[tactic findModLT] def evalfindModLT : Tactic := fun stx => do
--   let g ← getMainGoal
--   let ty ← instantiateMVars (← g.getType)
--   let (fn, args) := ty.getAppFnArgs
--    let some n := stx[1].isNatLit?
--     | throwError "usage: findModLT <n> (natural number)"
--   match fn with
--     | ``Iff =>
--         let (fn2, args2) := args[args.size -1]!.getAppFnArgs
--         match fn2 with
--         | ``Eq =>
--            let (fn3, args3) := args2[args2.size -1]!.getAppFnArgs
--            match fn3 with
--            | ``HMod.hMod =>
--                 let lhs := args3[args3.size - 2]!    -- adjust if your indexing changes
--         -- build 2 ^ n as a Nat expression
--                 let twoPowN : Expr := mkApp2 (mkConst ``Nat.pow) (mkNatLit 2) (mkNatLit n)
--                 let prop ← mkAppM ``LT.lt #[lhs, twoPowN]
--                 let pr ← g.withContext do mkFreshExprMVar prop
--                 let gWithHyp  ← g.assert `Leq prop pr
--                 --let hyp ← g.withContext do pr.mvarId!.assert `Leq prop pr
--                 -- let gWithHyp ←  g.assert `Leq prop pr
--                 setGoals [pr.mvarId!, gWithHyp]
--            | _ => pure ()
--         | _ => pure ()
--     | _ => pure ()



lemma and_mle_one_chunk[ZKField f] (bv1 bv2 : BitVec 8) (fv1 fv2 : Vector f 8) :
  some bvoutput = map_f_to_bv_8 foutput ->
   some (bool_to_bv bv1[7])  = map_f_to_bv_8 fv1[0]  ->
   some (bool_to_bv bv1[6]) = map_f_to_bv_8 fv1[1]  ->
   some (bool_to_bv bv1[5]) = map_f_to_bv_8 fv1[2]  ->
   some (bool_to_bv bv1[4]) = map_f_to_bv_8 fv1[3]  ->
   some (bool_to_bv bv1[3]) = map_f_to_bv_8 fv1[4]  ->
  some (bool_to_bv bv1[2]) = map_f_to_bv_8 fv1[5]  ->
   some (bool_to_bv bv1[1]) = map_f_to_bv_8 fv1[6]  ->
   some (bool_to_bv bv1[0]) = map_f_to_bv_8 fv1[7]  ->
  some (bool_to_bv bv2[7]) = map_f_to_bv_8 fv2[0]  ->
  some (bool_to_bv bv2[6]) = map_f_to_bv_8 fv2[1]  ->
  some (bool_to_bv bv2[5]) = map_f_to_bv_8 fv2[2]  ->
  some (bool_to_bv bv2[4]) = map_f_to_bv_8 fv2[3]  ->
  some (bool_to_bv bv2[3]) = map_f_to_bv_8 fv2[4]  ->
  some (bool_to_bv bv2[2]) = map_f_to_bv_8 fv2[5]  ->
  some (bool_to_bv bv2[1]) = map_f_to_bv_8 fv2[6]  ->
  some (bool_to_bv bv2[0]) = map_f_to_bv_8 fv2[7]  ->
  (bvoutput = bv1 &&& bv2)
  =
  (foutput = evalSubtable AND_16 (Vector.append fv1 fv2))
 := by
  solveMLE AND_16 8
