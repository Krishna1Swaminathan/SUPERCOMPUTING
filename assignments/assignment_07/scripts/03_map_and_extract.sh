#!/bin/bash

for fwd in "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean"/*_1.clean.fastq; do
    base=$(basename "$fwd" _1.clean.fastq)
    rev="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/clean/${base}_2.clean.fastq"
    bam="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/mapped/${base}.bam"
    hits="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/hits/${base}.hits.bam"

    bbmap.sh \
        -Xmx16g \
        ref="/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/reference/dog_genome.fna" \
        in1="$fwd" \
        in2="$rev" \
        out="$bam" \
        minid=0.95 \
        threads=8 \
        nodisk

    samtools view -F 4 -b "$bam" -o "$hits"
done
