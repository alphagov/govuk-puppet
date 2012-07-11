class puppet::master {
    file { '/etc/init/puppetmaster.conf':
        require => Package['puppet'],
        source  => 'puppet:///modules/puppet/etc/init/puppetmaster.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    service { 'puppetmaster':
        ensure    => running,
        provider  => upstart,
        require   => File['/etc/init/puppetmaster.conf'],
        subscribe => Class['Ruby::Rubygems'],
    }
}