# The Human Phenotype Ontology

* Ontology is the philosophical discipline which studies the nature of existence and aims to understand how things in the world are divided into categories and how these categories are related together
* Each term in the Human Phenotype Ontology (HPO) describes a clinical abnormality and range in specificity
* The HPO working group has mapped nearly all clinical descriptions in Online Mendelian Inheritance in Man (OMIM) to terms of the HPO

# HPO tools

* [The Phenomizer](http://compbio.charite.de/phenomizer/): match a list of HPO terms to an OMIM disease
* [The Exomiser](http://www.sanger.ac.uk/science/tools/exomiser): an ensemble of tools that can prioritise variants based on HPO terms and find new genes associated with known disease causing genes
* [Phenolyzer](http://phenolyzer.usc.edu/): free text to list of genes that are related to the input

# My scripts

The `hp.obo.gz` and `phenotype_annotation.tab.gz` files must be in the same directory as the scripts.

## Free text to HPO ID

Takes a file containing free text on each line.

~~~~{.bash}
cd script
./text_to_hpo_term.pl input.txt
focal seizures: HP:0007359

Matched 1 term/s out of a total of 2. 1 term/s could not be matched:
deep set eyes

=====================================
deep set eyes
=====================================
Best match/es for deep set eyes with a mismatch score of 1:
        deep set eye: HP:0000490
        deep-set eyes: HP:0000490

Best match/es for deep set eyes with a mismatch score of 2:

Best match/es for deep set eyes with a mismatch score of 3:
        deeply set eye: HP:0000490
~~~~

There is a direct match for `focal seizures` to a HPO term. The term `deep set eyes` is not a HPO term but the script finds the next best match which is `deep set eye` or `deep-set eyes`.

## HPO ID to term/synonym

Takes a HPO ID from the command line.

~~~~{.bash}
cd script
./hpo_to_term.pl HP:0007359
HP:0007359
        focal seizures
        partial seizures
~~~~

## Tree structure of a HPO term

Takes a HPO ID from the command line.

~~~~{.bash}
cd script
./hpo_to_tree.pl HP:0007359
HP:0007359      focal seizures
HP:0001250      seizures
HP:0012638      abnormality of nervous system physiology
HP:0000707      abnormality of the nervous system
HP:0000118      phenotypic abnormality
HP:0000001      all
Level 5
~~~~

## HPO ID and associated disorders

Takes a HPO ID from the command line.

~~~~{.bash}
cd script
./hpo_to_disease.pl HP:0007359
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
~~~~

