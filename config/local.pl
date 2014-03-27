use File::Basename 'dirname';
use File::Spec;
my $common = require(File::Spec->catfile(dirname(__FILE__), 'common.pl'));
my $conf = {
    %$common,
    'Cache' => { 
        servers   => ['127.0.0.1:11211'],
        namespace => 'Rainview',
    },
    'DBI' => {
        connect_info => [qw/dbi:mysql:rainview root/, undef],
    },
    
};
$conf;

