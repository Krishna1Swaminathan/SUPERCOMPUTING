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
