#!/bin/bash

echo "Downloading data"
bash scripts/01_download_data.sh

echo "Building Flye locally"
bash scripts/02_flye_2.9.6_manual_build.sh

echo "Installing Flye via conda"
bash scripts/02_flye_2.9.6_conda_install.sh
echo "Running Flye with conda"
bash scripts/03_run_flye_conda.sh

echo "Running Flye with module"
bash scripts/03_run_flye_module.sh

echo "Running Flye with local build"
bash scripts/03_run_flye_local.sh

echo "Comparing last 10 lines of each log"
tail -10 ./assemblies/assembly_conda/conda_flye.log
tail -10 ./assemblies/assembly_module/module_flye.log
tail -10 ./assemblies/assembly_local/local_flye.log

echo "Pipeline complete"
