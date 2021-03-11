#
# jscanner
#
# This program is essentially a virus scan program that looks for 
# known signatures and suspicious activity otherwise.
#
# The script takes in a file with a list of directories to scan
# 
#
# ex: jscanner <directory file> <report directory>
#
#

use Digest::MD5;

die "\nusage: $0 <directory file> <report directory>\n" if $#ARGV < 0;

$ARGV[1] =~ s/\/$//;

open DFH, "$ARGV[0]" or die "can't open directory list file$!";

while (<DFH>) {

  chomp;

  print "\n------------------------------------------------------------------\n";
  print "Directory scan for $_\n";
  print "------------------------------------------------------------------\n";


  #
  # traverse the Joomla production directory
  #
  
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  
  $year += 1900;
  # my $snapfilename = "jscanner_$mon-$mday-$year.txt";
#  my $scannerlogfile = $ARGV[1] . "/jscanner." . time;
  
  
  #open SFHL, ">$scannerlogfile" or die $!;
  
  $ARGV[0] =~ s#/$##;
  $basedir = $_ . "/public_html";
  
  $result = chdir "$_";
  opendir(PDIR, ".");
  @files = readdir(PDIR);
  closedir(PDIR);
  

   @dirlist = list($basedir);

   foreach $item (@dirlist) {
       $item =~ s/\(/\\(/;
       $item =~ s/\)/\\)/;
       $item =~ s/ /\\ /;
       $item =~ s/\-/\\-/;
       $item =~ s/\&/\\&/;

       # grep the file for base64_decode
       $result = `grep base64_decode $item | grep eval`;
       if ($result) {
#         print "$item - $result\n";
         print "$item\n";
       }
       $prodhash->{$item} = "";
   }

} # end while

#
# Recursively list the files in a directory and returns an array with the
# just the filename in it
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
	next if $file eq '..' || $file eq '.';
	$mtime = $xstat[9];
        $file =~ s/ /\\ /g;
        $file =~ s/\-/\\-/g;
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
