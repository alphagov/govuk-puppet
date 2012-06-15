class puppet {
    package { 'puppet':
        ensure   => '3.7.3',
        provider => gem;
    }
}
