#!/usr/bin/perl
use warnings;
use v5.12;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dump qw(dump);
use Getopt::Long;
use Tree::Serial;

my($help);

GetOptions (
    "h|help" => \$help,
    );

if ($help) {
    my $CMD=qq{less $0};
    system $CMD;
    exit;
}

dump Tree::Serial->new();
dump Tree::Serial->new({traversal => 1})->strs2lol(\@ARGV);
