class puppet {
    package { 'puppet':
        ensure   => '2.7.3',
        provider => gem;
    }
}
