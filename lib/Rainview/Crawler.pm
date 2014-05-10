package Rainview::Crawler;
use strict;
use warnings;
use utf8;

use Carp;
use Furl;
use XML::XPath::Diver;
use HTML::Tidy::libXML;
use List::MoreUtils 'mesh';
use Time::Piece;
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
    my @fields = map {s/(<br>|\n|\r|\s)/ii/g; $_} map {$_->text} $header->dive('//th');

    for my $field (@fields) {
        $field = 
            $field =~ /路線名/ ? 'route' :
            $field =~ /^(地名|観測地点)$/ ? 'name' :
            $field =~ /^時間雨量/ ? 'hourly_precip' :
            $field =~ /^連続雨量/ ? 'long_precip' :
            $field =~ /^観測日時/ ? 'report_time' :
            $field
        ;
    }
    @fields = grep {defined $_} @fields;

    for my $record (@recs) {
        my @cols = map {$_->text} $record->dive('//td');
        next unless @cols;

        my %data = mesh(@fields, @cols);

        for my $key (qw|long_precip hourly_precip|) {
            next unless defined $data{$key};
            $data{$key} = $data{$key} =~ /^[0-9]+$/ ? $data{$key} : undef;
        } 

        next unless $data{route};
        $data{route} =~ s/(（現道）|\r|\n|\s)//g;
        $data{route} =~ tr/[０-９]/[0-9]/;
        next unless $data{route};

        next unless $data{report_time};
        $data{report_time} = do {
            my $report_time = $data{report_time} =~ s/ ([0-9]{1})(月|日|時|分)/sprintf("%02d",$1).$2/reg;
            $report_time =~ s/　/ /g;
            my $piece = Time::Piece->strptime($report_time, '%Y年%m月%d日 %H時%M分');
            $piece->strftime('%Y-%m-%d %H:%M:%S');
        };

        %data = ( map {($_ => $data{$_})} qw/route name hourly_precip long_precip report_time/ );

        push @res, {%data};
    }

    return @res;
}

1;
