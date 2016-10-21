Clustering OMIM diseases
========================

There are about 8,000 or so described rare diseases. Many of them have overlapping clinical features. Here I try to cluster all the OMIM diseases based on the number of overlapping features.

# How many OMIM IDs with HPO terms?

~~~~{.bash}
gunzip -c ../script/phenotype_annotation.tab.gz |
awk '$1 == "OMIM" {print}' |
cut -f2 | sort -u | wc -l
    6947
~~~~

# How many terms are associated with each OMIM ID, on average?

~~~~{.bash}
gunzip -c ../script/phenotype_annotation.tab.gz |
awk '$1 == "OMIM" {print $2}' |
sort | uniq -c | awk '{print $1}' | stats
Total lines:            6947
Sum of lines:           103841
Ari. Mean:              14.9476032819922
Geo. Mean:              8.64515221919539
Median:                 9
Mode:                   2 (N=809)
Anti-Mode:              83 (N=1)
Minimum:                1
Maximum:                249
Variance:               313.762620929126
StdDev:                 17.7133458423056
~~~~

On average, each OMIM disorder is associated with a median of nine phenotypic terms and a mean of ~15 phenotypic terms.

# Jaccard distance

The [Jaccard index](https://en.wikipedia.org/wiki/Jaccard_index) is calculated as:

$$ J(A,B) = \frac{|A \cap B|}{|A \cup B|} $$

The higher the index, the more similar the two vectors.

~~~~{.r}
A <- 5:14
B <- 10:19

# as a function
jaccard_index <- function(x, y){
  i <- length(intersect(x, y))
  d <- i/length(union(x,y))
  return(d)
}

jaccard_index(A, B)
[1] 0.3333333

# higher index, higher similarity
jaccard_index(1:10, 1:11)
[1] 0.9090909

# Jaccard distance
1 - jaccard_index(1:10, 1:11)
[1] 0.09090909
~~~~

# Jaccard distance between OMIM disorders

~24 million comparisons.

~~~~{.r}
choose(6947, 2)
[1] 24126931
~~~~

