To start I went to the assignment_06 folder and mkdir data as well as mkdir scripts

cd scripts
nano scripts/01_download_data.sh

#!/bin/bash

mkdir -p ./data
cd ./data

wget -O ont_reads.fastq.gz https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

cd ..


That is what i put in the script it makes a data folder incase it hasnt been made then goes into it wget the dataset and names it then cd out of the data folder

Then if you go back to the base folder and run bash scripts/01_download_data.sh it should download the dataset correctly into the data folder

##then for step 3

nano scripts/02_flye_2.9.6_manual_build.sh

#!/bin/bash

mkdir ~/programs
cd ~/programs
# clone Flye
git clone https://github.com/fenderglass/Flye

cd Flye

make
export PATH=$HOME/programs/Flye/bin:$PATH

# check version
flye -v


then i ran bash scripts/02_flye_2.9.6_manual_build.sh to run and test it

later i think it will be part of a pipeline so it wont be neded to manually run it

echo 'export PATH="$HOME/programs/Flye/bin:$PATH"' >> ~/.bashrc
adding this will append it to the bashrc

##part 4

nano scripts/02_flye_2.9.6_conda_install.sh

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


##part 6

nano scripts/03_run_flye_conda.sh

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

# Clean up and remove everything unessacary
cd ./assemblies/assembly_conda
mv assembly.fasta conda_assembly.fasta
mv flye.log conda_flye.log
find . ! -name 'conda_assembly.fasta' ! -name 'conda_flye.log' -type f -delete
find . -mindepth 1 -type d -exec rm -rf {} +

conda deactivate


then use bash scripts/03_run_flye_conda.sh to run it
check to make sure that same 2 contigs, same total length, same coverage

#part B
use the HPC module env


nano scripts/03_run_flye_module.sh

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


then use bash scripts/03_run_flye_module.sh to run it
check that the output matches part A

#part c

nano scripts/03_run_flye_local.sh

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

then again run bash scripts/03_run_flye_local.sh to get the output

##part 7
now we compare the last 10 lines of each log

tail -10 ./assemblies/assembly_conda/conda_flye.log
tail -10 ./assemblies/assembly_module/module_flye.log
tail -10 ./assemblies/assembly_local/local_flye.log

this is what we get

tail -10 ./assemblies/assembly_module/module_flye.log
tail -10 ./assemblies/assembly_local/local_flye.log
[2026-03-19 01:33:45] root: INFO: Assembly statistics:

	Total length:	91713
	Fragments:	2
	Fragments N50:	47428
	Largest frg:	47428
	Scaffolds:	0
	Mean coverage:	422

[2026-03-19 01:33:45] root: INFO: Final assembly: /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_conda/assembly.fasta
[2026-03-19 01:38:18] root: INFO: Assembly statistics:

	Total length:	91713
	Fragments:	2
	Fragments N50:	47428
	Largest frg:	47428
	Scaffolds:	0
	Mean coverage:	422

[2026-03-19 01:38:18] root: INFO: Final assembly: /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_module/assembly.fasta
[2026-03-19 01:42:25] root: INFO: Assembly statistics:

	Total length:	91713
	Fragments:	2
	Fragments N50:	47428
	Largest frg:	47428
	Scaffolds:	0
	Mean coverage:	422

[2026-03-19 01:42:25] root: INFO: Final assembly: /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_local/assembly.fasta

this shows identical results which proves the reproduceability

Build pipeline

nano pipeline.sh

#!/bin/bash

echo "Downloading data"
bash scripts/01_download_data.sh

echo "Building Flye locally"
bash scripts/flye_2.9.6_manual_build.sh

echo "Installing Flye via conda"
bash scripts/flye_2.9.6_conda_install.sh

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

##Part 9
I need to undo everything so delete all data and conda ect.


rm -rf ./data ./assemblies ~/programs/Flye

conda remove -n flye-env --all -y


now run bash pipeline.sh and everything should run perfectly


##Documentation


The goal of the assignment was to run data in 3 different ways using a tool called Flye. The goal was to use different ways of installing and running software on an HPC.


`scripts/01_download_data.sh` — downloads the ONT fastq data to ./data/
`scripts/02_flye_2.9.6_manual_build.sh` — clones and builds Flye locally under ~/programs/
`scripts/02_flye_2.9.6_conda_install.sh` — creates a conda environment called flye-env with Flye v2.9.6 and exports it to flye-env.yml
`scripts/03_run_flye_conda.sh` — runs the assembly using the conda environment
`scripts/03_run_flye_module.sh` — runs the assembly using the HPC module
`scripts/03_run_flye_local.sh` — runs the assembly using the local manual build
`pipeline.sh` — runs everything in order automatically

To run it you just need to be in assignment_06 and type bash pipeline.sh

Here are the flye arguments correctly

`--nano-hq` because the data is high quality Nanopore
`--genome-size 170k` based on typical Coliphage genome sizes
`--meta` because there turned out to be more than one phage in the dataset
`--threads 6` to be a good citizen on the login node

All three methods produced identical results
2 contigs (2 different phages in the data)
Total length: 91,713 bp
Mean coverage: 422x



I had a lot of conda issues and random errors about version types. It also makes it harder on an HPC because you are limited by the permission you have. It was cool to troubleshoot the small errors but overall seeing how you could go about getting the same result from 3 different methods was pretty cool to see. I liked the module method the most probably because it is so accessible to use the next time around as well it just seems the simplest. 

