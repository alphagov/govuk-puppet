class puppet::master {
  include puppet::repository

  package { 'puppetdb-terminus':
    ensure  => present,
    require => Apt::Deb_repository['puppetlabs-repo']
  }

  package { ['mysql-server-5.1','mysql-client-5.1']: #old storedconfigs, before we used puppetdb
    ensure => purged
  }

  package { 'kwalify':
    ensure   => installed,
    provider => gem,
  }

  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }


  file { '/etc/init/puppetmaster.conf':
    require => Package['puppet'],
    source  => 'puppet:///modules/puppet/etc/init/puppetmaster.conf',
  }

  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/puppetmaster.conf'],
  }
}
