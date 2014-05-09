package Rainview::C::API::Route;
use strict;
use warnings;

sub list {
    my $c = shift;
    my @routes = $c->db->select('route');
    {
        routes => [ @routes ],
    };
}

sub detail {
    my $c = shift;
    my $id = $c->path_param('id');
    my $route = $c->db->single('route' => {id => $id}) or return $c->res_404;
    my @points = $c->db->select('point' => {route_id => $id});
    { 
        route => $route, 
        points => [ @points ],
    };
}

1;
