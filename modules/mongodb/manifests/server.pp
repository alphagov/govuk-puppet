class mongodb::server ($replicaset = $govuk_platform) {

  anchor { 'mongodb::begin':
    before => Class['mongodb::repository'],
    notify => Class['mongodb::service'];
  }

  class { 'mongodb::repository': }

  class { 'mongodb::package':
    require => Class['mongodb::repository'],
    notify  => Class['mongodb::service'];
  }

  class { 'mongodb::configuration':
    replicaset => $replicaset,
    require    => Class['mongodb::package'],
    notify     => Class['mongodb::service'];
  }

  class { 'mongodb::service': }

  class { 'mongodb::monitoring':
    require => Class['mongodb::service'],
  }

  # We don't need to wait for the monitoring class
  anchor { 'mongodb::end':
    require => Class['mongodb::service'],
  }
}
