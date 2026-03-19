#!/bin/bash
export PATH="$HOME/programs/Flye/bin:$PATH"

mkdir -p ./assemblies/assembly_local

flye --nano-hq ./data/ont_reads.fastq.gz \
     --genome-size 170k \
     --meta \
     --threads 6 \
     --out-dir ./assemblies/assembly_local

cd ./assemblies/assembly_local
mv assembly.fasta local_assembly.fasta
mv flye.log local_flye.log
find . ! -name 'local_assembly.fasta' ! -name 'local_flye.log' -type f -delete
find . -mindepth 1 -type d -exec rm -rf {} +
