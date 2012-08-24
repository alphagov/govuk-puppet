class puppet::master::package {
  anchor {'puppet::master::package::begin':
      before => [
          Class['puppet::repository'],
          Class['nginx'],
          Class['unicornherder'],
          ]
  }
  include puppet::repository
  include nginx
  include unicornherder
  package { 'unicorn':
    provider => gem,
  }
  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }
  package { 'puppetdb-terminus':
    ensure  => present,
  }
  file {'/var/run/puppetmaster':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
  }
  file { '/etc/init/puppetmaster.conf':
    content => template('puppet/etc/init/puppetmaster.conf.erb'),
  }

  anchor {'puppet::master::package::end':
      require => [
          Class['puppet::repository'],
          Class['nginx'],
          Class['unicornherder'],
          ]
  }
}

class puppet::master::config ($unicorn_port = '9090') {
  anchor {'puppet::master::config::begin':
      before => [
          Class['puppet::master::config::nginx'],
      ]
  }
  include puppet::master::config::nginx
  anchor {'puppet::master::config::end':
      subscribe => [
          Class['puppet::master::config::nginx'],
      ]
  }

  file { '/etc/puppet/config.ru':
    require => Exec['install rack 1.0.1'],
    source  => 'puppet:///modules/puppet/etc/puppet/config.ru'
  }

  file {'/etc/puppet/unicorn.conf':
    content => "worker_processes 4\n",
  }
  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }
}

class puppet::master::service {
  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/puppetmaster.conf'],
  }
}

class puppet::master($unicorn_port='9090') {
    include puppet::master::package, puppet::master::config, puppet::master::service
    anchor {'puppet::master::begin':
        before => [
            Class['puppet::master::package'],
            Class['puppet::master::config'],
            Class['puppet::master::service'],
        ]
    }
    anchor {'puppet::master::end':
        subscribe => [
            Class['puppet::master::package'],
            Class['puppet::master::config'],
            Class['puppet::master::service'],
        ]
    }
}
