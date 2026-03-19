#!/bin/bash

module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

#Trying to fix some permission issues
export CONDA_PKGS_DIRS="$HOME/.conda/pkgs"
mkdir -p "$HOME/.conda/pkgs"

mamba create -n flye-env -c bioconda flye=2.9.6 -y

conda activate flye-env

flye -v

conda env export --no-builds > ./flye-env.yml

conda deactivate
