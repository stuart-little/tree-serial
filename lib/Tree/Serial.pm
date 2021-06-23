package Tree::Serial;

use warnings;
use v5.12;

use List::Util qw(first);

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

sub _sepThreshold {
    my ($separator, $degree, $aref) = @_;
    return 2*(scalar grep {$_ eq $separator} @{$aref}) - (scalar @{$aref}) == $degree - 1;
}

sub _ixSplit {
    my ($separator, $degree, $aref) = @_;
    return first { my @ar = $aref->@[0..$_]; _sepThreshold($separator, $degree, \@ar) } (keys @{$aref});
}

sub strs2hash {
    my ($self, $aref) = @_;
    (! scalar @{$aref} || $aref->[0] eq $self->{separator}) && return {};
    my @rest = @{$aref}[1..scalar @{$aref}-1];
    my $ix = _ixSplit($self->{separator}, $self->{degree}, \@rest);
    my @left = @rest[0..$ix];
    my @right = @rest[$ix+1..$#rest];
    return {
	name => $aref->[0],
	left => strs2hash($self,\@left),
	right => strs2hash($self,\@right),
    };
}

sub strs2lol {
    my ($self, $aref) = @_;
    (! scalar @{$aref} || $aref->[0] eq $self->{separator}) && return [];
    my @rest = @{$aref}[1..scalar @{$aref}-1];
    my $ix = _ixSplit($self->{separator}, $self->{degree}, \@rest);
    my @left = @rest[0..$ix];
    my @right = @rest[$ix+1..$#rest];
    my @lr=(strs2lol($self,\@left), strs2lol($self,\@right));
    splice(@lr,$self->{traversal},0,$aref->[0]);
    return \@lr;
}

1;

__END__

=head1 NAME

Tree::Serial - Perl module for deserializing lists of strings into tree-like structures and vice versa

=head1 SYNOPSIS

This is a stub.

=head1 DESCRIPTION

This is a stub.

=head1 ATTRIBUTES

=head2 separator

=head2 degree

=head2 traversal

    my $ts = Tree::Serial->new({traversal => 1});

Can be 0 (meaning pre-order), 1 (meaning in-order), or 2 (meaning post-order). It will modify the behavior of the list-of-lists (de)serialization functions accordingly.

=head1 METHODS

=head1 INSTALLATION

Using L<cpanm|https://metacpan.org/dist/App-cpanminus/view/bin/cpanm>: clone this repo, C<cd> into it, and then:

    $ cpanm .

Manual install:

    $ perl Makefile.PL
    $ make
    $ make install

=cut
