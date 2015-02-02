# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga {

  anchor { 'icinga::begin':
    before => Class['icinga::package'],
    notify => Class['icinga::service'];
  }

  class { 'icinga::package':
    require => Class['nginx'],
    notify  => Class['icinga::service'];
  }

  class { 'icinga::config':
    require => Class['icinga::package'],
    notify  => Class['icinga::service'];
  }

  class { 'icinga::service': }
  class { 'icinga::nginx': }

  anchor { 'icinga::end':
    require => Class[
      'icinga::service',
      'icinga::nginx'
    ],
  }

  Icinga::Host            <<||>> { notify => Class['icinga::service'] }
  Icinga::Check           <<||>> { notify => Class['icinga::service'] }
  Icinga::Check::Graphite <<||>> { notify => Class['icinga::service'] }
  Icinga::Passive_check   <<||>> { notify => Class['icinga::service'] }
}

