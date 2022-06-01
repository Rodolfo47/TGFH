#!bin/sh
#Cleaning and formating yeast genomes to funannotate
#Rodolfo Angeles, May/2022

#print ending date and time
date
#make `list2fun.txt` with prefix
ls ../data/*.fna | sed -e "s/..\/data\///g" | sed -e "s/.fna//g" > list2fun.txt

## 1 Cleaning assemblies
for smpl in $(cat list2fun.txt); do
    # 1.1 clear repeated contigs
    funannotate clean -i ../data/$smpl.fna -o ../out/$smpl.clean.fna
    # 1.2 sort and relabel headers
    funannotate sort -i ../out/$smpl.clean.fna -o ../out/$smpl.clean.sort.fna
    # 1.3 softmasking with tantan
    funannotate mask --cpus 20 -i ../out/$smpl.clean.sort.fna -o ../out/$smpl.clean.sort.mask.fna

    #delete tmp files
    rm ../out/$smpl.clean.fna ../out/$smpl.clean.sort.fna
done

#print ending date and time
date
#END