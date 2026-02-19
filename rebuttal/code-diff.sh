#!/bin/bash

B=../benchmark_scripts
OUT=diff_results.txt

rm -f "$OUT"

{
for alg in connected_components mergesort nbody pi_approx; do
  for lang in cpp daph jl py; do
    seq="$B/${alg}-seq/$lang/${alg}.${lang}"
    for v in par mpi; do
      oth="$B/${alg}-${v}/$lang/${alg}.${lang}"
      echo "=== $alg | $lang | seq vs $v ==="

      if [[ -e "$seq" && -e "$oth" ]]; then
        git diff --no-index --numstat "$seq" "$oth"
        rc=$?
        # rc=0: no diff, rc=1: diff found (normal), rc>1: real error
        if (( rc > 1 )); then
          echo "ERROR(rc=$rc): git diff failed: $seq vs $oth"
        fi
      else
        echo "MISSING: $seq or $oth"
      fi

      echo
    done
  done
done
} | tee -a "$OUT"
