#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <first> <second>\n";
my $first = shift or die $usage;
my $second = shift or die $usage;

my %omim = ();
my $phenotype = "../script/phenotype_annotation.tab.gz";
open(IN, '-|', "gunzip -c $phenotype") || die "Could not open $phenotype: $!\n";
while(<IN>){
   chomp;
   my ($db, $db_object_id, $db_name, $qualifier, $hpo, $reference, $evidence, $modifier, $frequency, $with, $aspect, $synonym, $date, $assigned) = split(/\t/);
   next unless $db eq 'OMIM';
   next unless $hpo eq $first || $hpo eq $second;

   if (exists $omim{$db_object_id}{$hpo}){
      $omim{$db_object_id}{$hpo}++;
   } else {
      $omim{$db_object_id}{$hpo} = 1;
   }

}
close(IN);

foreach my $d (keys %omim){
   if (exists $omim{$d}{$first} && exists $omim{$d}{$second}){
      print "$d\n";
   }
}

exit(0);


__END__
