# The Human Phenotype Ontology

The [Human Phenotype Ontology](http://human-phenotype-ontology.github.io/) (HPO) was developed to provide an ontology of phenotypic anomalies that have been associated with disorders in the Online Mendelian Inheritance in Man (OMIM) database<sup>1</sup>. In a broad sense, an ontology is the philosophical discipline that studies the nature of existence and aims to understand how things in the world are divided into categories and how these categories are related together. For example, each term in the HPO is related to each other in a hierarchy.

![The hierarchy of HPO terms that are associated with OMIM:612922. The ontology plot illustrates the specificity level of HPO terms as we move down the hierarchy.](prop/image/612922.png)

# Bioinformatic tools using HPO terms

The association of HPO terms to disorders allows potential disorders to be identified based on a patient's clinical phenotypes (Phenomizer) and can be used to prioritise genetic variants in an individual (Exomiser and Genomiser). The HPO resource has also been leveraged by others to help identify potential diseases and their associated genes (Phenolyzer).

* [The Phenomizer](http://compbio.charite.de/phenomizer/)<sup>2</sup>: match a list of HPO terms to an OMIM disease
* [The Exomiser](http://www.sanger.ac.uk/science/tools/exomiser)<sup>3</sup>: an ensemble of tools that can prioritise variants based on HPO terms and find new genes associated with known disease causing genes
* [The Genomiser](http://exomiser.github.io/Exomiser/manual/7/quickstart/#genomiser)<sup>4</sup>: the Genomiser uses the Exomiser framework to analyse whole-genome data and has been especially tailored to include non-coding variants
* [Phenolyzer](http://phenolyzer.usc.edu/)<sup>5</sup>: free text to list of genes that are related to the input

# Organisation of this repository

There are several directories in this repository; below is a brief description.

* cluster - cluster analysis on OMIM phenotypes
* data - contains the data used for the scripts
* exomiser - analysis using the Exomiser
* gene - analyses using genes
* phenolyzer - analysis using Phenolyzer
* prop - analyses on the properties of HPO terms
* script - basic scripts for working with HPO terms

# My scripts

I have written some basic scripts in Perl and R to make use of HPO terms. The script makes use of the `hp.obo.gz` and `phenotype_annotation.tab.gz` files, which can be downloaded from the [downloads page](http://human-phenotype-ontology.github.io/downloads.html) of the HPO site.

## Free text to HPO ID

The script `text_to_hpo_term.pl` is used to find HPO terms that match your input text.

```bash
script/text_to_hpo_term.pl 
Usage: script/text_to_hpo_term.pl <infile.txt>

# using a test file with two lines of text
cat script/input.txt 
focal seizures
deep set eyes

# running the script
script/text_to_hpo_term.pl script/input.txt 
focal seizures: HP:0007359

Matched 1 term/s out of a total of 2. 1 term/s could not be matched:
deep set eyes

=====================================
deep set eyes
=====================================
Best match/es for deep set eyes with a mismatch score of 1:
        deep-set eyes: HP:0000490
        deep set eye: HP:0000490

Best match/es for deep set eyes with a mismatch score of 2:

Best match/es for deep set eyes with a mismatch score of 3:
        deeply set eye: HP:0000490
```

There is a direct match for `focal seizures` to `HP:0007359`. The term `deep set eyes` is not an exact HPO term but the script finds the next best match which is `deep set eye` or `deep-set eyes`, corresponding to HP:0000490.

## HPO ID to term/synonym

The script `hpo_to_term.pl` lists all the synonyms for a HPO ID, the depth of the HPO term, the number of OMIM disorders and genes  associated with the ID.

```bash
script/hpo_to_term.pl HP:0007359
HP:0007359      level: 5        disease associations: 15        gene associations: 42
        focal seizures
        partial seizures
```

## Tree structure of a HPO term

The script `hpo_to_tree.pl` shows the ancestors of a HPO term.

```bash
script/hpo_to_tree.pl HP:0007359
HP:0007359      focal seizures
HP:0001250      seizures
HP:0012638      abnormality of nervous system physiology
HP:0000707      abnormality of the nervous system
HP:0000118      phenotypic abnormality
HP:0000001      all
Level 5
```

## HPO ID and associated disorders

The script `hpo_to_disease.pl` finds OMIM disorders associated with a HPO ID.

```bash
script/hpo_to_disease.pl HP:0007359
HP:0007359
        EPILEPSY, FEMALE-RESTRICTED, WITH MENTAL RETARDATION
        #300491 EPILEPSY, X-LINKED, WITH VARIABLE LEARNING DISABILITIES AND BEHAVIORDISORDERS
        #300643 ROLANDIC EPILEPSY, MENTAL RETARDATION, AND SPEECH DYSPRAXIA, X-LINKED;RESDX
        #600513 EPILEPSY, NOCTURNAL FRONTAL LOBE, 1; ENFL1
        %601764 SEIZURES, BENIGN FAMILIAL INFANTILE, 1; BFIS1;;CONVULSIONS, BENIGN FAMILIAL INFANTILE, 1; BFIC1
        MYOCLONIC EPILEPSY, INFANTILE
        #607745 SEIZURES, BENIGN FAMILIAL INFANTILE, 3; BFIS3;;CONVULSIONS, BENIGN FAMILIAL INFANTILE, 3; BFIC3;;SEIZURES, BENIGN FAMILIAL NEONATAL-INFANTILE; BFNIS
        #611277 GENERALIZED EPILEPSY WITH FEBRILE SEIZURES PLUS, TYPE 3; GEFSP3;;GEFS+, TYPE 3; GEFS+3FEBRILE SEIZURES, FAMILIAL, 8, INCLUDED; FEB8, INCLUDED
        #613060 EPILEPSY, IDIOPATHIC GENERALIZED, SUSCEPTIBILITY TO, 10; EIG10GENERALIZED EPILEPSY WITH FEBRILE SEIZURES PLUS, TYPE 5, SUSCEPTIBILITYTO, INCLUDED; GEFS5, INCLUDED;;GEFS+, TYPE 5, SUSCEPTIBILITY TO, INCLUDED;;GEFS+5, SUSCEPTIBILITY TO, INCLUDED;;GEFSP5, SUSCEPTIBILITY TO, INCLUDED;;EPILEPSY, JUVENILE MYOCLONIC, SUSCEPTIBILITY TO, 7, INCLUDED; EJM7,INCLUDED
        %613608 EPILEPSY, FAMILIAL ADULT MYOCLONIC, 3; FAME3;;CORTICAL MYOCLONIC TREMOR WITH EPILEPSY, FAMILIAL, 3; FCMTE3
        #613722 EPILEPTIC ENCEPHALOPATHY, EARLY INFANTILE, 12; EIEE12
        #613863 GENERALIZED EPILEPSY WITH FEBRILE SEIZURES PLUS, TYPE 7; GEFSP7;;GEFS+, TYPE 7; GEFS+7FEBRILE SEIZURES, FAMILIAL, 3B, INCLUDED; FEB3B, INCLUDED
        #614563 MENTAL RETARDATION, AUTOSOMAL DOMINANT 13; MRD13;;MENTAL RETARDATION, AUTOSOMAL DOMINANT, 13, WITH NEURONAL MIGRATIONDEFECTS
        #615005 EPILEPSY, NOCTURNAL FRONTAL LOBE, 5; ENFL5
        #615476 EPILEPTIC ENCEPHALOPATHY, EARLY INFANTILE, 18; EIEE18
HP:0007359      15
```

## OMIM ID to HPO terms

The script `omim_to_hpo.pl` finds HPO IDs associated with an OMIM disorder ID and in addition, lists the number of disease and gene associations for each HPO term. This gives you an indication of how specific a HPO term is.

```bash
script/omim_to_hpo.pl 147920
OMIM:147920     #147920 KABUKI SYNDROME 1; KABUK1;;KABUKI SYNDROME;;KABUKI MAKE-UP SYNDROME; KMS;;NIIKAWA-KUROKI SYNDROME
        HP:0000006      autosomal dominant inheritance  no. disease association: 2675   no. gene association: 1238
        HP:0000028      cryptorchidism  no. disease association: 593    no. gene association: 455
        HP:0000054      micropenis      no. disease association: 139    no. gene association: 137
        HP:0000074      ureteropelvic junction obstruction      no. disease association: 10     no. gene association: 13
        HP:0000164      abnormality of the teeth        no. disease association: 159    no. gene association: 561
        HP:0000175      cleft palate    no. disease association: 586    no. gene association: 352
        HP:0000218      high palate     no. disease association: 313    no. gene association: 340
        HP:0000252      microcephaly    no. disease association: 959    no. gene association: 624
        HP:0000358      posteriorly rotated ears        no. disease association: 127    no. gene association: 238
        HP:0000365      hearing impairment      no. disease association: 483    no. gene association: 888
        HP:0000400      macrotia        no. disease association: 190    no. gene association: 122
        HP:0000403      recurrent otitis media  no. disease association: 54     no. gene association: 56
        HP:0000431      wide nasal bridge       no. disease association: 298    no. gene association: 317
        HP:0000437      depressed nasal tip     no. disease association: 12     no. gene association: 17
        HP:0000486      strabismus      no. disease association: 581    no. gene association: 521
        HP:0000508      ptosis  no. disease association: 489    no. gene association: 397
        HP:0000535      sparse eyebrow  no. disease association: 70     no. gene association: 62
        HP:0000592      blue sclerae    no. disease association: 89     no. gene association: 57
        HP:0000637      long palpebral fissure  no. disease association: 32     no. gene association: 20
        HP:0000851      congenital hypothyroidism       no. disease association: 14     no. gene association: 15
        HP:0000957      cafe-au-lait spot       no. disease association: 79     no. gene association: 81
        HP:0001007      hirsutism       no. disease association: 64     no. gene association: 138
        HP:0001212      prominent fingertip pads        no. disease association: 9      no. gene association: 7
        HP:0001249      intellectual disability no. disease association: 971    no. gene association: 1114
        HP:0001250      seizures        no. disease association: 1295   no. gene association: 1019
        HP:0001252      muscular hypotonia      no. disease association: 1014   no. gene association: 943
        HP:0001263      global developmental delay      no. disease association: 734    no. gene association: 911
        HP:0001374      congenital hip dislocation      no. disease association: 41     no. gene association: 47
        HP:0001382      joint hypermobility     no. disease association: 234    no. gene association: 199
        HP:0001629      ventricular septal defect       no. disease association: 304    no. gene association: 206
        HP:0001631      atria septal defect     no. disease association: 244    no. gene association: 205
        HP:0001680      coarctation of aorta    no. disease association: 42     no. gene association: 47
        HP:0001878      hemolytic anemia        no. disease association: 73     no. gene association: 84
        HP:0001973      autoimmune thrombocytopenia     no. disease association: 14     no. gene association: 24
        HP:0002023      anal atresia    no. disease association: 68     no. gene association: 105
        HP:0002024      malabsorption   no. disease association: 147    no. gene association: 172
        HP:0002025      anal stenosis   no. disease association: 18     no. gene association: 25
        HP:0002100      recurrent aspiration pneumonia  no. disease association: 6      no. gene association: 4
        HP:0002553      highly arched eyebrow   no. disease association: 96     no. gene association: 82
        HP:0002566      intestinal malrotation  no. disease association: 92     no. gene association: 66
        HP:0002650      scoliosis       no. disease association: 746    no. gene association: 567
        HP:0003468      abnormality of the vertebrae    no. disease association: 20     no. gene association: 291
        HP:0004322      short stature   no. disease association: 1351   no. gene association: 811
        HP:0004467      preauricular pit        no. disease association: 34     no. gene association: 37
        HP:0004736      crossed fused renal ectopia     no. disease association: 2      no. gene association: 5
        HP:0005218      anoperineal fistula     no. disease association: 1      no. gene association: 2
        HP:0007655      eversion of lateral third of lower eyelids      no. disease association: 2      no. gene association: 4
        HP:0008872      feeding difficulties in infancy no. disease association: 240    no. gene association: 287
        HP:0008897      postnatal growth retardation    no. disease association: 87     no. gene association: 101
        HP:0009237      short 5th finger        no. disease association: 15     no. gene association: 25
        HP:0010314      premature thelarche     no. disease association: 3      no. gene association: 5
51 HPO terms

HP:0000006;HP:0000028;HP:0000054;HP:0000074;HP:0000164;HP:0000175;HP:0000218;HP:0000252;HP:0000358;HP:0000365;HP:0000400;HP:0000403;HP:0000431;HP:0000437;HP:0000486;HP:0000508;HP:0000535;HP:0000592;HP:0000637;HP:0000851;HP:0000957;HP:0001007;HP:0001212;HP:0001249;HP:0001250;HP:0001252;HP:0001263;HP:0001374;HP:0001382;HP:0001629;HP:0001631;HP:0001680;HP:0001878;HP:0001973;HP:0002023;HP:0002024;HP:0002025;HP:0002100;HP:0002553;HP:0002566;HP:0002650;HP:0003468;HP:0004322;HP:0004467;HP:0004736;HP:0005218;HP:0007655;HP:0008872;HP:0008897;HP:0009237;HP:0010314;

---------------------------

# anoperineal fistula is only associated to one disorder
script/hpo_to_disease.pl HP:0005218
HP:0005218
        147920  #147920 KABUKI SYNDROME 1; KABUK1;;KABUKI SYNDROME;;KABUKI MAKE-UP SYNDROME; KMS;;NIIKAWA-KUROKI SYNDROME
HP:0005218      1

# HP:0010314      premature thelarche     no. disease association: 3      no. gene association: 5
script/hpo_to_disease.pl HP:0010314 
HP:0010314
        147920  #147920 KABUKI SYNDROME 1; KABUK1;;KABUKI SYNDROME;;KABUKI MAKE-UP SYNDROME; KMS;;NIIKAWA-KUROKI SYNDROME
        180849  #180849 RUBINSTEIN-TAYBI SYNDROME 1; RSTS1;;RUBINSTEIN SYNDROME;;BROAD THUMBS AND GREAT TOES, CHARACTERISTIC FACIES, AND MENTAL RETARDATION;;BROAD THUMB-HALLUX SYNDROME
        615346  #615346 PRECOCIOUS PUBERTY, CENTRAL, 2; CPPB2
HP:0010314      3
```

# References

1. [The Human Phenotype Ontology: a tool for annotating and analyzing human hereditary disease](https://www.ncbi.nlm.nih.gov/pubmed/18950739)
2. [Clinical diagnostics in human genetics with semantic similarity searches in ontologies.](https://www.ncbi.nlm.nih.gov/pubmed/19800049)
3. [Next-generation diagnostics and disease-gene discovery with the Exomiser](https://www.ncbi.nlm.nih.gov/pubmed/26562621)
4. [A Whole-Genome Analysis Framework for Effective Identification of Pathogenic Regulatory Variants in Mendelian Disease](https://www.ncbi.nlm.nih.gov/pubmed/27569544)
5. [Phenolyzer: phenotype-based prioritization of candidate genes for human diseases](https://www.ncbi.nlm.nih.gov/pubmed/26192085)

