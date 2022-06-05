# Sesión 2: Práctica de anotación: Funanotate
*Elena Flores, Rodolfo Ángeles y Christian Quintero, Junio 2022*

## Estructura de la sesión

* Genomica de hongos ftopatógenos (REAA)
	* descanso
* Ensamble genómico (REAA)
* Predicción de genes (EFC)
	* descanso
* Anotación funcional (REAA)
* Clusters biosintéticos (CAQC)

## Genomica de hongos ftopatógenos
Ver la presentación.

## Ensamble genómico

## Predicción de genes

## Anotación funcional
### Definición
Con "anotación funcional" nos referimos a un grupo grande y heterogeno de acciones para asignar funciones a los modelos genéticos (y a otras cosas) de un ensamble genómico o transcriptómico.
Usarémos el pipeline [Funannotate](https://funannotate.readthedocs.io/en/latest/index.html).

Funannotate es un *pipeline* de predicción, anotación y comparación de genomas.

Originalmente se escribió para anotar genomas fúngicos (pequeños eucariotas ~30 Mb), pero se puede usar para genomas (euk) más grandes.

Tienen el principal objetivo de anotar con precisión y facilidad para enviar a NCBI GenBank.

Funannotate es también una plataforma ligera de genómica comparativa. Los genomas a los que se les ha agregado una anotación funcional a través del comando `funannotate annotate` se pueden comparar usando `funannotate compare` que genera comparaciones de genoma completo basadas en html. Funannotate hace agrupaciones ortólogas, filogenias de genoma completo, análisis de enriquecimiento de Gene Ontology, y calcula proporciones dN/dS para grupos de ortólogos bajo selección positiva.

Funannotate tiene muchas (muuuchas) dependencias y, por lo tanto, la instalación es la parte más difícil. Hay varias alternativas, el contenedor de Docker y el ambiente conda traen pre-compiladas las dependencias. Tambien se pueden instalar soo los scripts de funannotate con python pip y luego instalar cada una de las dependencias (pero mejor no).

### Intalación
```
#Installing funannotate in biogen server by usin mamba

#instaling mamba
conda install -n base mamba
#creating env
mamba create -n funannotate funannotate
#activating env
conda activate funannotate
#sownload and setup DB
funannotate setup -d /home/rangeles/binlike/funannotate_db
echo "export FUNANNOTATE_DB=/home/rangeles/binlike/funannotate_db" > /home/rangeles/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
echo "unset FUNANNOTATE_DB" > /home/rangeles/.conda/envs/funannotate/etc/conda/deactivate.d/funannotate.sh

#checking al phats and dependences
funannotate check --show-versions

```
```
Algunas dependencias no están:
	ERROR: Bio::Perl not installed, install with cpanm Bio::Perl
	ERROR: FUNANNOTATE_DB not set. export FUNANNOTATE_DB=/path/to/dir
	ERROR: GENEMARK_PATH not set. export GENEMARK_PATH=/path/to/dir
	ERROR: emapper.py not installed
	ERROR: gmes_petap.pl not installed
	ERROR: signalp not installed
```

```
##Set some missing dependences
cpanm Bio::Perl
#get the academic licence of SignalP v6, and install
#download, decompres and:
#create pithon env
python3 -m venv signalp-6-package/
#install signalp in the env
sudo pip3 install signalp-6-package/
#set bd paths
SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )

```
### Limpieza del ensamble

Antes de anotar un ensamble hay que limpiarlo un poco.

* Eliminar pequeños contigs repetitivos

`funannotate clean`usa minimap2 para alinear contigs/scaffolds cortos contra el resto del ensamble, para así determinar si es repetitivo. El script recorre los contigs comenzando con el más corto y avanza hasta el N50.

* Clasificar y cambiar los headers

NCBI pide headers de 16 caracteres; Augustus también tiene problemas con headers largos. `funannotate sort` ordena el ensamble por longitud y luego cambia el nombre de los fasta headers.

* Enmascarar

El predeterminado de `funannotate mask`  es enmascarar con tantan. "Softmasking" es donde las repeticiones se representan con letras minúsculas y todas las regiones no repetitivas son letras mayúsculas.

***EJECUCIÓN***

Situarnos en $HOME/Sesion2/bin

```
cd
cd TGFH/Sesion2/bin
```
Limpieza del ensamble con funannotate

```
# 1.1 clear repeated contigs
    funannotate clean -i ../data/O.polymorpha_NCYC495.fna -o ../out/O.polymorpha_NCYC495.clean.fna
# 1.2 sort and relabel headers
    funannotate sort -i ../out/O.polymorpha_NCYC495.clean.fna -o ../out/O.polymorpha_NCYC495.clean.sort.fna
# 1.3 softmasking with tantan
    funannotate mask --cpus 20 -i ../out/O.polymorpha_NCYC495.clean.sort.fna -o ../out/O.polymorpha_NCYC495.clean.sort.mask.fna

#delete tmp files
    rm ../out/O.polymorpha_NCYC495.clean.fna ../out/O.polymorpha_NCYC495.clean.sort.fna
```

### Predicción de genes
La predicción de genes en funannotate se debe parametrizar atendiendo a la información con la que se cuenta.

En el núcleo del algoritmo de predicción se encuentra el Evidence Modeler, que toma las predicciones hechas por diferentes programas y genera modelos de genes de consenso.

Los predictores de genes *ab initio* son Augustus, snap, glimmerHMM, CodingQuarry y GeneMark-ES/ET (opcional debido a la licencia). Es importante dar "evidencia" a los predictores.


***EJECUCIÓN***
```

funannotate predict \
    -i ../out/O.polymorpha_NCYC495.clean.sort.mask.fna \
    -o ../out/O.polymorpha_NCYC495 \
    -s O.polymorpha_NCYC495 \
    --isolate XXX \
    --name O.polymorpha_NCYC495 \
    --ploidy 1 \
    --protein_evidence ../data/Protein_models.faa \
    --cpus 28
```


## Clusters biosintéticos




