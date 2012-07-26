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

  anchor { 'mongodb::end':
    require => Class['mongodb::service'],
  }
}
