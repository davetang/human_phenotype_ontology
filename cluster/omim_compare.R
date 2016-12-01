#!/usr/bin/env Rscript
#
# Usage: omim_to_closest.R <first OMIM ID> <second OMIM ID>
#

if("dplyr" %in% rownames(installed.packages()) == FALSE){
  stop('Please install the dplyr package')
}

if("wordcloud" %in% rownames(installed.packages()) == FALSE){
  stop('Please install the wordcloud package')
}

args <- commandArgs(TRUE)
if (length(args) != 2){
  stop('Please input two OMIM IDs')
}

my_first_omim  <- args[1]
my_second_omim <- args[2]

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(wordcloud))
library(dplyr)
library(wordcloud)

pa <- read.table('../script/phenotype_annotation.tab.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')
omim <- filter(pa, DB == 'OMIM')

my_first_check <- my_first_omim %in% omim$DB_Object_ID
my_second_check <- my_second_omim %in% omim$DB_Object_ID

if (!my_first_check){
  stop('First input OMIM ID does not exist in database')
}
if (!my_second_check){
  stop('Second input OMIM ID does not exist in database')
}

############ Start functions ############
omim_to_hpo <- function(x){
  r <- omim %>% filter(DB_Object_ID == x) %>% select(HPO)
  return(r$HPO)
}

get_omim_name <- function(x){
  my_name <- pa %>% filter(DB == 'OMIM', DB_Object_ID == x) %>% select(DB_Name) %>% summarise(name = unique(DB_Name))
  my_name <- strsplit(x = unlist(my_name), split = ";")[[1]][1]
  return(my_name)
}

make_term_matrix <- function(name1, name2, x, y){
  both <- intersect(x, y)
  first <- setdiff(x, y)
  second <- setdiff(y, x)
  
  column_1 <- c(rep(1, length(first)), rep(2, length(both)), rep(0, length(second)))
  column_2 <- c(rep(0, length(first)), rep(2, length(both)), rep(1, length(second)))
  
  my_matrix <- matrix(c(column_1, column_2), nrow=length(column_1))
  row.names(my_matrix) <- c(first, both, second)
  colnames(my_matrix)  <- c(paste('OMIM:', name1, sep = ''), paste('OMIM:', name2, sep = ''))
  return(my_matrix)
}

jaccard_index <- function(x, y){
  i <- length(intersect(x, y))
  d <- i/length(union(x,y))
  return(d)
}
############ End functions ############

my_first_name  <- get_omim_name(my_first_omim)
my_second_name <- get_omim_name(my_second_omim)
my_first_hpo <- omim_to_hpo(my_first_omim)
my_second_hpo <- omim_to_hpo(my_second_omim)

my_ji <- jaccard_index(my_first_hpo, my_second_hpo)
print(paste('The Jaccard Index for ', my_first_omim, ' and ', my_second_omim, ' is ', my_ji, sep=''))

my_matrix <- make_term_matrix(my_first_omim, my_second_omim, my_first_hpo, my_second_hpo)

my_pdf <- paste(my_first_omim, '_', my_second_omim, '.pdf', sep='')
pdf(file = my_pdf, width = 10, height = 10)
comparison.cloud(my_matrix, colors = NA, scale = c(1, 3), rot.per = 0)
dev.off()

both <- intersect(my_first_hpo, my_second_hpo)
my_txt <- paste(my_first_omim, '_', my_second_omim, '.txt', sep='')
write(both, my_txt)
write(my_first_hpo, paste(my_first_omim, '.txt', sep=''))
write(my_second_hpo, paste(my_second_omim, '.txt', sep=''))

