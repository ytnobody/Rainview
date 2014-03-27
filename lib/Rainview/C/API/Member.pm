package Rainview::C::API::Member;
use strict;
use warnings;
use utf8;
use Rainview::M::DB::Member;
use Rainview::M::Cache;

sub create {
    my $c = shift;
    my $valid = $c->form(
        name  => ['NOT_NULL', ['LENGTH', 1, 16]],
        email => ['NOT_NULL', 'EMAIL_LOOSE'],
    );

    return {status => 400, message => $valid->get_error_messages} if $valid->has_error;

    my $member = Rainview::M::DB::Member->create(
        name  => $c->param('name'),
        email => $c->param('email'),
    );
    return {member => $member};
}

sub fetch {
    my $c = shift;
    my $id = $c->path_param('id');

    return {status => 403, message => 'id is required'} unless $id;

    my $member = Rainview::M::Cache->get("member:$id") || Rainview::M::DB::Member->fetch($id);
    Rainview::M::Cache->set("member:$id", $member, 300) if $member;
    return $member ? {member => $member} : {status => 404, message => 'member not found'};
}

1;

