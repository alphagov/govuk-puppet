class puppet {
  group { 'puppet':
    ensure  => present,
    name    => 'puppet';
  }

# Can't manage both apt and gem 'puppet' packages in the same puppet run
# and we need to manage apt puppet to avoid upgrading to puppet 3 (!)
# If necessary, we can rewrite this as an exec
#  package { 'puppet':
#    ensure   => '2.7.19',
#    provider => gem,
#    require  => Group['puppet'];
#  }

  # This is required to allow Puppet to set the password hash for the ubuntu user
  package { 'libshadow':
    ensure   => present,
    provider => gem,
    require  => Package['build-essential'],
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('puppet/etc/puppet/puppet.conf.erb'),
  }

  file { '/usr/local/bin/govuk_puppet':
    ensure => present,
    mode   => '0755',
    source => [
      "puppet:///modules/puppet/govuk_puppet_${::govuk_platform}",
      'puppet:///modules/puppet/govuk_puppet'
    ],
  }

  file { '/usr/local/bin/puppet_passive_check_update':
    ensure  => present,
    mode    => '0755',
    content => template('puppet/puppet_passive_check_update'),
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$';
  }

  @nagios::plugin { 'check_puppet_agent':
    source  => 'puppet:///modules/puppet/usr/lib/nagios/plugins/check_puppet_agent',
  }

  @@nagios::check { "check_puppet_agent_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_puppet_agent',
    service_description => "puppet errors",
    host_name           => $::fqdn,
  }

  @@nagios::passive_check { 'check_puppet_${::hostname}':
    service_description => 'puppet last run errors'
  }
}
