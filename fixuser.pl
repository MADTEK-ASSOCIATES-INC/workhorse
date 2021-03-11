#!/usr/bin/perl

#----------------------------------------------------------------------------------------------
#
# Fix it script to modify an existing user account and lock it down into its directory
#
# usage: fixuser.pl <Username> <Home Directory> <Password> 
#
# ex: fixuser.pl bandw_01 bandwidthsolutions 
#
# Author: J Eversole - February 2014
#
#----------------------------------------------------------------------------------------------

die "\nusage: $0.pl <Username> <Home Directory>\n\n ex: $0 bandw_01 badnwidthsolutions\n\n" if $#ARGV < 1;

my ($user,$homedir) = @ARGV;

my $result;

my ($login,$pass,$uid,$gid) = getpwnam($user);


# Clean off single quotes in case they were necessary from the command line input

$pwd =~ s/'//g;


$result = `mkdir /home/$user`;

$result = `chown root /home/$user`;
$result = `chgrp root /home/$user`;

$result = `chmod 755 /home/$user`;

$result = `mkdir /home/$user/$homedir`;

$mntxt = "/var/www/$homedir       /home/$user/$homedir          none    bind      0 0";

$result = `echo $mntxt >> /etc/fstab`;

$result = `mount /home/$user/$homedir`;

