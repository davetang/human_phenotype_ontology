#!/usr/bin/env perl

# Script to output HPO terms associated with an OMIM ID

use strict;
use warnings;
use hpo qw/hpo_to_name hpo_to_disease hpo_to_gene/;

my $usage = "Usage: $0 <OMIM ID> [OMIM IDs]\n";

if (scalar(@ARGV) == 0){
   die $usage;
}
# download from http://purl.obolibrary.org/obo/hp.obo
my $script_path = $0;
$script_path =~ s/\w+\.pl$/..\/data\//;
my $disease = $script_path . 'phenotype_annotation.tab.gz';

=head1 Columns in annotation file
1       DB      required        MIM
2       DB_Object_ID    required        154700
3       DB_Name required        Achondrogenesis, type IB
4       Qualifier       optional        NOT
5       HPO ID  required        HP:0002487
6       DB:Reference    required        OMIM:154700 or PMID:15517394
7       Evidence code   required        IEA
8       Onset modifier  optional        HP:0003577
9       Frequency modifier      optional        "70%" or "12 of 30" or from the vocabulary show in table below
10      With    optional         
11      Aspect  required        O
12      Synonym optional        ACG1B|Achondrogenesis, Fraccaro type
13      Date    required        YYYY.MM.DD
14      Assigned by     required        HPO
=cut

my %lookup = ();
my %name   = ();

open(IN,'-|',"gunzip -c $disease") || die "Could not open $disease: $!\n";
while(<IN>){
   chomp;
   my ($db, $db_object_id, $db_name, $qualifier, $hpo, $reference, $evidence, $modifier, $frequency, $with, $aspect, $synonym, $date, $assigned) = split(/\t/);

   # store only OMIM disorders
   next unless $db eq 'OMIM';

   # just keep the numbers OMIM:100300
   $db_object_id =~ s/^OMIM://;

   if (exists $lookup{$db_object_id}){
      my $index = scalar(@{$lookup{$db_object_id}});
      $lookup{$db_object_id}[$index] = $hpo;
   } else {
      $lookup{$db_object_id}[0] = $hpo;
      $name{$db_object_id}      = $db_name;
   }
}
close(IN);

foreach my $h (@ARGV){
   my $phenolyzer_input = '';
   $h =~ s/^OMIM://;
   $h =~ s/(\d+).*$/$1/;
   
   if (exists $lookup{$h}){
      my %check = ();
      my $counter = 0;
      print "OMIM:$h\t$name{$h}\n";
      foreach my $n (@{$lookup{$h}}){
         next if exists $check{$n};
         $check{$n} = 1;
         $phenolyzer_input .= "$n;";
         ++$counter;
         my $term = hpo_to_name($n);
         my $disease = hpo_to_disease($n);
         my $gene = hpo_to_gene($n);
         print "\t$n\t$term\tno. disease association: $disease\tno. gene association: $gene\n";
      }

      print "$counter HPO terms\n\n";
      print "$phenolyzer_input\n\n";
      print "---------------------------\n\n";

   } else {
      print "Your input $h was not found\n\n";
      print "---------------------------\n\n";
   }

}

__END__

