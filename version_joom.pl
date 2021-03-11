#!/usr/bin/perl

#
# This is for updating joomla sites from a list of files and a source directory
#
# usage: version_joom.pl <webdir list> <source update dir>
#

# die "usage: $0 <webdir list> <source update dir>" if $#ARGV < 1;

my $result;
my $fn = $ARGV[0];
my $sourcedir = $ARGV[1] . "/*";
my $cnt=0;

my $jwebs="/var/www/joomla";

opendir(JD,$jwebs) or die "Cannot open Joomla directory... $!\n";

@files = readdir(JD);

foreach $f (@files) {

  if (-d "$jwebs/$f") {
      next if /^\.$/ || /^\.\.$/;
    print "Scanning $f\n";
    unless (open($version, "$jwebs/$f/public_html/libraries/joomla/version.php"))
    {
      print "No 1.5 ver for $f\n";
      next;
    }
    while (<$version>) {
        if (/\$RELEASE/ || /'1.5'/) {
  	  print;
        }
        if (/\$DEV_LEVEL/) {
  	  print;
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

