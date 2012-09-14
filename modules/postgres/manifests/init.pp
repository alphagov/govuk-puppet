class postgres {

  anchor { 'postgres::begin':
    notify => Class['postgres::service'];
  }

  class { 'postgres::package':
    require => Anchor['postgres::begin'],
    notify  => Class['postgres::service'];
  }

  class { 'postgres::config':
    require => Class['postgres::package'],
    notify  => Class['postgres::service'];
  }

  class { 'postgres::service':
    notify => Anchor['postgres::end'],
  }

  anchor { 'postgres::end': }

}
