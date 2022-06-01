#!bin/sh
#Predicting yeast genes and proteins with funannotate
#by train/run Augustus, snap, GlimmerHMM
#Training steps use the yeast reference protein models
#(Sacce1_GeneCatalog_proteins_20101210.aa.fasta from JGI Mycocosm)
#Rodolfo Angeles, May 2022

#print starting date and time
date
# 2.1 prediction step
for smpl in $(cat list2fun.txt); do
    funannotate predict \
    -i ../out/$smpl.clean.sort.mask.fna \
    -o ../out/$smpl \
    -s $smpl \
    --isolate XXX \
    --name $smpl \
    --ploidy 1 \
    --protein_evidence ../data/Protein_models.faa \
    --cpus 28
done
#print ending date and time
date
#End