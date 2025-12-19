#!/bin/bash

# Script to collect all coding productivity metrics with multimetric for the desired code.

# entries of the form benchmark-name:algo-name:short-form:type
entries=(
    "connected_components-seq:connected_components:cc:seq"   
    "connected_components-seq:connected_components:cc:par"      
    "connected_components-mpi:connected_components:cc:mpi"  
    "mergesort-seq:mergesort:ms:seq"
    "mergesort-par:mergesort:ms:par"
    "mergesort-mpi:mergesort:ms:mpi"     
    "pi_approx-seq:pi_approx:pi:seq"   
    "pi_approx-par:pi_approx:pi:par"   
    "pi_approx-mpi:pi_approx:pi:mpi"
    "nbody-seq:nbody:nb:seq"
    "nbody-par:nbody:nb:par"
    "nbody-mpi:nbody:nb:mpi"
)
langs=("py" "jl" "cpp" "daph")
indir="../../../benchmark_scripts"
outdir="../../metrics"

# clear output directory
rm "${outdir}"*.json 2>/dev/null

# activate conda env
ml Anaconda3/2023.07-2
source /<path-to-conda>/etc/profile.d/conda.sh
conda activate code-metrics
# change to multimetric folder
cd ./multimetric/multimetric

for entry in "${entries[@]}"; 
do
    IFS=':' read -r name algo short type <<< "$entry"

    for lang in "${langs[@]}"; 
    do

        infile="${indir}/${name}/${lang}/${algo}.${lang}"
        outfile="${outdir}/${short}_${lang}_${type}.json"

        if [[ -f "$infile" ]]; then
            echo "Analyzing: $infile -> ${outdir}/outfile"
            multimetric "$infile" > "$outfile"
        else
            echo "Skipping missing file: $infile"
        fi

  done
done