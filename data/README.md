Files are on `Build #117 (24/02/2017 3:42:21 PM)` and downloaded from <http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/>.

```bash
# 925K
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt.gz | head -5
#Format: entrez-gene-id<tab>entrez-gene-symbol<tab>HPO-Term-Name<tab>HPO-Term-ID
8192    CLPP    Seizures        HP:0001250
8192    CLPP    Short stature   HP:0004322
8192    CLPP    Primary amenorrhea      HP:0000786
8192    CLPP    Autosomal recessive inheritance HP:0000007

# 2.6M
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz | head -5
#Format: HPO-ID<tab>HPO-Name<tab>Gene-ID<tab>Gene-Name
HP:0001459      1-3 toe syndactyly      2737    GLI3
HP:0006088      1-5 finger complete cutaneous syndactyly        64327   LMBR1
HP:0010708      1-5 finger syndactyly   6469    SHH
HP:0010708      1-5 finger syndactyly   64327   LMBR1
```

Why is one file over twice the size of the other? Shouldn't they be the same since they are just re-arrangements of each other?

```bash
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt.gz | grep HP:0001459
2737    GLI3    1-3 toe syndactyly      HP:0001459

gunzip -c ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz | grep HP:0001459
HP:0001459      1-3 toe syndactyly      2737    GLI3

# find the most frequent HPO terms
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt.gz | cut -f4 | sort | uniq -c | sort -k1rn | head -5
1935 HP:0000007
1233 HP:0000006
 948 HP:0001249
 914 HP:0001250
 869 HP:0001263

gunzip -c ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz | cut -f1 | sort | uniq -c | sort -k1rn | head -5
2422 HP:0000707
2217 HP:0012638
1957 HP:0000152
1935 HP:0000007
1934 HP:0000234

# 13 genes associated with HP:0000707
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt.gz | grep HP:0000707
8626    TP63    Abnormality of the nervous system       HP:0000707
1277    COL1A1  Abnormality of the nervous system       HP:0000707
1278    COL1A2  Abnormality of the nervous system       HP:0000707
26154   ABCA12  Abnormality of the nervous system       HP:0000707
11136   SLC7A9  Abnormality of the nervous system       HP:0000707
11231   SEC63   Abnormality of the nervous system       HP:0000707
3043    HBB     Abnormality of the nervous system       HP:0000707
5156    PDGFRA  Abnormality of the nervous system       HP:0000707
5589    PRKCSH  Abnormality of the nervous system       HP:0000707
5624    PROC    Abnormality of the nervous system       HP:0000707
80184   CEP290  Abnormality of the nervous system       HP:0000707
6519    SLC3A1  Abnormality of the nervous system       HP:0000707
7227    TRPS1   Abnormality of the nervous system       HP:0000707

gunzip -c ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz | grep HP:0000707 | head -5
HP:0000707      Abnormality of the nervous system       8192    CLPP
HP:0000707      Abnormality of the nervous system       8195    MKKS
HP:0000707      Abnormality of the nervous system       4099    MAG
HP:0000707      Abnormality of the nervous system       8200    GDF5
HP:0000707      Abnormality of the nervous system       90121   TSR2

# 2,422 genes associated with HP:0000707
gunzip -c ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz | grep HP:0000707 | wc -l
    2422
```

