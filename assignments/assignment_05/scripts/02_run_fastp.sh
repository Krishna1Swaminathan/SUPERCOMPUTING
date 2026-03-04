#!/bin/bash
set -euo pipefail

mkdir -p log
mkdir -p data/trimmed

#input files
FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

#out
FWD_OUT=${FWD_IN/raw/trimmed}
FWD_OUT=${FWD_OUT/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/raw/trimmed}
REV_OUT=${REV_OUT/.fastq.gz/.trimmed.fastq.gz}

#HTML
SAMPLE=$(basename $FWD_IN | cut -d "_" -f1)

#run the fastp
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
