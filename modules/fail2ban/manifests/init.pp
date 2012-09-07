class fail2ban {

  anchor { 'fail2ban::begin':
    notify => Class['fail2ban::service'];
  }

  class { 'fail2ban::package':
    require => Anchor['fail2ban::begin'],
    notify  => Class['fail2ban::service'];
  }

  class { 'fail2ban::config':
    require   => Class['fail2ban::package'],
    notify    => Class['fail2ban::service'];
  }

  class { 'fail2ban::service':
    notify => Anchor['fail2ban::end'],
  }

  anchor { 'fail2ban::end': }

}
