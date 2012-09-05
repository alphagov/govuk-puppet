class puppet {
  group { 'puppet':
    ensure  => present,
    name    => 'puppet';
  }

  package { 'puppet':
    ensure   => '2.7.19',
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

  @nagios::plugin { 'check_puppet_agent':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_puppet_agent',
  }

  @@nagios::check { "check_puppet_agent_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_puppet_agent',
    service_description => "Check puppet has run recently on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
