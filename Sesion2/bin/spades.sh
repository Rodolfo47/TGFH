#!bin/sh
date
spades.py \
    -1 ../data/reads.R1.fq \
    -2 ../data/reads.R2.fq \
    --careful \
    -t 4 \
    -k 31,41,51,61,71 \
    -o ../out/spadesYeast
date
