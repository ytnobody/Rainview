package Rainview::M::DB::Member;
use strict;
use warnings;
use parent 'Rainview::M::DB';

sub table { 'member' }

sub create {
    my ($class, %opts) = @_;
    my $now = time();
    $opts{created_at} = $now;
    $opts{updated_at} = $now;
    $class->SUPER::create(%opts);
}

sub fetch {
    my ($class, $id) = @_;
    $class->single(id => $id);
}

1;

