#!/usr/bin/perl
use warnings;
use v5.12;

use Data::Dumper;
use List::Util qw(reduce);
use Tree::Serial;

## say Dumper(Tree::Serial->new());
## say Dumper(Tree::Serial->new({traversal => 0})->strs2lol(\@ARGV));
##

say Dumper(Tree::Serial->new({degree => 3})->strs2hash(\@ARGV));
