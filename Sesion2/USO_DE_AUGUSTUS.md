## USO DE AUGUSTUS

#### Taller de Genómica de Hongos.- Sesión 2

Elena Flores Callejas 

Junio del 2022

###### 

### AUGUSTUS 

AUGUSTUS es un software predictor de genes en secuencias genómicas eucariotas. Su versión original era un método puramente *ab initio*, es decir, su predicción se basaba en la información contenida en la secuencia genómica a analizar. Una versión extendida del programa ahora puede usar información extrínseca adicional (ie. coincidencias con bases de datos de proteínas o alineaciones de secuencias genómicas) para mejorar la precisión de la predicción. 

Sin embargo, la predicción de genes *ab initio* sigue siendo muy importante ya que para muchos genomas recién secuenciados hay pocas marcadores de secuencias expresadas EST (expressed sequence tag) y genómicas relacionadas disponibles. Además de que a partir de alineaciones con secuencias proteicas solo se pueden encontrar aquellos genes que tienen parientes cercanos en las bases de datos. 

AUGUSTUS es considerado el mejor programa en la categoría de predicción de genes *ab initio* (Guigó y Reese, 2005).  Se basa en un modelo de Markov oculto generalizado (HMM), que define distribuciones de probabilidad para las diversas secciones de las secuencias genómicas (intrones, exones, regiones intergénicas, etc.). 

Estas secciones corresponden a estados en el modelo y cada estado crea secuencias de ADN con ciertas probabilidades de emisión predefinidas. Al igual que otros buscadores de genes basados en HMM, AUGUSTUS encuentra un análisis óptimo de una secuencia genómica determinada y modela su estructura génica al segmentarla en cualquier *secuencia significativa de exones, intrones y regiones intergénicas*.  Esto incluye la posibilidad de no tener ningún gen o de tener múltiples genes. 

AUGUSTUS intenta predecir una estructura génica que sea (biológicamente) consistente en los siguientes sentidos:

1. Ningún exón contiene un codón de término en el marco de lectura. 
2. Los sitios de empalme obedecen al consenso gt-ag. Los genes completos comienzan con atg y terminan con un codón de término.  
3. Cada gen termina antes de que comience el siguiente gen. 
4. Las longitudes de exones e intrones individuales superan una longitud mínima dependiente de la especie.  
5. Que obedezca todas las restricciones dadas.  Una restricción puede contradecir la consistencia biológica, por lo que si no es posible una estructura genética consistente se ignoran algunas restricciones. Además, si dos o más restricciones se contradicen, AUGUSTUS obedece solo a la restricción que se ajusta mejor al modelo.

El rendimiento de AUGUSTUS se ha evaluado ampliamente en datos de secuencias de humanos, *Drosophila* y otras especies. Estos estudios demostraron que, especialmente para secuencias de entrada largas, la precisión de este programa es superior a la de los enfoques existentes de búsqueda de genes *ab initio*. 



#### INSTALACIÓN Y EJECUCIÓN

Puede ejecutarse en el servidor web AUGUSTUS (http://bioinf.uni-greifswald.de/augustus/), en su nuevo servidor web (http://bioinf.uni-greifswald.de/webaugustus/) para archivos de entrada más grandes o bien, descargarse y ejecutarse localmente.  Ahora también se puede ejecutar AUGUSTUS en el MediGRID alemán, lo que permite enviar archivos de secuencias más grandes y usar información de homología de proteínas en la predicción. MediGRID requiere un registro fácil e instantáneo por correo electrónico para usuarios nuevos.

```bash
# Installing AUGUSTUS
# Elena Flores Callejas
# June 2022
 
#Install globally. You can install AUGUSTUS globally, if you have root privileges.
sudo apt install augustus augustus-data augustus-doc
#END- Working fine 
```

###### INPUT

El servidor web AUGUSTUS permite cargar una secuencia de ADN en formato FASTA, varias secuencias en formato FASTA múltiple o pegar una secuencia en el formulario web. La longitud total máxima de las secuencias enviadas al servidor es de **3 millones de pares de bases**. 

```bash
>name_of_sequence_1
agtgctgcatgctagctagct
>name_of_sequence_2
gtgctngcatgctagctagctggtgtnntgaaaaatt
```

Cualquier letra que no sea a,c,g,t,A,C,G o T se interpreta como una base desconocida. Los dígitos y espacios en blanco se ignoran. Al ejecutarse localmente, el número de caracteres por línea y de secuencias no está restringido. 

Actualmente en el servidor web AUGUSTUS tiene conjuntos de parámetros específicos precalculados para ciertas especies, como son: *Homo sapiens, Drosophila melanogaster, Arabidopsis thaliana, Brugia malayi, Coprinus cinereus, Tribolium castaneum, Schistosoma mansoni, Tetrahymena thermophila y Galdieria sulfuraria*. 

Además, tiene dos opciones globales para la estructura génica predicha. Primero, el usuario puede restringir la estructura del gen pronosticado para que contenga exactamente un gen completo, cualquier número de genes completos, al menos un gen completo o, por defecto, cualquier número de genes que pueden ser parciales en los límites de la secuencia. En segundo lugar, el usuario puede suspender el requisito de consistencia de que cada gen finalice antes de que comience el siguiente, así los genes se predicen independientemente en ambas cadenas y pueden superponerse o anidarse. 

###### OUTPUT

La salida de texto consta de límites de exones, intrones, transcritos, codones, regiones codificantes (CDS) y de otras estructuras génicas predichas en formato de características generales (GFF) común, con comentarios adicionales (líneas que empiezan con #). En este formato, los resultados contienen para cada gen líneas con campos de datos separados por un carácter TAB. Estos campos de datos incluyen la posición inicial y final del elemento génico, un nombre para la secuencia, un nombre para el gen y si está en la cadena directa o inversa.

```
seqname  source  feature  start  end  score  strand  frame   transcript and gene name
```

```
HS04636   AUGUSTUS   initial    966   1017  .  +  0    transcript_id "g1.1"; gene_id "g1";
HS04636   AUGUSTUS   internal   1818  1934  .  +  2    transcript_id "g1.1"; gene_id "g1";
```

También se obtienen secuencias de aminoácidos y de codificación predichas en formato FASTA con ayuda del comando:

```
 /usr/share/augustus/scripts/getAnnoFasta.pl
```

La página de resultados del servidor web muestra para cada secuencia una miniatura y enlaces a imágenes en formato pdf y postscript. También es posible generar una salida gráfica con el programa gff2ps a partir de la salida de texto.

![](/home/elena/Proyecto_tesis_Laccaria/augustus_output.jpeg)



###### EXECUTION

Para la ejecución local de AUGUSTUS se escribe el siguiente comando con los parámetros apropiados:

```
augustus --species=SPECIES [parameters] queryfilename
```

SPECIES corresponde al identificador de una especie, "queryfilename" es el path relativo que nos lleva al archivo que contiene la secuencia o secuencias de entrada en formato FASTA. 



#### PARÁMETROS IMPORTANTES

- --species=SPECIES

SPECIES corresponde a un identificador de alguna de las especies con las que el programa ha sido entrenado. El directorio completo con los nombres de estos identificadores puede llamarse escribiendo `augustus --species=help`

| identifier                               | species                            |
| ---------------------------------------- | ---------------------------------- |
| human                                    | Homo sapiens                       |
| fly                                      | Drosophila melanogaster            |
| arabidopsis                              | Arabidopsis thaliana               |
| brugia                                   | Brugia malayi                      |
| aedes                                    | Aedes aegypti                      |
| tribolium                                | Tribolium castaneum                |
| schistosoma                              | Schistosoma mansoni                |
| tetrahymena                              | Tetrahymena thermophila            |
| galdieria                                | Galdieria sulphuraria              |
| maize                                    | Zea mays                           |
| toxoplasma                               | Toxoplasma gondii                  |
| caenorhabditis                           | Caenorhabditis elegans             |
| (elegans)                                | Caenorhabditis elegans             |
| aspergillus_fumigatus                    | Aspergillus fumigatus              |
| aspergillus_nidulans                     | Aspergillus nidulans               |
| (anidulans)                              | Aspergillus nidulans               |
| aspergillus_oryzae                       | Aspergillus oryzae                 |
| aspergillus_terreus                      | Aspergillus terreus                |
| botrytis_cinerea                         | Botrytis cinerea                   |
| candida_albicans                         | Candida albicans                   |
| candida_guilliermondii                   | Candida guilliermondii             |
| candida_tropicalis                       | Candida tropicalis                 |
| chaetomium_globosum                      | Chaetomium globosum                |
| coccidioides_immitis                     | Coccidioides immitis               |
| coprinus                                 | Coprinus cinereus                  |
| coprinus_cinereus                        | Coprinus cinereus                  |
| coyote_tobacco                           | Nicotiana attenuata                |
| cryptococcus_neoformans_gattii           | Cryptococcus neoformans gattii     |
| cryptococcus_neoformans_neoformans_B     | Cryptococcus neoformans neoformans |
| cryptococcus_neoformans_neoformans_JEC21 | Cryptococcus neoformans neoformans |
| (cryptococcus)                           | Cryptococcus neoformans            |
| debaryomyces_hansenii                    | Debaryomyces hansenii              |
| encephalitozoon_cuniculi_GB              | Encephalitozoon cuniculi           |
| eremothecium_gossypii                    | Eremothecium gossypii              |
| fusarium_graminearum                     | Fusarium graminearum               |
| (fusarium)                               | Fusarium graminearum               |
| histoplasma_capsulatum                   | Histoplasma capsulatum             |
| (histoplasma)                            | Histoplasma capsulatum             |
| kluyveromyces_lactis                     | Kluyveromyces lactis               |
| laccaria_bicolor                         | Laccaria bicolor                   |
| lamprey                                  | Petromyzon marinus                 |
| leishmania_tarentolae                    | Leishmania tarentolae              |
| lodderomyces_elongisporus                | Lodderomyces elongisporus          |
| magnaporthe_grisea                       | Magnaporthe grisea                 |
| neurospora_crassa                        | Neurospora crassa                  |
| (neurospora)                             | Neurospora crassa                  |
| phanerochaete_chrysosporium              | Phanerochaete chrysosporium        |
| (pchrysosporium)                         | Phanerochaete chrysosporium        |
| pichia_stipitis                          | Pichia stipitis                    |
| rhizopus_oryzae                          | Rhizopus oryzae                    |
| saccharomyces_cerevisiae_S288C           | Saccharomyces cerevisiae           |
| saccharomyces_cerevisiae_rm11-1a_1       | Saccharomyces cerevisiae           |
| (saccharomyces)                          | Saccharomyces cerevisiae           |
| schizosaccharomyces_pombe                | Schizosaccharomyces pombe          |
| thermoanaerobacter_tengcongensis         | Thermoanaerobacter tengcongensis   |
| trichinella                              | Trichinella spiralis               |
| ustilago_maydis                          | Ustilago maydis                    |
| (ustilago)                               | Ustilago maydis                    |
| yarrowia_lipolytica                      | Yarrowia lipolytica                |
| nasonia                                  | Nasonia vitripennis                |
| tomato                                   | Solanum lycopersicum               |
| chlamydomonas                            | Chlamydomonas reinhardtii          |
| amphimedon                               | Amphimedon queenslandica           |
| pneumocystis                             | Pneumocystis jirovecii             |
| wheat                                    | Triticum aestivum                  |
| chicken                                  | Gallus gallus                      |
| zebrafish                                | Danio rerio                        |
| E_coli_K12                               | Escherichia coli                   |
| s_aureus                                 | Staphylococcus aureus              |
| volvox                                   | Volvox carteri                     |



- --strand=both, --strand=forward or --strand=backward 

Reporta genes predichos en ambas hebras de DNA, en la *forward* (hacia delante) o en la *backward* (reversa). La opción predeterminada es "both", ambas.



- --genemodel=partial, --genemodel=intronless, --genemodel=complete, --genemodel=atleastone or --genemodel=exactlyone

*partial (predeterminado]:* AUGUSTUS puede predecir ningún gen en absoluto, uno o más genes; pero permite la predicción de genes parciales en los límites de la secuencia. Es decir, genes para los que no todos sus exones están contenidos en la secuencia de entrada, pero se asume que dicha secuencia comienza o termina en una región no codificante.

*complete:* AUGUSTUS asume que la secuencia de entrada no comienza ni termina dentro de un gen. Se predicen cero o más genes completos.

*atleastone*: Igual que en "complete" pero AUGUSTUS predice al menos un gen completo (si es posible).

*exactlyone:* AUGUSTUS asume que la secuencia contiene exactamente un gen completo y lo predice.

*intronless:* solo predice genes de un solo exón como en la mayoría de los procariotas y algunos eucariotas.



- --singlestrand=true 

Se predicen genes independientemente en cada hebra, permite el sobrelapamiento de genes en hebras opuestas. *genes superpuestos: secuencias de ADN que codifican simultáneamente dos o más proteínas en diferentes marcos de lectura.*



- --protein=on/off

- --codingseq=on/off

- --introns=on/off

- --start=on/off

- --stop=on/off

- --cds=on/off

- --UTR=on/off 

Se predicen explícitamente proteínas, secuencias codificantes, intrones, codones de inicio y de término. regiones codificantes (cds) y las regiones no traducidas (UTR), para incluirse en el GFF.



- progress=true 

  Muestra un el progreso del proceso en pantalla.



Para visualizar una lista completa de parámetros se escribe `augustus --paramlist`



#### PRÁCTICA: USO DE AUGUSTUS.

```bash
# Running predictions with AUGUSTUS
# Executional script: AUGUSTUS (3.3.3) 
# Elena Flores Callejas
# June 2022

#Log into the server
ssh eflores@132.248.248.175 ServerAliveInterval=300

#Clone repo 
git clone https://github.com/Rodolfo47/TGFH

#Create a directory for the AUGUSTUS_predictions | move to bin
# mkdir TGFH/Sesion2/data/Gene_prediction/AUGUSTUS_predictions
mkdir TGFH/Sesion2/data/Gene_prediction/augustus_predictions
cd /home/eflores/TGFH/Sesion2/bin/
```

```bash
#Gene prediction in two different formats (amino acids and nucleotides), of a small genome (O.polymorpha 8.7M) 
ls -lhF ../data/Yeasts_assembly/Hanpo2_AssemblyScaffolds.fasta 

##1st prediction. Output: Aminoacids FASTA.
# augustus --species=saccharomyces_cerevisiae_S288C --progress=true --singlestrand=true --genemodel=complete ../data/Gene_prediction/O.polymorpha_NCYC495.fna > ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha.gff

augustus --species=saccharomyces_cerevisiae_S288C --progress=true --singlestrand=true --genemodel=complete ../data/Gene_prediction/O.polymorpha_NCYC495.fna > ../data/Gene_prediction/augustus_predictions/O_polymorpha.gff

##Obtain the fasta aa
 # /usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha.gff
 /usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/augustus_predictions/O_polymorpha.gff
## 1 output: O_polymorpha.aa

##2nd prediction. Output: Nucleotids FASTA.
# augustus --species=saccharomyces_cerevisiae_S288C --progress=true --singlestrand=true --genemodel=complete --codingseq=on --protein=on ../data/Gene_prediction/O.polymorpha_NCYC495.fna > ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha_codingseq.gff
augustus --species=saccharomyces_cerevisiae_S288C --progress=true --singlestrand=true --genemodel=complete --codingseq=on --protein=on ../data/Gene_prediction/O.polymorpha_NCYC495.fna > ../data/Gene_prediction/augustus_predictions/O_polymorpha_codingseq.gff

##Obtain the fasta aa and the codingseq 
# /usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha_codingseq.gff
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/augustus_predictions/O_polymorpha_codingseq.gff
### 2 outputs: O_polymorpha_codingseq.aa O_polymorpha_codingseq.codingseq

##Are they the same gff files?
# diff -s ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha.gff ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha_codingseq.gff 
diff -s ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha.gff ../data/Gene_prediction/augustus_predictions/O_polymorpha_codingseq.gff 
#-s, --report-identical-files: report when two files are the same
##ARE IDENTICAL

##Number of predicted genes
###Aminoacids FASTA (aa)
# grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha.aa | wc -l 
grep -o ">" ../data/Gene_prediction/augustus_predictions/O_polymorpha.aa | wc -l 
#no. genes 6652
# grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha_codingseq.aa | wc -l 
grep -o ">" ../data/Gene_prediction/augustus_predictions/O_polymorpha_codingseq.aa | wc -l 
#no. genes 6652
#Nucleotids FASTA (codingseq)
# grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/O_polymorpha_codingseq.codingseq | wc -l 
grep -o ">" ../data/Gene_prediction/augustus_predictions/O_polymorpha_codingseq.codingseq | wc -l 
#no. genes 6652

##ARE IDENTICAL
```

```bash
#Generating materials for evaluating gene predictions of Laccaria bicolor S238N-H82 genome, based on different gene models. 

##1st prediction. Gene model complete.
# augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=complete ../data/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_complete.gff
augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=complete ../data/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/augustus_predictions/Laccaria_bicolor_S238N_H82_complete.gff
##Obtain the fasta aa 
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_complete.gff
### 1 output: Laccaria_bicolor_S238N_H82_complete.aa
##Number of predicted genes
grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_complete.aa | wc -l 
#no. genes 18971

##2nd prediction. Gene model partial.
# augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=partial ../data/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_partial.gff
augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=partial ../data/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/augustus_predictions/Laccaria_bicolor_S238N_H82_partial.gff
##Obtain the fasta aa
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_partial.gff
### 1 output: Laccaria_bicolor_S238N_H82_partial.aa
##Number of predicted genes
grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_partial.aa | wc -l 
#no. genes 19005

##3rd prediction. Gene model intronless.
# augustus --species=laccaria_bicolor --progress=true --strand=both --genemodel=intronless ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_intronless_proof.gff
augustus --species=laccaria_bicolor --progress=true --strand=both --genemodel=intronless ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/augustus_predictions/Laccaria_bicolor_S238N_H82_intronless_proof.gff
##Obtain the fasta aa
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_intronless.gff
### 1 output: Laccaria_bicolor_S238N_H82_intronless.aa
##Number of predicted genes
grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_intronless.aa | wc -l
#no. genes 18116

##4th prediction. Gene model atleastone.
# augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=atleastone ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_atleastone.gff
augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=atleastone ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/augustus_predictions/Laccaria_bicolor_S238N_H82_atleastone.gff
##Obtain the fasta aa
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_atleastone.gff
### 1 output: Laccaria_bicolor_S238N_H82_atleastone.aa
##Number of predicted genes
grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_atleastone.aa | wc -l 
#no. genes 19276

##5th prediction. Gene model exactlyone.
# augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=exactlyone ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_exactlyone.gff
augustus --species=laccaria_bicolor --progress=true --singlestrand=true --genemodel=exactlyone ../data/Gene_prediction/Laccaria_bicolor_S238N_H82.fna > ../data/Gene_prediction/augustus_predictions/Laccaria_bicolor_S238N_H82_exactlyone.gff
##Obtain the fasta aa
/usr/share/augustus/scripts/getAnnoFasta.pl ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_exactlyone.gff
### 1 output: Laccaria_bicolor_S238N_H82_exactlyone.aa
##Number of predicted genes
grep -o ">" ../data/Gene_prediction/AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82_exactlyone.aa | wc -l 
#no. genes 1013
```

```bash
# Searching MiSSPs matches in ~Laccaria~ predictions
# Executional script: Blastp.sh
# Elena Flores Callejas
# June 2022

#Place in bin
cd /home/eflores/TGFH/Sesion2/bin/
#Make a directory for the results
mkdir ../out
mkdir ../out/Gene_prediction
# mkdir ../out/Gene_prediction/blastp_predictions
mkdir ../out/Gene_prediction/BLASTp_predictions
#Make a directory or the data | copy all the aminoacids predictions into it
mkdir ../data/Gene_prediction/AUGUSTUS_aa_predictions/
cd ../data/Gene_prediction/AUGUSTUS_aa_predictions/
cp ../AUGUSTUS_predictions/Laccaria_bicolor_S238N_H82*.aa .
#Go back to bin
cd ../../../bin/
#Make a list of the prediction files names 
nano ../data/Gene_prediction/list_blastp.txt

Laccaria_bicolor_S238N_H82_atleastone.aa
Laccaria_bicolor_S238N_H82_complete.aa
Laccaria_bicolor_S238N_H82_exactlyone.aa
Laccaria_bicolor_S238N_H82_intronless.aa
Laccaria_bicolor_S238N_H82_partial.aa
  
#Running bulk
for predictions in $(cat ../data/Gene_prediction/list_blastp.txt); do
	for MiSSPs in $(cat ../data/Gene_prediction/list_MiSSPs.txt); do

    #Create database and specify subject data type (prot)
    makeblastdb -in ../data/Gene_prediction/AUGUSTUS_aa_predictions/$predictions -dbtype prot    

    #Run blastp where query is an ".faa" and subject an ".faa" as well
    # blastp -db ../data/Gene_prediction/AUGUSTUS_aa_predictions/$predictions -query ../data/Gene_prediction/MiSSPs_data/$MiSSPs.faa -out ../out/Gene_prediction/blastp_predictions/$MiSSPs.$predictions.m7 -outfmt 7 -evalue 0.0001
	blastp -db ../data/Gene_prediction/AUGUSTUS_aa_predictions/$predictions -query ../data/Gene_prediction/MiSSPs_data/$MiSSPs.faa -out  ../out/Gene_prediction/BLASTp_predictions/$MiSSPs.$predictions.m7 -outfmt 7 -evalue 0.0001

	done
done
```

```bash
# Searching MiSSP7 matches in ~Laccaria~ proteomes
# Data mining script: Blastp_mining.sh
# Elena Flores Callejas
# Abril 2021

#Create a directory for the blastp hits of each MiSSPs
# mkdir ../out/Gene_prediction/blastp_predictions/MiSSPs_blastphits
 mkdir ../out/Gene_prediction/BLASTp_predictions/MiSSPs_blastphits 

#Bulk for creating the blastp hits files
for MiSSPs in $(cat ../data/Gene_prediction/list_MiSSPs.txt); do
  #create summary tables of data with hits by MiSSPs information  
   # grep 'hits' ../out/Gene_prediction/blastp_predictions/*.m7 | sort -u | cut -d "/" -f5 | grep "^$MiSSPs"| sed 's/$MiSSPs//g'| sed 's/.aa.m7//g' > ../out/Gene_prediction/blastp_predictions/MiSSPs_blastphits/$MiSSPs.blastphits.txt 
   grep 'hits' ../out/Gene_prediction/BLASTp_predictions/*.m7 | sort -u | cut -d "/" -f5 | grep "^$MiSSPs"| sed 's/$MiSSPs//g'| sed 's/.aa.m7//g' > ../out/Gene_prediction/BLASTp_predictions/MiSSPs_blastphits/$MiSSPs.blastphits.txt
   #Filter the standard output using a patron | sort and filter unique data | keep only the desired columns and overwrite the table obtained in a new results file
done 
```

##### Summary table

```bash
# less -S ../out/Gene_prediction/blastp_predictions/MiSSPs_blastphits/$MiSSPs.blastphits.txt 
less -S ../out/Gene_prediction/BLASTp_predictions/MiSSPs_blastphits/$MiSSPs.blastphits.txt 
```

<img src="/home/elena/Proyecto_tesis_Laccaria/image.png" style="zoom:60%;" />

#### REFERENCIAS

- Stanke, M. (n.d.). *Augustus: gene prediction*. AUGUSTUS: Gene Prediction. Retrieved June 10, 2022, from http://bioinf.uni-greifswald.de/augustus/
- Stanke, M. (2021, July). *Augustus/RUNNING-AUGUSTUS.md at master · Gaius-Augustus/Augustus*. GitHub. Retrieved June 10, 2022, from https://github.com/Gaius-Augustus/Augustus/blob/master/docs/RUNNING-AUGUSTUS.md
- Stanke, M. (2015, June). *Predicting Genes with AUGUSTUS*. Predicting Genes with AUGUSTUS. Retrieved June 10, 2022, from https://vcru.wisc.edu/simonlab/bioinformatics/programs/augustus/docs/tutorial2015/prediction.html
- Stanke, M., Keller, O., Gunduz, I., Hayes, A., Waack, S., & Morgenstern, B. (2006). *AUGUSTUS: ab initio prediction of alternative transcripts. Nucleic Acids Research, 34(Web Server), W435–W439.* doi:10.1093/nar/gkl200
