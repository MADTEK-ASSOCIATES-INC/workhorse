#
# jscan
#
# This program takes a source directory and a snapshot file and 
# compares the two to see if any new files have appeared or there are any
# files that have disappeared.
#
# ex: jscan.pl <source directory> <snapshot file>
#
#

die "\nusage: $0 <source directory> <snapshot file>\n" if $#ARGV < 0;

my $sourcedir;

#
# traverse the Joomla production directory
#

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;


open SFH, "$ARGV[1]" or die $!;

# Read and parse the contents of the snapshot file into a hash

while (<SFH>) {
    chomp;
    my ($timestamp,$file) = split("\t", $_);


#    my @test = split(/\t/, $_);
    $snapshot->{$file} = $timestamp;

} # end while

# Read in and parse the content of the source directory

$result = chdir "$ARGV[0]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);


#foreach $file (@files) {

#    next if $file eq '.' || $file eq '..';
#    next if $file =~ /^installation/;

    print "$file\n";

    @dirlist = list($ARGV[0]);

    foreach $item (@dirlist) {
        my ($timestamp,$file) = split(/\|/, $item);

        $prodhash->{$file} = $timestamp;

        if ($file eq "") {
          print "$_\n";
        }
    }
#} # end for

# =====

# Now do the intersection of the two sets

# 1st whats in the snapshopt that's not in prod dir

print "\n------ Files in snapshot not in production -----\n\n";

foreach my $key (keys %$snapshot) {

    if (!exists($prodhash->{$key})) {
        print "$key\n"; 
    }

} # end foreach

# 2nd whats in the prod dir that's not in snapshot

print "\n------ Files in production not in snapshot -----\n\n";

foreach my $key (keys %$prodhash) {


    if (!exists($snapshot->{$key})) {
      print "$key\n"; 
    }
    


} # end foreach


close SFH;


#
# Recursively list the files in a directory
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
	next if $file eq '.' || $file eq '..';
	$mtime = $xstat[9];
#	push @list, "$mtime|$file";
	push @list, $file;
#	print "-> $file\n";
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
	push @files, "$mtime|$dir/$file"        if -f "$dir/$file";
	push @files, list ("$dir/$file") if -d "$dir/$file";
    }
  }

    return @files;
}
