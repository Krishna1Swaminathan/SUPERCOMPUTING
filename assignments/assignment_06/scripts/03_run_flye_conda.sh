#!/bin/bash

module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

export CONDA_PKGS_DIRS="$HOME/.conda/pkgs"
export CONDA_ENVS_DIRS="$HOME/.conda/envs"

conda activate flye-env

mkdir -p ./assemblies/assembly_conda

flye --nano-hq ./data/ont_reads.fastq.gz \
     --genome-size 170k \
     --meta \
     --threads 6 \
     --out-dir ./assemblies/assembly_conda

# Clean up — keep only assembly and log
cd ./assemblies/assembly_conda
mv assembly.fasta conda_assembly.fasta
mv flye.log conda_flye.log
find . ! -name 'conda_assembly.fasta' ! -name 'conda_flye.log' -type f -delete
find . -mindepth 1 -type d -exec rm -rf {} +

conda deactivate
