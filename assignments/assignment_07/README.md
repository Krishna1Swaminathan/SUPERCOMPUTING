
Description
The purpose of this pipeline is to  find dog DNA contamination in public coral reef metagenomic data that we got from NCBI SRA. The script is able to download raw data, filter it, and mpa it tothe Canis familiaris reference genome. It then exctracts the matching reads. 

SRA search: coral metagenome AND "Illumina" AND "WGS" 

The samples were selected from Metagenome of SCTLD in the Dry Tortugas

Requirements

Install to programs
sra-toolkit
samtools
bbmap
fastp

Installation instructions are shown below if needed
cd ~/programs
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz
tar -xzf sratoolkit.current-centos_linux64.tar.gz

cd ~/programs
wget https://github.com/samtools/samtools/releases/download/1.19/samtools-1.19.tar.bz2
tar -xjf samtools-1.19.tar.bz2
cd samtools-1.19
./configure --prefix=/sciclone/home/ksswaminathan/programs/samtools
make
make install

cd ~/programs
wget https://sourceforge.net/projects/bbmap/files/BBMap_39.06.tar.gz
tar -xzf BBMap_39.06.tar.gz



How to run
Upload the data as SraRunTable.csv into the data folder
install any programs you dont already have
then use sbatch assignment_7_pipeline.slurm to submit to slurm
The pipeline will run 01_download.sh, 02_clean.sh, and 03_map_and_extract.sh in that order

Directory structure

assignment_07/
├── assignment_7_pipeline.slurm
├── README.md
├── scripts/
│   ├── 01_download.sh
│   ├── 02_clean.sh
│   └── 03_map_and_extract.sh
├── data/
│   ├── raw/
│   ├── clean/
│   ├── mapped/
│   ├── hits/
│   ├── reference/
│   └── SraRunTable.csv
└── output/


I first went to the assignment_07 directory there is did 
mkdir data scripts output
mkdir data/raw data/clean data/reference data/mapped data/hits


this made the data scripts and output folder and also in the data folder i made raw clean reference mapped and hits

then nano scripts/01_download.sh
to make the first script


#!/bin/bash

tail -n +2 "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/SraRunTable.csv" | cut -d',' -f1 | while read -r acc; do
    prefetch "$acc" --output-directory /sciclone/home/ksswaminathan/sra_cache
    fasterq-dump /sciclone/home/ksswaminathan/sra_cache/sra/${acc}.sra \
        --outdir "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/raw" \
        --split-files \
        --threads 8
done

datasets download genome taxon "Canis lupus familiaris" \
    --reference \
    --include genome \
    --filename "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/reference/dog_genome.zip"

cd "/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/data/reference"
unzip -o dog_genome.zip
find . -name "*.fna" | head -1 | xargs -I{} mv {} dog_genome.fna




I used prefetch becuase i was having all sorts of issues where fasterq was not working on slurm.
This reads through the CSV file and gets each id. It then downloads each raw DNA section into the raw data file. Then it downloads the dog reference genome and puts it in the refernce folder so that later we can use bbmap to access it. 
I used the absolute file path for everything because when running thoruhg slurm it will not be local and could be running from anywhere in the computer


The next script is for taking the raw data and cleaning it with fastp it also removes low quality bases and short reads. 

nano scripts/02_clean.sh

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


for the next script the purpose is to clean reads against the dog genome with bbmapn. It uses samtools to get the sequences that actually end up matching. 

nano scripts/03_map_and_extract.sh

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


chmod +x scripts/01_download.sh scripts/02_clean.sh scripts/03_map_and_extract.sh
this makes everything excecuteable

also i had to install the sra toolkit bbmap and samtools

cd ~/programs
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz
tar -xzf sratoolkit.current-centos_linux64.tar.gz

cd ~/programs
wget https://github.com/samtools/samtools/releases/download/1.19/samtools-1.19.tar.bz2
tar -xjf samtools-1.19.tar.bz2
cd samtools-1.19
./configure --prefix=/sciclone/home/ksswaminathan/programs/samtools
make
make install

cd ~/programs
wget https://sourceforge.net/projects/bbmap/files/BBMap_39.06.tar.gz
tar -xzf BBMap_39.06.tar.gz



then add it to my path

source ~/.bashrc

this reloads so that they will work


export PATH=$PATH:/sciclone/home/ksswaminathan/programs/sratoolkit.3.2.0-centos_linux64/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/samtools/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/bbmap
Add the tools to our path


Next we make the slurm script to get the HPC to run the code. 

#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --output=/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/output/%j.out
#SBATCH --error=/sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/output/%j.err
#SBATCH --time=9:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=ksswaminathan@wm.edu

source ~/.bashrc

export PATH=$PATH:/sciclone/home/ksswaminathan/programs/sratoolkit.3.2.0-centos_linux64/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/samtools/bin
export PATH=$PATH:/sciclone/home/ksswaminathan/programs/bbmap
export PATH=$PATH:/sciclone/home/ksswaminathan/programs

bash /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/scripts/01_download.sh
bash /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/scripts/02_clean.sh
bash /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_07/scripts/03_map_and_extract.sh



Results

| Sample | Clean Reads | Dog Hits |
|--------|-------------|----------|
| SRR31168905 | 5736406 | 2732 |

I was having a recurring issue where the slurm script would only run 1 out of the 10 files and complete. I tried several times. I believe the issue was when downloadinng the file paths of the data got messed up each file first got saved under a folder with the same name as the file. But for other files that did not happen. I was not able to find that out until too late so I only was able to do one sample. Especially when it took several hours to queue and then run it took a very long time to indentify the errors and I would fix one thing and just have to hope everything worked perfectly. 
I ran the my scripts throuhg slurm 4 times total over the course of 2 days and did small fixes each time. I wish there was something i could have done to have ixed the one sample issue before it was too late.

Another challenge i was running into was getting fasterq-dump to work correctly. It seemed like sra-toolkit requires prefetch to download the .sra file first before fasterq-dump can work and convert it to fastq. Also prefetch command saves files in a different folder structure than expected which ended up caused the pipeline to only process one sample instead of all ten.
It was also insteresting to have to use the absolute file path for everthing when running on slurm as well as learning to read and understand the error files.


