#
# jtime
#
# This program reads a directory of files and consolidates the time stamps
# so as to get a spread on the time stamps.  This is useful information to
# determine the most recent file activity on the site.
#
# ex: jtime <directory> [date]
#
# options:
#
#   -l list files on a specific date
#
#

#

use Digest::MD5;

#use Getopt::Long;
use Time::Local;

die "\nusage: $0 <directory>\n" if $#ARGV < 0;

my $threshold;

if ($ARGV[1]) {
  # split the file date into mon day year
    my ($mon,$day,$year) = split(/-/,$ARGV[1],-1);
    $threshold = timelocal(0,0,0,$day,$mon-1,$year);
} 


#
# traverse the directory
#

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $localtime = localtime(time);

$year += 1900;

$ARGV[0] =~ s#/$##;
$basedir = $ARGV[0];

$result = chdir "$ARGV[0]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);

print "\n\n";

    @dirlist = list($ARGV[0]);

    foreach $item (@dirlist) {
        next unless $item =~ /\.php$/;
        my ($timestamp, $fullpath) = split("\t", $item);
#        $timehash->{$timestamp} = $fullpath;
        $timehash->{$fullpath} = $timestamp;
        if ($threshold <= $timestamp) {
          my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timestamp);
  	  print $mon+1,"-$mday-",$year+1900," \t: $fullpath\n";
        }
    }

# Print out the unique time stamps

$prev = "";
$cnt = 0;

#if (1==2) {

print "\n\nDate\t\t Hour\t Count\n";
print "----------------+-------+---------\n";

foreach $key (sort {$a<=>$b} values %$timehash) {
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($key);
  $year += 1900;
  $mon++;
  $output = "$mon-$mday-$year \t: $hour \t:";
  if ($output ne $prev) {
    print "$output $cnt\n"; 
    $prev = $output;
    $cnt = 0;
  }
  $cnt++;

} # end foreach

print "\n\n";

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
	push @files, "$mtime\t$dir/$file"        if -f "$dir/$file";
	push @files, list ("$dir/$file") if -d "$dir/$file";
    }
  }

    return @files;
}
