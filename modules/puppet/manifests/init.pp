class puppet {
    package { 'puppet':
        ensure   => '2.7.3',
        provider => gem;
    }

    cron { 'puppet':
        user    => 'root',
        ensure  => present,
        minute  => [0,30],
        command => '/usr/bin/puppet agent --onetime --no-daemonize';
    }
}
