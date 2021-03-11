#!/usr/bin/perl

# ----------------------------------------------------------------------------
#
# This script takes a collection of parameters and generates an Apache
# .conf file in /etc/httpd/vhost.d
#
# usage: mkhconf.pl <IP> <client> <platform> <domain> <user> <group>
#
# ex: mkhconf.pl windowgang joomla windowgang.com wgang_01 wgang_01
#
# Author: J. Eversole - November 2013
#
# ----------------------------------------------------------------------------

die "\n\nusage: $0 <IP> <client dir> <platform> <domain> <user> <group>\n\nex: mkhconf.pl 10.209.72.74 windowgang joomla windowgang.com wgang_01 wgang_01\n\n" if $#ARGV < 5;

my $clientdir = $ARGV[1];
my $platform  = $ARGV[2];
my $domain    = $ARGV[3];
my $filename  = "$domain.conf";
my $user      = $ARGV[4];
my $group     = $ARGV[5];
my $ip        = $ARGV[0];

$result = chdir "/etc/httpd/vhost.d";
$result = `cp -a templates/phphconf.template $filename`;


$result = `sed -i -e 's/<IP>/$ip/g' $filename`;
$result = `sed -i -e 's:<CLIENT>:$clientdir:g' $filename`;
$result = `sed -i -e 's/<PLATFORM>/$platform/g' $filename`;
$result = `sed -i -e 's/<DOMAIN>/$domain/g' $filename`;
$result = `sed -i -e 's/<USER>/$user/g' $filename`;
$result = `sed -i -e 's/<GROUP>/$group/g' $filename`;



