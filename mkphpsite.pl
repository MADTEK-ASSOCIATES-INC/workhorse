#!/usr/bin/perl

#----------------------------------------------------------------------------------------------
#
# Provisioning script for a standard PHP site
#
# usage: mkphpsite.pl <CLIENT> <PLATFORM> <DOMAIN> <USER> <GROUP>
#
# ex: mkphpsite.pl seakayakadventures joomla seakayakadventures.com seaka_01 seaka_01
#
# Author: J Eversole - November 2013
#
#----------------------------------------------------------------------------------------------

my $basedir = "/var/www";
my $provisiondir = "/opt/madtek/provision_tools/templates/web";

die "\nusage: $0.pl <client> <platform> <domain> <user> <group>\n\n ex: $0 seakayakadventures joomla seakayakadventures.com seaka_01 seaka_01\n\n" if $#ARGV < 4;

my ($client,$platform,$domain,$user,$group) = @ARGV;

my $result;

my ($login,$pass,$uid,$gid) = getpwnam($user)
    or die "$user must exist for this script to run";

#----------------------------------------------------------------------------------------------
# The client directory may of may not exist. If it does then it could have been created as
# the home directory when the user id was created.  The check above makes sure we can't get
# here unless the user id exists
#----------------------------------------------------------------------------------------------

my $clientdir = "$basedir/$client";

if (-d $clientdir) {

    # If the platform directory exists then get out as an install has already been done
    die "\nAn installation already exists... $platform\n" if -d $platform;

    $result = chdir $clientdir;        # chdir into platform directory

    $result = mkdir $platform, 0755;   # create platform directory
    `chown $user $platform`;
    `chgrp $group $platform`;
    $result = chdir $platform;         # chdir into platform directory
    $result = mkdir $domain, 0755;     # create domain directory
    `chown $user $domain`;
    `chgrp $group $domain`;
    $result = chdir $domain;           # chdir into domain directory
} else {
    $result = chdir $basedir;        # chdir into platform directory
    $result = mkdir $clientdir, 0755;   # create the client directory
    `chown $user $client`;
    `chgrp $group $client`;
    $result = chdir $clientdir;         # chdir into client directory
    $result = mkdir $platform, 0755;     # create platform directory
    `chown $user $platform`;
    `chgrp $group $platform`;
    $result = chdir $platform;           # chdir into platform directory
    $result = mkdir $domain, 0755;     # create domain directory
    `chown $user $domain`;
    `chgrp $group $domain`;
    $result = chdir $domain;           # chdir into domain directory

}

#----------------------------------------------------------------------------------------------
# At this point we are in the domain directory and our next job is to copy over 
# the template files and substitute the tags in the files.
#----------------------------------------------------------------------------------------------

$result = `cp -a $provisiondir/cgi-bin .`;
$result = `cp -a $provisiondir/etc .`;
$result = `cp -a $provisiondir/logs .`;
$result = `cp -a $provisiondir/tmp .`;
$result = `cp -a $provisiondir/jsnap .`;
$result = `cp -a $provisiondir/public_html .`;
$result = `chown -R $user *`;
$result = `chgrp -R $group *`;


$result = `sed -i -e 's/<CLIENT>/$client/g' cgi-bin/php.fcgi`;
$result = `sed -i -e 's/<PLATFORM>/$platform/g' cgi-bin/php.fcgi`;
$result = `sed -i -e 's/<DOMAIN>/$domain/g' cgi-bin/php.fcgi`;

$result = `sed -i -e 's/<CLIENT>/$client/g' etc/php.ini`;
$result = `sed -i -e 's/<PLATFORM>/$platform/g' etc/php.ini`;
$result = `sed -i -e 's/<DOMAIN>/$domain/g' etc/php.ini`;


