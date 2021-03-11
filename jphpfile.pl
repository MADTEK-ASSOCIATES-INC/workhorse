#
# jphpfile
#
# This program reads a production directory of files and compares that to
# the out of the box Joomla distribution to look for php files in the 
# production directory that are not in the standard distribution.  This is a
# way to do a comprehensive search of php files that do not belong in the
# files system.
#
# ex: jphpfile <production directory> <Joomla distribution dirfile>
#
#

use Digest::MD5;

die "\nusage: $0 <directory> <Joomla distribution dirfile>\n" if $#ARGV < 1;

#
# traverse the directory
#

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;

$ARGV[0] =~ s#/$##;
$basedir = $ARGV[0];

$result = chdir "$ARGV[0]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);


@dirlist = list($ARGV[0]);

# Open the joomla distribution file list and read it in

open(JFH, $ARGV[1]) or die "Can't open Joomla distribution file $! \n";

@joomlist = <JFH>;

    foreach $item (@dirlist) {
        next unless $item =~ /\.php$/;
        $item =~ s#$ARGV[0]/##;
        $cnt = `grep $item $ARGV[1]`;
        if (!$cnt) {
	    if (($item =~ /^media/) || ($item =~ /^images/)) {
		print ">>>> ";
            }
 	  print "$item\n";
        }
    }


#}

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

	next if $file eq '..';
	$mtime = $xstat[9];

	push @list, $file;

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
