class puppet {
  group { 'puppet':
    ensure  => present,
    name    => 'puppet';
  }

  package { 'puppet':
    ensure   => '2.7.18',
    provider => gem,
    require  => Group['puppet'];
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('puppet/etc/puppet/puppet.conf.erb'),
    require => Package['puppet'];
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$';
  }
}
