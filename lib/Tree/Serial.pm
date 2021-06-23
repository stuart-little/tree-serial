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
	(defined $data) ? (%{$data}) : (),
	);
    $self->{separator} = $data{separator};
    $self->{degree} = $data{degree};
}

sub _sepThreshold {
    my ($separator, $degree, $aref) = @_;
    return 2*(scalar grep {$_ eq $separator} @{$aref}) - (scalar @{$aref}) == $degree - 1;
}

sub _ixSplit {
    my ($separator, $degree, $aref) = @_;
    return first { my @ar = $aref->@[0..$_]; _sepThreshold($separator, $degree, \@ar) } (keys @{$aref});
}

sub treeList2Hash {
    my ($self, $aref) = @_;
    (! scalar @{$aref} || $aref->[0] eq $self->{separator}) && return {};
    my @rest = @{$aref}[1..scalar @{$aref}-1];
    my $ix = _ixSplit($self->{separator}, $self->{degree}, \@rest);
    my @left = @rest[0..$ix];
    my @right = @rest[$ix+1..$#rest];
    return {
	name => $aref->[0],
	left => treeList2Hash($self,\@left),
	right => treeList2Hash($self,\@right),
    };
}

1;

__END__

=head1 NAME

Tree::Serial - stub

=head1 SYNOPSIS

This is a stub.

=head1 DESCRIPTION

This is a stub.

=head1 INSTALLATION

Using C<cpanm>: clone this repo, C<cd> into it, and then:

    $ cpanm .

Manual install:

    $ perl Makefile.PL
    $ make
    $ make install

=cut
