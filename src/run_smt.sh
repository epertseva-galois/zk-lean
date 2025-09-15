#!/usr/bin/env bash

# --- Config ---
CVC5=../../../../ZKLean/zk-lean/cvc5/build/bin/cvc5
INDIR="./sampled"
OUTCSV="smt_results.csv"

# --- Tooling checks (macOS needs GNU tools) ---
TIME_BIN="${TIME_BIN:-gtime}"
TIMEOUT_BIN="${TIMEOUT_BIN:-gtimeout}"

if ! command -v "$TIME_BIN" >/dev/null 2>&1; then
  echo "Error: $TIME_BIN not found. Install with: brew install gnu-time" >&2
  exit 1
fi
if ! command -v "$TIMEOUT_BIN" >/dev/null 2>&1; then
  echo "Error: $TIMEOUT_BIN not found. Install with: brew install coreutils" >&2
  exit 1
fi
if [ ! -x "$CVC5" ]; then
  echo "Error: cvc5 not found/executable at: $CVC5" >&2
  exit 1
fi
if [ ! -d "$INDIR" ]; then
  echo "Error: input directory not found: $INDIR" >&2
  exit 1
fi

# --- Collect files ---
files=("$INDIR"/*)
total=${#files[@]}
if [ $total -eq 0 ]; then
  echo "No files found in $INDIR" >&2
  exit 1
fi

# --- Init CSV ---
echo "file,result,exit_code,time_seconds" > "$OUTCSV"

# --- Process each file ---
count=0
for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  count=$((count + 1))

  echo "[${count}/${total}] Running on $f..."

  tmpout="$(mktemp)"
  tmperr="$(mktemp)"
  tmptime="$(mktemp)"

  # Run: measure wall time (%e), timeout after 300s
  "$TIME_BIN" -f "%e" -o "$tmptime" "$TIMEOUT_BIN" 180s "$CVC5" "$f" >"$tmpout" 2>"$tmperr"
  exit_code=$?

  solver_out="$(head -n 1 "$tmpout" | tr -d '\r' | tr -d '\n')"
  if [ $exit_code -eq 0 ]; then
    if [ -n "$solver_out" ]; then
      result="$solver_out"
    else
      result="success"
    fi
  else
    if [ $exit_code -eq 124 ]; then
      result="timeout"
    else
      if [ -n "$solver_out" ]; then
        result="$solver_out"
      else
        result="error"
      fi
    fi
  fi

  time_seconds="$(cat "$tmptime" 2>/dev/null || true)"

  printf '"%s",%s,%d,%s\n' "$f" "$result" "$exit_code" "${time_seconds:-}" >> "$OUTCSV"

  echo "    → result: $result, time: ${time_seconds:-N/A}, exit_code: $exit_code"

  rm -f "$tmpout" "$tmperr" "$tmptime"
done

echo "All done! Results written to $OUTCSV"
