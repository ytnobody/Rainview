package Rainview::Logic::Point;
use strict;
use warnings;

sub rainy {
    my ($class, $c) = @_;
    my $route_map = { map {($_->{id} => $_)} $c->db->select('route') };
    my @points = map { 
        $_->{route} = $route_map->{$_->{route_id}};
        $_;
    } $c->db->select('point' => {hourly_precip => {'>' => 0}});
    {
        points => [ @points ],
    };
}

sub wet {
    my ($class, $c) = @_;
    my $route_map = { map {($_->{id} => $_)} $c->db->select('route') };
    my @points = map { 
        $_->{route} = $route_map->{$_->{route_id}};
        $_;
    } $c->db->select('point' => {long_precip => {'>' => 0}});
    {
        points => [ @points ],
    };
}


1;
