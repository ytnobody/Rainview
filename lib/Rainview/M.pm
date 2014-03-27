package Rainview::M;
use strict;
use warnings;
use Nephia::Incognito;

sub c {
    my $class = shift;
    Nephia::Incognito->unmask('Rainview');
}

1;

