# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet (
    $use_puppetmaster = true
  ) {

  # Be absolutely certain we have a bool as strings are weird
  validate_bool($use_puppetmaster)

  include puppet::cronjob
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

  if $use_puppetmaster {
    $govuk_puppet_template = 'puppet/govuk_puppet'
  } else {
    $govuk_puppet_template = 'puppet/govuk_puppet_development'
  }

  file { '/usr/local/bin/govuk_puppet':
    ensure  => present,
    mode    => '0755',
    content => template($govuk_puppet_template),
    require => File['/var/run/lock/puppet'],
  }

  file { '/var/run/lock/puppet':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$',
    require  => Class['puppet::package'],
  }
}
