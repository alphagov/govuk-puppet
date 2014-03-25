class puppet::master::config ($unicorn_port = '9090') {

  file { '/etc/puppet/config.ru':
    require => Exec['install rack 1.0.1'],
    source  => 'puppet:///modules/puppet/etc/puppet/config.ru'
  }


  file {'/etc/puppet/unicorn.conf':
    source => 'puppet:///modules/puppet/etc/puppet/unicorn.conf',
  }
  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }
  file { '/usr/local/bin/puppet_config_version':
    ensure  => present,
    source  => 'puppet:///modules/puppet/usr/local/bin/puppet_config_version',
    mode    => '0755',
  }

  # Track checksums and reload `puppetmaster` service when they change. This
  # is still pretty non-deterministic because it requires a `puppet agent`
  # run on the master after deployment and then a wait for `unicornherder`
  # to do its thing. Workaround for the issue:
  # https://tickets.puppetlabs.com/browse/PUP-1336
  file { '/usr/share/puppet/production/current/hiera.yml':
    ensure => undef,
    owner  => undef,
    group  => undef,
    mode   => undef,
    audit  => 'content',
  }
}
