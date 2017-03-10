# Sources

* The phenotype to gene files are on `Build #117 (24/02/2017 3:42:21 PM)` and downloaded from <http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/>.
* The file `hgnc_symbol_mim_morbid.tsv` was created using biomaRt

```r
library(biomaRt)
ensembl <- useMart('ENSEMBL_MART_ENSEMBL', dataset = 'hsapiens_gene_ensembl')
my_result <- getBM(attributes=c('hgnc_symbol', 'mim_morbid'), mart = ensembl)
write.table(my_result, 'hgnc_symbol_mim_morbid.tsv', quote = FALSE, sep = "\t", row.names = FALSE)
```

