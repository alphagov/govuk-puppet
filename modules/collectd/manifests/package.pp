# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::package {
  include govuk::ppa

  # collectd contains only configuration files, which we're overriding anyway
  package { 'collectd':
    ensure => purged,
  }
  # collectd-core contains collectd itself, and all the compiled plugins
  package { 'collectd-core':
    ensure  => '5.4.0-ppa1~precise1',
    require => Package['collectd'],
  }
  package { 'libyajl1':
    ensure => present,
  }
}
