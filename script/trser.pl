#!/usr/bin/env perl
use warnings;
use v5.12;

use Data::Dumper;
use Tree::Serial;

say Dumper(Tree::Serial->new());
say Dumper(Tree::Serial->new({degree => 3, traversal => 2})->strs2lol(\@ARGV));

## say Dumper(Tree::Serial->new({degree => 3})->strs2hash(\@ARGV));
