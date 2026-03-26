#!/bin/bash
#SBATCH --job-name=finish_pipeline
#SBATCH --output=/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/output/%j.out
#SBATCH --error=/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/output/%j.err
#SBATCH --time=1:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ksswaminathan@wm.edu

source ~/.bashrc
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/sratoolkit.3.2.0-centos_linux64/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/samtools/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/bbmap
export PATH=$PATH:/sciclone/home/ksswaminathan/programs

bash /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/scripts/02_clean.sh
bash /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/scripts/03_map_and_extract.sh
