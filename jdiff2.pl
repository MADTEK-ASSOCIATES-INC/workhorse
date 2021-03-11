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
# ex: jdiff <production dir> <snapshot dir>
#
#

use File::Basename;

die "\nusage: $0 <production dir> <snapshot dir>\n\n" if $#ARGV < 1;

#
# Read the production dir and build a hash and read the snapshot file
# and build a hash for comparison.
#
$ARGV[1] =~ s/\/$//;
$snapfile = $ARGV[1] . "/jsnap.txt";

open (FH1, $snapfile) or die "Cannot open $snapfile\n";

while (<FH1>) {
    chomp;
    ($timestamp, $fullname) = split("\t", $_);
    $snap1->{$fullname} = $timestamp;
} # end while

$ARGV[0] =~ s/\/$//;
$basedir = $ARGV[0];

@dirlist = list($ARGV[0]);

foreach $item (@dirlist) {
    $prodhash->{$item} = "";
    $item =~ s/$basedir\///;

    ($timestamp, $fullname) = split("\t", $item);
    $snap2->{$fullname} = $timestamp;
}

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

#
# Recursively list the files in a directory and returns an array with the
# timestamp and full pathname delimited by tab.
#
sub list
{
    my ($dir) = @_;
    return unless -d $dir;

    my @files;
  if (opendir my $dh, $dir)
  {
    # Capture entries first, so we don't descend with an
    # open dir handle.
      my @list;
      my $file;
      my $mtime;
    while ($file = readdir $dh)
    {
#       next if $file eq '.' || $file eq '..';
        next if $file eq '..';
        $mtime = $xstat[9];
#       push @list, "$mtime|$file";
        push @list, $file;
#       print "-> $file\n";
    }
      closedir $dh;

    for $file (@list)
    {
      # Unix file system considerations.
        next if $file eq '.' || $file eq '..';

      # Swap these two lines to follow symbolic links into
      # directories.  Handles circular links by entering an
      # infinite loop.
        $mtime = (stat "$dir/$file") [9];
        push @files, "$mtime\t$dir/$file"        if -f "$dir/$file";
        push @files, list ("$dir/$file") if -d "$dir/$file";
    }
  }

    return @files;
}
