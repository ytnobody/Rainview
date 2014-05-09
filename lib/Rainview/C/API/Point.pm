package Rainview::C::API::Point;
use strict;
use warnings;
use Rainview::Logic::Point;

sub rainy {
    my $c = shift;
    Rainview::Logic::Point->rainy($c);
}

sub wet {
    my $c = shift;
    Rainview::Logic::Point->wet($c);
}

1;
