class puppet::master::package {
  package { 'unicorn':
    provider => gem,
  }
  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }
  package { 'puppet-common':
    ensure => '2.7.19-1puppetlabs2',
  }
  package { 'puppetdb-terminus':
    ensure  => '1.0.0-1puppetlabs1',
    require => Package['puppet-common'],
  }
  package { 'puppet':
    require => Package['puppet-common'],
    ensure  => '2.7.19-1puppetlabs2',
  }
  file {['/var/log/puppetmaster','/var/run/puppetmaster']:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
  }
  file { '/etc/init/puppetmaster.conf':
    content => template('puppet/etc/init/puppetmaster.conf.erb'),
  }
}
