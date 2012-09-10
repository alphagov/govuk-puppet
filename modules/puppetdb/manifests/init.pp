class puppetdb {

  anchor { 'puppetdb::begin':
    notify => Class['puppetdb::service'];
  }

  class { 'puppetdb::package':
    require => Anchor['puppetdb::begin'],
    notify  => Class['puppetdb::service'];
  }

  class { 'puppetdb::config':
    require => Class['puppetdb::package'],
    notify  => Class['puppetdb::service'];
  }

  class { 'puppetdb::service':
    notify => Anchor['puppetdb::end'],
  }

  anchor { 'puppetdb::end': }

}
