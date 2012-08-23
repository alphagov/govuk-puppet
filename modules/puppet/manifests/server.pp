class puppet::server{
  include nginx
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
  file { '/etc/puppet/unicorn.conf':
    require => Package['unicorn'],
    source  => 'puppet:///modules/puppet/etc/puppet/unicorn.conf'
  }
}