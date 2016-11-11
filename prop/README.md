Properties of HPO terms
-----------------------

# How many HPO terms?

~~~~{.bash}
gunzip -c ../script/hp.obo.gz |
grep "^id" |
sed 's/id: //' |
sort -u |
wc -l
11785
~~~~

# Co-occurrence

How often do HP:0000648 (optic atrophy) and HP:0000668 (hypodontia) co-occur in the same OMIM disorder?

~~~~{.bash}
gunzip -c ../script/phenotype_annotation.tab.gz |
grep "^OMIM" |
cut -f2 |
sort -u |
wc -l
6947

gunzip -c ../script/phenotype_annotation.tab.gz |
grep "^OMIM" |
cut -f2,5 |
grep "HP:0000648\|HP:0000668" |
sort -u |
cut -f1 |
sort |
uniq -c |
sort -k1rn |
head
      2 101800
      2 194190
      2 272440
      2 303600
      2 305600
      2 308300
      2 607694
      1 101200
      1 101400
      1 103285

~/script/omim_to_gene.R 101800
[1] "ACRODYSOSTOSIS 1 WITH OR WITHOUT HORMONE RESISTANCE; ACRDYS1"
[1] "PRKAR1A, TSE1, CNC1, CAR, PPNAD1, ACRDYS1"

~/script/omim_to_gene.R 101800
[1] "ACRODYSOSTOSIS 1 WITH OR WITHOUT HORMONE RESISTANCE; ACRDYS1"
[1] "PRKAR1A, TSE1, CNC1, CAR, PPNAD1, ACRDYS1"

~/script/omim_to_gene.R 194190
[1] "WOLF-HIRSCHHORN SYNDROME; WHS"
NULL

~/script/omim_to_gene.R 272440
[1] "FILIPPI SYNDROME; FLPIS"
[1] "CKAP2L, RADMIS"

~/script/omim_to_gene.R 303600
[1] "COFFIN-LOWRY SYNDROME; CLS"
[1] "RPS6KA3, RSK2, MRX19"

~/script/omim_to_gene.R 305600
[1] "FOCAL DERMAL HYPOPLASIA; FDH"
[1] "PORCN, PORC, DHOF, FODH"

~/script/omim_to_gene.R 308300
[1] "INCONTINENTIA PIGMENTI; IP"
[1] "IKBKG, NEMO, FIP3, IP, IPD2, AMCBX1, IMD33"

~/script/omim_to_gene.R 607694
[1] "LEUKODYSTROPHY, HYPOMYELINATING, 7, WITH OR WITHOUT OLIGODONTIA AND/OR HYPOGONADOTROPIC HYPOGONADISM; HLD7"
[1] "POLR3A, RPC1, RPC155, ADDH, HLD7"
~~~~

As a Perl script.

~~~~{.bash}
co.pl HP:0000648 HP:0000668 
308300
194190
607694
305600
303600
272440
101800
~~~~

# How many pairwise comparisons?

~~~~{.bash}
R --quiet -e 'choose(11785, 2)'
> choose(11785, 2)
[1] 69437220
~~~~

