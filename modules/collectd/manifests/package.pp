class collectd::package {
  include govuk::ppa

  # Allow this to fail() on unsupported versions of Ubuntu.
  $package_version = $::lsbdistcodename ? {
    'lucid'   => '5.4.0-ppa1~lucid2',
    'precise' => '5.4.0-ppa1~precise1',
  }

  # collectd contains only configuration files, which we're overriding anyway
  package { 'collectd':
    ensure => purged,
  }
  # collectd-core contains collectd itself, and all the compiled plugins
  package { 'collectd-core':
    ensure  => $package_version,
    require => Package['collectd'],
  }
  package { 'libyajl1':
    ensure => present,
  }
}
