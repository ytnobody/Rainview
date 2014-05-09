package Rainview;
use strict;
use warnings;
use Data::Dumper ();
use URI;
use Otogiri;
use Nephia::Incognito;
use Time::Piece;
use Nephia plugins => [
    'FillInForm',
    'FormValidator::Lite',
    'JSON' => {
        enable_api_status_header => 1,
    },
    'View::Xslate' => {
        syntax => 'TTerse',
        path   => [ qw/view/ ],
        function => {
            c    => \&c,
            dump => sub {
                local $Data::Dumper::Terse = 1;
                Data::Dumper::Dumper(shift);
            },
            uri_for => sub {
                my $path = shift;
                my $env = c()->req->env;
                my $uri = URI->new(sprintf(
                    '%s://%s%s',
                    $env->{'psgi.url_scheme'},
                    $env->{'HTTP_HOST'},
                    $path
                ));
                $uri->as_string;
            },
        },
    },
    'ErrorPage',
    'ResponseHandler',
    'Dispatch',
];

sub c () {Nephia::Incognito->unmask(__PACKAGE__)}

__PACKAGE__->c->{dsl}{db} = sub {
    my $c = __PACKAGE__->c;
    my $db = $c->{db};
    unless ($db) {
        my $conf = $c->{config}{DBI};
        $db = $c->{db} = Otogiri->new(%$conf);
    }
    $db;
};


__PACKAGE__->c->{dsl}{now} = sub {localtime};

app {
    get '/' => Nephia->call('C::Root#index');
    get '/route/{id:[0-9]+}' => Nephia->call('C::Route#detail');
    get '/api/routes' => Nephia->call('C::API::Route#list');
    get '/api/route/{id:[0-9]+}' => Nephia->call('C::API::Route#detail');
    get '/api/point/rainy' => Nephia->call('C::API::Point#rainy');
    get '/api/point/wet' => Nephia->call('C::API::Point#wet');
};

1;

