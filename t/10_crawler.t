use strict;
use Test::More;
use Rainview::Crawler;
use File::Slurp;

my $content = read_file('t/resource/kanto.html');

my $c = Rainview::Crawler->new;

my @res = $c->parse($content);

is scalar(@res), 82;

my @fields = sort keys %{$res[0]};

is_deeply \@fields, [qw[hourly_precip long_precip name report_time route]];

diag explain @res;

done_testing;
