#!/bin/bash
set -euo pipefail

./scripts/01_download_data.sh


for FWD in data/raw/*_R1_*.fastq.gz
do
    ./scripts/02_run_fastp.sh $FWD
done

