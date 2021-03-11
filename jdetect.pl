#
# jdetect
#
# This program takes a snapshot of a core Joomla distribution sitting
# in a staged directory and builds a hash of the file list then does the
# same for an existing production Joomla directory.  Then there is a
# set operation performed to determine the files in the production dir
# that are not in the core distribution.
#
#
# ex: jdetect <joomla core dir> <joomla prod dir>
#
#

use File::Basename;

die "\nusage: $0 <joomla core dir> <joomla prod dir>\n\n" if $#ARGV < 1;

#
# traverse the Joomla core directory
#

$result = chdir "$ARGV[0]";
opendir(DIR, ".");
@files = readdir(DIR);
closedir(DIR);

foreach $file (@files) {

    next if $file eq '.' || $file eq '..';
    next if $file =~ /^installation/;

    $corehash->{$file} = "$file";

#    print "$file\n";
    @dirlist = list($file);
    foreach $item (@dirlist) {
        next if $item =~ /^installation/;
        $corehash->{$item} = "";
#        print "-> $item\n";
    }
}

# print "\n ---------  -- -----------  --\n";

foreach $key (keys(%$corehash)) {
#        print "$key\n";
}


#
# traverse the Joomla production directory
#


$result = chdir "$ARGV[1]";
opendir(PDIR, ".");
@files = readdir(PDIR);
closedir(PDIR);

foreach $file (@files) {

    next if $file eq '.' || $file eq '..';
#    next if $file =~ /^installation/;

#    print "$file\n";
    @dirlist = list($file);
    foreach $item (@dirlist) {
#        next if $item =~ /^installation/;
        $prodhash->{$item} = "";
#        print "$item\n";
    }
}

# Now do the set operation

foreach $key (keys(%$prodhash)) {
    if (!exists($corehash->{$key})) {
        if ($key =~ /\.php/) {
          print "$key\n" ;
	  $dirname = dirname $key;
	  $dirhash->{$dirname} = "";
      }

    }
}

# Print out the list of unique directories where the files are found

print "\n\n --------- \n\n";
foreach $key (keys(%$dirhash)) {
  print "$key\n" ;

} # end for 



#
# Recursively list the files in a directory
#
sub list
{
    my ($dir) = @_;
    return unless -d $dir;

    my @files;
  if (opendir my $dh, $dir)
  {
    # Capture entries first, so we don't descend with an
    # open dir handle.
      my @list;
      my $file;
    while ($file = readdir $dh)
    {
	push @list, $file;
    }
      closedir $dh;

    for $file (@list)
    {
      # Unix file system considerations.
	next if $file eq '.' || $file eq '..';

      # Swap these two lines to follow symbolic links into
      # directories.  Handles circular links by entering an
      # infinite loop.
	push @files, "$dir/$file"        if -f "$dir/$file";
	push @files, list ("$dir/$file") if -d "$dir/$file";
    }
  }

    return @files;
}
