#!/bin/bash
set -euo pipefail

fasta="$1" #stores the input

num=$(grep -c "^>" "$fasta") #Total number of sequences
total=$(grep -v "^>" "$fasta" | tr -d '\n' | wc -c) #Total number of nucleotides

seqtk comp "$fasta" | awk '{print $1 "\t" $2}' #Makes the table of names	and length

echo "Total sequences: $num"
echo "Total nucleotides: $total"
