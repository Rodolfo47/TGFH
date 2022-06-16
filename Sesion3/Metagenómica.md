# Análisis de datos metagenómicos

Trabajaremos con un subset de los datos originales depositados en el EMBL bajo el código de acceso PRJEB13870 del artículo Gut microbiota dysbiosis contributes to the development of hypertension sobre microbioma e hipertensión. Estos se obtuvieron con una plataforma ILLUMINA HiSeq 4000 (2 x 150 pb) y están en formato FASTQ.

**FASTQ**: Normalmente se compone de cuatro lineas por secuencia:

```
@HWI-D00525:129:C6ACWANXX:5:1106:11467:38087
TGTCAAGACAGGCACGCACGTTCTGAATCAGCCGACGGTCGGTACGTAAGGCCATGTATATCGTGGCGTCCTTGTAAGTGATTTCCTTGCGTCCG
+
CCCCCGGGGGGGGGGGGGGGGGGGGGGGGGGGGGDGGFGGGGGGGGGGGGGGGGGGGGGGGGGGGGFGGGGGGGGGFGGGGGFGGGGGGEDGGGG
```

* L1 Comienza con '@' seguido del identificador de la secuencia y una descripción opcional
* L2 La secuencia de nucleótidos
* L3 Comienza con un '+' opcionalmente incluye el identificador de la secuencia
* L4 Indica los valores de calidad de la secuencia, debe contener el mismo número de
  símbolos que el número de nucleótidos.

**Manos a la obra** 

Abre tu terminal y conéctate al servidor

```shell
ssh -X -Y usuario@132.248.248.175 -o ServerAliveInterval=300
pw:
```

**NOTA**: Cada programa tiene una ayuda y un manual de usuario, es **importante** revisarlo y conocer cada parámetro que se ejecute. En terminal se puede consultar el manual con el comando `man` y también se puede consultar la ayuda con `-h` o `--help`, por ejemplo `fastqc -h`.

 La presente práctica sólo es una representación del flujo de trabajo para el análisis metagenómico, sin embargo, no sustituye los manuales de cada programa y el flujo puede variar dependiendo del tipo de datos y pregunta de investigación.

**Estructura del espacio de trabajo**

```shell
mkdir -p metagen/{data/raw,src,results,logs}
cd metagen/
```

### Datos

Los scripts y datos usados para cada paso del análisis los encuentras en el directorio `/home/dhernandez/metagen/`. Cópialos a tu espacio de trabajo

```shell
#Los scripts
cp /home/dhernandez/Meta/src/* src/
#Para los datos crea una liga simbólica
ln -s /home/dhernandez/Meta/data/raw/*.fastq data/raw/
```

## Pre-procesamiento 

### Control de calidad

Una herramienta común para verificar la calidad de las lecturas es **[FastQC](https://github.com/s-andrews/FastQC),** genera reportes que nos permiten darnos una idea de como están las lecturas, los posibles problemas y que futuros análisis son necesarios. La herramienta **[TrimGalore](https://github.com/FelixKrueger/TrimGalore)** nos permite eliminar lecturas de baja calidad, adaptadores, etc. 

Para ejecutar todo el preprocesamiento corre la siguiente linea:

```shell
bash src/01.qc_preprocessing.sh
```

TrimGalore ejecutó `fastqc`por lo que se generó el reporte de calidad después de la limpieza, podemos descargar el archivo correspondiente y visualizarlo en nuestro navegador. 

> ¿Mejoró la calidad?

Existen otros programas para limpiar las lecturas como **[Trimmomatic](https://github.com/usadellab/Trimmomatic)** o [**MultiQC**](https://github.com/ewels/MultiQC), entre otros. 

## **Ensambles**

Ya que sabemos que las lecturas de cada librería son de buena calidad podemos ensamblarlas, usaremos **[SPAdes](https://github.com/ablab/spades)** y **[Megahit](https://github.com/voutcn/megahit)**. 

Recordemos que las lecturas limpias se encuentran en el subdirectorio de resultados de la limpieza, podemos copiarlos al directorio data para trabajar con ellos desde ahí.

```shell
#Copiar los reads limpios
cp results/01.trimgalore/*/*.fq data/
#Cambiar el nombre de la extensión
bash src/change_name_extension.sh
```

Este es un ejemplo de linea a ejecutar, pero revisemos el manual y discutamos si hay algo que podamos quitar o agregar.

```shell
bash src/02.assembly.sh
```

### Calidad del ensamble

El nombre de los ensambles producidos es muy genérico, por lo que antes de evaluar la calidad podemos cambiarle el nombre. Ve al directorio `03.ensambles/` y ejecuta el script `change_name_assembly.sh` ubicado en `src/`

```shell
bash src/change_name_assembly.sh
```

Existen diversos factores a tomar en cuenta para el control de calidad de los ensambles, uno de ellos es la cantidad de  lecturas que mapean al ensamble, esta proporción nos da una idea de que tan representativo es el ensamble en nuestra muestra. Para obtener esta información usaremos **BBmap**.

Antes de hacer la evaluación de los ensambles, copiémoslos a un solo directorio

```bash
cd results/02.assembly/
mkdir fastas && cd fastas
cp ../*/*_megahit.fasta .
cp ../*/*_spades.fasta .
cp ../../../src/filter_contig_length.py .
for fasta in $(ls *_spades.fasta); do python3 filter_contig_length.py 500 1 $fasta ; done
rm *_spades.fasta
cd ../../../
```

Activa el ambiente de bbmap y ejecuta el script 

```shell
## activar el ambiente de bbmap
conda activate /home/dhernandez/.conda/envs/bbmap
## correr bbmap
bash src/03.depth_assembly.sh
```

Desactiva el ambiente de bbmap

```shell
conda deactivate
```

Aunque esta información es sumamente útil, aún no conocemos las estadísticas de los contigs ensamblados, para ello podemos usar **[MetaQuast](https://github.com/ablab/quast)**

```shell
# Ejecuta la siguiente línea de comandos
metaquast.py --rna-finding --fragmented results/02.assembly/fastas/*.fasta -o results/03.metaquast
```

Revisemos los outputs, pueden descargar el report.html a su computadora y visualizarlo en Chrome

```bash
scp dhernandez@132.248.248.175:/home/dhernandez/Meta/results/03.metaquast/report.html .
```

¿Qué proporción de las lecturas se usaron para los ensambles? podemos ver cuantas lecturas mapearon a cada uno de los ensambles que se generaron.

```shell
#Para el ensamble hecho con megahit
cut -f8 results/03.depth_assembly/pHTN_100M_megahit/pHTN_100M_megahit.scafstats | grep -v assignedReads | awk '{sum += $1;}END{print sum;}'
#Para el ensamble hecho con spades
cut -f8 results/03.depth_assembly/pHTN_100M_spades/pHTN_100M_spades.scafstats | grep -v assignedReads | awk '{sum += $1;}END{print sum;}'
```

```shell
520008
414716
```



### Asignación taxonómica

Después de la selección del ensamble a utilizar podemos seguir con la asignación taxonómica. Como lo hemos discutido, existen muchas herramientas para ello y es importante tomar en cuenta la naturaleza de los datos para elegir la mejor estrategia.

Uno de los asignadores más usado es **[Kraken2](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown)**, el cual tiene algunas utilidades recientemente añadidas. Por lo que pudimos ver del resultado de comparación de asignadores taxonómicos en **[LEMMI](https://genome.cshlp.org/content/30/8/1208.full)** y  **[CAMI](https://www.biorxiv.org/content/10.1101/2021.07.12.451567v1.full)**, la versión de Kraken2 con proteinas es más precisa. 

```shell
bash src/04.tax_assign.sh
```

Para sacar las abundancias de los taxones asignados por Kraken2, es importante tomar en cuenta que el análisis se hizo con contigs y no con lecturas. Podemos utilizar la imformación proporcionada por BBmap para obtener el número de lecturas mapeado a cada contig asignado por kraken.

****

Existen otros asignadores que podríamos utilizar para evaluar y comparar el perfil taxonómico de una muestra. **[CCMetagen](https://github.com/vrmarcelino/CCMetagen)** es una herramienta que promete ser precisa y que fue creada para solventar los problemas de nula o mala asignación de microorganismos eucariontes. 

Además, podemos evaluar las aproximaciones que utilizan marcadores de copia única y ribosomales para hacer la asignación taxonómica, como es el caso de [**Metaphlan3**](https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-3.0) 
