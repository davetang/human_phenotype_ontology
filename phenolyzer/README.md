Phenolyzer
==========

[Phenolyzer](http://phenolyzer.usc.edu/) stands for Phenotype Based Gene Analyzer, a tool focusing on discovering genes based on user-specific disease/phenotype terms.

# HPO IDs to genes

The four HPO IDs below are used in The Exomiser example for prioritising the gene associated with [Pfeiffer syndrome](https://en.wikipedia.org/wiki/Pfeiffer_syndrome) (FGFR2).

~~~~{.bash}
cat pfeiffer.txt 
HP:0001156;HP:0001363;HP:0011304;HP:0010055

perl disease_annotation.pl pfeiffer.txt -f -p -ph -logistic -out out/pfeiffer/out -addon DB_DISGENET_GENE_DISEASE_SCORE,DB_GAD_GENE_DISEASE_SCORE -addon_weight 0.25

# top 10 seed genes
cat out/pfeiffer/out.seed_gene_list | head -11
Rank    Gene    ID      Score
1       FGFR2   2263    1
2       GLI3    2737    0.9006
3       FGFR3   2261    0.7777
4       FGFR1   2260    0.6202
5       FLNA    2316    0.4413
6       GDF5    8200    0.4354
7       ROR2    4920    0.4137
8       MED12   9968    0.404
9       SUMF1   285362  0.2642
10      TWIST1  7291    0.2412
~~~~

How specific, i.e. how deep into the ontology, are these HPO IDs?

~~~~{.bash}
perl -I../script/ ../script/hpo_to_term.pl HP:0001156 HP:0001363 HP:0011304 HP:0010055
HP:0001156      level 8
        brachydactyly syndrome
        brachydactyly
HP:0001363      level 7
        craniosynostosis
        cranial suture synostosis
        craniostenosis
        craniosyostosis
        deformity of the skull
        early fusion of cranial sutures
        premature closure of cranial sutures
        premature fontanel closure
HP:0011304      level 8
        broad thumb
        broad phalanges of the thumb
        broad thumbs
        wide/broad thumb
        wide/broad thumb phalanges
HP:0010055      level 7
        broad hallux
        abnormally broad great toes
        broad big toe
        broad great toe
        broad great toes
        broad halluces
        wide big toe
~~~~

