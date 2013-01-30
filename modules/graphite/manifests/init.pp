class graphite {

  include nginx
  include pip
  include gunicorn
  include apache::remove

  anchor { 'graphite::begin':
    notify => Class['graphite::service'];
  }

  class { 'graphite::package':
    require => Anchor['graphite::begin'],
    notify  => Class['graphite::service'];
  }

  class { 'graphite::config':
    require   => Class['graphite::package'],
    notify    => Class['graphite::service'];
  }

  class { 'graphite::service':
    notify => Anchor['graphite::end'],
  }

  anchor { 'graphite::end': }

}
