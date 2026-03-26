#!/bin/bash

for fwd in "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/raw"/*_1.fastq; do
    base=$(basename "$fwd" _1.fastq)
    rev="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/raw/${base}_2.fastq"
    out1="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean/${base}_1.clean.fastq"
    out2="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean/${base}_2.clean.fastq"

    fastp \
        --in1 "$fwd" \
        --in2 "$rev" \
        --out1 "$out1" \
        --out2 "$out2" \
        --thread 8 \
        --detect_adapter_for_pe \
        --qualified_quality_phred 20 \
        --length_required 50 \
        --json "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean/${base}_fastp.json" \
        --html "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean/${base}_fastp.html"
done
