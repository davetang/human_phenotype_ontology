HPO files
=========

See <http://human-phenotype-ontology.github.io/downloads.html>

~~~~{.bash}
wget http://compbio.charite.de/jenkins/job/hpo.annotations/lastStableBuild/artifact/misc/phenotype_annotation.tab
gzip phenotype_annotation.tab

wget http://purl.obolibrary.org/obo/hp.obo
gzip hp.obo
~~~~

# File format

Format documented at <http://human-phenotype-ontology.github.io/documentation.html>

Column  Content Required        Example
1       DB      required        MIM
2       DB_Object_ID    required        154700
3       DB_Name required        Achondrogenesis, type IB
4       Qualifier       optional        NOT
5       HPO ID  required        HP:0002487
6       DB:Reference    required        OMIM:154700 or PMID:15517394
7       Evidence code   required        IEA
8       Onset modifier  optional        HP:0003577
9       Frequency modifier      optional        “70%” or “12 of 30” or from the vocabulary show in table below
10      With    optional         
11      Aspect  required        O
12      Synonym optional        ACG1B|Achondrogenesis, Fraccaro type
13      Date    required        YYYY.MM.DD
14      Assigned by     required        HPO

~~~~{.bash}
gunzip -c phenotype_annotation.tab.gz | cat -T | head -1 | sed 's/\^I/\n/g' | nl -ba
     1  DECIPHER
     2  1
     3  WOLF-HIRSCHHORN SYNDROME
     4
     5  HP:0000252
     6  DECIPHER:1
     7  IEA
     8
     9
    10
    11  O
    12
    13  2013.05.29
    14  HPO:skoehler
~~~~

