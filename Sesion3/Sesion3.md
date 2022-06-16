# Sesión 3: Ecologia genómica

*Roberto Garibay, Andrés Argüelles, Diana Oaxaca y Valeria Flores*

Junio 2022



**Estructura de la sesión**

- Genomica de hongos micorrízicos (RGO)
  - descanso
- Metabarcode (AAM)
  - descanso
- Metagenómica (DHO)
  - descanso
- Metatranscriptómica (VFA)

**Estructura de la sesión**

- Genomica de hongos micorrízicos (RGO)
  - descanso
  - 
- Metabarcode (AAM)
# Iniciamos en el server

```
ssh -Y -X aarguelles@**IPdelcluster**
  
mkdir cursoLAVIS3
```  
  
## Descargamos los archivos de entrada
 
 ### Todo codigo está basado y modificado de Bálint, Miklós, et al. "An Illumina metabarcoding pipeline for fungi." Ecology and evolution 4.13 (2014): 2642-2653.
 
``` 
wget https://dataportal.senckenberg.de/dataset/3f8de147-6017-408e-9a04-8542f2e20d66/resource/85de7956-1f72-46cc-b416-a171a61b608e/download/illumina_metabarcoding_pipeline_scripts-examples.zip
```

```
wget http://drive5.com/python/python_scripts.tar.gz
```

## descomprimir los archivos

descomprimir un zip
```
unzip illumina_metabarcoding_pipeline_scripts-examples.zip  
```

descomprimir un archivo *.tar
```
mkdir python_scripts  
mv python_scripts.tar.gz python_scripts  
cd python_scripts  
tar -xvkf python_scripts.tar.gz  
```
mover archivos a la carpeta de trabajo
```
mv Sample_files data  
cd data  
```
renombramos con nombres coherentes   
```
mv exp02pool02_S1_L001_R1_001.fastq R1.fastq  
mv exp02pool02_S1_L001_R2_001.fastq R2.fastq  
```
contamos cuantas secuencias tienen los archivos de fastq
```
grep -c "+" R1.fastq  
grep -c "+" R2.fastq  
```  
**##50000 seqs en cada uno**
  
## revisar calidad  
  
#### hacer el directorio  calidad

```
mkdir Calidad  
  
fastqc -o Calidad -f fastq R1.fastq R2.fastq  
  
cd Calidad  
  
firefox R1_fastqc.html&  
firefox R2_fastqc.html&  
```  
### filtrar por calidad  
  
 **##moverse al directirio con los script Scripts_to_supply**
``` 
cp Reads_Quality_Length_distribution.pl ~/cursoLAVIS3/data  
  
perl Reads_Quality_Length_distribution.pl -fw R1.fastq -rw R2.fastq -sc 33 -q 26 -l 150 -ld N  
  
grep -c "+" Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R1.fastq  
  
grep -c "+" Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R2.fastq  
```  
  
**#44692 seqs** 
  
### renombramos y verificamos secuencias
```  
#rename Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R1.fastq and R2 to fR1 & fR2  
  
mv Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R1.fastq fR1.fastq
  
mv Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R2.fastq fR2.fastq
  
grep -c "+" fR1.fastq  
grep -c "+" fR2.fastq  
```  
### revisar la nueva calidad  
```
mkdir Calidad2  
  
fastqc -o Calidad2 -f fastq fR1.fastq fR2.fastq  
```  
## Paired-end assembly ##
```  
pandaseq -f fR1.fastq -r fR2.fastq -F N -o 5 > paired_assembled.fastq  
  
grep -c "+" paired_assembled.fastq  
```  
  
**#41759 seqs**
  
  
  
### Reorient  
  
***#### buscar en el archivo de primers.txt GATGAAGAACG[CT]AG[CT][AG]AA  
CT[TCG]TT[CGA]CC[GT]CTTCACTCG***  
  
```  
fqgrep -mN -p GATGAAGAACG[CT]AG[CT][AG]AA -e paired_assembled.fastq > good_5-3.fastq  
  
fqgrep -mN -p CT[TCG]TT[CGA]CC[GT]CTTCACTCG -e paired_assembled.fastq > good_3-5.fastq  
  
  
grep -c "+" good_5-3.fastq  
grep -c "+" good_3-5.fastq  
```  
**#19923 seqs #19270 seqs**

```
fastx_reverse_complement -Q33 -i good_3-5.fastq >> good_5-3.fastq  
  
grep -c "+" good_5-3.fastq  
```  
**#39193 seqs**  
  
## Remove multiprimer  
#Remove primer artifacts  
## Check which version of python do you have. This works with python 2.x  
  
`### conda env list`
`### source activate python27 `
`### conda deactivate`
  
```
cp ~/cursoLAVIS3/Scripts_to_supply/remove_multiprimer.py ~/cursoLAVIS3/data  
  
  
python2 remove_multiprimer.py -i good_5-3.fastq -o paired_assembled_good.fastq -f GATGAAGAACGCAGTGAA -r CTTTTGCCTCTTCACTCG  
  
  
grep -c "+" good_5-3.fastq  
grep -c "+" paired_assembled_good.fastq  
```  
**#39193 seqs #38980 seqs**
  
## Demultiplexing  
  
```  
cp ~/cursoLAVIS3/Scripts_to_supply/demultiplex.sh ~/cursoLAVIS3/data  
  
bash demultiplex.sh forward_labels.csv reverse_labels.csv paired_assembled_good.fastq  `
```  
##### #se hacen un monton de archivos  
```  
cp ~/cursoLAVIS3/Scripts_to_supply/[rename.pl](http://rename.pl/) ~/cursoLAVIS3/data  
perl [rename.pl](http://rename.pl/)  
  
cat renamed_*.fasta >> combined_samples.fasta  
```  
**#33252 seqs**
  
```  
fastx_trimmer -f 27 -i combined_samples.fasta -o head_trimmed.fasta  
fastx_trimmer -t 26 -i head_trimmed.fasta -o trimmed.fasta  
  
grep -c ">" head_trimmed.fasta  
grep -c ">" trimmed.fasta  
```  
**#33252 seqs**
  
## Extract fungal ITS  
  
***### check or install HMMER ver. 3, be patient :)***  
```  
git clone https://github.com/arg-and/code-base1.git

cd code-base1

cd FungalITSextractor

cp ~/cursoLAVIS3/data/trimmed.fasta ~/cursoLAVIS3/data/code-base1/FungalITSextractor/indata 
  

mv trimmed.fasta indata.fasta  
```  

#### *#usa la mitad de los nucleos*
```  
ITSx -i indata.fasta -o outITS --partial 100 -t F --preserve T --cpu 20 --multi_threads 20  
  
grep -c ">" outITS.ITS2.full_and_partial.fasta  
  
  
cp outITS.ITS2.full_and_partial.fasta ITS2.fasta  
  
grep -c ">" ITS2.fasta  
```
**#29348 seqs**  
  
## Similarity clustering  
```  
mkdir clustering  
mv ITS2.fasta clustering/  
cd clustering/  
  
cp ITS2.fasta ITS2ok.fasta  
  
head ITS2ok.fasta  
  
sed -i "/>/c\>otu" ITS2ok.fasta  
  
usearch11 -fastx_uniques ITS2ok.fasta -fastaout derep.fasta -sizeout  
  
grep -c ">" derep.fasta  
  
usearch11 -sortbysize derep.fasta -fastaout sorted.fasta -minsize 2  
  
grep -c ">" sorted.fasta  
  
usearch11 -cluster_otus sorted.fasta -otus output_file_otus.fasta  
  
grep -c ">" output_file_otus.fasta  
  
head output_file_otus.fasta  
  
usearch11 -unoise3 output_file_otus.fasta -zotus zotus.fasta  
  
head zotus.fasta  
  
usearch11 -uchime3_denovo output_file_otus.fasta -nonchimeras nochimeras97.fasta -chimeras chimeras.fasta -uchimeout otus+chimeras.txt  
  
grep -c ">" nochimeras97.fasta  
  
grep -c ">" zotus.fasta  
  
grep -c ">" chimeras.fasta  
```  
**#544 seqs #5 seqs #520 seqs**
  
## Blast  
  
###### #Input file: nochimeras97.fasta  
```  
cp nochimeras97.fasta blast  
  
mkdir blast  
  
cd blast  
  
wget https://files.plutof.ut.ee/doi/87/C9/87C97D15437BA13125B61403810C6E46D1319B68A0E6E3BC77BFC57C8D0A67A3.zip

  
mv 87C97D15437BA13125B61403810C6E46D1319B68A0E6E3BC77BFC57C8D0A67A3.zip unite.zip
  
unzip unite.zip  
```  
  
**#format database**  
```
makeblastdb -in UNITE_public_01.12.2017.fasta -dbtype nucl -out unitforblast  
  
blastn -db unitforblast -query nochimeras97.fasta -outfmt "6 qseqid salltitles" -out blasttable.tsv -num_threads=4 -evalue 0.001 -max_target_seqs 1  
 ``` 
  
**#usando MEGAN6**  
```
blastn -db unitforblast -query nochimeras97.fasta -outfmt 5 -out blasttable.xml -num_threads=4 -evalue 0.001 -max_target_seqs 1  
```  
## Otutable  
```  
mkdir otutable  
  
mv nochimeras97.fasta otutable  

mv blasttable.xml otutable  
    
zip -q megan_in.zip nochimeras97.fasta blasttable.xml  

scp meganout.fasta aarguelles@**IPdelcluster**:~/cursoLAVIS3/data/FungalITSextractor/clustering/blast/otutable  
  
scp meganout.fasta aarguelles@**IPdelcluster**:~/cursoLAVIS3/data/FungalITSextractor/clustering/blast/otutable  
  
cp ~/cursoLAVIS3/python_scripts/*.py ~/cursoLAVIS3/data/FungalITSextractor/clustering/blast/otutable    
  
python2 fasta_number.py meganout.fasta OTU_>fungalotus_numbered.fa  
  
cp ~/cursoLAVIS3/data/FungalITSextractor/clustering/ITS2.fasta ~/cursoLAVIS3/data/FungalITSextractor/clustering/blast/otutable  
  
usearch11 -usearch_global ITS2.fasta -db fungalotus_numbered.fa -strand plus -id 0.97 -uc fungal_readmap.uc  

python2 uc2otutab.py fungal_readmap.uc > fungal_otu_table.txt  
  
head fungal_otu_table.txt  
```  
####END
  
## FUNGuild  
```  
git clone [https://github.com/UMNFuN/FUNGuild](https://github.com/UMNFuN/FUNGuild)  
cd FUNGuild/  
  
conda deactivate  
  
python FUNGuild.py taxa -otu example/otu_table.txt -format tsv -column taxonomy -classifier unite
  
python FUNGuild.py guild -taxa example/otu_table.taxa.txt
  
head otu_table.taxa.txt
```
## descanso
