# Sesión 2: Práctica de anotación: Funanotate
*Rodolfo Ángeles, Junio 2022*

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

### Installing
```
#Instaling funannotate in biogen server by usin mamba

#instaling mamba
conda install -n base mamba
#creating env
mamba create -n funannotate funannotate
#activating env
conda activate funannotate
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
#Set some missing dependences
cpanm Bio::Perl

```

## Clusters biosintéticos






\\\\\\\\\\\\\\\\

Descargué desde chrome los `*.gz` de 7 unmazked asem de levaduras y las puse en mi `/REAnAr/[...]/TGFH/Sesion2/data/`.

Usando git sincronizo el repo con github y luego lo clono a chichen

Quast

push -u origin master desde chichen

[token](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)

```
ln -s Sacch/Canalb1_AssemblyScaffolds.fasta C.albicans_SC5314.fna
ln -s Sacch/Picpa1_AssemblyScaffolds.fasta P.pastoris_GS115.fna
ln -s Sacch/Sacarb1_AssemblyScaffolds.fasta S.arboricola_H6.fna
ln -s Sacch/Saceu1_AssemblyScaffolds.fasta S.eubayanus_FM1318.fna
ln -s Sacch/SacceM3707_1_AssemblyScaffolds.fasta S.cerevisiae_M3707.fna
ln -s Sacch/SacceM3836_1_AssemblyScaffolds.fasta S.cerevisiae_M3836.fna
ln -s Sacch/Sacce1_AssemblyScaffolds.fasta S.cerevisiae_S288C.fna
```


`nohup sh clean.sh > clean.nohup.log &`

`nohup sh predict.sh > predict.nohup.log &
`


