#!/usr/bin/env perl
use warnings;
use v5.12;

use Data::Dumper;
use Tree::Serial;

$Data::Dumper::Indent = 0;

say Dumper(Tree::Serial->new({showMissing => ''}));
# $VAR1 = bless( {'traversal' => 0,'degree' => 2,'separator' => '.'}, 'Tree::Serial' );

# say Dumper(Tree::Serial->new({separator => "#", degree => 5, traversal => 4}));
# $VAR1 = bless( {'degree' => 5,'separator' => '#','traversal' => 4}, 'Tree::Serial' );

say Dumper(Tree::Serial->new()->strs2hash([qw(1 . 2 . .)]));
# $VAR1 = {'1' => {'1' => {},'0' => {},'name' => '2'},'0' => {},'name' => '1'};

say Dumper(Tree::Serial->new({traversal => 2})->strs2lol([qw(1 2 . 3 . . .)]));
# $VAR1 = [[[],[[],[],'3'],'2'],[],'1'];
