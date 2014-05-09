{
    appname => 'Rainview',
    'Plugin::FormValidator::Lite' => {
        function_message => 'en',
        constants => [qw/Email/],
    },
    ErrorPage => {
        template => 'error.tt',
    },
    'Cache' => { 
        servers   => ['127.0.0.1:11211'],
        namespace => 'Rainview',
    },
    'DBI' => {
        connect_info => [qw/dbi:mysql:rainview root/, undef],
    },
};

