class collectd::package {
  include govuk::ppa

  # Allow this to fail() on unsupported versions of Ubuntu.
  $package_version = $::lsbdistcodename ? {
    'precise' => '5.3.0-ppa6',
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
}
