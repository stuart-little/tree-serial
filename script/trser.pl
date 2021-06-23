#!/usr/bin/perl
use warnings;
use v5.12;

use Data::Dumper;
use Tree::Serial;

say Dumper(Tree::Serial->new());
say Dumper(Tree::Serial->new({traversal => 1})->strs2lol(\@ARGV));
