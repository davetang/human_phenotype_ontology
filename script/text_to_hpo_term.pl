#!/usr/bin/env perl

# Strings (the query) present on each line of a file are matched to Human Phenotype Ontology (HPO) terms (the subject)
# If a direct match between the query and subject could not be found, a global alignment is performed
# Alignments will only take place between queries and subjects that are not longer than each 
# other by a length of 5 characters (including spaces)
# For example, 'short' and 'microphones' differ by a length of 6 and will not be compared
# The terms 'short' and 'computer' will be aligned because they differ by a length of 3
# Change $threshold if you want to change the length difference threshold

use strict;
use warnings;

my $threshold = 4;

my $usage = "Usage: $0 <infile.txt>\n";
my $infile = shift or die $usage;

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
      $lookup{$name} = $id;
      # print "\tname\t$name\n";
   } elsif (/^synonym:\s\"(.*)\"/){
      my $synonym = lc($1);
      $lookup{$synonym} = $id;
      # print "\tsynonym\t$synonym\n";
   }

}
close(IN);

my ($total, $match, $missing) = (0, 0, 0);
my @missing = ();

open(IN,'<',$infile) || die "Could not open $infile: $!\n";
while(<IN>){
   chomp;
   ++$total;
   my $term = lc($_);
   if (exists $lookup{$term}){
      ++$match;
      print "$term: $lookup{$term}\n";
   } else {
      push(@missing, $term);
      ++$missing;
   }
}
close(IN);

my $report = "\nMatched $match term/s out of a total of $total.";

if ($missing > 0){
   $report .= " $missing term/s could not be matched:\n";
   foreach my $m (@missing){
      $report .= "$m\n";
   }
} else {
   $report .= "\n";
}

print ("$report\n");

foreach my $q (@missing){
   my $best_score = 31;
   my %score = ();
   my @best = ();
   my $ql = length($q);

   print "=====================================\n$q\n=====================================\n";

   foreach my $s (keys %lookup){
      my $sl = length($s);
      my $diff = abs($ql - $sl);
      next if $diff > $threshold;
      my $e = align($q, $s);
      if ($e < $best_score){
         $best_score = $e;
         @best = $s;
      } elsif ($e <= $best_score){
         push(@best, $s);
      }
      if (exists $score{$e}){
         my $i = scalar(@{$score{$e}});
         $score{$e}[$i] = $s;
      } else {
         $score{$e}[0] = $s;
      }
   }
   
   print "Best match/es for $q with a mismatch score of $best_score:\n";
   foreach my $best (@best){
      print "\t$best: $lookup{$best}\n";
   }
   print "\n";

   for (my $i = 1; $i < 3; ++$i){
      my $new_best = $best_score + $i;
      print "Best match/es for $q with a mismatch score of $new_best:\n";
      foreach my $s (@{$score{$best_score+$i}}){
         print "\t$s: $lookup{$s}\n";
      }
      print "\n";
   }

}

exit(0);

sub align {
   my ($seq1,$seq2) = @_;
   my $edit = '0';

   my $match = '1';
   my $mismatch = '-1';
   my $gap = '-1';

   my @matrix;
   $matrix[0][0]{score}   = 0;
   $matrix[0][0]{pointer} = "none";
   for(my $j = 1; $j <= length($seq1); $j++) {
      $matrix[0][$j]{score}   = $gap * $j;
      $matrix[0][$j]{pointer} = "left";
   }
   for (my $i = 1; $i <= length($seq2); $i++) {
      $matrix[$i][0]{score}   = $gap * $i;
      $matrix[$i][0]{pointer} = "up";
   }

   # fill
   for(my $i = 1; $i <= length($seq2); $i++) {
      for(my $j = 1; $j <= length($seq1); $j++) {
         my ($diagonal_score, $left_score, $up_score);

         # calculate match score
         my $letter1 = substr($seq1, $j-1, 1);
         my $letter2 = substr($seq2, $i-1, 1);
         if ($letter1 eq $letter2) {
            $diagonal_score = $matrix[$i-1][$j-1]{score} + $match;
         } else {
            $diagonal_score = $matrix[$i-1][$j-1]{score} + $mismatch;
         }

         # calculate gap scores
         $up_score   = $matrix[$i-1][$j]{score} + $gap;
         $left_score = $matrix[$i][$j-1]{score} + $gap;

         # choose best score
         if ($diagonal_score >= $up_score) {
            if ($diagonal_score >= $left_score) {
               $matrix[$i][$j]{score}   = $diagonal_score;
               $matrix[$i][$j]{pointer} = "diagonal";
            } else {
               $matrix[$i][$j]{score}   = $left_score;
               $matrix[$i][$j]{pointer} = "left";
            }
         } else {
            if ($up_score >= $left_score) {
               $matrix[$i][$j]{score}   = $up_score;
               $matrix[$i][$j]{pointer} = "up";
            } else {
               $matrix[$i][$j]{score}   = $left_score;
               $matrix[$i][$j]{pointer} = "left";
            }
         }
      }
   }
   # trace-back
   my $align1 = "";
   my $align2 = "";

   # start at last cell of matrix
   my $j = length($seq1);
   my $i = length($seq2);

   while (1) {
      last if $matrix[$i][$j]{pointer} eq "none"; # ends at first cell of matrix

      if ($matrix[$i][$j]{pointer} eq "diagonal") {
         $align1 .= substr($seq1, $j-1, 1);
         $align2 .= substr($seq2, $i-1, 1);
         $i--;
         $j--;
      } elsif ($matrix[$i][$j]{pointer} eq "left") {
         $align1 .= substr($seq1, $j-1, 1);
         $align2 .= "-";
         $j--;
      } elsif ($matrix[$i][$j]{pointer} eq "up") {
         $align1 .= "-";
         $align2 .= substr($seq2, $i-1, 1);
         $i--;
      }
   }
   $align1 = reverse $align1;
   $align2 = reverse $align2;

   for (my $i=0; $i<length($align1); ++$i){
      if (substr($align1,$i,1) ne substr($align2,$i,1)){
         ++$edit;
      }
   }
   return($edit);
}

__END__
