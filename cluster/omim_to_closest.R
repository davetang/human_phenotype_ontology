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

my_omim <- args[1]

library(dplyr)

pa <- read.table('../script/phenotype_annotation.tab.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')
omim <- filter(pa, DB == 'OMIM')

my_check <- my_omim %in% omim$DB_Object_ID

if (!my_check){
  stop('Input OMIM ID does not exist in database')
}

############ Start functions ############
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
############ End functions ############

all_omim_id <- omim %>% select(DB_Object_ID) %>% unique()
all_omim_id <- all_omim_id$DB_Object_ID
all_omim_id <- all_omim_id[!grepl(my_omim, all_omim_id)]
one_to_all <- sapply(X = all_omim_id, function(x) jaccard_index(omim_to_hpo(x), omim_to_hpo(my_omim)))
all_omim_name <- sapply(X = all_omim_id, FUN = get_omim_name)
one_to_all_df <- data.frame(omim = all_omim_id, jaccard = one_to_all, name = unlist(all_omim_name))
one_to_all_df %>% arrange(desc(jaccard)) %>% select(name, jaccard) %>% head(n = 20)

