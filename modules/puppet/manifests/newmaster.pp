class puppet::newmaster {
  include puppet::repository
  include nginx
  include unicornherder
  include puppet::master::config::nginx
  package { 'unicorn':
    provider => gem,
  }
  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }
  file { '/etc/puppet/config.ru':
    require => Exec['install rack 1.0.1'],
    source  => 'puppet:///modules/puppet/etc/puppet/config.ru'
  }

  file {'/etc/puppet/unicorn.conf':
    content => "worker_processes 4\n",
  }

  package { 'puppetdb-terminus':
    ensure  => present,
  }

  package { ['mysql-server-5.1','mysql-client-5.1']: #old storedconfigs, before we used puppetdb
    ensure => purged
  }

  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }

  file { '/etc/init/puppetmaster.conf':
    require => Package['puppet'],
    source  => 'puppet:///modules/puppet/etc/init/newpuppetmaster.conf',
  }

  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/puppetmaster.conf'],
  }
}
