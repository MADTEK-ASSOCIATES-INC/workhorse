#!/usr/bin/perl

#
# This is for updating joomla sites from a list of files and a source directory
#
# usage: update_joom.pl <webdir list> <source update dir>
#

die "usage: $0 <webdir list> <source update dir>" if $#ARGV < 1;

my $result;
my $fn = $ARGV[0];
my $sourcedir = $ARGV[1] . "/*";
my $cnt=0;

open(FH, "$fn") or die "Can't open $fn : $!";

while (<FH>) {

  chomp;

  print "updating $_ from $sourcedir\n";

  $result = chdir "$_";
  
  $result = `\\cp -a $sourcedir .`;

  $cnt++;
  
} # end while

print "\n$cnt sites updated have a nice day :)\n";

