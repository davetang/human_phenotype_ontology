#!/usr/bin/env perl

require Exporter;
package hpo;
@ISA = qw(Exporter);
@EXPORT_OK = qw/hpo_to_name hpo_to_synonym hpo_to_level/;

# download from http://purl.obolibrary.org/obo/hp.obo
my $script_path = $0;
$script_path =~ s/\w+\.pl$//;
my $obo = $script_path . 'hp.obo.gz';
my $id = '';
# HPO ID has hash key
# scalar references: ISA, NAME, and SYN for attributes of HPO
my %lookup = ();

open(IN,'-|',"gunzip -c $obo") || die "Could not open $obo: $!\n";
while(<IN>){
   chomp;

   # http://www.ontobee.org/ontology/HP?iri=http://purl.obolibrary.org/obo/HP_0000002
   # the id line is always first, so $id should be defined
   # id: HP:0000002
   if (/^id:\s(HP:\d+)/){
      $id = $1;
      # print "$id\n";
   }

   # is_a: HP:0001507 ! Growth abnormality
   elsif (/^is_a:\s(HP:\d+)\s/){
      my $isa = $1;
      if (exists $lookup{$id}->{'ISA'}){
         my $index = scalar(@{$lookup{$id}->{'ISA'}});
         $lookup{$id}->{'ISA'}->[$index] = $isa;
      } else {
         $lookup{$id}->{'ISA'}->[0] = $isa;
      }
   }

   # should be only one name entry
   # name: Abnormality of body height
   elsif (/^name:\s(.*)$/){
      my $n = lc($1);
      $lookup{$id}->{'NAME'} = $n;
   }

   # synonym: "Multicystic dysplastic kidney" EXACT []
   elsif (/^synonym:\s\"(.*)\"/){
      my $synonym = lc($1);
      if (exists $lookup{$id}->{'SYN'}){
         my $index = scalar(@{$lookup{$id}->{'SYN'}});
         $lookup{$id}->{'SYN'}->[$index] = $synonym;
      } else {
         $lookup{$id}->{'SYN'}->[0] = $synonym;
      }
   }
}
close(IN);

# return the full name of a HPO ID
sub hpo_to_name {
   my ($hpo) = @_;
   if (exists $lookup{$hpo}->{'NAME'}){
      return($lookup{$hpo}->{'NAME'});
   } else {
      return("No name for $hpo\n");
   }
}

# return synonym/s for a HPO ID
sub hpo_to_synonym {
   my ($hpo) = @_;
   # return the of a HPO term
   if (exists $lookup{$hpo}->{'SYN'}){
      return($lookup{$hpo}->{'SYN'});
   } else {
      my @empty = ();
      return(\@empty);
   }
}

# return level for a HPO ID
sub hpo_to_level {
   my ($hpo) = @_;
   my $level = 0;
   while(traverse($hpo)){
      ++$level;
      my $hpo_up = traverse($hpo);
      $hpo = $hpo_up;
   }
   return($level);
}

sub traverse {
   my ($hp) = @_;
   if (exists $lookup{$hp}){
      # returns the "is a" relationship
      return($lookup{$hp}->{'ISA'}->[0]);
   }
}

1;
