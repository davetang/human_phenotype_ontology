#!/usr/bin/env Rscript
#
# Usage: omim_to_closest.R <OMIM API key> <OMIM ID>
#

if("romim" %in% rownames(installed.packages()) == FALSE){
  stop("Please install the romim package first by running: library(devtools); install_github('davetang/romim')")
}

args <- commandArgs(TRUE)
if (length(args) != 2){
  stop('Please input two arguments: your OMIM API key and a single OMIM ID')
}

library(romim)

my_key <- set_key(args[1])
my_omim <- args[2]

my_result <- get_omim(my_omim, geneMap=TRUE)

get_title(my_result)
get_gene(my_result)

