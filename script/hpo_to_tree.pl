#!/usr/bin/env perl

# Script to output tree from a HPO term

use strict;
use warnings;

my $usage = "Usage: $0 <HPO term> [HPO terms]\n";

if (scalar(@ARGV) == 0){
   die $usage;
}

# download from http://purl.obolibrary.org/obo/hp.obo
my $script_path = $0;
$script_path =~ s/\w+\.pl$/..\/data\//;
my $obo = $script_path . 'hp.obo.gz';

my $id = '';
my %lookup = ();
my %name = ();

open(IN,'-|',"gunzip -c $obo") || die "Could not open $obo: $!\n";
while(<IN>){
   chomp;
   # http://www.ontobee.org/ontology/HP?iri=http://purl.obolibrary.org/obo/HP_0000002
   # the id line is always first, so $id should be defined
   # id: HP:0000002
   if (/^id:\s(HP:\d+)/){
      $id = $1;
      # print "$id\n";
   # is_a: HP:0001507 ! Growth abnormality
   } elsif (/^is_a:\s(HP:\d+)\s/){
      my $isa = $1;
      if (exists $lookup{$id}){
         my $index = scalar(@{$lookup{$id}});
         $lookup{$id}[$index] = $isa;
      } else {
         $lookup{$id}[0] = $isa;
      }
   # name: Abnormality of body height
   } elsif (/^name:\s(.*)$/){
      my $n = lc($1);
      $name{$id} = $n;
   }

}
close(IN);

my $x = '';

foreach my $hpo (@ARGV){
   # new variable to store the "is a" relationships
   $x = $hpo;
   my $level = 0;
   print "$hpo\t$name{$hpo}\n";
   while(traverse($x)){
      ++$level;
      my $up = traverse($x);
      print "$up\t$name{$up}\n";
      $x = $up;
   }
   print "Level $level\n";
}

sub traverse {
   my ($hp) = @_;
   if (exists $lookup{$hp}){
      # returns the "is a" relationship
      return($lookup{$hp}[0]);
   }
}

__END__
