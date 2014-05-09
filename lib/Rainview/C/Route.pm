package Rainview::C::Route;
use strict;
use warnings;
use Rainview::Logic::Route;

sub detail {
    my $c = shift;
    my $route_data = eval { Rainview::Logic::Route->detail($c) };

    unless ($route_data) {
        warn $@;
        return $c->res_404;
    }

    {
        template => 'route/detail.tt',
        %$route_data,
    };    
}

1;
