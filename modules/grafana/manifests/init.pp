# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class grafana {
  include govuk::ppa

  package { 'grafana':
    ensure => latest,
  }

  file { '/etc/grafana':
    ensure => directory,
  }

  file { '/etc/grafana/config.js':
    ensure => file,
    source => 'puppet:///modules/grafana/config.js',
  }

  file { '/etc/grafana/dashboards':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/grafana/dashboards',
  }

  nginx::config::site { 'grafana':
    source => 'puppet:///modules/grafana/vhost.conf',
  }
}
