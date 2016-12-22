#!/usr/bin/env Rscript
#
# Usage: omim_to_closest.R <HPO ID> [HPO ID]
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

# initialise empty data frame to store results
my_result <- data.frame(id = character(0), info = numeric(0), freq = numeric(0), stringsAsFactors = FALSE)

for (i in 1:length(args)){
   my_hpo <- args[i]
   r <- subset(information_content, id == my_hpo)
   # if there is a match
   if (nrow(r) > 0){
      my_result[i,] <- r
   }
}

library(ontologyIndex)
data("hpo")

my_result$name <- sapply(X = my_result$id, FUN = function(x) get_term_property(hpo, property_name = 'name', term = x))
print(my_result)
