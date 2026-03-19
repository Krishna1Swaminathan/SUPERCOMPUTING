#!/bin/bash

module load Flye/gcc-11.4.1/2.9.6

mkdir -p ./assemblies/assembly_module

flye --nano-hq ./data/ont_reads.fastq.gz \
     --genome-size 170k \
     --meta \
     --threads 6 \
     --out-dir ./assemblies/assembly_module

cd ./assemblies/assembly_module
mv assembly.fasta module_assembly.fasta
mv flye.log module_flye.log
find . ! -name 'module_assembly.fasta' ! -name 'module_flye.log' -type f -delete
find . -mindepth 1 -type d -exec rm -rf {} +
