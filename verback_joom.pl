#!/usr/bin/perl

#
# This file looks for back level joomla sites as a double check on a
# security update.
#
# usage: verback_joom.pl <directory> <minor release> 
#
#  options: 
#
#   -l list only and all files that are a back level release from minor release
#
#   -e list files that are at a specific minor release
#

use Getopt::Long;

die "usage: $0 <directory> [minor release]" if $#ARGV < 1;

my $result;
my $listonly;
my @argv = @ARGV;
my $devlevel;
my $specific;

GetOptions ('l' => \$listonly, 'e' => \$specific);
if ($listonly) {
    $dir = $argv[1];
  $devlevel = $argv[2];
} elsif ($specific) {
    $dir = $argv[1];
  $devlevel = $argv[2];
} else {
  $dir = $argv[0];
  $devlevel = $argv[1];
}

my $cnt=0;

my $jwebs="/var/www/$dir";

opendir(JD,$jwebs) or die "Cannot open web directory... $!\n";

@files = readdir(JD);

foreach $f (@files) {

  if (-d "$jwebs/$f") {
      next if /^\.$/ || /^\.\.$/;
    print "Scanning $f\n" unless $listonly || $specific;
    unless (open($version, "$jwebs/$f/public_html/libraries/joomla/version.php"))
    {
      print "No 1.5 ver for $f\n" unless $listonly || $specific;
      next;
    }
    while (<$version>) {
        if (/\$RELEASE/ || /'1.5'/) {
	    $release = "1.5";
        }
        if (/\$DEV_LEVEL/) {
	    /= '(\d+)'/;
            if ($listonly) {
              if ($1 < $devlevel) {
		  print "$f - $release.$1\n";
              }
	    } elsif ($specific) {
	        print "$f - $release.$1\n" if $1 == $devlevel;
            } else {
		  print "$f - $release.$1\n";
            }
        }
    } # end while
  } # end if

}

__END__

open(FH, "$fn") or die "Can't open $fn : $!";

while (<FH>) {

  chomp;

  print "updating $_ from $sourcedir\n";

  $result = chdir "$_";
  
  $result = `\\cp -a $sourcedir .`;

  $cnt++;
  
} # end while

print "\n$cnt sites updated have a nice day :)\n";

