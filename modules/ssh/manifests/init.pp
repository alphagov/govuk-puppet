class ssh {

  anchor { 'ssh::begin':
    notify => Class['ssh::service'];
  }

  class { 'ssh::package':
    require => Anchor['ssh::begin'],
    notify  => Class['ssh::service'];
  }

  class { 'ssh::config':
    require => Class['ssh::package'],
    notify  => Class['ssh::service'];
  }

  class { 'ssh::service':
    notify => Anchor['ssh::end'],
  }

  anchor { 'ssh::end': }


}
