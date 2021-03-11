#!/usr/bin/perl

#----------------------------------------------------------------------------------------------
#
# Provisioning script to create a user account for a new web client
#
# usage: mkuser.pl <Username> <Home Directory> <Password> 
#
# ex: mkuser.pl seaka_01 /var/www/seakayakadventures changeme
#
# Author: J Eversole - November 2013
#
#----------------------------------------------------------------------------------------------

die "\nusage: $0.pl <Username> <Home Directory> <Password>\n\n ex: $0 seaka_01 /var/www/seakayakadventures changeme\n\n" if $#ARGV < 2;

my ($user,$homedir,$pwd) = @ARGV;

my $result;

my ($login,$pass,$uid,$gid) = getpwnam($user);

die "Username - $user already exists..." if $uid;

# Clean off single quotes in case they were necessary from the command line input

$pwd =~ s/'//g;

$result = `useradd -m -d $homedir -p $pwd -U $user`;


