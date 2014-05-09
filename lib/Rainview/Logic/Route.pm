package Rainview::Logic::Route;
use strict;
use warnings;
use Carp;

sub list {
    my ($class, $c) = @_;
    my @routes = $c->db->select('route');
    {
        routes => [ @routes ],
    };
}

sub detail {
    my ($class, $c) = @_;
    my $id = $c->path_param('id');
    my $route = $c->db->single('route' => {id => $id}) or croak('No such route');
    my @points = $c->db->select('point' => {route_id => $id});
    { 
        route => $route, 
        points => [ @points ],
    };
}

1;
