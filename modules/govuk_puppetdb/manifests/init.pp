# == Class: govuk_puppetdb
#
# Install and configure PuppetDB with Postgres and Java, listening on the
# loopback interface.
#
# === Parameters
#
# [*package_ensure*]
#   Ensure parameter passed to the package{} resource.
#
class govuk_puppetdb($package_ensure) {

  anchor { 'govuk_puppetdb::begin':
    notify => Class['govuk_puppetdb::service'];
  }

  class { 'govuk_postgresql::server::standalone':
    notify => Class['govuk_puppetdb::package'],
  }

  class { 'govuk_puppetdb::package':
    package_ensure => $package_ensure,
    require        => Anchor['govuk_puppetdb::begin'],
    notify         => Class['govuk_puppetdb::service'];
  }

  class { 'govuk_puppetdb::config':
    require => Class['govuk_puppetdb::package'],
    notify  => Class['govuk_puppetdb::service'];
  }

  class { 'govuk_puppetdb::firewall':
    require => Class['govuk_puppetdb::config'],
  }

  class { 'govuk_puppetdb::service':
    notify => Anchor['govuk_puppetdb::end'],
  }

  anchor { 'govuk_puppetdb::end':
    require => Class['govuk_puppetdb::firewall'],
  }

}
