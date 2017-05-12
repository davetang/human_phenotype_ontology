#!/usr/bin/env Rscript
#
# Usage: hpo_to_ic.R <HPO ID> [HPO ID]
#

args <- commandArgs(TRUE)
if (length(args) < 1){
  stop('Please input at least one HPO ID')
}

if("ontologyIndex" %in% rownames(installed.packages()) == FALSE){
  stop("Please install the ontologyIndex package first")
}

# http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

load(paste(script.basename, '/information_content.Robj', sep=''))

my_index <- match(args, information_content$id)
my_result <- information_content[na.exclude(my_index),]

library(ontologyIndex)
# data("hpo")
hpo <- get_ontology(file = paste(script.basename, "/../data/hp.obo.gz", sep=''))

my_result$name <- sapply(X = my_result$id, FUN = function(x) get_term_property(hpo, property_name = 'name', term = x))
print(my_result)

