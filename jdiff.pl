#
# jdiff
#
# This program takes two snapshot files created by jsnap and determines
# the difference between the two files.  The primary purpose is to 
# see if either the time stamps have changed for existing files or if 
# a new file has showed up.  This is an intrusion detection technique.
# 
#
#
# ex: jdiff <snapshot 1> <snapshot 2>
#
#

use File::Basename;

die "\nusage: $0 <snapshot 1> <snapshot 2>\n\n" if $#ARGV < 1;

#
# open the two files and read the contents into hashes
#

open (FH1, $ARGV[0]) or die "Cannot open $ARGV[0]\n";
open (FH2, $ARGV[1]) or die "Cannot open $ARGV[1]\n";

while (<FH1>) {
    chomp;
    ($timestamp, $fullname) = split("\t", $_);
    $snap1->{$fullname} = $timestamp;
} # end while

while (<FH2>) {
    chomp;
    ($timestamp, $fullname) = split("\t", $_);
    $snap2->{$fullname} = $timestamp;
} # end while

# First check for files that match in name and time stamp differences

foreach $file (keys %$snap1) {
    if (exists $snap2->{$file}) {
      next if $snap1->{$file} == $snap2->{$file};
      print "\n$file - time stamp difference\n";
    }
} # end for

# Now check to see if anything new has showed up

foreach $file (keys %$snap2) {
    if (!exists $snap1->{$file}) {
      print "\n$file - new file\n";
    }

} # end for

