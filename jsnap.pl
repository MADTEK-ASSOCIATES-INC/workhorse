#
# jsnap
#
# This program reads a file with a list of domain names and directories 
# and then takes a snapshot of all the files in the directory.  These
# files are later used to monitor the deposit of any new files in the
# directories and send out an alarm based on the extension.
#
#
# ex: jsnap <snapshot directory>
#
#

die "\nusage: $0 <snapshot directory>\n" if $#ARGV < 0;

#
# traverse the Joomla production directory
#

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;


$result = chdir "$ARGV[0]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);


    @dirlist = list($ARGV[0]);

    foreach $item (@dirlist) {
#        next if $item =~ /^installation/;
        $prodhash->{$item} = "";
	$item =~ s/$ARGV[0]\///;
	print "$item\n";
    }


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
#	next if $file eq '.' || $file eq '..';
	next if $file eq '..';
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
	push @files, "$dir/$file"        if -f "$dir/$file";
	push @files, list ("$dir/$file") if -d "$dir/$file";
    }
  }

    return @files;
}
