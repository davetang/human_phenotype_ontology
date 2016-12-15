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

# http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)
my_base <- gsub('cluster', '', script.basename)

my_omim <- as.character(args[1])

suppressPackageStartupMessages(library(dplyr))
library(dplyr)

pa <- read.table(paste(my_base, '/script/phenotype_annotation.tab.gz', sep=''), header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')
omim <- filter(pa, DB == 'OMIM')

my_check <- my_omim %in% omim$DB_Object_ID

if (!my_check){
  stop('Input OMIM ID does not exist in database')
}

load(paste(my_base, '/cluster/my_jaccard_matrix_all.Robj', sep=''))

my_result <- my_jaccard_matrix[my_omim,]
my_id     <- names(my_result)
lookup    <- omim %>% distinct(DB_Object_ID, DB_Name)
my_name   <- sapply(lookup$DB_Name, function(x) strsplit(x, split = ";")[[1]][1])

my_df <- data.frame(omim = my_id, jaccard = my_result, name = my_name)
my_df %>% arrange(desc(jaccard)) %>% select(omim, jaccard, name) %>% head(n = 20)

