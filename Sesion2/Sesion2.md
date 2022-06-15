# Sesión 2: Ensamble, anotación y homología
*Elena Flores, Rodolfo Ángeles y Christian Quintero*

Junio 2022



**Estructura de la sesión**

* Genomica de hongos ftopatógenos (REAA)
	* descanso
* Ensamble genómico (REAA)
* Predicción de genes (EFC)
	* descanso
* Anotación funcional (REAA)
* Clusters biosintéticos (CAQC)

## Genómica de hongos fitopatógenos
Ver la presentación.

Ensamble genómico

Para iniciar con la práctica obtengamos los materiales.

    #go to the server
    ssh rangeles@132.248.248.175
    #enter pw
    #your prompt must look like:
    #(base) rangeles@biogen:~$
    #if not tipe
    conda init #activate conda base and rest the shell
    exit
    ssh rangeles@132.248.248.175
    #enter pw
    
    #get all data and code for the workshor
    git clone https://github.com/Rodolfo47/TGFH
    #get in and check the code
    cd TGFH/Session2/bin; ls

Dependencias

Conda

SPAdes

Quast

FastQC

trimseq



Activar el ambiente conda del ensamblador Spades

    #Installing with conda
    conda install -c bioconda spades
    spades -h
    mamba create -n quast quast
    quast -h

Ver la calidad y limpiar

FastQC

    #run fastQC analyses
    fastqc -o fastQC -f fastq ../data/Hv6.1.fastq ../data/Hv6.2.fastq
    #watch plots from my local compu
    ##remember change user name
    cd
    scp -r rangeles@132.248.248.175:/home/rangeles/TGFH/Sesion2/data/fastQC .

Limpieza

    #clean raw data
    trimseq --help
    trimseq ../data/Hv6.1.fastq ../data/Hv6.1.trim.fq -window 5 -percent 50 -strict -osformat2 fastq
    trimseq ../data/Hv6.2.fastq ../data/Hv6.2.trim.fq -window 5 -percent 50 -strict -osformat2 fastq

Ensamblar un genoma deamentis con unos pequeños datos

    #create out dir
    mkdir ../out/spadesHv
    #run spades
    spades.py \
        -1 ../data/Hv6.1.fastq \
        -2 ../data/Hv6.2.fastq \
        --careful \
        -t 4 \
        -k 31,41,51,61,71 \
        -o ../out/spadesHv
        
    #ran in seconds

Deberíamos haber usado las lecturas limpias en lo de arriba pero:

    == Error ==  system call for: "['/usr/lib/spades/bin/spades-hammer', '/home/rangeles/TGFH/Sesion2/out/spades/corrected/configs/config.info']" finished abnormally, err code: 255

Arreglarlo creo así https://github.com/rrwick/Unicycler/issues/152



Ensamblar un genoma de levadura

    #in real word you must to evaluate the quality and clean/trimm prior to assembling
    #make out dir
    mkdir ../out/spadesYeast
    #run spades
    spades.py \
        -1 ../data/reads.R1.fq \
        -2 ../data/reads.R2.fq \
        --careful \
        -t 4 \
        -k 31,41,51,61,71 \
        -o ../out/spadesYeast
    #07:12:01
    #

Revisar los resultados de mi nuevo ensamble

    #wake up quast
    conda activate /home/rangeles/.conda/envs/quast
    #run quast for my new assemblies
    quast ../out/spadesHv/contigs.fasta ../out/spades/scaffolds.fasta  ../out/spadesYeast/scaffolds.fasta
    #run quast for all the yeast assemblies to be used in annotation practicing
    quast ../data/*.fna






## Predicción de genes

Ver `~/TGFH/Sesion2/USO_DE_AUGUSTUS.md`

Después de clonarse el repo usar las lineas de abajo para copiarse los archivos pesados que faltan

```sh
cd; cp -r ../eflores/TGFH/Sesion2/data/Gene_prediction/L.b_S238N_H82/ TGFH/Sesion2/data/Gene_prediction/.
```



## Anotación funcional

### Definición
Con "anotación funcional" nos referimos a un grupo grande y heterogeno de acciones para asignar funciones a los modelos genéticos (y a otras cosas) de un ensamble genómico o transcriptómico. Por lo general involucra 3 pasos principales ([Grigoriev *et al.* 2006](https://www.sciencedirect.com/science/article/pii/S1874533406800080); [Haas *et al.* 2011](https://www.tandfonline.com/doi/full/10.1080/21501203.2011.606851); [Haridas *et al.* 2018](https://link.springer.com/protocol/10.1007/978-1-4939-7804-5_15)).

1. Identificar características/regiones no codificantes del genoma.
2. Identificar genes que codifican proteínas (predicción).
3. Adjuntar información biológica (anotación), ej: dominios [pfam](https://pfam.xfam.org/) y nombres descriptivos.

Hay varios *pipelines* para la anotación de genomas de hongos ([FunGAP](https://academic.oup.com/bioinformatics/article/33/18/2936/3861332?login=true), [BRAKER1](https://academic.oup.com/bioinformatics/article/32/5/767/1744611?login=true), [CodingQuarry](https://link.springer.com/article/10.1186/s12864-015-1344-4)).

Hoy usaremos [Funannotate](https://funannotate.readthedocs.io/en/latest/index.html).

Funannotate es un *pipeline* de predicción, anotación y comparación de genomas.

Originalmente se escribió para anotar genomas fúngicos (pequeños eucariotas ~30 Mb), pero se puede usar para otros genomas (euk) más grandes.

Tienen el principal objetivo de anotar con precisión y facilidad para enviar a NCBI GenBank (`*.gbk`).

Funannotate es también una plataforma ligera de genómica comparativa. Los genomas a los que se les ha agregado una anotación funcional (con el comando  `funannotate annotate`) se pueden comparar usando `funannotate compare`, que genera un  `*.html` de resumen.

Funannotate hace agrupaciones de ortólogos, filogenias de genoma completo, análisis de enriquecimiento de [GO](http://geneontology.org/), y calcula proporciones dN/dS para grupos de ortólogos bajo selección positiva.

Funannotate tiene muchas (muuuchas) dependencias y, por lo tanto, la instalación es la parte más difícil. Hay varias alternativas: el contenedor de [Docker](https://www.docker.com/resources/what-container/) y el ambiente [conda](https://docs.conda.io/projects/conda/en/latest/) traen pre-compiladas las dependencias. Tambien se pueden instalar soo los scripts de funannotate con python pip y luego instalar cada una de las dependencias (pero mejor no).



### Dependencias

[Funannotate](https://funannotate.readthedocs.io/en/latest/index.html)

[Augustus](https://bioinf.uni-greifswald.de/augustus/)

[InterProScan](https://interproscan-docs.readthedocs.io/en/latest/index.html)



> ### Instalación
>
> Saltamos la instalación
>
> ```sh
> #Installing funannotate in biogen server by usin mamba
> #activar conda
> conda init
> #cerrar y abrir el shell
> 
> #installing mamba
> conda install -n base mamba
> #creating env
> mamba create -n funannotate funannotate
> #activating env
> conda activate funannotate
> 
> #download and setup DB
> funannotate setup -d /home/rangeles/binlike/funannotate_db
> export FUNANNOTATE_DB=/home/rangeles/binlike/funannotate_db
> echo "export FUNANNOTATE_DB=/home/rangeles/binlike/funannotate_db" > /home/rangeles/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
> echo "unset FUNANNOTATE_DB" > /home/rangeles/.conda/envs/funannotate/etc/conda/deactivate.d/funannotate.sh
> 
> #solving some augustus compilation issue
> conda remove augustus -n funannotate --force
> #next line every time you login
> export AUGUSTUS_CONFIG_PATH="/usr/share/augustus/config"
> augustus/config"
> 
> #checking all paths and dependences
> funannotate check --show-versions
> 
> ##Set some missing dependences
> cpanm Bio::Perl
> #get the academic licence of SignalP v6, and install
> #download, decompres and:
> #create pithon env
> python3 -m venv signalp-6-package/
> #install signalp in the env
> sudo pip3 install signalp-6-package/
> #set bd paths
> SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
> ```



### Limpieza del ensamble

Antes de anotar un ensamble hay que limpiarlo un poco.

* Eliminar pequeños contigs repetitivos

`funannotate clean` usa [minimap2](https://academic.oup.com/bioinformatics/article/34/18/3094/4994778) para alinear contigs/scaffolds cortos contra el resto del ensamble, para así determinar si es repetitivo. El script recorre los contigs comenzando con el más corto y avanza hasta el [N50](https://es.wikipedia.org/wiki/Estad%C3%ADstico_N50).

* Clasificar y cambiar los headers

NCBI pide headers de 16 caracteres; Augustus también tiene problemas con headers largos. `funannotate sort` ordena el ensamble por longitud y luego cambia el nombre de los fasta headers.

* Enmascarar

El predeterminado de `funannotate mask`  es enmascarar con tantan. "Softmasking" es donde las repeticiones se representan con letras minúsculas y todas las regiones no repetitivas son letras mayúsculas.

<u>***EJECUCIÓN***</u>

> Situarnos en $HOME/TGFH/Sesion2/bin
>
> ```sh
> cd; cd TGFH/Sesion2/bin
> ```
> > Si no has activado el ambiente funannotate:
> >
> > ```sh
> > conda activate /home/rangeles/.conda/envs/funannotate
> > export FUNANNOTATE_DB=/home/rangeles/binlike/funannotate_db
> > export AUGUSTUS_CONFIG_PATH="/usr/share/augustus/config"
> > ```

Limpieza del ensamble con funannotate

```bash
# 0 create output directori to stor my preliminar results
mkdir ../out
# 1.1 clear repeated contigs
funannotate clean \
	-i ../data/O.polymorpha_NCYC495.fna \
	-o ../out/O.polymorpha_NCYC495.clean.fna
# 1.2 sort and relabel headers
funannotate sort \
	-i ../out/O.polymorpha_NCYC495.clean.fna \
	-o ../out/O.polymorpha_NCYC495.clean.sort.fna
# 1.3 softmasking with tantan
funannotate mask \
	-i ../out/O.polymorpha_NCYC495.clean.sort.fna \
	-o ../out/O.polymorpha_NCYC495.clean.sort.mask.fna \
	--cpus 4 

#delete tmp files
rm ../out/O.polymorpha_NCYC495.clean.fna ../out/O.polymorpha_NCYC495.clean.sort.fna
```

El tiempo de ejecución de este paso es dependiente de la calidad del ensamble. Cada contig adicional multiplica el numero de mapeos por el N50. Por lo que es recomendable quitar de nuestro ensamble toda la padecería (<1000 b).



### Predicción de genes

> Si no corriste los pasos de limpieza, puedes traer los resultados con estas líneas:
>
> ```sh
> cd; cp -r ../rangeles/TGFH/Sesion2/old/out/O.*clean.sort.mask.fna TGFH/Sesion2/out
> ```

La predicción de genes en Funannotate se debe parametrizar atendiendo a la información con la que se cuenta.

En el núcleo del algoritmo de predicción es [Evidence Modeler](https://evidencemodeler.github.io/), que toma las predicciones *ab initio* hechas por diferentes programas para combinarlas con la evidencia que se le da y genera modelos de genes consenso.

Los predictores de genes *ab initio* son [Augustus](https://bioinf.uni-greifswald.de/augustus/), [snap](https://github.com/KorfLab/SNAP), [glimmerHMM](https://ccb.jhu.edu/software/glimmerhmm/man.shtml), [CodingQuarry](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-015-1344-4) y [GeneMark-ES/ET](http://exon.gatech.edu/GeneMark/) (opcional debido a la licencia). Es importante dar "evidencia" a los predictores.

<u>***EJECUCIÓN***</u>

> Situarnos en `/$HOME/$USR/TGFH/Sesion2/bin`
>
>
> ```sh
> cd; cd TGFH/Sesion2/bin
> ```
> 

Predecir usando de proteínas como evidencia.

```sh
#prediction step
funannotate predict \
	-i ../out/O.polymorpha_NCYC495.clean.sort.mask.fna \
	-o ../out/O.polymorpha_NCYC495 \
	-s O.polymorpha_NCYC495 \
	--isolate XXX \
	--name O.polymorpha_NCYC495 \
	--ploidy 1 \
	--protein_evidence ../data/Protein_models.faa \
	--cpus 4
## Jun 11 04:26 PM
## Jun 11 07:14 PM
### Took <3 hours
```

Hay muchas maneras de usar el script `funannotate predict`. En el ejemplo usamos como evidencia un `.faa` pero se le puede dar transcritos, tablas de anotación, genes, etc...

Las salidas las guarda en el directorio `[...]/predict_results/`, son varios archivos:

| **File Name**                   | **Description**                              |
| ------------------------------- | -------------------------------------------- |
| Basename.gbk                    | Annotated Genome in GenBank Flat File format |
| Basename.tbl                    | NCBI tbl annotation file                     |
| Basename.gff3                   | Genome annotation in GFF3 format             |
| Basename.scaffolds.fa           | Multi-fasta file of scaffolds                |
| Basename.proteins.fa            | Multi-fasta file of protein coding genes     |
| Basename.transcripts.fa         | Multi-fasta file of transcripts (mRNA)       |
| Basename.discrepency.report.txt | tbl2asn summary report of annotated genome   |
| Basename.error.summary.txt      | tbl2asn error summary report                 |
| Basename.validation.txt         | tbl2asn genome validation report             |
| Basename.parameters.json        | ab-initio training parameters                |

> Tardaría mucho: matamos el proceso.
>
> Para matar el proceso se hace `ctrl+c`.
>
> > Copia los resultados de la predicción con estas líneas:
> >
> > ```sh
> > #create directory for this sample
> > cd; mkdir TGFH/Sesion2/out/O.polymorpha_NCYC495
> > #get Ogataea predictions
> > cp -r ../rangeles/TGFH/Sesion2/old/out/O.polymorpha_NCYC495/predict_* TGFH/Sesion2/out/
> > ```



### Anotación funcional

En Funannotate la anotación son 3 pasos:

1. Uso de anotadores en linea
2. Uso de InterProScan
3. Uso de `funannotate annotate` con muchas bases de datos y anotadores

<u>***EJECUCIÓN***</u>

> Situarnos en `/$HOME/$USR/TGFH/Sesion2/bin`
>
>
> ```sh
> cd; cd TGFH/Sesion2/bin
> ```

Solicitar a los servidores remotos de [Phobius](https://phobius.sbc.su.se/) y [AntiSmash](https://fungismash.secondarymetabolites.org/#!/start) sus anotaciones.

```sh
funannotate remote \
	-m all \
	-e rodolfo.angeles.argaiz@gmail.com \
	-i ../out/O.polymorpha_NCYC495 \
	--force
```

El tiempo de ejecución de `funannotate remote`es muy variable pues depende de la carga de los servidores remotos.



Usar [InterProScan](https://www.ebi.ac.uk/interpro/search/sequence/) para obtener IPRs. Hay un par de opciones:

- Cuando instalamos funannotate con docker se puede usar el comando `funannotate -iprscan`.
- Como usamos un funannotate instalado con conda (mamba) tenemos que correrlo (e instalarlo) de manera independiente.

> Ya lo tenemos instalado en BioGen, lo instalamos así:
>
> ```sh
> #install and test interpro
> ##get the tar ball
> wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.56-89.0/interproscan-5.56-89.0-64-bit.tar.gz --no-check-certificate
> ##get the md5sum to check the correct download
> wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.56-89.0/interproscan-5.56-89.0-64-bit.tar.gz.md5
> #checking
> md5sum -c interproscan-5.56-89.0-64-bit.tar.gz.md5
> ##uncompress
> tar -pxvzf interproscan-5.56-89.0-*-bit.tar.gz
> ##install
> cd interproscan-5.56-89.0/
> python3 initial_setup.py
> ##test iprs
> ./interproscan.sh -i test_all_appl.fasta -f tsv -dp
> ```

Anotar con InterProScan

```sh
#set interpro to my $PATH
export PATH=$PATH:/home/rangeles/binlike/my_interproscan/interproscan-5.56-89.0
mkdir ../out/interproscan
#run interpro
interproscan.sh \
	-i ../out/O.polymorpha_NCYC495/predict_results/*.proteins.fa \
	-f xml -iprlookup -dp \
	-d ../out/interproscan \
	-cpu 4
## Start time: 07/06/2022 00:48:01:280
## Finish time: 07/06/2022 04:54:40:608
### Took 4 hours
```

> Copiar los resultados de Interpro para Ogataea
>
> ```sh
> #go home
> cd; cp ../rangeles/TGFH/Sesion2/old/out/interproscan/O.* TGFH/Sesion2/out/interproscan
> # back to bin
> cd TGFH/Sesion2/bin
> ```

Actualizar la db.

```sh
#check for yeasts busco db
#display db
funannotate database
#choose suitable db
funannotate database --show-buscos
#look in `funannotate_db/ 
ls ../../../binlike/funannotate_db/
#get saccharomycetales BUSCOS 
funannotate setup -b saccharomycetales

#update all dbs
funannotate setup -i all -d $HOME/funannotate_db --force
## Start time: Jun 12 03:03 PM
## Finish time: Jun 12 03:21 PM
### Took 18 minutes
```

Ejecutar `funannotate annotate`

```sh
#Run funannotate annotation with saccharomycetales buscos
funannotate annotate \
	-i \../out/O.polymorpha_NCYC495 \
  --iprscan ../out/interproscan/O.polymorpha_NCYC495*.xml \
  --busco_db saccharomycetales \
  --cpus 4
  
## Start time: Jun 07 01:32 PM
## Finish time: Jun 07 01:42 PM
### Took 10 minutes

#By using 60 cores just took 3 mins
```



### Genómica comparada

Para usar el script de comparación `funannotate compare` se ocupan varios genomas.

> Usé los scripts de `~/TGFH/Sesion2/bin/` para procesar los genomas de otras 7 levaduras.
>
> muestra | genoma Mbps | contigs | N50 Mbps
>
> - *Candida albicans* SC5314 |   |   |
> - *Ogataea polymorpha* NCYC 495  |   |   |
> - *Pichia pastoris* GS115 |   |   |
> - *Saccharomyces arboricola* H6 |   |   |
> - *Saccharomyces cerevisiae* M3707 |   |   |
> - *Saccharomyces cerevisiae* M3836 |   |   |
> - *Saccharomyces cerevisiae* S288C |   |   |
> - *Saccharomyces eubayanus* FM1318 |   |   |
>
> **Limpieza**
>
> ```sh
> nohup sh 1_clean.sh > 1_clean.nohup.log &
> #Sat 04 Jun 2022 08:41:20 PM CDT
> #Sat 04 Jun 2022 08:42:32 PM CDT
> ## Took <2 mins
> ```
>
> ```sh
> #check out the script
> cd; cd TGFH/Sesion2/bin/
> less -S 1_clean.sh
> #check out the log
> less -S 1_clean.nohup.log
> ```
>
> **Predicción**
>
> ```sh
> nohup sh 2_predict.sh > 2_predict.nohup.log &
> #lun 06 jun 2022 15:29:21 CDT
> #lun 06 jun 2022 21:20:24 CDT
> ## Took >6 hours
> ```
>
> ```shell
> #check out the script
> less -S 2.predict.sh
> #check out the log
> less -S 2.predict.nohup.log
> ```
>
> **Anotación**
>
> ```sh
> nohup sh 3_annotate.sh > 3_annotate.nohup.log &
> #mar 07 jun 2022 15:04:36 CDT
> #mié 08 jun 2022 02:20:27 CDT
> ## Took >11 hours
> ```
>
> ```sh
> #check out the script
> less -S 3_annotate.sh
> #check out the log
> less -S 3_annotate.nohup.log
> ```
>
> **Comparación**
>
> ```sh
> nohup sh 4_compare.sh > 4_compare.nohup.log &
> #[Jun 08 02:41 PM]
> #[Jun 10 04:35 AM]
> ## >2 days
> ```
>
> ```sh
> #check out the script
> less -S 4_compare.sh
> #check out the log
> less -S 4_compare.nohup.log
> ```
>
> Hizo casi todas las comparaciones las hizo en 2 minutos
>
> Pero tardó un día en el análisis de enriquecimiento de GOs
>
> y un día en la filogenia



<u>***EJECUCIÓN***</u>

> Para copiar los resultados de las anotaciones de todas las levaduras copia y pega estas líneas de código:
>
> ```sh
> cd; cd TGFH/Sesion2/bin
> cp -r ../../../../rangeles/TGFH/Sesion2/old/out/*.*_* ../out/	
> ```

Ejecutar funannotate compare con el script

```sh
#run 
nohup sh 4_compare.sh > 4_compare.nohup.new.log &
# kill the process
kill $PROCESS_ID_NO.
```

```sh
#!bin/sh
#Compare yeasts genomes with funannotate
#Rodolfo Angeles, june 2022

#add salple prefix in the .gbk
for smpl in $(cat list2fun.txt); do
	cd ../out/$smpl/annotate_results
	sed -i 's/FUN_/$smpl/g' *.gbk
	cd ../..
done
#
mkdir fun_yeasts.compare ../res/
#funannotate compare
#caution!
#this script will compare all annotate_results
#placed in the `../out/` dir
funannotate compare \
-i ../out/*/annotate_results/*.gbk \
-o fun_yeasts.compare \
--run_dnds estimate \
--cpus 55

mv fun_yeasts.* ../res/
#END
```

Para explorar los resultados de la comparación primero usa estas lineas:

```sh
#go home
cd
#get file from rangeles usr
cp ../rangeles/TGFH/Sesion2/old/res/fun_yeasts.compare.tar.gz TGFH/Sesion2/res
#go tu results dir
cd TGFH/Sesion2/res
#uncompress
tar -xvf fun_yeasts.compare.tar.gz
```



Desde una terminal local (en tu compu, no en el servidor)

```sh
#go to your local desktop
cd
cd Desktop
#get compressed files
scp $USER_NAME@132.248.248.175:/home/$USER_NAME/TGFH/Sesion2/res/fun_yeasts.compare.tar.gz
#uncompress
tar -xvf fun_yeasts.compare.tar.gz
##if last line dont work try uncompressing by clicking
#ver el .html con un navegador
firefox fun_yeasts.compare/index.html
```



## Clusters biosintéticos



