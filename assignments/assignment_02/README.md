Assignment 2 - File Transfer
Krishna Swaminathan
Feb 9, 2026


Description:

For this assignment I accessed biological data using FTP to my local machine. From there I used FileZilla to transfer it to the HPC. I verified it was not compromised and made sure all pa>

I was having trouble with FTP so I used LFTP which I looked up and it was able to serve the same purpose.
lftp ftp.ncbi.nlm.nih.gov (Command i used to access the ncbi data)
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/ (to access the specific data sets i was trying to access)

get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
(Both these commands were able to get the data on to my local computer)

bye
(which leaves the session and brings me back to my local.

Then I opened up the HPC with the 'bora' shortcut we setup.

then in both my local and the HPC i went into cd SUPERCOMPUTING/assignments/assignment_02
mkdir data (in both the local and HPC so I would have a place to put the datasets I just downloaded

I then used Filezilla to transfer the data from my local home directory directly into data within my assignment_02 filder in SUPERCOMPUTINGxx
On my local machine i just used finder to transfer the files into the data folder

chmod 644 *.gz (I used this command to make the data readable to all)

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
(These commands allowed me to copy the hashes from my local and confirm with the HPC hashes to make sure the data was still intact)

Below are what was shown on my local and HPC these are the hashes

LOCAL:
c13d459b5caa702ff7e1f26fe44b8ad7 GCF_000005845.2_ASM584v2_genomic.fna.gz
2238238dd39e11329547d26ab138be41 GCF_000005845.2_ASM584v2_genomic.gff.gz

HPC:
c13d459b5caa702ff7e1f26fe44b8ad7 /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_02/data/GCF_000005845.2_ASM584v2_genomic.fna.gz
2238238dd39e11329547d26ab138be41 /sciclone/home/ksswaminathan/SUPERCOMPUTING/assignments/assignment_02/data/GCF_000005845.2_ASM584v2_genomic.gff.gz

(This confirms that the hashes are the same)



I then ran the same command on my HPC and verified the hashes

nano ~/.bashrc
(This command to get into the bash script)

alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
(Added these into the file so that I can use u d and ll as shortcuts int he future)
source ~/.bashrc
Then finally i ran this to allow those new shortcuts to be activated



Reflection:

I think it was a very important assignment. It was good using ftp to access data as well as being comfortable transfering files from local to HPC and back. One thing that I still dont ful>
Another observation I have is it is difficult to write a lot in nano or vim. The lines keep running on off the page and it makes it difficult to proofread and make sure your sentences mak>


