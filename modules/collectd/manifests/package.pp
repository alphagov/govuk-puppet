class collectd::package {
  # collectd doesn't have a versioned dependency on collectd-core so if we
  # want to upgrade it to a given version we have to manage both.
  package { ['collectd', 'collectd-core']:
    ensure  => present,
  }
}
