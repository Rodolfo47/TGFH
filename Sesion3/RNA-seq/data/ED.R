#!/RScript

#Expresión diferencial
#TGFH
#Valeria Flores
#Junio 2022


#Paqueterías
library(tximport)
library(DESeq2)
library(tidyverse)


#Importar archivos
files <- file.path("./salmon/", list.files("salmon"))
samples <- read.delim("./metadata.csv", header=TRUE, sep=",") 
names(samples)[names(samples)== "conditio"] <- "Condition"
txi <- tximport(files = files, type = "salmon", txOut = T)
head(txi)

#Archivo deseq
dds <- DESeqDataSetFromTximport(txi= txi,
                                colData = samples,
                                design = ~Condition)

dds


#Solo mantener filas que tengan al menos 10 lecturas en total
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

#Establecer valores de referencia
dds$Condition <- relevel(dds$Condition, ref= "asymptomatic")

#Análisis de expresión diferencial
dds <- DESeq(dds)
res <- results(dds)
head(dds, tidy= TRUE)
res$pvalue

#Resumen de nuestro análisis
summary(res, alpha = 0.01)


#Contar cuántos transcritps tenemos de acuerdo a umbrales establecidos por nosotros
res[which(res$log2FoldChange > 1 & res$padj < .01),] #UP

res[which(res$log2FoldChange < 1 & res$padj < .01),] #DOWN


#Volcano plot

#Ordenar archivo de resumen por p-value
res <- res[order(res$padj),]
head(res)

#Hacer una dataframe a partir del objeto de resultados
topT <- as.data.frame(res)
de <- topT[complete.cases(topT), ]

#Añadir una columna con información de la expresión diferencial
de$diffexpressed <- "NO"
de$diffexpressed[de$log2FoldChange > 1 & de$padj < 0.01] <- "UP"
de$diffexpressed[de$log2FoldChange < -1 & de$padj < 0.01] <- "DOWN"

#Graficar
ggplot(data=de, aes(x=log2FoldChange, y=-log10(padj), col=diffexpressed)) + geom_point() +
  theme_minimal()+ geom_vline(xintercept=c(-1, 1), col="red") +
  geom_hline(yintercept=2, col="red")+
  scale_color_manual(values=c("blue", "black", "red"))








