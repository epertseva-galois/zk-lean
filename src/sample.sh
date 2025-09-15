#!/usr/bin/env bash

# Usage: ./sample_files.sh dir1 dir2

if [ $# -ne 2 ]; then
  echo "Usage: $0 <dir1> <dir2>"
  exit 1
fi

dir1=$1
dir2=$2

# Directory to copy sampled files into
outdir="sampled"
mkdir -p "$outdir"

# Sample 10 files and copy them
find "$dir1" "$dir2" -type f | shuf | head -n 10 | while read -r file; do
  cp "$file" "$outdir"/
done

echo "Copied 10 random files into $outdir/"