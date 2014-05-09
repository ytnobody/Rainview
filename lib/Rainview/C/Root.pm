package Rainview::C::Root;
use strict;
use warnings;
use Rainview::Logic::Route;
use Rainview::Logic::Point;

sub index {
    my $c = shift;
    my $route_list_data = Rainview::Logic::Route->list($c);
    my $rainy_point_data = Rainview::Logic::Point->rainy($c);
    my $wet_point_data = Rainview::Logic::Point->wet($c);
    
    { 
        template => 'index.tt', 
        rainy_points => $rainy_point_data->{points},
        wet_points => $wet_point_data->{points},
        %$route_list_data,
    };
}

1;

