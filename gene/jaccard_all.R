#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(dplyr))
library(dplyr)
pg <- read.table('../data/ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='#')
names(pg) <- c('hpo', 'hpo_def', 'entrez', 'gene')
length(unique(pg$gene))

gene_to_hpo <- function(x){
  r <- pg %>% filter(gene == x) %>% select(hpo)
  return(r$hpo)
}

jaccard_index <- function(x, y){
  i <- length(intersect(x, y))
  d <- i/length(union(x,y))
  return(d)
}

my_gene <- unique(pg$gene)
my_gene_hpo <- sapply(my_gene, gene_to_hpo)

my_jaccard_indexes <- apply(expand.grid(1:length(my_gene), 1:length(my_gene)), 1, function(x) jaccard_index(my_gene_hpo[[x[2]]], my_gene_hpo[[x[1]]]))
my_jaccard_matrix <- matrix(my_jaccard_indexes, nrow = length(my_gene))

row.names(my_jaccard_matrix) <- my_gene
colnames(my_jaccard_matrix) <- my_gene

save(my_jaccard_matrix, file = 'my_jaccard_matrix_gene_all.Robj')

