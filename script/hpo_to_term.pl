#!/usr/bin/env perl

# Script to output names and synonyms of HPO terms

use strict;
use warnings;

my $usage = "Usage: $0 <HPO term> [HPO terms]\n";

if (scalar(@ARGV) == 0){
   die $usage;
}

# download from http://purl.obolibrary.org/obo/hp.obo
my $obo = 'hp.obo.gz';
my $id = '';
my %lookup = ();
open(IN,'-|',"gunzip -c $obo") || die "Could not open $obo: $!\n";
while(<IN>){
   chomp;
   if (/^id:\s(HP:\d+)/){
      $id = $1;
      # print "$id\n";
   } elsif (/^name:\s(.*)$/){
      my $name = lc($1);
      $lookup{$id}[0] = $name;
   } elsif (/^synonym:\s\"(.*)\"/){
      my $synonym = lc($1);
      my $index = scalar(@{$lookup{$id}});
      $lookup{$id}[$index] = $synonym;
   }

}
close(IN);

foreach my $h (@ARGV){
   print "$h\n";
   if (exists $lookup{$h}){
      foreach my $d (@{$lookup{$h}}){
         print "\t$d\n";
      }
   } else {
      print "\tNo match\n";
   }
}

__END__
