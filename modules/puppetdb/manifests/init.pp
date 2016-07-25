# == Class: puppetdb
#
# Install and configure PuppetDB with Postgres and Java, listening on the
# loopback interface.
#
# === Parameters
#
# [*package_ensure*]
#   Ensure parameter passed to the package{} resource.
#
class puppetdb($package_ensure) {

  anchor { 'puppetdb::begin':
    notify => Class['puppetdb::service'];
  }

  class { 'govuk_postgresql::server::standalone':
    notify => Class['puppetdb::package'],
  }

  class { 'puppetdb::package':
    package_ensure => $package_ensure,
    require        => Anchor['puppetdb::begin'],
    notify         => Class['puppetdb::service'];
  }

  class { 'puppetdb::config':
    require => Class['puppetdb::package'],
    notify  => Class['puppetdb::service'];
  }

  class { 'puppetdb::firewall':
    require => Class['puppetdb::config'],
  }

  class { 'puppetdb::service':
    notify => Anchor['puppetdb::end'],
  }

  anchor { 'puppetdb::end':
    require => Class['puppetdb::firewall'],
  }

}
