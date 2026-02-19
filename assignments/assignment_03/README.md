I already had the assignment 3 folder set up with the readme in it. 

went into assignment 3

mkdir data (to create the data folder)

cd data
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz (used wget to the get the file from the web)
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz (used gunzip to unzip the file)

cd .. (so we are in the assignment_03 directory so everything is reproduceable

grep -c "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna (how many sequences starting with >)
The answer is 7

grep -v "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -c (remove the headers and the new lines then count the charectors. 
The answer is 119668634

wc -l data/GCF_000001735.4_TAIR10.1_genomic.fna (word count -l for count lines)
14 lines

grep "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -c "mitochondrion" ( count header lines with mitocondrian)
1 line has it

grep "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -c "chromosome" ( header lines with chromosome)
The answer is 5

6. 
grep -A1 "chromosome" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -v "^>" | head -n 1 |  wc -c (This gets the header and the sequence line after it. Then it removes the header lines that have the > at the beginning of it. Then it does head and grabs the first line. This is the command for the first chromosome sequence. Then it finall ydoes the charector count

grep -A1 "chromosome" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -v "^>" | head -n 2 | tail -n 1 | wc -c (This does the exact same thing as the line above but takes the first 2 sequence lines then cuts lut the first line then takes the word count.

grep -A1 "chromosome" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -v "^>" | head -n 3 | tail -n 1 | wc -c (This si the command for the 3rd sequence. I did the exact same thing only difference was I took the first 3 sequence lines then took the last of the 3 to get the third line then took the charector count. 

I did this problem in 3 lines that the way I could figure out how to do it. 

7. 

grep -A1 "chromosome" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -v "^>" | head -n 5 | tail -n 1 | wc -c ( did the same thing where i got the header and the sequence removed the headers by removing > lines then I took the first 5 seuqnece lines then look the last of the 5 then did the charector count. 
26975503


8. 
grep -v "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | grep -c "AAAAAAAAAAAAAAAA" I took the sequence lines then found all instances of AAAAAAAAAAAAAAA and counted it
1 was the answer

9. 
grep "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -n 1 (this takes the sequence liens that start with > thne sorts alphabetically, then takes the first sequence. 
>NC_000932.1 Arabidopsis thaliana chloroplast, complete genome

10. 

#######
FAILED ATTEMPT
touch h.txt (creates h file)
touch s.txt (creates s file)
grep "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna > h.txt (puts all headers in h.txt)
grep -v "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna > s.txt (puts all sequences in s.txt)
paste h.txt s.txt 
#######


#Researched and found that sed can be used for find and replace

grep -A1 "^>" data/GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | sed 's/>/\n>/g' | sed 's/\n/\t/'
What this does is it first takes the headers and one line after the headers. then deletes the new lines. Then it finds every > and repleaces it with > then a new line. Then it converts the space into a tab so it is tab seperated. 



This assignment really made me think. One thing that was really frustrating was when I would be missing a step. Something like being able to search for a specific character. It was also tough when I would think I figured out a way just for me to realize something went wrong and I had to completely rework my approach. This happened question 10, where you had to combine into one line. I thought the paste command was the way to go. I was going to split the sequences and headers into separate files and then paste them together so they would go one after another. Then i realized that each individual header and sequence would need to be together. I then tried to stick with it and try a for loop but I just knew that was not the way to go. An infinite for loop would not have been ideal. So then I was able to find the sed command, which seemed to do the job well. It was frustrating but I had fun with the problem-solving aspect of it. Skills like these apply beyond just HPCs. This critical thinking and problem-solving definitely have their applications everywhere. As for automation, I struggle to see how this could be effective. There are two routes. One is that a human writes the code and it is just able to run over and over again and identify and separate whatever data it is handling. This can bring lots of efficiency especially when working with large amounts of data. Another aspect of automation i can think of is using AI to write the code to sort the data. I feel AI could be good at something like this with its attention to detail. Otherwise, I am not too sure what types of automation  could be incorporated. 
