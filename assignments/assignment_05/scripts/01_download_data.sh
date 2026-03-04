#!/bin/bash
set -euo pipefail

URL="https://gzahn.github.io/data/fastq_examples.tar"
TARBALL="fastq_examples.tar"

wget -O $TARBALL $URL
tar -xvf $TARBALL
mv *.fastq.gz data/raw/
rm $TARBALL
