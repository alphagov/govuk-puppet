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

  @logstash::collector { "puppetmaster":
    source => 'puppet:///modules/puppet/logstash.conf',
  }

  @logrotate::conf { "puppetmaster":
    matches => "/var/log/puppetmaster/*.log",
  }

  file {'/etc/puppet/unicorn.conf':
    source => "puppet:///modules/puppet/etc/puppet/unicorn.conf",
  }
  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }
}
