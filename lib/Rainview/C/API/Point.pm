package Rainview::C::API::Point;
use strict;
use warnings;

sub rainy {
    my $c = shift;
    my $route_map = { map {($_->{id} => $_->{name})} $c->db->select('route') };
    my @points = $c->db->select('point' => {hourly_precip => {'>' => 0}});
    {
        points => [ @points ],
    };
}

sub wet {
    my $c = shift;
    my $route_map = { map {($_->{id} => $_->{name})} $c->db->select('route') };
    my @points = $c->db->select('point' => {long_precip => {'>' => 0}});
    {
        points => [ @points ],
    };
}

1;
