# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::client {

  anchor { 'icinga::client::begin':
    before => Class['icinga::client::package'],
    notify => Class['icinga::client::service'],
  }

  class { 'icinga::client::package':
    notify => Class['icinga::client::service'],
  }

  class { 'icinga::client::config':
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

  class { 'icinga::client::checks':
    require => Class['icinga::client::config'],
    notify  => Class['icinga::client::service'],
  }

  class { 'icinga::client::firewall':
    require => Class['icinga::client::config'],
  }

  class { 'icinga::client::service': }

  anchor { 'icinga::client::end':
    require => Class[
      'icinga::client::firewall',
      'icinga::client::service'
    ],
  }

  @@icinga::host { $::fqdn:
    hostalias => $::fqdn,
    address   => $::ipaddress,
  }

  Icinga::Nrpe_config <| |>
  Icinga::Plugin <| |>
}
