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
omim <- tbl_df(omim)

# cross-checking the stats
omim %>%
  select(DB_Object_ID) %>%
  group_by(DB_Object_ID) %>%
  summarise(n = n()) %>%
  summarise(mean = mean(n))

omim %>% select(DB_Object_ID) %>% group_by(DB_Object_ID) %>% summarise(n = n()) %>% filter(n > 30, n < 61)

omim_to_hpo <- function(x){
  r <- omim %>% filter(DB_Object_ID == x) %>% select(HPO)
  return(r$HPO)
}

# 148050 KBG SYNDROME
a <- omim_to_hpo(148050)
# 305400 AARSKOG-SCOTT SYNDROME
b <- omim_to_hpo(305400)
# 610253 KLEEFSTRA SYNDROME
c <- omim_to_hpo(610253)
# 272440 FILIPPI SYNDROME
d <- omim_to_hpo(272440)

jaccard_index(a, b)
jaccard_index(a, c)
jaccard_index(b, c)
jaccard_index(c, d)

# data frame with OMIM ID and number of HPO terms
wanted <- omim %>% select(DB_Object_ID) %>% group_by(DB_Object_ID) %>% summarise(n = n()) %>% filter(n > 30, n < 61)

# vector of OMIM IDs
wanted_omim <- wanted$DB_Object_ID

# list of OMIM IDs and HPO terms
wanted_omim_hpo <- sapply(X = wanted_omim, FUN = omim_to_hpo)
names(wanted_omim_hpo) <- wanted_omim

# calculate all jaccard indexes
indexes <- apply(combn(1:length(wanted_omim), 2), 2, function(x) jaccard_index(wanted_omim_hpo[[x[1]]], wanted_omim_hpo[[x[2]]]))
choose(length(wanted_omim), 2)

summary(indexes)
table(indexes > 0.16)

# create empty matrix
mat <- diag(length(wanted_omim))

# fill lower triangle with Jaccard indexes
mat[lower.tri(mat)] <- indexes
row.names(mat) <- wanted_omim
colnames(mat) <- wanted_omim

# sanity check
mat[1:7, 1:7]
x <- wanted_omim_hpo$`148050`
y <- wanted_omim_hpo$`305400`
jaccard_index(x, y)

# another sanity check
grep(pattern = 148050, x = wanted_omim)
grep(pattern = 305400, x = wanted_omim)
mat[489, 75]

# convert into distance
mat_dist <- as.dist(1 - mat)
hc <- hclust(mat_dist, method = 'average')
plot(hc)

omim_name <- function(x){
  n <- pa %>% filter(DB == 'OMIM', DB_Object_ID == x) %>% select(DB_Name) %>% summarise(name = unique(DB_Name))
  return(n)
}

clusters <- cutree(hc, h = 0.80)
table(clusters)[table(clusters)>1]
my_cluster <- wanted_omim[clusters == 248]
sapply(X = my_cluster, FUN = omim_name)

