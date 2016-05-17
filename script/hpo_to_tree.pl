#!/usr/bin/env perl

# Script to output tree from a HPO term

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
my %name = ();

open(IN,'-|',"gunzip -c $obo") || die "Could not open $obo: $!\n";
while(<IN>){
   chomp;
   if (/^id:\s(HP:\d+)/){
      $id = $1;
      # print "$id\n";
   } elsif (/^is_a:\s(HP:\d+)\s/){
      my $name = $1;
      if (exists $lookup{$id}){
         my $index = scalar(@{$lookup{$id}});
         $lookup{$id}[$index] = $name;
      } else {
         $lookup{$id}[0] = $name;
      }
   } elsif (/^name:\s(.*)$/){
      my $n = lc($1);
      $name{$id} = $n;
   }

}
close(IN);

my $x = '';

foreach my $h (@ARGV){
   $x = $h;
   my $level = 0;
   print "$h\t$name{$h}\n";
   while(traverse($x)){
      ++$level;
      my $o = traverse($x);
      print "$o\t$name{$o}\n";
      $x = $o;
   }
   print "Level $level\n";
}

sub traverse {
   my ($hp) = @_;
   if (exists $lookup{$hp}){
      return($lookup{$hp}[0]);
   }
}

__END__
