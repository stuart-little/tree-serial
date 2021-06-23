#!/usr/bin/perl
use warnings;
use v5.12;

use Data::Dumper;
use lib qq!$ENV{HOME}/repos/tree-serial/lib!;
use Tree::Serial;
use List::Util qw(zip);

say Dumper(Tree::Serial->new());
## say Dumper(Tree::Serial->new({traversal => 0})->strs2lol(\@ARGV));

## say Dumper(Tree::Serial->new({degree => 3})->strs2hash(\@ARGV));
