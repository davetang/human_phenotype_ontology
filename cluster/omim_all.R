#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(dplyr))
library(dplyr)

pa <- read.table('../script/phenotype_annotation.tab.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')

omim_to_hpo <- function(x){
  r <- omim %>% filter(DB_Object_ID == x) %>% select(HPO)
  return(r$HPO)
}

jaccard_index <- function(x, y){
  i <- length(intersect(x, y))
  d <- i/length(union(x,y))
  return(d)
}

get_omim_name <- function(x){
  my_name <- pa %>% filter(DB == 'OMIM', DB_Object_ID == x) %>% select(DB_Name) %>% summarise(name = unique(DB_Name))
  my_name <- strsplit(x = unlist(my_name), split = ";")[[1]][1]
  return(my_name)
}

omim <- filter(pa, DB == 'OMIM')
omim_id <- omim %>% select(DB_Object_ID) %>% unique()
omim_id <- omim_id$DB_Object_ID
omim_hpo <- sapply(X = omim_id, FUN = omim_to_hpo)
names(omim_hpo) <- omim_id

my_jaccard_indexes <- apply(expand.grid(1:length(omim_id), 1:length(omim_id)), 1, function(x) jaccard_index(omim_hpo[[x[2]]], omim_hpo[[x[1]]]))
my_jaccard_matrix <- matrix(my_jaccard_indexes, nrow = length(omim_id))

row.names(my_jaccard_matrix) <- omim_id
colnames(my_jaccard_matrix) <- omim_id

save(my_jaccard_matrix, file = 'my_jaccard_matrix_all.Robj')

