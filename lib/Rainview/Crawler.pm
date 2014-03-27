package Rainview::Crawler;
use strict;
use warnings;
use utf8;

use Carp;
use Furl;
use XML::XPath::Diver;
use HTML::Tidy::libXML;
use List::MoreUtils 'mesh';
use Class::Accessor::Lite (
    rw => [qw[agent url tidy charset]],
    new => 0,
);

sub new {
    my ($class, %opts) = @_;

    my $self = bless {%opts}, $class;

    my $furl = Furl->new(agent => "$class/0.01");
    my $tidy = HTML::Tidy::libXML->new;

    $self->agent($furl);
    $self->tidy($tidy);

    $self;
}

sub crawl {
    my $self = shift;

    my $url = $self->url;

    my $res = $self->agent->get($url);
    croak($res->status_line) unless $res->is_success;

    my $content = $res->content;
    return $self->parse($content);
}

sub parse {
    my ($self, $content) = @_;

    my $charset = $self->charset || 'Shift_JIS';
    $content = $self->tidy->html2dom($content, $charset);

    my $diver = XML::XPath::Diver->new(xml => $content);

    my @tables = $diver->dive('//table');
    my $table = $tables[0];

    my ($header, @recs) = $table->dive('//tr');

    my @res;
    my @fields = map {$_->text} $header->dive('//th');
    for my $record (@recs) {
        my @cols = map {$_->text} $record->dive('//td');
        my %data = mesh(@fields, @cols);
        push @res, { %data };
    }

    return @res;
}

1;
