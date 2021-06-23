package Tree::Serial;

use warnings;
use v5.12;

use List::Util qw(first reduce sum zip);

our $VERSION=0.1;

sub new {
    my ($class,$data) = @_;
    my $self = {};
    bless $self, $class;
    $self->_init($data);
    return $self;
}

sub _init {
    my ($self,$data) = @_;
    my %data = (
	separator => '.',
	degree => 2,
        traversal => 0,
	(defined $data) ? (%{$data}) : (),
	);
    $self->{separator} = $data{separator};
    $self->{degree} = $data{degree};
    $self->{traversal} = $data{traversal};
}

sub _eatWhileNot {
    my ($pred,$acc,$el) = @_;
    my @larger = (@{$acc->[1]}, $el);
    return ($pred->(\@larger)) ? ([[@{$acc->[0]}, \@larger],[]]) : ([$acc->[0], \@larger]);
}

sub _chunkBy {
    my ($pred,$aref) = @_;
    my $reduction = reduce { _eatWhileNot($pred, $a, $b) } [[],[]], @{$aref};
    return $reduction->[0];
}

sub _isKAry {
    my ($separator,$degree,$aref) = @_;
    return ((sum map { ($_ eq $separator) ? (-1) : ($degree-1) } @{$aref}) == -1);
}

sub _chunkKAry {
    my ($separator,$degree,$aref) = @_;
    my $pred = sub { _isKAry($separator,$degree,$_[0]) };
    return _chunkBy($pred,$aref);
}

sub strs2hash {
    my ($self, $aref) = @_;
    (! scalar @{$aref} || $aref->[0] eq $self->{separator}) && return {};
    my @rest = @{$aref}[1..scalar @{$aref}-1];
    my $chunks = _chunkKAry($self->{separator}, $self->{degree}, \@rest);
    my %h = (
	name => $aref->[0],
	map {$_->[0] => strs2hash($self,$_->[1])} zip [0..$#{$chunks}], $chunks,
	);
    return \%h;
}

sub strs2lol {
    my ($self, $aref) = @_;
    (! scalar @{$aref} || $aref->[0] eq $self->{separator}) && return [];
    my @rest = @{$aref}[1..scalar @{$aref}-1];
    my $chunks = _chunkKAry($self->{separator}, $self->{degree}, \@rest);
    my @others = map {strs2lol($self,$_)} @{$chunks};
    splice(@others,$self->{traversal},0,$aref->[0]);
    return \@others;
}

1;

__END__

=head1 NAME

Tree::Serial - Perl module for deserializing lists of strings into tree-like structures

=head1 SYNOPSIS

This is a stub.

=head1 DESCRIPTION

The purpose of the module is to turn lists of strings (typically passed on the command line) into tree-like structures: hashes and lists of lists (of lists, etc.; i.e. nested).

=head1 INSTALLATION

Using L<cpanm|https://metacpan.org/dist/App-cpanminus/view/bin/cpanm>: clone this repo, C<cd> into it, and then:

    $ cpanm .

Manual install:

    $ perl Makefile.PL
    $ make
    $ make install

=head1 ATTRIBUTES

=head2 separator

=head2 degree

The common maximal degree assumed of the tree nodes. It defaults to 2 (i.e. to handling I<binary> trees):

    my $ts = Tree::Serial->new({degree => 2});

is the same as 

    my $ts = Tree::Serial->new();

but you can specify any other positive integer.

=head2 traversal

    my $ts = Tree::Serial->new({traversal => 1});

A non-negative integer, indicating where the root is placed as you deserialize the tree into a list of lists. It defaults to 0, meaning the root comes first, before the subtrees: what is usually called L<pre-order traversal|https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/>.

If you've specified a C<k>-ary tree, then setting the C<traversal> attribute to C<k> means you are doing a L<post-order traversal|https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/> instead:

    my $ts = Tree::Serial->new({degree => 3, traversal => 3});

=head1 METHODS

=cut
