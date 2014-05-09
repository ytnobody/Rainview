package Rainview::C::API::Route;
use strict;
use warnings;
use Rainview::Logic::Route;

sub list {
    my $c = shift;
    Rainview::Logic::Route->list($c);
}

sub detail {
    my $c = shift;
    my $res = eval { Rainview::Logic::Route->detail($c) };

    unless ($res) {
        warn $@;
        return $c->res_404;
    }

    $res;
}

1;
