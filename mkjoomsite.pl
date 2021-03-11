#!/usr/bin/perl

#
# This is for a site that is being moved
#
# usage: mkphpsite.pl <target app> <target dir> <user> <group>
#
# ex: mkphpsite.pl joomla mydomain.com

die "usage: $0.pl <target app> <target dir> <user> <group> <template dir>" if $#ARGV < 4;

my $result;

$result = chdir "/var/www/$ARGV[0]";
$result = `mkdir $ARGV[1]`;
$result = `chown $ARGV[2] $ARGV[1]`;
$result = `chgrp $ARGV[3] $ARGV[1]`;
$result = `cp -a /var/www/$ARGV[4]/web-template/cgi-bin $ARGV[1]`;
$result = `cp -a /var/www/$ARGV[4]/web-template/etc $ARGV[1]`;
$result = `cp -a /var/www/$ARGV[4]/web-template/logs	$ARGV[1]`;
$result = `cp -a /var/www/$ARGV[4]/web-template/tmp $ARGV[1]`;
$result = chdir "$ARGV[1]";
$result = `mkdir public_html`;
$result = `chown $ARGV[2] public_html`;
$result = `chgrp $ARGV[3] public_html`;
$result = `chmod g+w public_html`;

my $dir = $ARGV[1];
my $dir2 = $ARGV[0];

$result = `sed -i -e 's/TARGETDIR/$dir/g' cgi-bin/php.fcgi`;
$result = `sed -i -e 's/TARGETAPP/$dir2/g' cgi-bin/php.fcgi`;

$result = `sed -i -e 's/TARGETDIR/$dir/g' etc/php.ini`;
$result = `sed -i -e 's/TARGETAPP/$dir2/g' etc/php.ini`;

#
# Here is where we want a straight copy from the specified directory
# of the latest to the public_html.  Not sure the best way to do that
# at this point, but it will come to mind.
