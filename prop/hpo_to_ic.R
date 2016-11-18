#!/usr/bin/env Rscript
#
# Usage: omim_to_closest.R <HPO ID> [HPO ID]
#

args <- commandArgs(TRUE)
if (length(args) < 1){
  stop('Please input at least one HPO ID')
}

load('information_content.Robj')

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

print(my_result)

