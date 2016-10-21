jaccard_index <- function(x, y){
  i <- length(intersect(x, y))
  d <- i/length(union(x,y))
  return(d)
}

setwd('~/github/human_phenotype_ontology/cluster/')
pa <- read.table('../script/phenotype_annotation.tab.gz', header = FALSE, stringsAsFactors = FALSE, quote='', sep="\t", comment='')
names(pa) <- c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO', 'DB_Reference', 'Evidence_code', 'Onset_modifier', 'Frequency_modifier', 'With', 'Aspect', 'Synonym', 'Date', 'Assigned_by')

library(dplyr)
omim <- filter(pa, DB == 'OMIM')

# cross-checking the stats
omim %>%
  select(DB_Object_ID) %>%
  group_by(DB_Object_ID) %>%
  summarise(n = n()) %>%
  summarise(mean = mean(n))

omim %>% select(DB_Object_ID) %>% group_by(DB_Object_ID) %>% summarise(n = n()) %>% filter(n > 7, n < 61)

# 148050 KBG SYNDROME
a <- omim %>% filter(DB_Object_ID == 148050) %>% select(HPO)
# 305400 AARSKOG-SCOTT SYNDROME
b <- omim %>% filter(DB_Object_ID == 305400) %>% select(HPO)
# 610253 KLEEFSTRA SYNDROME
c <- omim %>% filter(DB_Object_ID == 610253) %>% select(HPO)
# 272440 FILIPPI SYNDROME
d <- omim %>% filter(DB_Object_ID == 272440) %>% select(HPO)

jaccard_index(a$HPO, b$HPO)
jaccard_index(a$HPO, c$HPO)
jaccard_index(b$HPO, c$HPO)
jaccard_index(c$HPO, d$HPO)


