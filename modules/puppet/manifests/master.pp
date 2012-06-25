class puppet::master {
    file { '/etc/init/puppetmaster.conf':
        require => Package['puppet'],
        source  => 'puppet:///modules/puppet/etc/init/puppetmaster.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    service { 'puppetmaster':
        ensure   => running,
        provider => upstart,
        require  => File['/etc/init/puppetmaster.conf'],
    }

    service { 'daemonized-puppetmaster': # kill any existing daemonized puppetmaster process
        ensure   => stopped,
        provider => base,
        require  => Service['puppetmaster'], # don't kill the daemon til the upstart process is working
        pattern  => '/usr/bin/puppet master$';
    }

}