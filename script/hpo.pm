#!/usr/bin/env perl

use strict;
use warnings;

package hpo;

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

sub hpo_to_term {
   my ($hpo) = @_;
   return($lookup{$hpo}[0]);
}

1;

