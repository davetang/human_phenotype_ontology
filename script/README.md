HPO files
=========

Some of the scripts require the subroutines, i.e. functions, in the `hpo.pm` package file. If you are running the scripts in the same directory that `hpo.pm` resides, then Perl won't complain about being unable to find the `hpo` package; however, you may wish to run these scripts outside of this directory. There are several ways to tell Perl where to look for packages; I recommend setting the `PERL5LIB` variable in your shell. For the bash shell:

~~~~{.bash}
# you can also put this in your .bashrc file
export PERL5LIB=~/github/human_phenotype_ontology/script
~~~~

# Files to download

See <http://human-phenotype-ontology.github.io/downloads.html>

~~~~{.bash}
wget http://compbio.charite.de/jenkins/job/hpo.annotations/lastStableBuild/artifact/misc/phenotype_annotation.tab
gzip phenotype_annotation.tab

wget http://purl.obolibrary.org/obo/hp.obo
gzip hp.obo
~~~~

# File format

Format documented at <http://human-phenotype-ontology.github.io/documentation.html>

~~~~{.bash}
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
~~~~

Check out the first line:

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

