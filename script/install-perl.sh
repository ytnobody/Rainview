#!/bin/sh

PERLROOT=$HOME/perls/perl-5.18
PERLVERSION=5.18.2

if [ ! -d $PERLROOT ]; then
    curl https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build | perl - $PERLVERSION $PERLROOT/ 
    curl https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm > $PERLROOT/bin/cpanm && chmod +x $PERLROOT/bin/cpanm
    PERL5LIB=$PERLROOT/lib
    PATH=$PERLROOT/bin:$PATH
    cpanm Carton
    echo "INSTALL DONE."
fi

