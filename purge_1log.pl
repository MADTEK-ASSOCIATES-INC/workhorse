#
# purge_log
#
# This program purges log files that are older than 30 days
#
# ex: purge_log.pl <log file dir>
#
#

die "\nusage: $0 <log file dir> \n" if $#ARGV < 0;

my $sourcedir;

#
# get local time and purge files older than 30 days
#

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $today = time();

$year += 1900;



# Read in and parse the content of the source directory

$result = chdir "$ARGV[0]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);

# Note: There are 86400 seconds in a day
#

foreach $item (@files) {
    next if $item eq '.' || $item eq '..';
    $item =~ /\w*\.\w*\.(\d*)/;
#    print "$1\n";

    # if today - $1 > 86400 * 30
    #  delete it
    if (($today - $1) > (86400 * 30)) {
	if (unlink($item) == 0) {
          print "$item deleted\n";
        }
    }

}

__END__


# ??  print "$file\n";

  @dirlist = list($ARGV[0]);

  foreach $item (@dirlist) {

        next if $file eq '.' || $file eq '..';

        # only look at files with a .conf extension
        next unless $item =~ /\.conf$/;

        my ($timestamp,$file) = split(/\|/, $item);

        # open the conf file and pull out where the logs are
        open FH, $file or die ("Could not open $file - $! \n");
        while (<FH>) {
            chomp;
	    if (/ErrorLog/) {
		my ($p1, $p2, $logdir, $dur) = split(" ", $_);
                $logdir =~ s/\/error_log$//;
		print "$logdir\n";

                # Open the directory and unlink any file that is older
                # than 30 days from todays time

                my $result = chdir "$logdir";
                opendir(LDIR, ".");
                @lfiles = readdir(LDIR);
                closedir(LDIR);
                foreach $lfile (@lfiles) {
		    chomp;
                  next if $lfile eq '.' || $lfile eq '..';
		    @parts = split('\.', $lfile);

                  # if today - $parts[$#parts] > 86400 * 30
                  #  delete it
		    if (($today - $parts[$#parts]) > (86400 * 30)) {
			print "$lfile is ready to delete\n";
		    }

                  print "@parts\n";

		}
	    }


        } # end while

    } # end for



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
