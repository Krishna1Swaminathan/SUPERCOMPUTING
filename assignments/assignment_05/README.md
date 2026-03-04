I did touch pipeline.sh
mdkir scripts
mkdir data

then cd data
mkdir raw
mkdir trimmed


then go back to the assignment_05 folder
cd scripts
cd log

nano 01_download_data.sh

#!/bin/bash
set -euo pipefail

URL="https://gzahn.github.io/data/fastq_examples.tar"
TARBALL="fastq_examples.tar"

wget -O $TARBALL $URL
tar -xvf $TARBALL
mv *.fastq.gz data/raw/
rm $TARBALL

chmod +x 01_download_data.sh

then go to the asisgnment 5 area and you can run it
./scripts/01_download_data.sh 
this will return the fastq.gz files


then 
cd ~/programs

wget http://opengene.org/fastp/fastp
chmod a+x ./fastp

this is to download fastp according to the github

I tried to install using sudo because thats the first thing that was showing on github and i got an error message. It was saying I am not in the sudoers file and that the incedient will be reported. I hope I havent done anything too wrong.

go to ~/.bashrc
then put this in .bashrc
export PATH=$HOME/programs:$PATH

this will make it update
source ~/.bashrc

then go to the assignment_05

nano scripts/02_run_fastp.sh

#!/bin/bash
set -euo pipefail

FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/raw/trimmed}
FWD_OUT=${FWD_OUT/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/raw/trimmed}
REV_OUT=${REV_OUT/.fastq.gz/.trimmed.fastq.gz}

SAMPLE=$(basename $FWD_IN | cut -d "_" -f1)

fastp \
--in1 $FWD_IN \
--in2 $REV_IN \
--out1 $FWD_OUT \
--out2 $REV_OUT \
--json /dev/null \
--html log/${SAMPLE}.html \
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20

echo "$SAMPLE" 



this is what I am using to trim


chmod +x ./scripts/02_run_fastp.sh 
give excecute permissions


./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz
used this to test and make sure it was running correctly and everything trimmed correct

now we make the pipeline.sh file functional in the rrot of the asisngment_05

nano pipeline.sh

#!/bin/bash
set -euo pipefail

./scripts/01_download_data.sh
# runt he fastq on all the reads
for FWD in data/raw/*_R1_*.fastq.gz
do
    ./scripts/02_run_fastp.sh $FWD
done

then exit and chmod +x pipeline.sh


rm  data/raw/*
rm data/trimmed/*


I remove the data so I can run pipeline.sh and it will do everything for me and run all the scripts



Overview

For this assignment I built a pipeline for bioinformation that would be reproduceable to others. The pipeline was for processing fastq sequencing data. 

File structure

assignment_05
-data
   -raw
   -trimmed
-log
-scripts
  -01_download_data.sh
  -02_run_fastp.sh
-pipeline.sh
-README.md



The 01_download_data.sh has the purpse of downloading the data, extracting the contents. It then moves the files into the raw data folder then deletes the tarball installation. 

The 02_run_fastp.sh script has the purpose of processing a sample data using fastp. It takes the input and gets the reverse of the filename, then creates the trimmed file names according to the parameters then runs fastp with the trims and removals of charectors. It writes HTML code the the log and sends JSON to the dev/null

pipeline.sh is meant to run the whole thing as one where all the scripts work together. It runs the download data scripts then loops through every forward read in the raw data then calls the run fastp for each sample. 


Instructions to run the pipeline are just use the below command
./pipeline.sh

I also needed the gitignore to exclude the data
nano .gitignore

data/
*.fastq.gz
*.tar



In reflection it was cool to see how a task can be sort of automated for anyone on any computer can do it. I did have some weird issue where I tried downloading from github to the HPC using sudo and the HPC gave me a warning about how I am not allowed to do that and warning me what I did was reported. I wonder if what about sudo is dangerous. Maybe it allows for unrestricted downloading? Or maybe it was was downloading somewhere not just in my personal directory and had the chance to make changes for others as well. I think it is a very cool concept to have several scripts that do an individual task and then put them together in a pipeline instead of just having one big script. It is a lot easier to follow and disect when the scripts are very task oriented and straight forward. 
