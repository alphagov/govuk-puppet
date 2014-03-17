class puppet {
  include puppet::repository
  include puppet::package
  include puppet::monitoring

  user { 'puppet':
    ensure  => present,
    name    => 'puppet',
    home    => '/var/lib/puppet',
    shell   => '/bin/false',
    gid     => 'puppet',
    system  => true,
    require => Class['puppet::package'],
  }

  group { 'puppet':
    ensure  => present,
    name    => 'puppet',
    require => Class['puppet::package'],
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('puppet/etc/puppet/puppet.conf.erb'),
    require => Class['puppet::package'],
  }

  file { '/usr/local/bin/govuk_puppet':
    ensure => present,
    mode   => '0755',
    source => [
      "puppet:///modules/puppet/govuk_puppet_${::govuk_platform}",
      'puppet:///modules/puppet/govuk_puppet'
    ],
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$',
    require  => Class['puppet::package'],
  }
}
