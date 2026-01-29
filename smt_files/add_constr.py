#!/usr/bin/env python3
"""
Append a fully-expanded finite-field range polynomial RC_(2^b) to one or more SMT2 files.

It generates, for N=2^b:

(define-fun RC_N ((x FF)) FF
  (ff.mul (ff.add x (ff.mul neg_one #f0mP))
    (ff.mul (ff.add x (ff.mul neg_one #f1mP))
      ...
        (ff.add x (ff.mul neg_one #f(N-1)mP))...)))

and then appends:
(assert (= (RC_N <target>) zero))

Example:
  python3 add_rc.py --bits 8 --target foutput smt_jolt/foo.smt2 smt_jolt/bar.smt2

Notes:
- This is HUGE for bits=16/32 (RC_65536 / RC_4294967296). It will generate gigantic text.
- For bits=32, you almost certainly don't want to actually emit all factors unless your goal is
  to stress/break things; it's terabytes of text.
"""

from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path
import argparse


@dataclass(frozen=True)
class FFSpec:
    sort_name: str = "FF"
    prime: str = "52435875175126190479447740508185965837690552500527637822603658699938581184513"
    neg_one_name: str = "neg_one"
    zero_name: str = "zero"  # or use "#f0m<prime>" if you prefer literal


def ff_lit(i: int, p: str) -> str:
    return f"#f{i}m{p}"


def rc_name(n: int) -> str:
    return f"RC_{n}"


def build_rc_define(n: int, spec: FFSpec) -> str:
    """
    Fully expanded right-associated multiplication chain:
      (ff.mul f0 (ff.mul f1 (... fn-1 ...)))
    where fi := (ff.add x (ff.mul neg_one #f{i}mP))
    """
    if n <= 0:
        raise ValueError("n must be positive")

    # Build from the end to avoid quadratic concatenation from deep nesting
    # We'll still end up with an enormous string, but this keeps it simple.
    factors = [
        f"(ff.add x (ff.mul {spec.neg_one_name} {ff_lit(i, spec.prime)}))"
        for i in range(n)
    ]

    body = factors[-1]
    for f in reversed(factors[:-1]):
        body = f"(ff.mul {f}\n  {body})"

    return (
        f"(define-fun {rc_name(n)} ((x {spec.sort_name})) {spec.sort_name}\n"
        f"  {body})\n"
    )


def build_assert(target_var: str, n: int, spec: FFSpec) -> str:
    return f"(assert (= ({rc_name(n)} {target_var}) {spec.zero_name}))\n"


def already_has_rc(text: str, n: int) -> bool:
    return f"(define-fun {rc_name(n)} " in text


def append_rc_to_file(path: Path, bits: int, target: str, spec: FFSpec, force: bool) -> None:
    n = 1 << bits

    text = path.read_text(errors="ignore")
    if (not force) and already_has_rc(text, n):
        print(f"[skip] {path} already has {rc_name(n)}")
        return

    rc_def = build_rc_define(n, spec)
    rc_assert = build_assert(target, n, spec)

    out = (
        "\n\n;; =====================\n"
        f";; Range check polynomial for {target} in [0, 2^{bits})\n"
        ";; =====================\n"
        + rc_def
        + "\n;; Usage:\n"
        + rc_assert
    )

    with path.open("a", encoding="utf-8") as f:
        f.write(out)

    print(f"[ok] appended {rc_name(n)} + assert to {path}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--bits", type=int, required=True, help="bitwidth b (generates N=2^b factors)")
    ap.add_argument("--target", type=str, default="foutput", help="FF var to constrain, e.g. foutput")
    ap.add_argument("--prime", type=str, default=FFSpec.prime, help="field modulus P")
    ap.add_argument("--sort", type=str, default="FF", help="field sort name in SMT2, e.g. FF")
    ap.add_argument("--neg-one", type=str, default="neg_one", help="name of FF constant -1")
    ap.add_argument("--zero", type=str, default="zero", help="name of FF constant 0")
    ap.add_argument("--force", action="store_true", help="append even if RC_N already present")
    ap.add_argument("files", nargs="+", help="one or more .smt2 files")
    args = ap.parse_args()

    if args.bits < 1:
        raise SystemExit("--bits must be >= 1")

    spec = FFSpec(
        sort_name=args.sort,
        prime=args.prime,
        neg_one_name=args.neg_one,
        zero_name=args.zero,
    )

    for fp in args.files:
        append_rc_to_file(Path(fp), args.bits, args.target, spec, args.force)


if __name__ == "__main__":
    main()


