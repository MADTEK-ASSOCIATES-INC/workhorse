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

use Crypt::Passwd;

die "\nusage: $0.pl <Username> <Client Directory> <Password>\n\n ex: $0 seaka_01 seakayakadventures changeme\n\n" if $#ARGV < 2;

my ($user,$clientdir,$pwd) = @ARGV;

my $result;

my ($login,$pass,$uid,$gid) = getpwnam($user);

die "Username - $user already exists..." if $uid;

# Clean off single quotes in case they were necessary from the command line input

$pwd =~ s/'//g;

$cpass = unix_std_crypt($pwd, "salt");

$result = `mkdir /home/$user`;

#$result = `useradd -m -d /home/$user -p $cpass -U $user`;

$result = `useradd -s /bin/false -G sftponly -d /home/$user -p $cpass $user`;

$result = `chown root:root /home/$user`;

$result = `chmod 755 /home/$user`;

$result = `mkdir /home/$user/$clientdir`;
$result = `mkdir /var/www/$clientdir`;

$mntxt = "/var/www/$clientdir       /home/$user/$clientdir          none    bind      0 0";

$result = `echo $mntxt >> /etc/fstab`;

$result = `mount /home/$user/$clientdir`;

$result = `chown root:root /home/$user/$clientdir`;
