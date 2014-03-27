use strict;
use Test::More;
use Rainview::Crawler;
use File::Slurp;
use utf8;

my $content = read_file('t/resource/kanto.html');

my $c = Rainview::Crawler->new;

my @res = $c->parse($content);

is scalar(@res), 82;

my @fields = sort keys %{$res[0]};

is_deeply \@fields, [qw[地名 時間雨量(mm)* 観測日時 路線名 連続雨量(mm)*]];

done_testing;
