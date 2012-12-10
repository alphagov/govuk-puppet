class postfix (
    $smarthost = 'logging.management.production',
    $smarthost_auth = false
) {

  anchor { 'postfix::begin':
    notify => Class['postfix::service'];
  }
  class { 'postfix::package':
    require => Anchor['postfix::begin'],
    notify  => Class['postfix::service'];
  }
  class { 'postfix::config':
    require => Class['postfix::package'],
    notify  => Class['postfix::service'];
  }
  class { 'postfix::service': }
  anchor { 'postfix::end':
    require => Class['postfix::service']
  }

}
