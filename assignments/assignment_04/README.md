I already had a programs file in the HPC
So all I did was cd programs

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
This installed tarball

tar -xzvf gh_2.74.2_linux_amd64.tar.gz
This command unzips it and opens it up

rm gh_2.74.2_linux_amd64.tar.gz
This then just removes the tarball

nano install_gh.sh
For part 3 this creates the scrpit

#!/bin/bash
set -euo pipefail

cd ~/programs || exit
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz

I put this inside the install_gh.sh file


chmod +x install_gh.sh
this then makes sure that the file is excitcuteable

./install_gh.sh
This command runs it

is then cd .. to go to the home directory

then nano .bashrc to go to the bashrc file

export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin
add this to the bottom of .bashrc

source ~/.bashrc
Did this to make sure .bashrc is up to date

I am already logged into github on the HPC

I ran ------------------------------------------------
[1 ksswaminathan@bora ~ ]$gh auth status
github.com
  ✓ Logged in to github.com account Krishna1Swaminathan (/sciclone/home/ksswaminathan/.config/gh/hosts.yml)
  - Active account: true
  - Git operations protocol: https
  - Token: ghp_************************************
  - Token scopes: 'admin:gpg_key', 'admin:org', 'admin:org_hook', 'admin:ssh_signing_key', 'gist', 'notifications', 'repo', 'workflow'
[2 ksswaminathan@bora ~ ]$




nano install_seqtk.sh
this creates the file for the installation script

#!/bin/bash
set -euo pipefail

cd "$HOME/programs"
git clone https://github.com/lh3/seqtk.git
cd seqtk
make
echo 'export PATH=$PATH:$HOME/programs/seqtk' >> "$HOME/.bashrc"
echo "seqtk is installed now run: source ~/.bashrc"

chmod +x install_seqtk.sh
makes it excitcutable

./install_seqtk.sh
used this to run it

seqtk typed this command and here was the output

Usage:   seqtk <command> <arguments>
Version: 1.5-r133

Command: seq       common transformation of FASTA/Q
         size      report the number sequences and bases
         comp      get the nucleotide composition of FASTA/Q
         sample    subsample sequences
         subseq    extract subsequences from FASTA/Q
         fqchk     fastq QC (base/quality summary)
         mergepe   interleave two PE FASTA/Q files
         split     split one file into multiple smaller files
         trimfq    trim FASTQ using the Phred algorithm

         hety      regional heterozygosity
         gc        identify high- or low-GC regions
         mutfa     point mutate FASTA at specified positions
         mergefa   merge two FASTA/Q files
         famask    apply a X-coded FASTA to a source FASTA
         dropse    drop unpaired from interleaved PE FASTA/Q
         rename    rename sequence names
         randbase  choose a random base from hets
         cutN      cut sequence at long N
         gap       get the gap locations
         listhet   extract the position of each het
         hpc       homopolyer-compressed sequence
         telo      identify telomere repeats in asm or long reads


cd ..
cd SUPERCOMPUTING/assignments/assignment_04
nano summarize_fasta.sh creates the script file

#!/bin/bash
set -euo pipefail

fasta="$1" #stores the input

num=$(grep -c "^>" "$fasta") #Total number of sequences
total=$(grep -v "^>" "$fasta" | tr -d '\n' | wc -c) #Total number of nucleotides

seqtk comp "$fasta" | awk '{print $1 "\t" $2}' Makes the table of names and length

echo "Total sequences: $num"
echo "Total nucleotides: $total"

This is what i put in the file

chmod +x summarize_fasta.sh
this makes it excicutible


in assignment_04 i mkdir data to make a data folder

inside i downloaded a few datasets from ncbi

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz
gunzip GCF_000146045.2_R64_genomic.fna.gz

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
gunzip GCF_000005845.2_ASM584v2_genomic.fna.gz

wget "https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=NC_001416.1&db=nuccore&report=fasta&format=text" -O lambda.fna
downloaded and unzipped the files

then in the assignment_04 folder
./summarize_fasta.sh data/lambda.fna
this runs summarize_fasta.sh and uses lambda.fna as the input


NC_001416.1	48502
Total sequences: 1
Total nucleotides: 48502

this was the output



for step 9 i make a for loop to run on all the files in the data folder

for f in data/*.fna; do ./summarize_fasta.sh "$f"; done
this says for each file f in the daya folder run summarize_fasta.sh and it will output to the screen and then end the loop

NC_000913.3	4641652
Total sequences: 1
Total nucleotides: 4641652
NC_001133.9	230218
NC_001134.8	813184
NC_001135.5	316620
NC_001136.10	1531933
NC_001137.3	576874
NC_001138.5	270161
NC_001139.9	1090940
NC_001140.6	562643
NC_001141.2	439888
NC_001142.9	745751
NC_001143.9	666816
NC_001144.5	1078177
NC_001145.3	924431
NC_001146.8	784333
NC_001147.6	1091291
NC_001148.4	948066
NC_001224.1	85779
Total sequences: 17
Total nucleotides: 12157105
NC_001416.1	48502
Total sequences: 1
Total nucleotides: 48502


this was the output



Reflection

the bashrc is one complicated file. It has so many parts and one error can be very difficult to fix. I was adding stuff to the end of bashrc and suddenly it would start giving me errors about different parts of the code. I had to restart the HPC and it went away but it is scary that I have control over such an important part of the HPC. seqtk was also an interesting addition. I feel like I am learning so many new different functions I am worried about staying on top of all of them. It is difficult to remember what each does and then on top of that having to use them all together makes it quite difficult. It is definately cool to me though the problem solving aspect of having so many commands at my disposal to solve one specific task. I think learning about the inputs like $1 as well as learning for loops is a big addition to my bash knowledge. 
$PATH is something that is used to house a list of directories. It makes it easy for the computer to find and will keep it alive whenever the HPC is opened up. 
