# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::package {
  include govuk::ppa

  case $::lsbdistcodename {
    'precise': {
      $collectd_version = '5.4.0-ppa1~precise1'
      $yajl_package = 'libyajl1'
    }
    'trusty': {
      $collectd_version = '5.4.0-3ubuntu2'
      $yajl_package = 'libyajl2'
    }
    default: {
      fail('Only precise and trusty are supported')
    }
  }

  # collectd contains only configuration files, which we're overriding anyway
  package { 'collectd':
    ensure => purged,
  }
  # collectd-core contains collectd itself, and all the compiled plugins
  package { 'collectd-core':
    ensure  => $collectd_version,
    require => Package['collectd'],
  }
  package { $yajl_package:
    ensure => present,
  }
}
