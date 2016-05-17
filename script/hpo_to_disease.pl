#!/usr/bin/env perl

# Script to output tree from a HPO term

use strict;
use warnings;

my $usage = "Usage: $0 <HPO term> [HPO terms]\n";

if (scalar(@ARGV) == 0){
   die $usage;
}

my $disease = 'phenotype_annotation.tab.gz';

=head1 Columns in annotation file
1	DB	required	MIM
2	DB_Object_ID	required	154700
3	DB_Name	required	Achondrogenesis, type IB
4	Qualifier	optional	NOT
5	HPO ID	required	HP:0002487
6	DB:Reference	required	OMIM:154700 or PMID:15517394
7	Evidence code	required	IEA
8	Onset modifier	optional	HP:0003577
9	Frequency modifier	optional	"70%" or "12 of 30" or from the vocabulary show in table below
10	With	optional	 
11	Aspect	required	O
12	Synonym	optional	ACG1B|Achondrogenesis, Fraccaro type
13	Date	required	YYYY.MM.DD
14	Assigned by	required	HPO
=cut

my %lookup = ();
my %hpo = ();

open(IN,'-|',"gunzip -c $disease") || die "Could not open $disease: $!\n";
while(<IN>){
   chomp;
   my ($db, $db_object_id, $db_name, $qualifier, $hpo, $reference, $evidence, $modifier, $frequency, $with, $aspect, $synonym, $date, $assigned) = split(/\t/);
   $hpo{$hpo} = 1;
   if (exists $lookup{$hpo}){
      my $index = scalar(@{$lookup{$hpo}});
      $lookup{$hpo}[$index] = $db_name;
   } else {
      $lookup{$hpo}[0] = $db_name;
   }
}
close(IN);

foreach my $h (@ARGV){
   next unless exists $lookup{$h};
   my %check = ();
   my $counter = 0;
   print "$h\n";
   foreach my $n (@{$lookup{$h}}){
      next if exists $check{$n};
      $check{$n} = 1;
      ++$counter;
      print "\t$n\n";
   }
   print "$h\t$counter\n";
}

__END__

# check to see number of disease associations to HPO terms
my @hpo = keys %hpo;
my $number = scalar(@hpo);
warn("There are $number HPO terms in $disease\n");

foreach my $h (@hpo){
   next unless exists $lookup{$h};
   my %check = ();
   my $counter = 0;
   foreach my $n (@{$lookup{$h}}){
      next if exists $check{$n};
      $check{$n} = 1;
      ++$counter;
   }
   print "$h\t$counter\n";
}


