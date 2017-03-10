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

There are five directories in this repository.

* cluster - cluster analysis on disorders
* data - contains the data used for the scripts
* exomiser - analysis using the Exomiser
* gene - analysis using genes
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

The script `omim_to_hpo.pl` finds HPO IDs associated with an OMIM disorder ID.

```bash
script/omim_to_hpo.pl 147920
OMIM:147920     #147920 KABUKI SYNDROME 1; KABUK1;;KABUKI SYNDROME;;KABUKI MAKE-UP SYNDROME; KMS;;NIIKAWA-KUROKI SYNDROME
        HP:0000006      autosomal dominant inheritance
        HP:0000028      cryptorchidism
        HP:0000054      micropenis
        HP:0000074      ureteropelvic junction obstruction
        HP:0000164      abnormality of the teeth
        HP:0000175      cleft palate
        HP:0000218      high palate
        HP:0000252      microcephaly
        HP:0000358      posteriorly rotated ears
        HP:0000365      hearing impairment
        HP:0000400      macrotia
        HP:0000403      recurrent otitis media
        HP:0000431      wide nasal bridge
        HP:0000437      depressed nasal tip
        HP:0000486      strabismus
        HP:0000508      ptosis
        HP:0000535      sparse eyebrow
        HP:0000592      blue sclerae
        HP:0000637      long palpebral fissure
        HP:0000851      congenital hypothyroidism
        HP:0000957      cafe-au-lait spot
        HP:0001007      hirsutism
        HP:0001212      prominent fingertip pads
        HP:0001249      intellectual disability
        HP:0001250      seizures
        HP:0001252      muscular hypotonia
        HP:0001263      global developmental delay
        HP:0001374      congenital hip dislocation
        HP:0001382      joint hypermobility
        HP:0001629      ventricular septal defect
        HP:0001631      atria septal defect
        HP:0001680      coarctation of aorta
        HP:0001878      hemolytic anemia
        HP:0001973      autoimmune thrombocytopenia
        HP:0002023      anal atresia
        HP:0002024      malabsorption
        HP:0002025      anal stenosis
        HP:0002100      recurrent aspiration pneumonia
        HP:0002553      highly arched eyebrow
        HP:0002566      intestinal malrotation
        HP:0002650      scoliosis
        HP:0003468      abnormality of the vertebrae
        HP:0004322      short stature
        HP:0004467      preauricular pit
        HP:0004736      crossed fused renal ectopia
        HP:0005218      anoperineal fistula
        HP:0007655      eversion of lateral third of lower eyelids
        HP:0008872      feeding difficulties in infancy
        HP:0008897      postnatal growth retardation
        HP:0009237      short 5th finger
        HP:0010314      premature thelarche
51 HPO terms

HP:0000006;HP:0000028;HP:0000054;HP:0000074;HP:0000164;HP:0000175;HP:0000218;HP:0000252;HP:0000358;HP:0000365;HP:0000400;HP:0000403;HP:0000431;HP:0000437;HP:0000486;HP:0000508;HP:0000535;HP:0000592;HP:0000637;HP:0000851;HP:0000957;HP:0001007;HP:0001212;HP:0001249;HP:0001250;HP:0001252;HP:0001263;HP:0001374;HP:0001382;HP:0001629;HP:0001631;HP:0001680;HP:0001878;HP:0001973;HP:0002023;HP:0002024;HP:0002025;HP:0002100;HP:0002553;HP:0002566;HP:0002650;HP:0003468;HP:0004322;HP:0004467;HP:0004736;HP:0005218;HP:0007655;HP:0008872;HP:0008897;HP:0009237;HP:0010314;

```

# References

1. [The Human Phenotype Ontology: a tool for annotating and analyzing human hereditary disease](https://www.ncbi.nlm.nih.gov/pubmed/18950739)
2. [Clinical diagnostics in human genetics with semantic similarity searches in ontologies.](https://www.ncbi.nlm.nih.gov/pubmed/19800049)
3. [Next-generation diagnostics and disease-gene discovery with the Exomiser](https://www.ncbi.nlm.nih.gov/pubmed/26562621)
4. [A Whole-Genome Analysis Framework for Effective Identification of Pathogenic Regulatory Variants in Mendelian Disease](https://www.ncbi.nlm.nih.gov/pubmed/27569544)
5. [Phenolyzer: phenotype-based prioritization of candidate genes for human diseases](https://www.ncbi.nlm.nih.gov/pubmed/26192085)

