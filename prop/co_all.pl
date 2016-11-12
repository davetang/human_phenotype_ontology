#!/usr/bin/env perl

use strict;
use warnings;

my %omim = ();
my %omim_id = ();
my %hpo  = ();

my $phenotype = "../script/phenotype_annotation.tab.gz";
open(IN, '-|', "gunzip -c $phenotype") || die "Could not open $phenotype: $!\n";
while(<IN>){
   chomp;
   my ($db, $db_object_id, $db_name, $qualifier, $hpo, $reference, $evidence, $modifier, $frequency, $with, $aspect, $synonym, $date, $assigned) = split(/\t/);
   next unless $db eq 'OMIM';

   $omim_id{$db_object_id} = 1;
   $hpo{$hpo} = 1;

   if (exists $omim{$db_object_id}{$hpo}){
      $omim{$db_object_id}{$hpo}++;
   } else {
      $omim{$db_object_id}{$hpo} = 1;
   }
}
close(IN);

my @omim = sort {$a cmp $b} keys %omim_id;
my @hpo  = sort {$a cmp $b} keys %hpo;

foreach my $d (@omim){
   for (my $i = 0; $i < scalar(@hpo)-1; ++$i){
      my $first = $hpo[$i];
      for (my $j = $i + 1; $j < scalar(@hpo); ++$j){
         my $second = $hpo[$j];
         if (exists $omim{$d}{$first} && exists $omim{$d}{$second}){
            print join("\t", $first, $second, $d), "\n";
         }
      }
   }
}

exit(0);


__END__
