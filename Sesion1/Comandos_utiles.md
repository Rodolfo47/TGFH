## Introducción a linux para bioinformática


##### Sistema de ficheros

El sistema de ficheros está constituido principalmente por los siguientes directorios:

- `/` - raiz del directorio virtual
- `/bin` - directorio de binarios, donde se almacenan la mayor parte de los programas de GNU/Linux.
- `/etc` - configuración del sistema de directorio de archivos.
- `/home` - directorio home, donde Linux crea los directorios de usuarios.
- `/lib` - directorio de librerías, donde se almacenan librerías del sistema y de aplicaciones.
- `/media` - directorio de media, un lugar común para puntos de montaje de dispositivos extraibles.
- `/sys` - directorio de sistema, donde se almacena información del sistema de hardware.
- `/tmp` - directorio temporal, donde se crean y destruyen archivos temporales de trabajo.
- `/usr` - directorio binario de usuario, donde se guardan los programas ejecutable de usuario.
- `/var` - directorio variable, para archivos que cambian frecuentemente,como archivos de registro. 

Antes de los sistemas gráficos, la única manera de interactuar con los sistemas Linux era a través de texto en una interfaz de linea de comandos (CLI) provista por el shell.

##### Shell

El shell es un programa que toma los comandos del teclado y los comunica al sistema operativo para que se lleven a cabo. La mayoría de las distribuciones Linux proporcionan un programa shell del GNU Project llamado bash.

* Es importante distinguir entre `/home/cyntia`, `/Home/cyntia/`, `/home/cyntia/`

* Linux es sensible a mayúsculas y minúsculas
  Los archivos personales de usuario a menudo se encuentran en `/home/my-user-name`.

Existen muchas maneras de localizarlos o de referir al directorio home.

- `cd` : Sin argumentos, el comando cd nos lleva directamente al directorio

  home.

- `$HOME` La variable de entorno HOME contiene el nombre de nuestro directorio home: `echo $HOME`

  El comando `echo` imprime el argumento de la variable `$HOME`
   `~` : Cuando se usa en lugar de directorio, la virgulilla es interpretada por el shell como el nombre del directorio **home**. `echo ~`

### Rutas

**Ruta relativa**: Inicia en el directorio actual

**Ruta absoluta**: Inicia desde la raíz

```shell
. 		 #El directorio dónde estás parado
..       #El directorio arriba en la estructura de directorios
../../   #Dos directorios arriba en la estructura de directorios
~/       #Directorio HOME
```

### Algunos comandos básicos

```shell
hostname #Para saber en donde estamos conectados
whoami  #Usuario con el que estamos conectados
pwd #Muestra la ruta absoluta en la que estamos posicionados
tree #La estructura de los archivos del directorio en donde estamos
ls #Lista los contenidos de un directorio 
mkdir #Crea un directorio
touch #Genera archivos vacios
cd #Cambia de directorio
cp #Copia un archivo o directorio
mv #Mueve un archivo o directorio, también se usa para renombrar archivos o directorios 
rm #Elimina un archivo o directorio
which #Muestra la ruta completa de un comando
locate #Localizar archivos
history #Muestra el historial de comandos
clear #Limpia la pantalla
df #Reporte de espacio en el disco duro
du #Reporta la suma del tamaño de archivos
```

##### Cada comando tiene un manual de uso y regularmente tienen funciones extra denominadas flags (banderas)

```shell
man ls
```

### Atajos en el teclado

**TAB**				                   	 Autocompletar comandos y nombres de archivos

**Flechas arriba y abajo**				   Navegar en la historia de comandos

**Botón derecho del ratón**			  Copiar y pegar texto

**Ctrl+e**											   Ir al final de una línea

**Ctrl+a**                       					    Ir al inicio de una línea

**Ctrl+k**                         				      Borrar una línea

**Ctrl+w**                        					 Elimina una palabra completa, del final al principio

**Ctrl+c**                         					  Abortar la ejecución del último comando

**Ctrl+r+comando**                			Busca en el historial las lineas ejecutadas que contienen el comando  


### Bases de datos

Base de datos: Es una colección organizada de información estructurada, o datos, normalmente
almacenados electrónicamente en un sistema informático.
En bioinformática se utilizan diversas bases de datos, algunos ejemplos son:

De diversos organismos:

NCBI: https://www.ncbi.nlm.nih.gov/

ENSEMBL: https://www.ensembl.org/index.html

UCSC Table Browser: https://genome.ucsc.edu/cgi-bin/hgTables

Dedicadas a organismos específicos:

Ecocyc

Flybase

Wormbase

Especializadas en un tema particular

ENCODE: Elementos funcionales del genoma humano


RegulonDB: Regulación transcripcional de E. coli

Pfam: Familias proteícas

miRBase: Secuencias de miRNA y sus blancos

Base de datos de bases de datos:
https://www.oxfordjournals.org/nar/database/cat/3

### Descargar un genoma

* Link para genomas de referencia NCBI: https://ftp.ncbi.nlm.nih.gov/genomes/refseq/

* Link para el genoma de Raoultella terrigena: https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Raoultella_terrigena/representative/GCF_012029655.1_ASM1202965v1/

Primero vamos a crear nuestro espacio de trabajo

```shell
mkdir Intro
cd Intro
mkdir data results && cd data
```

`&&` permite dar dos instrucciones seguidas sin depender del resultado de la primer instrucción.


* Descarga el genoma representativo de Raoultella terrigena de la Refseq de NCBI

```bash
wget -O Raoultella_terrigena.fasta.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Raoultella_terrigena/representative/GCF_012029655.1_ASM1202965v1/GCF_012029655.1_ASM1202965v1_genomic.fna.gz
#El flag es letra O mayúscula
#Para mobaxterm
wget --no-check-certificate

```

* Descargar el archivo de aminoacidos

```shell
curl https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Raoultella_terrigena/representative/GCF_012029655.1_ASM1202965v1/GCF_012029655.1_ASM1202965v1_protein.faa.gz > Raoultella_terrigena.faa.gz
```

`>` Permite direccionar un resultado a un archivo nuevo. Crea el archivo si no existe y lo sobre escribe si existe

* Descarga el archivo de anotación

```shell
wget -O Raoultella_terrigena.gff.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Raoultella_terrigena/representative/GCF_012029655.1_ASM1202965v1/GCF_012029655.1_ASM1202965v1_genomic.gff.gz
```

* Ahora descarga el archivo md5checksums.txt del directorio genomes/refseq/bacteria/Raoultella terigena de NCBI

```shell
curl https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Raoultella_terrigena/representative/GCF_012029655.1_ASM1202965v1/md5checksums.txt > md5sum_R.terrigena.txt
```

* Regresa al directorio de trabajo

```shell
cd ../
```

* Revisemos la integridad de los archivos

```sh
shasum data/Raoultella_terrigena.fasta.gz
md5sum data/Raoultella_terrigena.fasta.gz
more data/md5sum_R.terrigena.txt
```

Pero si son muchos?

```shell
## 
for gz in $(ls data/*.gz); do md5sum $gz ; done | cut -d ' ' -f1 >> results/md5sum_Rt.txt
```

`>>` Permite redireccionar un resultado en pantalla o un archivo a otro, sin remplazar o
sobreescribir. Crea el archivo si no existe y agrega el nuevo contenido al final, si el archivo
existe.

* Y la integridad?

```shell
# crea un vinculo a un archivo de mi usuario
ln -s /home/dhernandez/extra_data/md5sum_Rt_edit.txt data/
# revisemos si son iguales los id de los archivos
diff data/md5sum_Rt_edit.txt results/md5sum_Rt.txt
```

##### También podríamos descargar todos los archivos de un BioProject de NCBI 

```shell
#fastq-dump --split-files SRR1234567
```

##### Ahora descargaremos y transferiremos un archivo al servidor

* Dirigete a la siguiente liga: https://fungi.ensembl.org/index.html

`scp` Security Copy Shell

``` shell
`scp` [FUENTE][DESTINO]
#FUENTE=Nombre del archivo que quieres transferir
#DESTINO=Ruta de destino
#Ejemplo de mi computadora al servidor:
scp Puccinia_graminis.ASM14992v1.53.gff3.gz dhernandez@132.248.248.175:/home/dhernandez/Intro/data/
#Me pedirá el password
#Funciona de manera inversa si quieres bajar del servidor a tu computadora
scp dhernandez@132.248.248.175:/home/dhernandez/Intro/data/Puccinia_graminis.ASM14992v1.53.gff3.gz .#ojo el
destino puede ser con ruta absoluta o relativa, aquí fue relativa "."
#También puedes usar rsync
`rsync -e ssh` [FUENTE][DESTINO]
# -e ssh indica que nos conectaremos al servidor a través de una conexión de
tipo ssh
```

* Para descomprimir archivos usamos `gunzip`

```shell
#Podemos correr esta linea indicando archivo por archivo
gunzip data/Raoultella_terrigena.faa.gz
#O podemos usar un comodin
gunzip data/*.gz
```

* Podemos ver el archivo con `less`

```shell
less data/Raoultella_terrigena.gff 
# Espacio OR Enter => Navegar hacia abajo
# b OR flecha arriba => Navegar hacia arriba
# /WORD => Búsqueda forward
# n => Siguiente
# ?WORD => Búsqueda backward
# N => Anterior
# G => Ir al final del archivo
# g => Ir al inicio del archivo
-S Mostrar una línea por renglón
```

#### Búsquedas y conteos

`sort` Ordena una serie de líneas

`cut` Corta una sección de cada línea

`uniq` Filtra lineas repetidas

`wc` Cuenta líneas, carácteres y bytes

 `grep` permite buscar patrones, algunas opciones que tiene:
 
**--colour** Marca el texto que corresponde al patrón

**-E** Interpreta el patrón como una expresión regular

**-P** Interpreta el patrón como una expresión regular extendida, tipo Perl

**-f** Lee uno o más patrones a partir de un archivo

**-i** Ignora mayúsculas/minúsculas

**-n** Imprime el número de línea donde se encontró el patrón -

**-v** Selecciona las líneas en donde no ocurre el patrón

**-w** Realiza una búsqueda estricta


El uso de pipe `|` funciona para evitar la escritura o lectura innecesaria de disco, pues los análisis
se llevan a acabo en RAM, un análisis en RAM es más rápido que un proceso de lectura y
escritura. Permite crear tuberías de procesamiento de datos. La salida de un programa es la
entrada de otro.

La diferencia con `&&` es que `|` requiere la salida de una instrucción como entrada de la otra y
`&&` ejecuta instrucciones independientes.

* ¿Cuántos cromosomas tiene *Raoultella terrigena*?

```shell
cut -f1 data/Raoultella_terrigena.gff | sort | uniq -c
#Eliminar encabezado
grep -v "#" data/Raoultella_terrigena.gff | cut -f1 | sort| uniq
```

* ¿En cuáles tipos de features se clasifica el genoma de *R. terrigena*?

```shell
cut -f3 data/Raoultella_terrigena.gff | sort -u
```

* ¿Cuáles son las fuentes de los datos de anotación?

```shell
cut -f2 data/Raoultella_terrigena.gff | sort -u
```

* ¿Cuántos genes y cuántos CDS tiene el genoma de R.terrigena?

```shell
cut -f3 data/Raoultella_terrigena.gff | sort | uniq -c
##
cut -f3-5 data/Raoultella_terrigena.gff | sort -u | cut -f1 | sort | uniq -c
```

* Escribe un archivo de anotación que esté ordenado por cadena y por región genómica

```shell
sort -k7,7 -k4,4n data/Raoultella_terrigena.gff | less -s
sort -k7,7 -k4,4n data/Raoultella_terrigena.gff > results/R.terrigena_strand.gff
```

* ¿Cuántos genes con diferente nombre existen en el genoma de R. terrigena?

```shell
grep "gene" data/Raoultella_terrigena.gff
grep "gene" data/Raoultella_terrigena.gff | cut -f3 | sort -u
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f3 | sort -u


### Ahora si, paso por paso
## Obtener únicamente los genes
grep -P "\tgene" data/Raoultella_terrigena.gff | head
## Acceder a la columna 9
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f9 | head
## Separar esa info por ;
## Quedarnos con la columna 3
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f9 | cut -d ';' -f3 | head
## Obtener los valores únicos
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f9 | cut -d ';' -f3 | sort -u | head
## Contar el número de valores únicos
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f9 | cut -d ';' -f3 | sort -u | wc -l
```

* ¿Cuántos genes (ID distinto) existen en el genoma de R. terrigena?

```shell
grep -P "\tgene" data/Raoultella_terrigena.gff | cut -f9 |cut -d ';' -f1 | grep "ID=gene-" | sort -u | wc -l
```

* ¿Cuál es la longitud de la secuencia de la proteína WP_000448832.1?
  ¿Cuál es el algoritmo?
  Extraer la ubicación del ID WP_000448832.1
  Obtener el siguiente ID
  conocer el número de lineas de WP_000448832.1
  Extraer la secuencia del ID WP_000448832.1
  Obtener el número de caractéres de la secuencia

```shell
grep ">" data/Raoultella_terrigena.faa | grep -n "WP_000448832.1"
grep ">" data/Raoultella_terrigena.faa | head -7
grep -n "WP_000448832.1" data/Raoultella_terrigena.faa
grep -n "WP_000487600.1" data/Raoultella_terrigena.faa
head -18 data/Raoultella_terrigena.faa | tail -2
head -18 data/Raoultella_terrigena.faa | tail -2 | wc
###Listo
112 bytes
2 lineas, 1 byte por salto de linea = 111 caraceteres de secuencia
```

* ¿Cuál es el protein_id del gene fnr?

```shell
grep --color "fnr" data/Raoultella_terrigena.gff
### agreguémos más contexto
grep --color ";gene=fnr" data/Raoultella_terrigena.gff | grep --color "protein_id"
```

* Extrae y guarda en un archivo fasta la secuencia de la proteina fnr de Raoultella terrigena

```shell
grep '>' data/Raoultella_terrigena.faa | head -29 | tail -2
grep '>' data/Raoultella_terrigena.faa | grep -n WP_002903394.1
grep -n WP_002903394.1 data/Raoultella_terrigena.faa
grep -n WP_002913148.1 data/Raoultella_terrigena.faa
head -79 data/Raoultella_terrigena.faa | tail -5 > results/FNR.faa
```

* Pero podemos extraer un montón de secuencias de una forma más sencilla

```shell
grep 'Nif' data/Raoultella_terrigena.faa | sed 's/>//g' > results/nif_headers.txt
seqtk subseq data/Raoultella_terrigena.faa results/nif_headers.txt > results/nif.faa
less results/nif.faa 
```

