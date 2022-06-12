#!bin/sh
#Annotate yeasts genomes with funannotate
#Rodolfo Angeles, May 2021

#Steps
# 1 remote
# 1 interpro
# 2 funannot

#1 remote
#run antysmash and phobius in remote servers

#indicate the start of the next step
echo "Start with remote annotations"
date
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

#indicate the start of the next step
echo "Start with InterProScan"
date

# 2 interpro
mkdir ../out/interproscan
for smpl in $(cat list2fun.txt); do
    date
    ./../../../binlike/my_interproscan/interproscan-5.56-89.0/interproscan.sh \
    -i ../out/$smpl/predict_results/*.proteins.fa \
    -f xml -iprlookup -dp \
    -d ../out/interproscan \
    -cpu 55
done

# 3 annotate with funannotate prediction and interproscan xml
echo "Start with funannotate annotations"
date
for smpl in $(cat list2fun.txt); do
    date
    funannotate annotate -i ../out/$smpl \
    --iprscan ../out/interproscan/$smpl*.xml \
    --busco_db saccharomycetales \
    --cpus 55
done
date
#End
