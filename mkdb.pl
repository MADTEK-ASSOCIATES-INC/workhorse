#!/usr/bin/perl

#
# This script creates a database and user account to go with the database
#
# usage: mkdb.pl <db name> <username> <password> <db root password>
#

die "\nusage: $0 <db name> <username> <password> <db root password>\n\n" if $#ARGV < 3;

my $result;
my $db = $ARGV[0];
my $user = $ARGV[1];
my $pwd = $ARGV[2];
my $rootpwd = $ARGV[3];


$result = `cp templates/db/phpdbtemplate.sql /tmp/$db.sql`;

my $sqlfile = "/tmp/$db.sql";

$result = `sed -i -e 's/TARGETDB/$db/g' $sqlfile`;
$result = `sed -i -e 's/USER/$user/g' $sqlfile`;
$result = `sed -i -e 's/PASSWORD/$pwd/g' $sqlfile`;

$result = `mysql -u root -p$rootpwd mysql <$sqlfile`;

unlink $sqlfile or warn "Could not unlink $sqlfile: $!";
