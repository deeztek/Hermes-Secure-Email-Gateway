#!/usr/bin/perl -w
# technion@lolware.net
# Detects vba macros containing blacklisted strings.
# https://github.com/technion/maia_mailguard/blob/master/scripts/detectvba.pl
# Mods by www.cammckenzie.com
#
# Suggested amavisd/maiad.conf config:
# ['Detect-VBA',
#   '/usr/local/bin/detectvba.pl', "{}",
#      [0], qr/INFECTED/, qr/\bINFECTED (.+)\b/m ],
#
use strict;

my $sigtool = '/usr/bin/sigtool'; #Clamav sigtool path

if ($#ARGV != 0) {
    print "Please supply directory to scan\n";
    exit 0;
}

#Sanity check directory
my $dir = $ARGV[0];
if ($dir !~ /^[a-z0-9A-Z\/-]+$/) {
    print "Invalid directory passed\n";
    exit 0;
}

opendir DIR, $dir or die "Cannot open dir $dir: $!";
my @files = readdir DIR;

foreach my $file (@files) {
    next if $file =~ /^\.$/;
    next if $file =~ /^\.\.$/;
    my $scan = `$sigtool --vba="$dir/$file"`;
    if ($scan =~ /autoopen/i ) {
        print "Scanning $file: INFECTED VBA\n";
        exit 1;
    } else {
        print "Scanning $file: OK\n";
    }
}

closedir DIR;

exit 0;

