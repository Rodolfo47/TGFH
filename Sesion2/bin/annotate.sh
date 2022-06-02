#!bin/sh
#Annotate yeast genomes with funannotate
#Rodolfo Angeles, May 2021

#Steps
# 1 remote
# 1 interpro
# 2 funannot

#1 remote
#run antysmash and phobius in remote servers

#run
for smpl in $(cat list2fun.txt); do
   #print sample name and time
   echo "$smpl"
   date
   #send remote jobs
    funannotate remote \
    -m all \
    -e rodolfo.angeles.argaiz@gmail.com \
    -i ../out/$smpl \
    --force
done    
#End

# 2 interpro
mkdir ../out/interproscan
for smpl in $(cat list2fun.txt); do
    interproscan.sh -i ../out/$smpl/predict_results/*.proteins.fa \
    -f xml -iprlookup -dp \
    -d ../out/interproscan
done

# 3 annotate with funannotate prediction and interproscan xml

for smpl in $(cat list2fun.txt); do
    funannotate annotate -i ../out/$smpl \
    --iprscan ../out/interproscan/$smpl*.xml \
    --busco_db saccharomycetales \
    --cpus 28
done
date
#End