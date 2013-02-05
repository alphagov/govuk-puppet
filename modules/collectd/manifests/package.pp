class collectd::package {
  # Allow this to fail() on unsupported versions of Ubuntu.
  $package_version = $::lsbdistcodename ? {
    'lucid'   => '5.1.0-3',
    'precise' => '5.1.0-2',
  }

  # collectd doesn't have a versioned dependency on collectd-core so if we
  # want to upgrade it to a given version we have to manage both.
  package { ['collectd', 'collectd-core']:
    ensure  => $package_version,
  }
}
