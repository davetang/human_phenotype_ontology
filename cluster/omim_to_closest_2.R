#!/usr/bin/env Rscript
#
# Usage: omim_to_closest.R <OMIM ID>
#

if("dplyr" %in% rownames(installed.packages()) == FALSE){
  stop('Please install the dplyr package first')
}

args <- commandArgs(TRUE)
if (length(args) != 1){
  stop('Please input a single OMIM ID')
}

my_omim <- as.character(args[1])

library(dplyr)

pa <- read.table('../script/phenotype_annotation.tab.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')
omim <- filter(pa, DB == 'OMIM')

my_check <- my_omim %in% omim$DB_Object_ID

if (!my_check){
  stop('Input OMIM ID does not exist in database')
}

load('my_jaccard_matrix_all.Robj')

my_result <- my_jaccard_matrix[my_omim,]
my_id     <- names(my_result)
lookup    <- omim %>% distinct(DB_Object_ID, DB_Name)
my_name   <- sapply(lookup$DB_Name, function(x) strsplit(x, split = ";")[[1]][1])

my_df <- data.frame(omim = my_id, jaccard = my_result, name = my_name)
my_df %>% arrange(desc(jaccard)) %>% select(omim, jaccard, name) %>% head(n = 20)

