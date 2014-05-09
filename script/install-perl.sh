#!/bin/sh

PERLROOT=$HOME/perls/perl-5.18
PERLVERSION=5.18.2

if [ ! -d $PERLROOT ]; then
    curl https://raw.github.com/tokuhirom/Perl-Build/master/perl-build | perl - $PERLVERSION $PERLROOT/ 
    curl -L http://cpanmin.us > $PERLROOT/bin/cpanm && chmod +x $PERLROOT/bin/cpanm
    PERL5LIB=$PERLROOT/lib
    PATH=$PERLROOT/bin:$PATH
    cpanm Carton
    echo "INSTALL DONE."
fi

