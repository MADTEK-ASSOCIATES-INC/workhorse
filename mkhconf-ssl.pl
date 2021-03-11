#!/usr/bin/perl

#
# This is for a site that is being moved
#
# usage: mkhconf.pl <target dir> <target domain> <user> <group> <IP> <ssl filename>
#
# ex: mkhconf.pl joomla mydomain.com

die "usage: $0 <target dir> <target domain> <user> <group> <IP> <ssl filename>" if $#ARGV < 5;

my $result;
my $target;
my $domain;
my ($user, $group);

$targetfile = $ARGV[1] . ".conf";
$domain = $ARGV[1];
$targetdir = $ARGV[0];
$user = $ARGV[2];
$group = $ARGV[3];
$ip = $ARGV[4];
$sslfile = $ARGV[5];

$result = chdir "/etc/httpd/sites";
$result = `cp -a /root/admin-scripts/templates/phptemplate-ssl.hconf $targetfile`;


$result = `sed -i -e 's/TARGETDIR/$targetdir/g' $targetfile`;
$result = `sed -i -e 's/TARGETDOMAIN/$domain/g' $targetfile`;
$result = `sed -i -e 's/USER/$user/g' $targetfile`;
$result = `sed -i -e 's/GROUP/$group/g' $targetfile`;
$result = `sed -i -e 's/TARGETIP/$ip/g' $targetfile`;
$result = `sed -i -e 's/TARGETSSLFILENAME/$sslfile/g' $targetfile`;


